defmodule GithubParser.Workers.Repos do
  use GenServer
  require Logger

  alias GithubParser.Repositories

  @url Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:url)
  @options Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:options)
  @update_interval Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:update_interval)
  @retry_interval 1000

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{timer: send_after(0)}}
  end

  def handle_info(:update_repos, state) do
    Logger.info("starting update repos")
    case do_request() do
      {:ok, repos} ->
        repos
        |> Enum.map(&convert_repo(&1))
        |> add_titles()
        |> Repositories.update()
        |> process_result(state)
      {:error, _reason} ->
        send_after(@retry_interval)
        {:noreply, state}
    end
  end

  def handle_call(:force_update, _from, %{timer: timer} = state) do
    case Process.cancel_timer(timer, async: true) do
      :ok ->
        {:reply, :ok, %{timer: send_after(0)}}

      error ->
        Logger.error("cancel timer failed. details: #{inspect(error)}")
        {:reply, :error, state}
    end
  end

  def force_update(), do: GenServer.call(__MODULE__, :force_update)

  defp send_after(interval \\ @update_interval) do
    Process.send_after(self(), :update_repos, interval)
  end

  defp do_request() do
    case HTTPoison.get(@url, [], @options) do
      {:ok, %{status_code: 200, body: body}} ->
        Logger.info("repos successfully fetched")
        {:ok, Jason.decode!(body)}

      {:error, reason} ->
        Logger.error("error in the repos fetching process. reason: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp convert_repo(repo) do
    %{
      title: Map.get(repo, "title") |> String.replace(" ", ""),
      description: Map.get(repo, "description"),
      stars: Map.get(repo, "stars") |> String.replace(",", "") |> String.to_integer(),
      daily_stars: Map.get(repo, "currentPeriodStar") |> String.replace(",", "") |> String.to_integer(),
      forks: Map.get(repo, "forks") |> String.replace(",", "") |> String.to_integer(),
      language: Map.get(repo, "language"),
      language_color: Map.get(repo, "color"),
      avatar_url: Map.get(repo, "avatar"),
      url: Map.get(repo, "url")
    }
  end

  defp add_titles(repos) do
    titles = Enum.map(repos, fn(repo) -> Map.get(repo, :title) end)
    {repos, titles}
  end

  defp process_result(result, state) do
    case result do
      {:ok, _} ->
        Logger.info("repos successfully updated")
        send_after()
        {:noreply, state}
      {:error, reason} ->
        Logger.error("error for the update db process. reason: #{inspect(reason)}")
        {:stop, reason, %{}}
    end
  end
end

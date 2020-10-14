defmodule GithubParser.Workers.Repos do
  use GenServer
  require Logger

  alias GithubParser.Repositories

  @url Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:url)
  @options Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:options)
  @update_interval Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:update_interval)
  @count Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:count)
  @retry_interval 1000

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    {:ok, send_after(0)}
  end

  def handle_info(:update_repos, _state) do
    Logger.info("starting update repos")
    case do_request(@url, headers(), @options ++ [params: list_query_params()]) do
      {:ok, list} ->
        Logger.info("repos successfully fetched")
        list
        |> parse_list()
        |> get_repos()
        |> add_ids()
        |> Repositories.update()
        |> process_result()
      {:error, reason} ->
        Logger.error("error in the repos fetching process. reason: #{inspect(reason)}")
        {:noreply, send_after(@retry_interval)}
    end
  end

  def handle_call(:force_update, _from, timer) do
    case Process.cancel_timer(timer) do
      time when is_integer(time) ->
        {:reply, :ok, send_after(0)}

      error ->
        Logger.error("cancel timer failed. details: #{inspect(error)}")
        {:reply, :error, timer}
    end
  end

  def force_update(), do: GenServer.call(__MODULE__, :force_update)

  defp send_after(interval \\ @update_interval) do
    Process.send_after(self(), :update_repos, interval)
  end

  defp get_repos(list) do
    list
    |> Enum.map(&Task.async(fn -> do_request(&1, headers(), @options) end))
    |> Enum.map(&Task.await(&1))
    |> Enum.filter(fn{term, _} -> term == :ok end)
    |> Enum.map(fn {:ok, body} -> Jason.decode!(body) end)
    |> Enum.map(&convert_repo(&1))
  end

  defp do_request(url, headers, options) do
    case HTTPoison.get(url, headers, options) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, response} ->
        {:error, response}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_list(response) do
    response
    |> Jason.decode!()
    |> Map.get("items")
    |> Enum.map(&Map.get(&1, "url"))
  end


  defp list_query_params() do
    %{
      q: "stars:>100",
      sort: "stars",
      order: "desc",
      page: 1,
      per_page: @count
    }
  end

  defp convert_repo(repo) do
    %{
      id: Map.get(repo, "id"),
      title: Map.get(repo, "name"),
      description: Map.get(repo, "description"),
      stars: Map.get(repo, "stargazers_count"),
      forks: Map.get(repo, "forks"),
      language: Map.get(repo, "language"),
      avatar_url: Map.get(repo, "owner") |> Map.get("avatar_url"),
      url: Map.get(repo, "html_url")
    }
  end

  defp add_ids(repos) do
    ids = Enum.map(repos, fn(repo) -> Map.get(repo, :id) end)
    {repos, ids}
  end

  defp process_result(result) do
    case result do
      {:ok, _} ->
        Logger.info("repos successfully updated")
        {:noreply, send_after()}
      error ->
        Logger.error("error for the update db process. reason: #{inspect(error)}")
        {:stop, error, []}
    end
  end

  defp headers() do
    Application.fetch_env!(:github_parser, :trends) |> Keyword.get(:headers)
  end

end

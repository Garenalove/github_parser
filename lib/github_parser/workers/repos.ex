defmodule GithubParser.Workers.Repos do
  use GenServer
  require Logger

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
        Logger.info(inspect(repos))
        Logger.info("repos successfully updated")
        send_after()
        {:noreply, state}
      {:error, _reason} ->
        send_after(@retry_interval)
        {:noreply, state}
    end
  end

  def handle_call(:start_timer, %{timer: _timer} = state) do
    {:reply, :ok, state}
  end

  def handle_call(:start_timer, _state) do
    {:reply, :ok, %{timer: send_after()}}
  end

  def handle_call(:cancel_timer, %{timer: timer}) do
    Process.cancel_timer(timer)
    {:reply, :ok,  %{}}
  end

  def handle_call(:candel_timer, state), do: {:noreply, state}

  def cancel_timer(), do: GenServer.call(__MODULE__, :cancel_timer)

  def start_timer(), do: GenServer.call(__MODULE__, :start_timer)

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
end

defmodule AptosE2eTestToolWeb.ScriptLive.Show do
  use AptosE2eTestToolWeb, :live_view

  alias AptosE2eTestTool.Scripts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:script, Scripts.get_script!(id))}
  end

  defp page_title(:show), do: "Show Script"
  defp page_title(:edit), do: "Edit Script"
end

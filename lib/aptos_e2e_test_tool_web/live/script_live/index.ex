defmodule AptosE2eTestToolWeb.ScriptLive.Index do
  use AptosE2eTestToolWeb, :live_view

  alias AptosE2eTestTool.Scripts
  alias AptosE2eTestTool.Scripts.Script
  alias AptosE2ETestTool.ScriptParser
  @impl true
  def mount(_params, _session, socket) do
    change_set= Scripts.change_script( Scripts.get_script(1)|| %Script{})
    form = to_form(change_set, as: "script")
    {:ok, stream(socket, :scripts, Scripts.list_scripts()) |>
      assign(:form, form) |> assign(:log, nil)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Script")
    |> assign(:script, Scripts.get_script!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Script")
    |> assign(:script, %Script{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scripts")
    |> assign(:script, nil)
  end

  @impl true
  def handle_info({MoveE2eTestToolWeb.ScriptLive.FormComponent, {:saved, script}}, socket) do
    {:noreply, stream_insert(socket, :scripts, script)}
  end
  @impl true
  def handle_event("on_submit", %{"script" => %{"content" => content, "name" => name}}, socket) do
    case Scripts.get_script(1) do
      nil ->
        Scripts.create_script(%{"content": content, "name": name})
      script ->
        Scripts.update_script(script,%{"content": content, "name": name})
    end
    log = AptosE2ETestTool.web_run(content)
    {:noreply, socket |> assign(:log, log)}
  end
  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    script = Scripts.get_script!(id)
    {:ok, _} = Scripts.delete_script(script)

    {:noreply, stream_delete(socket, :scripts, script)}
  end
end

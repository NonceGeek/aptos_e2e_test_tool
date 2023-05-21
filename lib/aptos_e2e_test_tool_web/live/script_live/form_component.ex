defmodule AptosE2eTestToolWeb.ScriptLive.FormComponent do
  use AptosE2eTestToolWeb, :live_component

  alias AptosE2eTestTool.Scripts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage script records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="script-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:content]} type="text" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Script</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{script: script} = assigns, socket) do
    changeset = Scripts.change_script(script)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"script" => script_params}, socket) do
    changeset =
      socket.assigns.script
      |> Scripts.change_script(script_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"script" => script_params}, socket) do
    save_script(socket, socket.assigns.action, script_params)
  end

  defp save_script(socket, :edit, script_params) do
    case Scripts.update_script(socket.assigns.script, script_params) do
      {:ok, script} ->
        notify_parent({:saved, script})

        {:noreply,
         socket
         |> put_flash(:info, "Script updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_script(socket, :new, script_params) do
    case Scripts.create_script(script_params) do
      {:ok, script} ->
        notify_parent({:saved, script})

        {:noreply,
         socket
         |> put_flash(:info, "Script created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

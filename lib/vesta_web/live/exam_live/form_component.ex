defmodule VestaWeb.ExamLive.FormComponent do
  use VestaWeb, :live_component

  alias Vesta.Exams

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage exam records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="exam-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Exam</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{exam: exam} = assigns, socket) do
    changeset = Exams.change_exam(exam)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"exam" => exam_params}, socket) do
    changeset =
      socket.assigns.exam
      |> Exams.change_exam(exam_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"exam" => exam_params}, socket) do
    save_exam(socket, socket.assigns.action, exam_params)
  end

  defp save_exam(socket, :edit, exam_params) do
    case Exams.update_exam(socket.assigns.exam, exam_params) do
      {:ok, exam} ->
        notify_parent({:saved, exam})

        {:noreply,
         socket
         |> put_flash(:info, "Exam updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_exam(socket, :new, exam_params) do
    case Exams.create_exam(exam_params) do
      {:ok, exam} ->
        notify_parent({:saved, exam})

        {:noreply,
         socket
         |> put_flash(:info, "Exam created successfully")
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

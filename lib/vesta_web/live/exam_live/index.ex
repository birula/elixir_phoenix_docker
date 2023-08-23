defmodule VestaWeb.ExamLive.Index do
  use VestaWeb, :live_view

  alias Vesta.Exams
  alias Vesta.Exams.Exam

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :exams, Exams.list_exams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Exam")
    |> assign(:exam, Exams.get_exam!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Exam")
    |> assign(:exam, %Exam{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Exams")
    |> assign(:exam, nil)
  end

  @impl true
  def handle_info({VestaWeb.ExamLive.FormComponent, {:saved, exam}}, socket) do
    {:noreply, stream_insert(socket, :exams, exam)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    exam = Exams.get_exam!(id)
    {:ok, _} = Exams.delete_exam(exam)

    {:noreply, stream_delete(socket, :exams, exam)}
  end
end

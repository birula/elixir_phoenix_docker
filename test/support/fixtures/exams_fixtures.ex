defmodule Vesta.ExamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vesta.Exams` context.
  """

  @doc """
  Generate a exam.
  """
  def exam_fixture(attrs \\ %{}) do
    {:ok, exam} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Vesta.Exams.create_exam()

    exam
  end
end

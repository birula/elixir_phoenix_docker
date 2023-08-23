defmodule Vesta.ExamsTest do
  use Vesta.DataCase

  alias Vesta.Exams

  describe "exams" do
    alias Vesta.Exams.Exam

    import Vesta.ExamsFixtures

    @invalid_attrs %{name: nil}

    test "list_exams/0 returns all exams" do
      exam = exam_fixture()
      assert Exams.list_exams() == [exam]
    end

    test "get_exam!/1 returns the exam with given id" do
      exam = exam_fixture()
      assert Exams.get_exam!(exam.id) == exam
    end

    test "list_exams!/1 returns the exam with given id" do
      assert Exams.list_exams() |> Enum.count() == 1
    end

    test "create_exam/1 with valid data creates a exam" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Exam{} = exam} = Exams.create_exam(valid_attrs)
      assert exam.name == "some name"
    end

    test "create_exam/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exams.create_exam(@invalid_attrs)
    end

    test "update_exam/2 with valid data updates the exam" do
      exam = exam_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Exam{} = exam} = Exams.update_exam(exam, update_attrs)
      assert exam.name == "some updated name"
    end

    test "update_exam/2 with invalid data returns error changeset" do
      exam = exam_fixture()
      assert {:error, %Ecto.Changeset{}} = Exams.update_exam(exam, @invalid_attrs)
      assert exam == Exams.get_exam!(exam.id)
    end

    test "delete_exam/1 deletes the exam" do
      exam = exam_fixture()
      assert {:ok, %Exam{}} = Exams.delete_exam(exam)
      assert_raise Ecto.NoResultsError, fn -> Exams.get_exam!(exam.id) end
    end

    test "change_exam/1 returns a exam changeset" do
      exam = exam_fixture()
      assert %Ecto.Changeset{} = Exams.change_exam(exam)
    end
  end
end

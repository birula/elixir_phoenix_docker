defmodule VestaWeb.ExamLiveTest do
  use VestaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Vesta.ExamsFixtures
  import Vesta.AccountsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_exam(_) do
    exam = exam_fixture()
    %{exam: exam}
  end

  defp login_user(%{conn: conn}) do
    password = valid_user_password()
      user = user_fixture(%{password: password})
      %{conn: log_in_user(conn, user)}
  end

  describe "Index" do
    setup [:create_exam, :login_user]

    test "lists all exams", %{conn: conn, exam: exam} do
      {:ok, _index_live, html} = live(conn, ~p"/exams")

      assert html =~ "Listing Exams"
      assert html =~ exam.name
    end

    test "saves new exam", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/exams")

      assert index_live |> element("a", "New Exam") |> render_click() =~
               "New Exam"

      assert_patch(index_live, ~p"/exams/new")

      assert index_live
             |> form("#exam-form", exam: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#exam-form", exam: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/exams")

      html = render(index_live)
      assert html =~ "Exam created successfully"
      assert html =~ "some name"
    end

    test "updates exam in listing", %{conn: conn, exam: exam} do
      {:ok, index_live, _html} = live(conn, ~p"/exams")

      assert index_live |> element("#exams-#{exam.id} a", "Edit") |> render_click() =~
               "Edit Exam"

      assert_patch(index_live, ~p"/exams/#{exam}/edit")

      assert index_live
             |> form("#exam-form", exam: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#exam-form", exam: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/exams")

      html = render(index_live)
      assert html =~ "Exam updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes exam in listing", %{conn: conn, exam: exam} do
      {:ok, index_live, _html} = live(conn, ~p"/exams")

      assert index_live |> element("#exams-#{exam.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#exams-#{exam.id}")
    end
  end

  describe "Show" do
    setup [:create_exam, :login_user]

    test "displays exam", %{conn: conn, exam: exam} do
      {:ok, _show_live, html} = live(conn, ~p"/exams/#{exam}")

      assert html =~ "Show Exam"
      assert html =~ exam.name
    end

    test "updates exam within modal", %{conn: conn, exam: exam} do
      {:ok, show_live, _html} = live(conn, ~p"/exams/#{exam}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Exam"

      assert_patch(show_live, ~p"/exams/#{exam}/show/edit")

      assert show_live
             |> form("#exam-form", exam: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#exam-form", exam: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/exams/#{exam}")

      html = render(show_live)
      assert html =~ "Exam updated successfully"
      assert html =~ "some updated name"
    end
  end
end

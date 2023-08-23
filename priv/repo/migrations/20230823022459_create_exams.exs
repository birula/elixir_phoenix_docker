defmodule Vesta.Repo.Migrations.CreateExams do
  use Ecto.Migration

  def change do
    create table(:exams) do
      add :name, :string

      timestamps()
    end
  end
end

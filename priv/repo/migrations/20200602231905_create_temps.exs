defmodule SlackNoodling.Repo.Migrations.CreateTemps do
  use Ecto.Migration

  def change do
    create table(:temps, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :node, :string, null: false
      add :pid, :string, null: false
      add :event, :map, null: false, default: '{}'

      timestamps()
    end
  end
end

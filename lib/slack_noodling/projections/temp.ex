defmodule SlackNoodling.Projections.Temp do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "temps" do
    field :event, :map
    field :node, :string
    field :pid, :string

    timestamps()
  end

  @doc false
  def changeset(temp, attrs) do
    temp
    |> cast(attrs, [:node, :pid, :event])
    |> validate_required([:node, :pid, :event])
  end
end

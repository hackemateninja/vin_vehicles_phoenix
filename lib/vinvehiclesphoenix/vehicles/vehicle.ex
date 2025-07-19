defmodule Vinvehiclesphoenix.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "vehicles" do
    field :make, :string
    field :model, :string
    field :age, :integer
    field :vin, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:make, :vin, :model, :age])
    |> validate_required([:make, :vin, :model, :age])
  end
end

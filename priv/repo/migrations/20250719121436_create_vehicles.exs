defmodule Vinvehiclesphoenix.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :make, :string
      add :vin, :string
      add :model, :string
      add :age, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

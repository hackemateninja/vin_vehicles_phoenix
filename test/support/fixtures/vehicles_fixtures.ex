defmodule Vinvehiclesphoenix.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vinvehiclesphoenix.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        age: 42,
        make: "some make",
        model: "some model",
        vin: "some vin"
      })
      |> Vinvehiclesphoenix.Vehicles.create_vehicle()

    vehicle
  end
end

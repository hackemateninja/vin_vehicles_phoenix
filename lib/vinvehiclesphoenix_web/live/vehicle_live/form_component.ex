defmodule VinvehiclesphoenixWeb.VehicleLive.FormComponent do
  use VinvehiclesphoenixWeb, :live_component

  alias Vinvehiclesphoenix.Vehicles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage vehicle records in your database.</:subtitle>
      </.header>

      <.simple_form for={@form} id="vehicle-form" phx-target={@myself} phx-submit="get_vin">
        <.input field={@form[:vin]} type="text" label="Vin" />
        <:actions>
          <.button phx-disable-with="Validating...">Look for vehicle</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{vehicle: vehicle} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Vehicles.change_vehicle(vehicle))
     end)}
  end

  @impl true
  def handle_event("get_vin", %{"vehicle" => %{"vin" => vin_raw}}, socket) do
    vin = vin_raw |> String.trim(" ")

    response =
      Req.get!(
        "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValuesExtended/#{vin}?format=json"
      )

    [result] = response.body["Results"]

    model = result["Model"]
    make = result["Make"]
    year = result["ModelYear"]

    age = Date.utc_today().year - String.to_integer(year)

    vehicle = %{vin: vin, model: model, make: make, age: age}

    case Vehicles.create_vehicle(vehicle) do
      {:ok, vehicle} ->
        notify_parent({:saved, vehicle})

        {:noreply,
         socket
         |> put_flash(:info, "Vehicle created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

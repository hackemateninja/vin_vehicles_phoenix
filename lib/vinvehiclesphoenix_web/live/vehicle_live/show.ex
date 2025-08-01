defmodule VinvehiclesphoenixWeb.VehicleLive.Show do
  use VinvehiclesphoenixWeb, :live_view

  alias Vinvehiclesphoenix.Vehicles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:vehicle, Vehicles.get_vehicle!(id))}
  end

  defp page_title(:show), do: "Show Vehicle"
end

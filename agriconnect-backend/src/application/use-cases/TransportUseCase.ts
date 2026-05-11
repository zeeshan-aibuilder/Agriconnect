export class TransportUseCase {
  
  // 1. Core Logic: Calculate Distance between two GPS points (in KM)
  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    // A simplified distance formula for the prototype (approximating km)
    const R = 6371; // Earth's radius in KM
    const x = (lon2 - lon1) * Math.cos((lat1 + lat2) / 2);
    const y = (lat2 - lat1);
    return Math.sqrt(x * x + y * y) * R;
  }

  // 2. Main Feature: Find Nearest Driver & Calculate Fare
  async findNearestTransporters(pickupLat: number, pickupLon: number) {
    // Prototype Hack: Dummy online transporters in the area (e.g., Faisalabad coordinates)
    const onlineTransporters = [
      { id: 't1', name: 'Ali Trucking', lat: pickupLat + 0.05, lon: pickupLon + 0.02, vehicle: 'Mazda', baseRatePerKm: 150 },
      { id: 't2', name: 'Rizwan Trolley', lat: pickupLat + 0.15, lon: pickupLon - 0.10, vehicle: 'Tractor Trolley', baseRatePerKm: 100 },
      { id: 't3', name: 'Zahid Pickups', lat: pickupLat - 0.01, lon: pickupLon + 0.01, vehicle: 'Suzuki Pickup', baseRatePerKm: 80 }
    ];

    // Sab transporters ka distance aur fare calculate karo
    let availableDrivers = onlineTransporters.map(driver => {
      const distanceKm = this.calculateDistance(pickupLat, pickupLon, driver.lat, driver.lon);
      const estimatedFare = distanceKm * driver.baseRatePerKm;
      
      return {
        transporter_id: driver.id,
        name: driver.name,
        vehicle: driver.vehicle,
        distance_km: parseFloat(distanceKm.toFixed(2)),
        estimated_fare_pkr: Math.round(estimatedFare)
      };
    });

    // Sort by Nearest First
    availableDrivers.sort((a, b) => a.distance_km - b.distance_km);

    // Return only top 3 nearest drivers
    return availableDrivers.slice(0, 3);
  }
}
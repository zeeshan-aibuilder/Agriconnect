export class TransportRequest {
  constructor(
    public readonly id: string,
    public readonly listing_id: string,
    public readonly requester_id: string,
    public pickup_location: string,
    public dropoff_location: string,
    public status: 'Pending' | 'Accepted' | 'Completed' | 'Cancelled',
    public readonly created_at: Date
  ) {}
}
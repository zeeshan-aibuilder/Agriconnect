export class TransportBid {
  constructor(
    public readonly id: string,
    public readonly request_id: string,
    public readonly transporter_id: string,
    public bid_amount: number,
    public status: 'Pending' | 'Accepted' | 'Rejected',
    public readonly created_at: Date
  ) {}
}
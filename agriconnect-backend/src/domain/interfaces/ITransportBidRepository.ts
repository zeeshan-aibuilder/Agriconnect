import { TransportBid } from '../entities/TransportBid';

export interface ITransportBidRepository {
  create(bid: TransportBid): Promise<TransportBid>;
  findById(id: string): Promise<TransportBid | null>;
  findByRequestId(requestId: string): Promise<TransportBid[]>;
  findByTransporterId(transporterId: string): Promise<TransportBid[]>;
  updateStatus(id: string, status: string): Promise<TransportBid>;
}
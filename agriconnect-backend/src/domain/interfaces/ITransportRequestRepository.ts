import { TransportRequest } from '../entities/TransportRequest';

export interface ITransportRequestRepository {
  create(request: TransportRequest): Promise<TransportRequest>;
  findById(id: string): Promise<TransportRequest | null>;
  findByRequesterId(requesterId: string): Promise<TransportRequest[]>;
  findPendingRequests(): Promise<TransportRequest[]>;
  updateStatus(id: string, status: string): Promise<TransportRequest>;
}
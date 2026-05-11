import { Listing } from '../entities/Listing';

export interface IListingRepository {
  create(listing: Listing): Promise<Listing>;
  findById(id: string): Promise<Listing | null>;
  findAll(filters?: any): Promise<Listing[]>;
  findByFarmerId(farmerId: string): Promise<Listing[]>;
  updateStatus(id: string, status: string): Promise<Listing>;
  delete(id: string): Promise<boolean>;
}
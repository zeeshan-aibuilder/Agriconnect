import { IListingRepository } from '../../domain/interfaces/IListingRepository';
import { Listing } from '../../domain/entities/Listing';
import prisma from '../database/prismaClient';

export class ListingRepositoryImpl implements IListingRepository {
  async create(listing: Listing): Promise<Listing> {
    const newDoc = await prisma.listing.create({
      data: {
        farmer_id: listing.farmer_id,
        title: listing.title,
        description: listing.description,
        price: listing.price,
        images: listing.images,
        status: listing.status,
      },
    });
    return new Listing(newDoc.id, newDoc.farmer_id, newDoc.title, newDoc.description, newDoc.price, newDoc.images, newDoc.status as any, newDoc.created_at);
  }

  async findById(id: string): Promise<Listing | null> {
    const doc = await prisma.listing.findUnique({ where: { id } });
    if (!doc) return null;
    return new Listing(doc.id, doc.farmer_id, doc.title, doc.description, doc.price, doc.images, doc.status as any, doc.created_at);
  }

 async findAll(filters?: any): Promise<Listing[]> {
    const docs = await prisma.listing.findMany({ where: filters });
    return docs.map((doc: any) => new Listing(doc.id, doc.farmer_id, doc.title, doc.description, doc.price, doc.images, doc.status as any, doc.created_at));
  }

  async findByFarmerId(farmerId: string): Promise<Listing[]> {
    return this.findAll({ farmer_id: farmerId });
  }

  async updateStatus(id: string, status: string): Promise<Listing> {
    const updated = await prisma.listing.update({
      where: { id },
      data: { status },
    });
    return new Listing(updated.id, updated.farmer_id, updated.title, updated.description, updated.price, updated.images, updated.status as any, updated.created_at);
  }

  async delete(id: string): Promise<boolean> {
    await prisma.listing.delete({ where: { id } });
    return true;
  }
}
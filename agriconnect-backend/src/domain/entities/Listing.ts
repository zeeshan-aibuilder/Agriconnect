export class Listing {
  constructor(
    public readonly id: string,
    public readonly farmer_id: string,
    public title: string,
    public description: string,
    public price: number,
    public images: string[],
    public status: 'Active' | 'Sold' | 'Draft',
    public readonly created_at: Date
  ) {}
}
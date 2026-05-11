import { IListingRepository } from '../../domain/interfaces/IListingRepository';
import { Listing } from '../../domain/entities/Listing';

export class ListingUseCase {
  constructor(private listingRepository: IListingRepository) {}

  // 1. Kisaan nayi post (listing) lagayega keywords ke sath
  async createListing(farmer_id: string, title: string, description: string, price: number, keywords: string[]) {
    // Note: Future mein hum Prisma schema mein 'keywords' ka array add karenge, 
    // abhi ke liye keywords ko description mein append kar rahe hain as a prototype hack
    const enrichedDescription = `${description} | Keywords: ${keywords.join(', ')}`;
    
    // (this.listingRepository as any) is used to bypass any minor interface mismatches for now
    return await (this.listingRepository as any).create({
      farmer_id,
      title,
      description: enrichedDescription,
      price,
      images: [],
      status: 'Active'
    });
  }

  // 2. SMART MATCHING ALGORITHM (Buyer requirements ko kisaan ki posts se match karna)
  async getSmartMatches(buyerRequirementKeywords: string[], isPremiumUser: boolean) {
    // Database se saari active listings uthao
    const allListings = await this.listingRepository.findAll({ status: 'Active' });

    // Step A: Keyword Matching (Dekho ke buyer ka keyword post mein hai ya nahi)
    let matchedListings = allListings.filter(listing => {
      // Logic: Agar buyer ka koi ek keyword bhi title ya description mein mil jaye, toh usay list mein shamil kar lo
      return buyerRequirementKeywords.some(keyword => 
        listing.title.toLowerCase().includes(keyword.toLowerCase()) || 
        listing.description.toLowerCase().includes(keyword.toLowerCase())
      );
    });

    // Step B: Subscription Business Logic
    if (isPremiumUser) {
      // Premium user ko saare matches dikhao (Unlimited limits)
      return {
        isPremium: true,
        totalFound: matchedListings.length,
        results: matchedListings,
        message: "Premium User: Showing all available matches."
      };
    } else {
      // Free user ko sirf pehle 10 matches dikhao (Growth Hacking)
      const limitedResults = matchedListings.slice(0, 10);
      return {
        isPremium: false,
        totalFound: matchedListings.length,
        results: limitedResults,
        message: `Showing 10 results. Subscribe to unlock all ${matchedListings.length} matches!`
      };
    }
  }
}
import { PrismaClient } from '@prisma/client';

// Singleton instance for Prisma Client to prevent multiple connections
const prisma = new PrismaClient();

export default prisma;
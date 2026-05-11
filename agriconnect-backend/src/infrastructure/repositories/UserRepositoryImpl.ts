import { IUserRepository } from '../../domain/interfaces/IUserRepository';
import { User } from '../../domain/entities/User';
import prisma from '../database/prismaClient';

export class UserRepositoryImpl implements IUserRepository {
  async findById(id: string): Promise<User | null> {
    const userDoc = await prisma.user.findUnique({ where: { id } });
    if (!userDoc) return null;
    return new User(userDoc.id, userDoc.phone, userDoc.name || '', userDoc.role_id, userDoc.created_at);
  }

  async findByPhone(phone: string): Promise<User | null> {
    const userDoc = await prisma.user.findUnique({ where: { phone } });
    if (!userDoc) return null;
    return new User(userDoc.id, userDoc.phone, userDoc.name || '', userDoc.role_id, userDoc.created_at);
  }

  async create(user: User): Promise<User> {
    const newUser = await prisma.user.create({
      data: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        role_id: user.role_id,
      },
    });
    return new User(newUser.id, newUser.phone, newUser.name || '', newUser.role_id, newUser.created_at);
  }

  // ---- Interface ko satisfy karne ke liye required methods ----
  async save(user: User): Promise<User> {
    return this.update(user.id, user);
  }

  async update(id: string, userData: Partial<User>): Promise<User> {
    const updated = await prisma.user.update({
      where: { id },
      data: { name: userData.name, role_id: userData.role_id },
    });
    return new User(updated.id, updated.phone, updated.name || '', updated.role_id, updated.created_at);
  }

  async delete(id: string): Promise<boolean> {
    await prisma.user.delete({ where: { id } });
    return true;
  }
}
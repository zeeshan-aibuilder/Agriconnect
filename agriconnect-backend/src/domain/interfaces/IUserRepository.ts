import { User } from '../entities/User';

export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByPhone(phone: string): Promise<User | null>;
  create(user: User): Promise<User>;
  
  // Yahan Promise<User> hona lazmi hai taake implementation se match kare
  save(user: User): Promise<User>; 
  
  update(id: string, userData: Partial<User>): Promise<User>;
  delete(id: string): Promise<boolean>;
}
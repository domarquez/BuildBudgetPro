import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { storage } from './storage';
import type { InsertUser, User } from '@shared/schema';

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';
const JWT_EXPIRES_IN = '7d';

export interface AuthTokenPayload {
  userId: number;
  username: string;
  email: string;
  role: string;
}

export class AuthService {
  static async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 12);
  }

  static async comparePassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  static generateToken(user: User): string {
    const payload: AuthTokenPayload = {
      userId: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
    };
    return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
  }

  static verifyToken(token: string): AuthTokenPayload | null {
    try {
      return jwt.verify(token, JWT_SECRET) as AuthTokenPayload;
    } catch {
      return null;
    }
  }

  static async register(userData: {
    username: string;
    email: string;
    password: string;
    firstName?: string;
    lastName?: string;
    userType?: string;
  }): Promise<{ user: User; token: string }> {
    // Check if username already exists
    const existingUsername = await storage.getUserByUsername(userData.username);
    if (existingUsername) {
      throw new Error('El nombre de usuario ya está en uso');
    }

    // Check if email already exists
    const existingEmail = await storage.getUserByEmail(userData.email);
    if (existingEmail) {
      throw new Error('El correo electrónico ya está registrado');
    }

    // Hash password
    const hashedPassword = await this.hashPassword(userData.password);

    // Create user
    const newUser: InsertUser = {
      username: userData.username,
      email: userData.email,
      password: hashedPassword,
      firstName: userData.firstName || null,
      lastName: userData.lastName || null,
      role: 'user', // Default role
      userType: userData.userType || 'architect',
      isActive: true,
    };

    const user = await storage.createUser(newUser);
    const token = this.generateToken(user);

    return { user, token };
  }

  static async login(credentials: {
    username: string;
    password: string;
  }): Promise<{ user: User; token: string }> {
    // Find user by username
    const user = await storage.getUserByUsername(credentials.username);
    if (!user) {
      throw new Error('Credenciales incorrectas');
    }

    // Check if user is active
    if (!user.isActive) {
      throw new Error('Cuenta desactivada. Contacte al administrador');
    }

    // Verify password
    const isValidPassword = await this.comparePassword(credentials.password, user.password);
    if (!isValidPassword) {
      throw new Error('Credenciales incorrectas');
    }

    // Update last login
    await storage.updateUserLastLogin(user.id);

    // Generate token
    const token = this.generateToken(user);

    return { user, token };
  }

  static async getCurrentUser(token: string): Promise<User | null> {
    const payload = this.verifyToken(token);
    if (!payload) {
      return null;
    }

    const user = await storage.getUser(payload.userId);
    if (!user || !user.isActive) {
      return null;
    }

    return user;
  }
}

// Middleware for protecting routes
export const requireAuth = async (req: any, res: any, next: any) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Token de autenticación requerido' });
    }

    const token = authHeader.substring(7);
    const user = await AuthService.getCurrentUser(token);
    
    if (!user) {
      return res.status(401).json({ message: 'Token inválido o expirado' });
    }

    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Error de autenticación' });
  }
};

export const requireAdmin = async (req: any, res: any, next: any) => {
  await requireAuth(req, res, () => {
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Acceso denegado: Se requiere rol de administrador' });
    }
    next();
  });
};

export const requireSupplier = async (req: any, res: any, next: any) => {
  await requireAuth(req, res, () => {
    if (req.user.userType !== 'supplier') {
      return res.status(403).json({ message: 'Access denied - Not a supplier' });
    }
    next();
  });
};
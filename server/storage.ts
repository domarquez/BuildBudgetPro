import { 
  users, 
  materialCategories,
  constructionPhases,
  activities,
  materials,
  projects,
  budgets,
  budgetItems,
  type User, 
  type InsertUser,
  type MaterialCategory,
  type InsertMaterialCategory,
  type ConstructionPhase,
  type InsertConstructionPhase,
  type Activity,
  type InsertActivity,
  type Material,
  type InsertMaterial,
  type MaterialWithCategory,
  type ActivityWithPhase,
  type Project,
  type InsertProject,
  type Budget,
  type InsertBudget,
  type BudgetWithProject,
  type BudgetItem,
  type InsertBudgetItem,
  type BudgetItemWithActivity
} from "@shared/schema";
import { db } from "./db";
import { eq, desc, sql, like, ilike } from "drizzle-orm";

export interface IStorage {
  // Users
  getUser(id: number): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  createUser(user: InsertUser): Promise<User>;

  // Material Categories
  getMaterialCategories(): Promise<MaterialCategory[]>;
  createMaterialCategory(category: InsertMaterialCategory): Promise<MaterialCategory>;

  // Construction Phases
  getConstructionPhases(): Promise<ConstructionPhase[]>;
  createConstructionPhase(phase: InsertConstructionPhase): Promise<ConstructionPhase>;

  // Activities
  getActivities(): Promise<ActivityWithPhase[]>;
  getActivitiesByPhase(phaseId: number): Promise<ActivityWithPhase[]>;
  createActivity(activity: InsertActivity): Promise<Activity>;

  // Materials
  getMaterials(): Promise<MaterialWithCategory[]>;
  getMaterialsByCategory(categoryId: number): Promise<MaterialWithCategory[]>;
  searchMaterials(query: string): Promise<MaterialWithCategory[]>;
  getMaterial(id: number): Promise<MaterialWithCategory | undefined>;
  createMaterial(material: InsertMaterial): Promise<Material>;
  updateMaterial(id: number, material: Partial<InsertMaterial>): Promise<Material>;
  deleteMaterial(id: number): Promise<void>;

  // Projects
  getProjects(): Promise<Project[]>;
  getProject(id: number): Promise<Project | undefined>;
  createProject(project: InsertProject): Promise<Project>;
  updateProject(id: number, project: Partial<InsertProject>): Promise<Project>;

  // Budgets
  getBudgets(): Promise<BudgetWithProject[]>;
  getBudget(id: number): Promise<BudgetWithProject | undefined>;
  getBudgetsByProject(projectId: number): Promise<BudgetWithProject[]>;
  createBudget(budget: InsertBudget): Promise<Budget>;
  updateBudget(id: number, budget: Partial<InsertBudget>): Promise<Budget>;

  // Budget Items
  getBudgetItems(budgetId: number): Promise<BudgetItemWithActivity[]>;
  createBudgetItem(item: InsertBudgetItem): Promise<BudgetItem>;
  updateBudgetItem(id: number, item: Partial<InsertBudgetItem>): Promise<BudgetItem>;
  deleteBudgetItem(id: number): Promise<void>;

  // Statistics
  getStatistics(): Promise<{
    totalMaterials: number;
    totalActivities: number;
    activeBudgets: number;
    totalProjectValue: number;
  }>;

  // Price Settings
  getPriceSettings(): Promise<PriceSettings>;
  updatePriceSettings(settings: Partial<InsertPriceSettings>): Promise<PriceSettings>;
  applyGlobalPriceAdjustment(factor: number, updatedBy: string): Promise<{ affectedMaterials: number }>;
}

export class DatabaseStorage implements IStorage {
  // Users
  async getUser(id: number): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user || undefined;
  }

  async getUserByUsername(username: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.username, username));
    return user || undefined;
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const [user] = await db
      .insert(users)
      .values(insertUser)
      .returning();
    return user;
  }

  // Material Categories
  async getMaterialCategories(): Promise<MaterialCategory[]> {
    return await db.select().from(materialCategories).orderBy(materialCategories.name);
  }

  async createMaterialCategory(category: InsertMaterialCategory): Promise<MaterialCategory> {
    const [created] = await db
      .insert(materialCategories)
      .values(category)
      .returning();
    return created;
  }

  // Construction Phases
  async getConstructionPhases(): Promise<ConstructionPhase[]> {
    return await db.select().from(constructionPhases).orderBy(constructionPhases.id);
  }

  async createConstructionPhase(phase: InsertConstructionPhase): Promise<ConstructionPhase> {
    const [created] = await db
      .insert(constructionPhases)
      .values(phase)
      .returning();
    return created;
  }

  // Activities
  async getActivities(): Promise<ActivityWithPhase[]> {
    return await db
      .select()
      .from(activities)
      .leftJoin(constructionPhases, eq(activities.phaseId, constructionPhases.id))
      .then(rows => rows.map(row => ({
        ...row.activities,
        phase: row.construction_phases!
      })));
  }

  async getActivitiesByPhase(phaseId: number): Promise<ActivityWithPhase[]> {
    return await db
      .select()
      .from(activities)
      .leftJoin(constructionPhases, eq(activities.phaseId, constructionPhases.id))
      .where(eq(activities.phaseId, phaseId))
      .then(rows => rows.map(row => ({
        ...row.activities,
        phase: row.construction_phases!
      })));
  }

  async createActivity(activity: InsertActivity): Promise<Activity> {
    const [created] = await db
      .insert(activities)
      .values(activity)
      .returning();
    return created;
  }

  // Materials
  async getMaterials(): Promise<MaterialWithCategory[]> {
    return await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .orderBy(desc(materials.lastUpdated))
      .then(rows => rows.map(row => ({
        ...row.materials,
        category: row.material_categories!
      })));
  }

  async getMaterialsByCategory(categoryId: number): Promise<MaterialWithCategory[]> {
    return await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .where(eq(materials.categoryId, categoryId))
      .orderBy(materials.name)
      .then(rows => rows.map(row => ({
        ...row.materials,
        category: row.material_categories!
      })));
  }

  async searchMaterials(query: string): Promise<MaterialWithCategory[]> {
    return await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .where(ilike(materials.name, `%${query}%`))
      .orderBy(materials.name)
      .then(rows => rows.map(row => ({
        ...row.materials,
        category: row.material_categories!
      })));
  }

  async getMaterial(id: number): Promise<MaterialWithCategory | undefined> {
    const rows = await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .where(eq(materials.id, id));
    
    if (rows.length === 0) return undefined;
    
    const row = rows[0];
    return {
      ...row.materials,
      category: row.material_categories!
    };
  }

  async createMaterial(material: InsertMaterial): Promise<Material> {
    const [created] = await db
      .insert(materials)
      .values(material)
      .returning();
    return created;
  }

  async updateMaterial(id: number, material: Partial<InsertMaterial>): Promise<Material> {
    const [updated] = await db
      .update(materials)
      .set({ ...material, lastUpdated: new Date() })
      .where(eq(materials.id, id))
      .returning();
    return updated;
  }

  async deleteMaterial(id: number): Promise<void> {
    await db.delete(materials).where(eq(materials.id, id));
  }

  // Projects
  async getProjects(): Promise<Project[]> {
    return await db.select().from(projects).orderBy(desc(projects.createdAt));
  }

  async getProject(id: number): Promise<Project | undefined> {
    const [project] = await db.select().from(projects).where(eq(projects.id, id));
    return project || undefined;
  }

  async createProject(project: InsertProject): Promise<Project> {
    const [created] = await db
      .insert(projects)
      .values(project)
      .returning();
    return created;
  }

  async updateProject(id: number, project: Partial<InsertProject>): Promise<Project> {
    const [updated] = await db
      .update(projects)
      .set({ ...project, updatedAt: new Date() })
      .where(eq(projects.id, id))
      .returning();
    return updated;
  }

  // Budgets
  async getBudgets(): Promise<BudgetWithProject[]> {
    return await db
      .select()
      .from(budgets)
      .leftJoin(projects, eq(budgets.projectId, projects.id))
      .leftJoin(constructionPhases, eq(budgets.phaseId, constructionPhases.id))
      .orderBy(desc(budgets.createdAt))
      .then(rows => rows.map(row => ({
        ...row.budgets,
        project: row.projects!,
        phase: row.construction_phases!
      })));
  }

  async getBudget(id: number): Promise<BudgetWithProject | undefined> {
    const rows = await db
      .select()
      .from(budgets)
      .leftJoin(projects, eq(budgets.projectId, projects.id))
      .leftJoin(constructionPhases, eq(budgets.phaseId, constructionPhases.id))
      .where(eq(budgets.id, id));
    
    if (rows.length === 0) return undefined;
    
    const row = rows[0];
    return {
      ...row.budgets,
      project: row.projects!,
      phase: row.construction_phases!
    };
  }

  async getBudgetsByProject(projectId: number): Promise<BudgetWithProject[]> {
    return await db
      .select()
      .from(budgets)
      .leftJoin(projects, eq(budgets.projectId, projects.id))
      .leftJoin(constructionPhases, eq(budgets.phaseId, constructionPhases.id))
      .where(eq(budgets.projectId, projectId))
      .orderBy(budgets.phaseId)
      .then(rows => rows.map(row => ({
        ...row.budgets,
        project: row.projects!,
        phase: row.construction_phases!
      })));
  }

  async createBudget(budget: InsertBudget): Promise<Budget> {
    const [created] = await db
      .insert(budgets)
      .values(budget)
      .returning();
    return created;
  }

  async updateBudget(id: number, budget: Partial<InsertBudget>): Promise<Budget> {
    const [updated] = await db
      .update(budgets)
      .set({ ...budget, updatedAt: new Date() })
      .where(eq(budgets.id, id))
      .returning();
    return updated;
  }

  // Budget Items
  async getBudgetItems(budgetId: number): Promise<BudgetItemWithActivity[]> {
    return await db
      .select()
      .from(budgetItems)
      .leftJoin(activities, eq(budgetItems.activityId, activities.id))
      .leftJoin(constructionPhases, eq(activities.phaseId, constructionPhases.id))
      .where(eq(budgetItems.budgetId, budgetId))
      .then(rows => rows.map(row => ({
        ...row.budget_items,
        activity: {
          ...row.activities!,
          phase: row.construction_phases!
        }
      })));
  }

  async createBudgetItem(item: InsertBudgetItem): Promise<BudgetItem> {
    const [created] = await db
      .insert(budgetItems)
      .values(item)
      .returning();
    return created;
  }

  async updateBudgetItem(id: number, item: Partial<InsertBudgetItem>): Promise<BudgetItem> {
    const [updated] = await db
      .update(budgetItems)
      .set(item)
      .where(eq(budgetItems.id, id))
      .returning();
    return updated;
  }

  async deleteBudgetItem(id: number): Promise<void> {
    await db.delete(budgetItems).where(eq(budgetItems.id, id));
  }

  // Statistics
  async getStatistics(): Promise<{
    totalMaterials: number;
    totalActivities: number;
    activeBudgets: number;
    totalProjectValue: number;
  }> {
    const [materialCount] = await db
      .select({ count: sql<number>`count(*)` })
      .from(materials);

    const [activityCount] = await db
      .select({ count: sql<number>`count(*)` })
      .from(activities);

    const [budgetCount] = await db
      .select({ count: sql<number>`count(*)` })
      .from(budgets)
      .where(eq(budgets.status, 'active'));

    const [projectValue] = await db
      .select({ total: sql<number>`coalesce(sum(total), 0)` })
      .from(budgets)
      .where(eq(budgets.status, 'active'));

    return {
      totalMaterials: materialCount.count,
      totalActivities: activityCount.count,
      activeBudgets: budgetCount.count,
      totalProjectValue: Number(projectValue.total)
    };
  }
}

export const storage = new DatabaseStorage();

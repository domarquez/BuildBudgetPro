import { 
  users, 
  materialCategories,
  constructionPhases,
  activities,
  materials,
  projects,
  budgets,
  budgetItems,
  priceSettings,
  activityCompositions,
  cityPriceFactors,
  supplierCompanies,
  materialSupplierPrices,
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
  type BudgetItemWithActivity,
  type PriceSettings,
  type InsertPriceSettings,
  type ActivityComposition,
  type InsertActivityComposition,
  type CityPriceFactor,
  type InsertCityPriceFactor,
  type SupplierCompany,
  type InsertSupplierCompany,
  type SupplierCompanyWithUser,
  type MaterialSupplierPrice,
  type InsertMaterialSupplierPrice,
  type MaterialWithSupplierPrices
} from "@shared/schema";
import { db } from "./db";
import { eq, desc, sql, like, ilike, and } from "drizzle-orm";

export interface IStorage {
  // Users
  getUser(id: number): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  getUserByEmail(email: string): Promise<User | undefined>;
  createUser(user: InsertUser): Promise<User>;
  updateUserLastLogin(id: number): Promise<void>;

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
  getProjectsByUser(userId: number): Promise<Project[]>;
  getProject(id: number): Promise<Project | undefined>;
  createProject(project: InsertProject): Promise<Project>;
  updateProject(id: number, project: Partial<InsertProject>): Promise<Project>;
  deleteProject(id: number): Promise<void>;

  // Budgets
  getBudgets(): Promise<BudgetWithProject[]>;
  getBudget(id: number): Promise<BudgetWithProject | undefined>;
  getBudgetsByProject(projectId: number): Promise<BudgetWithProject[]>;
  getBudgetsByUser(userId: number): Promise<BudgetWithProject[]>;
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

  // Activity Compositions
  getActivityCompositions(): Promise<ActivityComposition[]>;
  getActivityCompositionsByActivity(activityId: number): Promise<ActivityComposition[]>;
  createActivityComposition(composition: InsertActivityComposition): Promise<ActivityComposition>;
  deleteActivityComposition(id: number): Promise<void>;

  // Activity Updates
  updateActivity(id: number, activity: Partial<InsertActivity>): Promise<Activity>;

  // Price Settings
  getPriceSettings(): Promise<PriceSettings>;
  updatePriceSettings(settings: Partial<InsertPriceSettings>): Promise<PriceSettings>;
  applyGlobalPriceAdjustment(factor: number, updatedBy: string): Promise<{ affectedMaterials: number }>;

  // City Price Factors
  getCityPriceFactors(): Promise<CityPriceFactor[]>;
  getCityPriceFactor(city: string, country?: string): Promise<CityPriceFactor | undefined>;
  createCityPriceFactor(factor: InsertCityPriceFactor): Promise<CityPriceFactor>;
  updateCityPriceFactor(id: number, factor: Partial<InsertCityPriceFactor>): Promise<CityPriceFactor>;
  deleteCityPriceFactor(id: number): Promise<void>;

  // User location
  updateUserLocation(userId: number, city: string, country?: string): Promise<User>;

  // Supplier Companies
  getSupplierCompanies(): Promise<SupplierCompanyWithUser[]>;
  getSupplierCompany(id: number): Promise<SupplierCompanyWithUser | undefined>;
  getSupplierCompanyByUser(userId: number): Promise<SupplierCompany | undefined>;
  createSupplierCompany(company: InsertSupplierCompany): Promise<SupplierCompany>;
  updateSupplierCompany(id: number, company: Partial<InsertSupplierCompany>): Promise<SupplierCompany>;
  deleteSupplierCompany(id: number): Promise<void>;

  // Material Supplier Prices
  getMaterialSupplierPrices(materialId: number): Promise<(MaterialSupplierPrice & { supplier: SupplierCompany })[]>;
  getSupplierPrices(supplierId: number): Promise<(MaterialSupplierPrice & { material: Material })[]>;
  createMaterialSupplierPrice(price: InsertMaterialSupplierPrice): Promise<MaterialSupplierPrice>;
  updateMaterialSupplierPrice(id: number, price: Partial<InsertMaterialSupplierPrice>): Promise<MaterialSupplierPrice>;
  deleteMaterialSupplierPrice(id: number): Promise<void>;
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

  async getUserByEmail(email: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.email, email));
    return user || undefined;
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const [user] = await db
      .insert(users)
      .values(insertUser)
      .returning();
    return user;
  }

  async updateUserLastLogin(id: number): Promise<void> {
    await db
      .update(users)
      .set({ lastLogin: new Date() })
      .where(eq(users.id, id));
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

  async getProjectsByUser(userId: number): Promise<Project[]> {
    return await db.select().from(projects).where(eq(projects.userId, userId)).orderBy(desc(projects.createdAt));
  }

  async getProject(id: number): Promise<Project | undefined> {
    const [project] = await db.select().from(projects).where(eq(projects.id, id));
    return project || undefined;
  }

  async createProject(project: InsertProject): Promise<Project> {
    const projectData = {
      ...project,
      startDate: typeof project.startDate === 'string' ? new Date(project.startDate) : project.startDate
    };
    const [created] = await db
      .insert(projects)
      .values(projectData)
      .returning();
    return created;
  }

  async updateProject(id: number, project: Partial<InsertProject>): Promise<Project> {
    const updateData = {
      ...project,
      updatedAt: new Date(),
      startDate: typeof project.startDate === 'string' ? new Date(project.startDate) : project.startDate
    };
    const [updated] = await db
      .update(projects)
      .set(updateData)
      .where(eq(projects.id, id))
      .returning();
    return updated;
  }

  async deleteProject(id: number): Promise<void> {
    // Delete related budgets and budget items first
    const projectBudgets = await db
      .select({ id: budgets.id })
      .from(budgets)
      .where(eq(budgets.projectId, id));

    for (const budget of projectBudgets) {
      await db.delete(budgetItems).where(eq(budgetItems.budgetId, budget.id));
    }
    
    await db.delete(budgets).where(eq(budgets.projectId, id));
    await db.delete(projects).where(eq(projects.id, id));
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

  async getBudgetsByUser(userId: number): Promise<BudgetWithProject[]> {
    return await db
      .select()
      .from(budgets)
      .leftJoin(projects, eq(budgets.projectId, projects.id))
      .leftJoin(constructionPhases, eq(budgets.phaseId, constructionPhases.id))
      .where(eq(projects.userId, userId))
      .orderBy(desc(budgets.createdAt))
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

  // Price Settings
  async getPriceSettings(): Promise<PriceSettings> {
    const [settings] = await db.select().from(priceSettings).limit(1);
    return settings;
  }

  async updatePriceSettings(updates: Partial<InsertPriceSettings>): Promise<PriceSettings> {
    const [settings] = await db.select().from(priceSettings).limit(1);
    
    const [updated] = await db
      .update(priceSettings)
      .set({
        ...updates,
        lastUpdated: new Date(),
      })
      .where(eq(priceSettings.id, settings.id))
      .returning();
    
    return updated;
  }

  async applyGlobalPriceAdjustment(factor: number, updatedBy: string): Promise<{ affectedMaterials: number }> {
    // Update all material prices by the factor
    const result = await db
      .update(materials)
      .set({
        price: sql`CAST((CAST(price AS DECIMAL) * ${factor}) AS TEXT)`,
        lastUpdated: new Date(),
      })
      .returning({ id: materials.id });

    // Update the global adjustment factor in settings
    await this.updatePriceSettings({
      globalAdjustmentFactor: factor.toString(),
      updatedBy,
    });

    return { affectedMaterials: result.length };
  }

  // Activity Compositions
  async getActivityCompositions(): Promise<ActivityComposition[]> {
    return await db.select().from(activityCompositions);
  }

  async getActivityCompositionsByActivity(activityId: number): Promise<ActivityComposition[]> {
    return await db.select()
      .from(activityCompositions)
      .where(eq(activityCompositions.activityId, activityId));
  }

  async createActivityComposition(composition: InsertActivityComposition): Promise<ActivityComposition> {
    const [created] = await db.insert(activityCompositions)
      .values(composition)
      .returning();
    return created;
  }

  async deleteActivityComposition(id: number): Promise<void> {
    await db.delete(activityCompositions)
      .where(eq(activityCompositions.id, id));
  }

  async updateActivity(id: number, updates: Partial<InsertActivity>): Promise<Activity> {
    const [activity] = await db
      .update(activities)
      .set(updates)
      .where(eq(activities.id, id))
      .returning();
    return activity;
  }

  // City Price Factors
  async getCityPriceFactors(): Promise<CityPriceFactor[]> {
    return await db
      .select()
      .from(cityPriceFactors)
      .where(eq(cityPriceFactors.isActive, true))
      .orderBy(cityPriceFactors.country, cityPriceFactors.city);
  }

  async getCityPriceFactor(city: string, country: string = "Bolivia"): Promise<CityPriceFactor | undefined> {
    const [factor] = await db
      .select()
      .from(cityPriceFactors)
      .where(
        and(
          eq(cityPriceFactors.city, city),
          eq(cityPriceFactors.country, country),
          eq(cityPriceFactors.isActive, true)
        )
      );
    return factor;
  }

  async createCityPriceFactor(factor: InsertCityPriceFactor): Promise<CityPriceFactor> {
    const [created] = await db
      .insert(cityPriceFactors)
      .values(factor)
      .returning();
    return created;
  }

  async updateCityPriceFactor(id: number, factor: Partial<InsertCityPriceFactor>): Promise<CityPriceFactor> {
    const [updated] = await db
      .update(cityPriceFactors)
      .set({ ...factor, updatedAt: new Date() })
      .where(eq(cityPriceFactors.id, id))
      .returning();
    return updated;
  }

  async deleteCityPriceFactor(id: number): Promise<void> {
    await db
      .update(cityPriceFactors)
      .set({ isActive: false, updatedAt: new Date() })
      .where(eq(cityPriceFactors.id, id));
  }

  async updateUserLocation(userId: number, city: string, country: string = "Bolivia"): Promise<User> {
    const [updated] = await db
      .update(users)
      .set({ city, country })
      .where(eq(users.id, userId))
      .returning();
    return updated;
  }

  // Supplier Companies
  async getSupplierCompanies(): Promise<SupplierCompanyWithUser[]> {
    const results = await db
      .select()
      .from(supplierCompanies)
      .leftJoin(users, eq(supplierCompanies.userId, users.id))
      .where(eq(supplierCompanies.isActive, true))
      .orderBy(desc(supplierCompanies.membershipType), desc(supplierCompanies.rating));

    return results.map(result => ({
      ...result.supplier_companies!,
      user: result.users!
    }));
  }

  async getSupplierCompany(id: number): Promise<SupplierCompanyWithUser | undefined> {
    const [result] = await db
      .select()
      .from(supplierCompanies)
      .leftJoin(users, eq(supplierCompanies.userId, users.id))
      .where(eq(supplierCompanies.id, id));
    
    if (!result) return undefined;
    
    return {
      ...result.supplier_companies!,
      user: result.users!
    };
  }

  async getSupplierCompanyByUser(userId: number): Promise<SupplierCompany | undefined> {
    const [company] = await db
      .select()
      .from(supplierCompanies)
      .where(eq(supplierCompanies.userId, userId));
    return company;
  }

  async createSupplierCompany(company: InsertSupplierCompany): Promise<SupplierCompany> {
    const [created] = await db
      .insert(supplierCompanies)
      .values(company)
      .returning();
    return created;
  }

  async updateSupplierCompany(id: number, company: Partial<InsertSupplierCompany>): Promise<SupplierCompany> {
    const [updated] = await db
      .update(supplierCompanies)
      .set({ ...company, updatedAt: new Date() })
      .where(eq(supplierCompanies.id, id))
      .returning();
    return updated;
  }

  async deleteSupplierCompany(id: number): Promise<void> {
    await db
      .update(supplierCompanies)
      .set({ isActive: false, updatedAt: new Date() })
      .where(eq(supplierCompanies.id, id));
  }

  // Material Supplier Prices
  async getMaterialSupplierPrices(materialId: number): Promise<(MaterialSupplierPrice & { supplier: SupplierCompany })[]> {
    const results = await db
      .select()
      .from(materialSupplierPrices)
      .leftJoin(supplierCompanies, eq(materialSupplierPrices.supplierId, supplierCompanies.id))
      .where(
        and(
          eq(materialSupplierPrices.materialId, materialId),
          eq(materialSupplierPrices.isActive, true),
          eq(supplierCompanies.isActive, true)
        )
      )
      .orderBy(
        desc(supplierCompanies.membershipType), // Premium first
        materialSupplierPrices.price // Then by price ascending
      );

    return results.map(result => ({
      ...result.material_supplier_prices,
      supplier: result.supplier_companies!
    }));
  }

  async getSupplierPrices(supplierId: number): Promise<(MaterialSupplierPrice & { material: Material })[]> {
    const results = await db
      .select()
      .from(materialSupplierPrices)
      .leftJoin(materials, eq(materialSupplierPrices.materialId, materials.id))
      .where(
        and(
          eq(materialSupplierPrices.supplierId, supplierId),
          eq(materialSupplierPrices.isActive, true)
        )
      )
      .orderBy(materials.description);

    return results.map(result => ({
      ...result.material_supplier_prices,
      material: result.materials!
    }));
  }

  async createMaterialSupplierPrice(price: InsertMaterialSupplierPrice): Promise<MaterialSupplierPrice> {
    const [created] = await db
      .insert(materialSupplierPrices)
      .values(price)
      .returning();
    return created;
  }

  async updateMaterialSupplierPrice(id: number, price: Partial<InsertMaterialSupplierPrice>): Promise<MaterialSupplierPrice> {
    const [updated] = await db
      .update(materialSupplierPrices)
      .set({ ...price, lastUpdated: new Date() })
      .where(eq(materialSupplierPrices.id, id))
      .returning();
    return updated;
  }

  async deleteMaterialSupplierPrice(id: number): Promise<void> {
    await db
      .update(materialSupplierPrices)
      .set({ isActive: false })
      .where(eq(materialSupplierPrices.id, id));
  }
}

export const storage = new DatabaseStorage();

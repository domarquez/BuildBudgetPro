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
  userMaterialPrices,
  companyAdvertisements,
  systemSettings,
  tools,
  laborCategories,
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
  type MaterialWithCustomPrice,
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
  type MaterialWithSupplierPrices,
  type UserMaterialPrice,
  type InsertUserMaterialPrice,
  type CompanyAdvertisement,
  type InsertCompanyAdvertisement,
  type AdvertisementWithSupplier,
  type SystemSetting,
  type InsertSystemSetting,
  type Tool,
  type InsertTool,
  type LaborCategory,
  type InsertLaborCategory
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

  // Company Advertisements
  getCompanyAdvertisements(supplierId: number): Promise<CompanyAdvertisement[]>;
  getCompanyAdvertisement(id: number): Promise<CompanyAdvertisement | undefined>;
  createCompanyAdvertisement(ad: InsertCompanyAdvertisement): Promise<CompanyAdvertisement>;
  updateCompanyAdvertisement(id: number, ad: Partial<InsertCompanyAdvertisement>): Promise<CompanyAdvertisement>;
  deleteCompanyAdvertisement(id: number): Promise<void>;
  incrementAdvertisementViews(id: number): Promise<void>;
  incrementAdvertisementClicks(id: number): Promise<void>;
  getRandomActiveAdvertisement(): Promise<AdvertisementWithSupplier | null>;

  // Configuración del sistema (TODO: implementar completamente)
  // getSystemSetting(key: string): Promise<string | null>;
  // setSystemSetting(key: string, value: string, description?: string): Promise<void>;

  // Acceso público (sin autenticación)
  getMaterialsPublic(): Promise<Material[]>;
  getMaterialCategoriesPublic(): Promise<MaterialCategory[]>;
  getSupplierCompaniesPublic(): Promise<SupplierCompany[]>;
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

  async updateMaterialPrice(id: number, price: number): Promise<Material> {
    const [updated] = await db
      .update(materials)
      .set({ price: price.toFixed(2), lastUpdated: new Date() })
      .where(eq(materials.id, id))
      .returning();
    return updated;
  }

  async deleteMaterial(id: number): Promise<void> {
    await db.delete(materials).where(eq(materials.id, id));
  }

  // Precios personalizados de materiales por usuario
  async getMaterialsWithCustomPrices(userId: number): Promise<MaterialWithCustomPrice[]> {
    const rows = await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .leftJoin(userMaterialPrices, and(
        eq(userMaterialPrices.materialId, materials.id),
        eq(userMaterialPrices.userId, userId)
      ))
      .orderBy(desc(materials.lastUpdated));

    return rows.map(row => ({
      ...row.materials,
      category: row.material_categories!,
      customPrice: row.user_material_prices || undefined,
      hasCustomPrice: !!row.user_material_prices
    }));
  }

  async getMaterialsWithCustomPricesByCategory(userId: number, categoryId: number): Promise<MaterialWithCustomPrice[]> {
    const rows = await db
      .select()
      .from(materials)
      .leftJoin(materialCategories, eq(materials.categoryId, materialCategories.id))
      .leftJoin(userMaterialPrices, and(
        eq(userMaterialPrices.materialId, materials.id),
        eq(userMaterialPrices.userId, userId)
      ))
      .where(eq(materials.categoryId, categoryId))
      .orderBy(materials.name);

    return rows.map(row => ({
      ...row.materials,
      category: row.material_categories!,
      customPrice: row.user_material_prices || undefined,
      hasCustomPrice: !!row.user_material_prices
    }));
  }

  async createUserMaterialPrice(data: InsertUserMaterialPrice): Promise<UserMaterialPrice> {
    // Verificar si ya existe un precio personalizado
    const existing = await db
      .select()
      .from(userMaterialPrices)
      .where(and(
        eq(userMaterialPrices.userId, data.userId),
        eq(userMaterialPrices.materialId, data.materialId)
      ));

    if (existing.length > 0) {
      // Actualizar precio existente
      const [updated] = await db
        .update(userMaterialPrices)
        .set({
          customPrice: data.customPrice,
          reason: data.reason,
          updatedAt: new Date()
        })
        .where(eq(userMaterialPrices.id, existing[0].id))
        .returning();
      return updated;
    } else {
      // Crear nuevo precio personalizado
      const [created] = await db
        .insert(userMaterialPrices)
        .values(data)
        .returning();
      return created;
    }
  }

  async deleteUserMaterialPrice(userId: number, materialId: number): Promise<void> {
    await db
      .delete(userMaterialPrices)
      .where(and(
        eq(userMaterialPrices.userId, userId),
        eq(userMaterialPrices.materialId, materialId)
      ));
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

  async updateActivityPhase(id: number, phaseId: number): Promise<Activity> {
    const [updated] = await db
      .update(activities)
      .set({ phaseId })
      .where(eq(activities.id, id))
      .returning();
    return updated;
  }

  async bulkMoveActivities(fromPhaseId: number, toPhaseId: number, keyword: string): Promise<{ count: number }> {
    const result = await db
      .update(activities)
      .set({ phaseId: toPhaseId })
      .where(and(
        eq(activities.phaseId, fromPhaseId),
        ilike(activities.name, `%${keyword}%`)
      ))
      .returning({ id: activities.id });
    
    return { count: result.length };
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
    // Remove any existing updatedAt and createdAt from the input to avoid conflicts
    const { updatedAt, createdAt, ...updateData } = company;
    
    const [updated] = await db
      .update(supplierCompanies)
      .set({ ...updateData, updatedAt: new Date() })
      .where(eq(supplierCompanies.id, id))
      .returning();
    return updated;
  }

  async getAllSupplierCompanies(): Promise<SupplierCompany[]> {
    return await db
      .select()
      .from(supplierCompanies)
      .orderBy(desc(supplierCompanies.membershipType), desc(supplierCompanies.createdAt));
  }

  async updateSupplierCompanyLogo(id: number, logoPath: string): Promise<SupplierCompany> {
    const [updated] = await db
      .update(supplierCompanies)
      .set({ logoUrl: logoPath, updatedAt: new Date() })
      .where(eq(supplierCompanies.id, id))
      .returning();
    return updated;
  }

  // Advertisement management methods
  async getAllAdvertisements(): Promise<(CompanyAdvertisement & { supplier: SupplierCompany })[]> {
    const results = await db
      .select()
      .from(companyAdvertisements)
      .leftJoin(supplierCompanies, eq(companyAdvertisements.supplierId, supplierCompanies.id))
      .orderBy(desc(companyAdvertisements.createdAt));

    return results.map(result => ({
      ...result.company_advertisements!,
      supplier: result.supplier_companies!
    }));
  }

  async createAdvertisement(data: InsertCompanyAdvertisement): Promise<CompanyAdvertisement> {
    const [created] = await db
      .insert(companyAdvertisements)
      .values(data)
      .returning();
    return created;
  }

  async updateAdvertisement(id: number, data: Partial<InsertCompanyAdvertisement>): Promise<CompanyAdvertisement> {
    // Remove any existing updatedAt and createdAt from the input to avoid conflicts
    const { updatedAt, createdAt, ...updateData } = data;
    
    const [updated] = await db
      .update(companyAdvertisements)
      .set({ ...updateData, updatedAt: new Date() })
      .where(eq(companyAdvertisements.id, id))
      .returning();
    return updated;
  }

  async deleteAdvertisement(id: number): Promise<void> {
    await db.delete(companyAdvertisements).where(eq(companyAdvertisements.id, id));
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

  // Tools management
  async getTools(): Promise<Tool[]> {
    const toolsList = await db.select().from(tools).where(eq(tools.isActive, true)).orderBy(tools.name);
    return toolsList;
  }

  async getTool(id: number): Promise<Tool | undefined> {
    const [tool] = await db.select().from(tools).where(eq(tools.id, id));
    return tool;
  }

  async createTool(toolData: InsertTool): Promise<Tool> {
    const [tool] = await db.insert(tools).values(toolData).returning();
    return tool;
  }

  async updateTool(id: number, toolData: Partial<InsertTool>): Promise<Tool> {
    const [tool] = await db.update(tools)
      .set({ ...toolData, updatedAt: new Date() })
      .where(eq(tools.id, id))
      .returning();
    return tool;
  }

  async deleteTool(id: number): Promise<void> {
    await db.update(tools).set({ isActive: false }).where(eq(tools.id, id));
  }

  // Labor categories management
  async getLaborCategories(): Promise<LaborCategory[]> {
    const laborList = await db.select().from(laborCategories).where(eq(laborCategories.isActive, true)).orderBy(laborCategories.name);
    return laborList;
  }

  async getLaborCategory(id: number): Promise<LaborCategory | undefined> {
    const [labor] = await db.select().from(laborCategories).where(eq(laborCategories.id, id));
    return labor;
  }

  async createLaborCategory(laborData: InsertLaborCategory): Promise<LaborCategory> {
    const [labor] = await db.insert(laborCategories).values(laborData).returning();
    return labor;
  }

  async updateLaborCategory(id: number, laborData: Partial<InsertLaborCategory>): Promise<LaborCategory> {
    const [labor] = await db.update(laborCategories)
      .set({ ...laborData, updatedAt: new Date() })
      .where(eq(laborCategories.id, id))
      .returning();
    return labor;
  }

  async deleteLaborCategory(id: number): Promise<void> {
    await db.update(laborCategories).set({ isActive: false }).where(eq(laborCategories.id, id));
  }

  // Sistema de publicidad (TODO: implementar completamente)
  // async getActiveAdvertisements(): Promise<AdvertisementWithSupplier[]> { ... }
  // async getRandomAdvertisement(): Promise<AdvertisementWithSupplier | null> { ... }
  // async createAdvertisement(data: InsertCompanyAdvertisement): Promise<CompanyAdvertisement> { ... }
  // async updateAdvertisementViews(adId: number): Promise<void> { ... }
  // async updateAdvertisementClicks(adId: number): Promise<void> { ... }
  // async getAdvertisementsBySupplier(supplierId: number): Promise<CompanyAdvertisement[]> { ... }

  // Configuración del sistema (TODO: implementar completamente)
  // async getSystemSetting(key: string): Promise<string | null> { ... }
  // async setSystemSetting(key: string, value: string, description?: string): Promise<void> { ... }

  // Acceso público (sin autenticación)
  async getMaterialsPublic(): Promise<Material[]> {
    return await db
      .select()
      .from(materials)
      .orderBy(materials.name)
      .limit(100); // Limitar para acceso público
  }

  async getMaterialCategoriesPublic(): Promise<MaterialCategory[]> {
    return await db
      .select()
      .from(materialCategories)
      .orderBy(materialCategories.name);
  }

  async getSupplierCompaniesPublic(): Promise<SupplierCompany[]> {
    return await db
      .select()
      .from(supplierCompanies)
      .where(
        and(
          eq(supplierCompanies.isActive, true),
          eq(supplierCompanies.isVerified, true)
        )
      )
      .orderBy(
        desc(supplierCompanies.membershipType), // Premium primero
        desc(supplierCompanies.rating)
      )
      .limit(50); // Limitar para acceso público
  }

  // Additional activity management methods
  async deleteActivity(id: number): Promise<void> {
    await db.delete(activities).where(eq(activities.id, id));
  }

  async getBudgetItemsByActivity(activityId: number): Promise<BudgetItem[]> {
    return await db.select().from(budgetItems).where(eq(budgetItems.activityId, activityId));
  }

  async deleteActivityCompositionsByActivity(activityId: number): Promise<void> {
    await db.delete(activityCompositions).where(eq(activityCompositions.activityId, activityId));
  }

  // Company Advertisements
  async getCompanyAdvertisements(supplierId: number): Promise<CompanyAdvertisement[]> {
    return await db
      .select()
      .from(companyAdvertisements)
      .where(eq(companyAdvertisements.supplierId, supplierId))
      .orderBy(desc(companyAdvertisements.createdAt));
  }

  async getCompanyAdvertisement(id: number): Promise<CompanyAdvertisement | undefined> {
    const [advertisement] = await db
      .select()
      .from(companyAdvertisements)
      .where(eq(companyAdvertisements.id, id));
    return advertisement || undefined;
  }

  async createCompanyAdvertisement(ad: InsertCompanyAdvertisement): Promise<CompanyAdvertisement> {
    const adData = {
      ...ad,
      startDate: ad.startDate ? new Date(ad.startDate) : null,
      endDate: ad.endDate ? new Date(ad.endDate) : null,
    };
    
    const [created] = await db
      .insert(companyAdvertisements)
      .values(adData)
      .returning();
    return created;
  }

  async updateCompanyAdvertisement(id: number, ad: Partial<InsertCompanyAdvertisement>): Promise<CompanyAdvertisement> {
    const updateData: any = {
      ...ad,
      updatedAt: new Date()
    };
    
    if (ad.startDate) {
      updateData.startDate = new Date(ad.startDate);
    }
    if (ad.endDate) {
      updateData.endDate = new Date(ad.endDate);
    }
    
    const [updated] = await db
      .update(companyAdvertisements)
      .set(updateData)
      .where(eq(companyAdvertisements.id, id))
      .returning();
    return updated;
  }

  async deleteCompanyAdvertisement(id: number): Promise<void> {
    await db.delete(companyAdvertisements).where(eq(companyAdvertisements.id, id));
  }

  async incrementAdvertisementViews(id: number): Promise<void> {
    await db
      .update(companyAdvertisements)
      .set({
        viewCount: sql`${companyAdvertisements.viewCount} + 1`,
        updatedAt: new Date()
      })
      .where(eq(companyAdvertisements.id, id));
  }

  async incrementAdvertisementClicks(id: number): Promise<void> {
    await db
      .update(companyAdvertisements)
      .set({
        clickCount: sql`${companyAdvertisements.clickCount} + 1`,
        updatedAt: new Date()
      })
      .where(eq(companyAdvertisements.id, id));
  }

  async getRandomActiveAdvertisement(): Promise<AdvertisementWithSupplier | null> {
    const activeAds = await db
      .select()
      .from(companyAdvertisements)
      .leftJoin(supplierCompanies, eq(companyAdvertisements.supplierId, supplierCompanies.id))
      .where(
        and(
          eq(companyAdvertisements.isActive, true),
          sql`(${companyAdvertisements.endDate} IS NULL OR ${companyAdvertisements.endDate} > NOW())`,
          sql`(${companyAdvertisements.startDate} IS NULL OR ${companyAdvertisements.startDate} <= NOW())`
        )
      )
      .orderBy(sql`RANDOM()`);

    if (activeAds.length === 0) {
      return null;
    }

    // Get first random result (already randomized by SQL)
    const randomAd = activeAds[0];

    if (!randomAd.company_advertisements || !randomAd.supplier_companies) {
      return null;
    }

    // Increment view count
    await this.incrementAdvertisementViews(randomAd.company_advertisements.id);

    return {
      ...randomAd.company_advertisements,
      supplier: randomAd.supplier_companies
    };
  }
}

export const storage = new DatabaseStorage();

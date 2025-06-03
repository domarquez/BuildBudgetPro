import { pgTable, text, serial, integer, boolean, decimal, timestamp } from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const users = pgTable("users", {
  id: serial("id").primaryKey(),
  username: text("username").notNull().unique(),
  email: text("email").notNull().unique(),
  password: text("password").notNull(),
  firstName: text("first_name"),
  lastName: text("last_name"),
  role: text("role").notNull().default("user"), // 'admin', 'user'
  userType: text("user_type").notNull().default("architect"), // 'architect', 'constructor', 'supplier'
  isActive: boolean("is_active").notNull().default(true),
  city: text("city"),
  country: text("country").default("Bolivia"),
  createdAt: timestamp("created_at").defaultNow(),
  lastLogin: timestamp("last_login"),
});

export const constructionPhases = pgTable("construction_phases", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description"),
});

export const materialCategories = pgTable("material_categories", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
});

export const activities = pgTable("activities", {
  id: serial("id").primaryKey(),
  phaseId: integer("phase_id").notNull().references(() => constructionPhases.id),
  name: text("name").notNull(),
  unit: text("unit").notNull(),
  description: text("description"),
  unitPrice: decimal("unit_price", { precision: 10, scale: 2 }).default("0"),
});

export const materials = pgTable("materials", {
  id: serial("id").primaryKey(),
  categoryId: integer("category_id").notNull().references(() => materialCategories.id),
  name: text("name").notNull(),
  unit: text("unit").notNull(),
  price: decimal("price", { precision: 10, scale: 2 }).notNull(),
  description: text("description"),
  lastUpdated: timestamp("last_updated").defaultNow(),
});

// Precios personalizados de materiales por usuario
export const userMaterialPrices = pgTable("user_material_prices", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  originalMaterialName: text("original_material_name").notNull(), // Nombre original del material
  customMaterialName: text("custom_material_name").notNull(), // Nombre personalizado por el usuario
  price: decimal("price", { precision: 10, scale: 2 }).notNull(),
  unit: text("unit").notNull(),
  reason: text("reason"), // Motivo del cambio de precio/nombre
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Sistema de publicidad para empresas
export const companyAdvertisements = pgTable("company_advertisements", {
  id: serial("id").primaryKey(),
  supplierId: integer("supplier_id").notNull().references(() => supplierCompanies.id),
  title: text("title").notNull(),
  description: text("description"),
  imageUrl: text("image_url").notNull(),
  linkUrl: text("link_url"), // URL externa o página de la empresa
  adType: text("ad_type").notNull().default("banner"), // 'banner', 'featured', 'popup'
  isActive: boolean("is_active").notNull().default(true),
  startDate: timestamp("start_date").defaultNow(),
  endDate: timestamp("end_date"),
  viewCount: integer("view_count").notNull().default(0),
  clickCount: integer("click_count").notNull().default(0),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Configuración del sistema público/premium
export const systemSettings = pgTable("system_settings", {
  id: serial("id").primaryKey(),
  settingKey: text("setting_key").notNull().unique(),
  settingValue: text("setting_value").notNull(),
  description: text("description"),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const projects = pgTable("projects", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  client: text("client"),
  location: text("location"),
  city: text("city"),
  country: text("country").default("Bolivia"),
  startDate: timestamp("start_date"),
  userId: integer("user_id").references(() => users.id),
  status: text("status").notNull().default('planning'), // planning, active, completed, cancelled
  // Porcentajes configurables para cálculos de costos
  equipmentPercentage: decimal("equipment_percentage", { precision: 5, scale: 2 }).notNull().default("5.00"),
  administrativePercentage: decimal("administrative_percentage", { precision: 5, scale: 2 }).notNull().default("8.00"),
  utilityPercentage: decimal("utility_percentage", { precision: 5, scale: 2 }).notNull().default("15.00"),
  taxPercentage: decimal("tax_percentage", { precision: 5, scale: 2 }).notNull().default("3.09"),
  socialChargesPercentage: decimal("social_charges_percentage", { precision: 5, scale: 2 }).notNull().default("71.18"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const budgets = pgTable("budgets", {
  id: serial("id").primaryKey(),
  projectId: integer("project_id").notNull().references(() => projects.id),
  phaseId: integer("phase_id"), // Opcional - para compatibilidad hacia atrás
  total: decimal("total", { precision: 12, scale: 2 }).notNull().default('0'),
  status: text("status").notNull().default('draft'), // draft, active, completed
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const budgetItems = pgTable("budget_items", {
  id: serial("id").primaryKey(),
  budgetId: integer("budget_id").notNull().references(() => budgets.id),
  activityId: integer("activity_id").notNull().references(() => activities.id),
  phaseId: integer("phase_id").references(() => constructionPhases.id), // Nueva columna para organizar por fases
  quantity: decimal("quantity", { precision: 10, scale: 3 }).notNull(),
  unitPrice: decimal("unit_price", { precision: 10, scale: 2 }).notNull(),
  subtotal: decimal("subtotal", { precision: 12, scale: 2 }).notNull(),
});

// Composiciones de actividades - materiales, mano de obra y herramientas que conforman cada actividad
export const activityCompositions = pgTable("activity_compositions", {
  id: serial("id").primaryKey(),
  activityId: integer("activity_id").notNull().references(() => activities.id),
  materialId: integer("material_id").references(() => materials.id), // null para mano de obra y herramientas
  laborId: integer("labor_id").references(() => laborCategories.id), // null para materiales y herramientas
  toolId: integer("tool_id").references(() => tools.id), // null para materiales y mano de obra
  description: text("description").notNull(), // ej: "Mano de obra especializada", "Cemento Portland", "Retroexcavadora"
  unit: text("unit").notNull(),
  quantity: decimal("quantity", { precision: 10, scale: 4 }).notNull(), // rendimiento por unidad de actividad
  unitCost: decimal("unit_cost", { precision: 10, scale: 2 }).notNull(),
  type: text("type").notNull(), // 'material', 'labor', 'tool'
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const priceSettings = pgTable("price_settings", {
  id: serial("id").primaryKey(),
  usdExchangeRate: decimal("usd_exchange_rate", { precision: 10, scale: 4 }).notNull().default("6.96"),
  inflationFactor: decimal("inflation_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  globalAdjustmentFactor: decimal("global_adjustment_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  lastUpdated: timestamp("last_updated").defaultNow().notNull(),
  updatedBy: text("updated_by"),
});

export const cityPriceFactors = pgTable("city_price_factors", {
  id: serial("id").primaryKey(),
  city: text("city").notNull(),
  country: text("country").notNull().default("Bolivia"),
  materialsFactor: decimal("materials_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  laborFactor: decimal("labor_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  equipmentFactor: decimal("equipment_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  transportFactor: decimal("transport_factor", { precision: 10, scale: 4 }).notNull().default("1.0000"),
  description: text("description"),
  isActive: boolean("is_active").notNull().default(true),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const supplierCompanies = pgTable("supplier_companies", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull().references(() => users.id),
  companyName: text("company_name").notNull(),
  businessType: text("business_type"), // 'wholesaler', 'retailer', 'manufacturer', 'distributor'
  speciality: text("speciality"), // 'acero', 'aluminio', 'cemento', 'agua', 'electricos', 'ceramicos', etc.
  description: text("description"),
  address: text("address"),
  city: text("city"),
  country: text("country").default("Bolivia"),
  phone: text("phone"),
  whatsapp: text("whatsapp"),
  website: text("website"),
  facebook: text("facebook"),
  logoUrl: text("logo_url"),
  imageUrls: text("image_urls").array(),
  membershipType: text("membership_type").notNull().default("free"), // 'free', 'premium'
  membershipExpiresAt: timestamp("membership_expires_at"),
  isActive: boolean("is_active").notNull().default(true),
  isVerified: boolean("is_verified").notNull().default(false),
  rating: decimal("rating", { precision: 3, scale: 2 }).default("0.00"),
  reviewCount: integer("review_count").notNull().default(0),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const materialSupplierPrices = pgTable("material_supplier_prices", {
  id: serial("id").primaryKey(),
  materialId: integer("material_id").notNull().references(() => materials.id),
  supplierId: integer("supplier_id").notNull().references(() => supplierCompanies.id),
  price: decimal("price", { precision: 12, scale: 4 }).notNull(),
  currency: text("currency").notNull().default("BOB"),
  minimumQuantity: decimal("minimum_quantity", { precision: 10, scale: 2 }).default("1.00"),
  leadTimeDays: integer("lead_time_days").default(0),
  description: text("description"),
  isActive: boolean("is_active").notNull().default(true),
  lastUpdated: timestamp("last_updated").defaultNow(),
  validUntil: timestamp("valid_until"),
  createdAt: timestamp("created_at").defaultNow(),
});

export const tools = pgTable("tools", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description"),
  unit: text("unit").notNull(),
  unitPrice: decimal("unit_price", { precision: 10, scale: 2 }).notNull(),
  isActive: boolean("is_active").notNull().default(true),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const laborCategories = pgTable("labor_categories", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description"),
  unit: text("unit").notNull(),
  hourlyRate: decimal("hourly_rate", { precision: 10, scale: 2 }).notNull(),
  skillLevel: text("skill_level"), // 'basic', 'skilled', 'specialist'
  isActive: boolean("is_active").notNull().default(true),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const consultationMessages = pgTable("consultation_messages", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").references(() => users.id),
  name: text("name").notNull(),
  email: text("email").notNull(),
  messageType: text("message_type").notNull().default("consulta"), // 'consulta', 'sugerencia'
  subject: text("subject").notNull(),
  message: text("message").notNull(),
  status: text("status").notNull().default("pendiente"), // 'pendiente', 'leido', 'respondido'
  adminResponse: text("admin_response"),
  isPublic: boolean("is_public").notNull().default(false),
  createdAt: timestamp("created_at").defaultNow(),
  respondedAt: timestamp("responded_at"),
});

// Relations
export const constructionPhasesRelations = relations(constructionPhases, ({ many }) => ({
  activities: many(activities),
  budgets: many(budgets),
}));

export const materialCategoriesRelations = relations(materialCategories, ({ many }) => ({
  materials: many(materials),
}));

export const activitiesRelations = relations(activities, ({ one, many }) => ({
  phase: one(constructionPhases, {
    fields: [activities.phaseId],
    references: [constructionPhases.id],
  }),
  budgetItems: many(budgetItems),
  compositions: many(activityCompositions),
}));

export const activityCompositionsRelations = relations(activityCompositions, ({ one }) => ({
  activity: one(activities, {
    fields: [activityCompositions.activityId],
    references: [activities.id],
  }),
  material: one(materials, {
    fields: [activityCompositions.materialId],
    references: [materials.id],
  }),
  labor: one(laborCategories, {
    fields: [activityCompositions.laborId],
    references: [laborCategories.id],
  }),
  tool: one(tools, {
    fields: [activityCompositions.toolId],
    references: [tools.id],
  }),
}));

export const toolsRelations = relations(tools, ({ many }) => ({
  compositions: many(activityCompositions),
}));

export const laborCategoriesRelations = relations(laborCategories, ({ many }) => ({
  compositions: many(activityCompositions),
}));

export const materialsRelations = relations(materials, ({ one }) => ({
  category: one(materialCategories, {
    fields: [materials.categoryId],
    references: [materialCategories.id],
  }),
}));

export const projectsRelations = relations(projects, ({ many }) => ({
  budgets: many(budgets),
}));

export const budgetsRelations = relations(budgets, ({ one, many }) => ({
  project: one(projects, {
    fields: [budgets.projectId],
    references: [projects.id],
  }),
  phase: one(constructionPhases, {
    fields: [budgets.phaseId],
    references: [constructionPhases.id],
  }),
  items: many(budgetItems),
}));

export const budgetItemsRelations = relations(budgetItems, ({ one }) => ({
  budget: one(budgets, {
    fields: [budgetItems.budgetId],
    references: [budgets.id],
  }),
  activity: one(activities, {
    fields: [budgetItems.activityId],
    references: [activities.id],
  }),
}));

export const usersRelations = relations(users, ({ one }) => ({
  supplierCompany: one(supplierCompanies, {
    fields: [users.id],
    references: [supplierCompanies.userId],
  }),
}));

export const supplierCompaniesRelations = relations(supplierCompanies, ({ one, many }) => ({
  user: one(users, {
    fields: [supplierCompanies.userId],
    references: [users.id],
  }),
  materialPrices: many(materialSupplierPrices),
  advertisements: many(companyAdvertisements),
}));

export const companyAdvertisementsRelations = relations(companyAdvertisements, ({ one }) => ({
  supplier: one(supplierCompanies, {
    fields: [companyAdvertisements.supplierId],
    references: [supplierCompanies.id],
  }),
}));

export const materialSupplierPricesRelations = relations(materialSupplierPrices, ({ one }) => ({
  material: one(materials, {
    fields: [materialSupplierPrices.materialId],
    references: [materials.id],
  }),
  supplier: one(supplierCompanies, {
    fields: [materialSupplierPrices.supplierId],
    references: [supplierCompanies.id],
  }),
}));

export const consultationMessagesRelations = relations(consultationMessages, ({ one }) => ({
  user: one(users, {
    fields: [consultationMessages.userId],
    references: [users.id],
  }),
}));

// Schemas
export const insertUserSchema = createInsertSchema(users).omit({
  id: true,
  createdAt: true,
  lastLogin: true,
});

export const insertMaterialCategorySchema = createInsertSchema(materialCategories).omit({
  id: true,
});

export const insertConstructionPhaseSchema = createInsertSchema(constructionPhases).omit({
  id: true,
});

export const insertActivitySchema = createInsertSchema(activities).omit({
  id: true,
});

export const insertMaterialSchema = createInsertSchema(materials).omit({
  id: true,
  lastUpdated: true,
});

export const insertProjectSchema = createInsertSchema(projects).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
}).extend({
  name: z.string().min(1, "El nombre del proyecto es requerido"),
  client: z.string().optional(),
  location: z.string().optional(),
  startDate: z.union([z.string(), z.date()]).optional().nullable(),
  userId: z.number().optional(),
  status: z.string().optional(),
});

export const insertBudgetSchema = createInsertSchema(budgets).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
}).extend({
  total: z.union([z.string(), z.number()]).transform(val => String(val)),
});

export const insertBudgetItemSchema = createInsertSchema(budgetItems).omit({
  id: true,
}).extend({
  quantity: z.union([z.string(), z.number()]).transform(val => String(val)),
  unitPrice: z.union([z.string(), z.number()]).transform(val => String(val)),
  subtotal: z.union([z.string(), z.number()]).transform(val => String(val)),
  phaseId: z.number().optional(),
});

export const insertPriceSettingsSchema = createInsertSchema(priceSettings).omit({
  id: true,
  lastUpdated: true,
});

export const insertActivityCompositionSchema = createInsertSchema(activityCompositions).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertCityPriceFactorSchema = createInsertSchema(cityPriceFactors).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertSupplierCompanySchema = createInsertSchema(supplierCompanies).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertMaterialSupplierPriceSchema = createInsertSchema(materialSupplierPrices).omit({
  id: true,
  createdAt: true,
  lastUpdated: true,
}).extend({
  price: z.union([z.string(), z.number()]).transform(val => String(val)),
  minimumQuantity: z.union([z.string(), z.number()]).transform(val => String(val)).optional(),
  currency: z.string().optional(),
  leadTimeDays: z.number().optional(),
  description: z.string().optional(),
  isActive: z.boolean().optional(),
  validUntil: z.union([z.string(), z.date()]).transform(val => 
    typeof val === 'string' ? new Date(val) : val
  ).optional(),
}).partial({
  minimumQuantity: true,
  currency: true,
  leadTimeDays: true,
  description: true,
  isActive: true,
  validUntil: true,
});

export const insertToolSchema = createInsertSchema(tools).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertLaborCategorySchema = createInsertSchema(laborCategories).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertUserMaterialPriceSchema = createInsertSchema(userMaterialPrices).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
}).extend({
  price: z.union([z.string(), z.number()]).transform(val => String(val)),
});

export const insertCompanyAdvertisementSchema = createInsertSchema(companyAdvertisements).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
  viewCount: true,
  clickCount: true,
}).extend({
  title: z.string().min(1, "El título es requerido"),
  imageUrl: z.string().min(1, "La imagen es requerida"),
  description: z.string().optional(),
  linkUrl: z.string().url().optional().or(z.literal("")),
  adType: z.string().optional(),
  startDate: z.union([z.string(), z.date()]).optional(),
  endDate: z.union([z.string(), z.date()]).optional(),
});

export const insertSystemSettingSchema = createInsertSchema(systemSettings).omit({
  id: true,
  updatedAt: true,
});

export const insertConsultationMessageSchema = createInsertSchema(consultationMessages).omit({
  id: true,
  status: true,
  adminResponse: true,
  isPublic: true,
  createdAt: true,
  respondedAt: true,
}).extend({
  name: z.string().min(1, "El nombre es requerido"),
  email: z.string().email("Email inválido"),
  subject: z.string().min(1, "El asunto es requerido"),
  message: z.string().min(10, "El mensaje debe tener al menos 10 caracteres"),
  messageType: z.enum(["consulta", "sugerencia"]).default("consulta"),
});

// Types
export type User = typeof users.$inferSelect;
export type InsertUser = z.infer<typeof insertUserSchema>;
export type MaterialCategory = typeof materialCategories.$inferSelect;
export type InsertMaterialCategory = z.infer<typeof insertMaterialCategorySchema>;
export type ConstructionPhase = typeof constructionPhases.$inferSelect;
export type InsertConstructionPhase = z.infer<typeof insertConstructionPhaseSchema>;
export type Activity = typeof activities.$inferSelect;
export type InsertActivity = z.infer<typeof insertActivitySchema>;
export type Material = typeof materials.$inferSelect;
export type InsertMaterial = z.infer<typeof insertMaterialSchema>;
export type Project = typeof projects.$inferSelect;
export type InsertProject = z.infer<typeof insertProjectSchema>;
export type Budget = typeof budgets.$inferSelect;
export type InsertBudget = z.infer<typeof insertBudgetSchema>;
export type BudgetItem = typeof budgetItems.$inferSelect;
export type InsertBudgetItem = z.infer<typeof insertBudgetItemSchema>;
export type PriceSettings = typeof priceSettings.$inferSelect;
export type InsertPriceSettings = z.infer<typeof insertPriceSettingsSchema>;

// Extended types for queries with relations
export type MaterialWithCategory = Material & {
  category: MaterialCategory;
};

export type ActivityWithPhase = Activity & {
  phase: ConstructionPhase;
};

export type BudgetWithProject = Budget & {
  project: Project;
  phase: ConstructionPhase;
};

export type ActivityComposition = typeof activityCompositions.$inferSelect;
export type InsertActivityComposition = z.infer<typeof insertActivityCompositionSchema>;

export type CityPriceFactor = typeof cityPriceFactors.$inferSelect;
export type InsertCityPriceFactor = z.infer<typeof insertCityPriceFactorSchema>;

export type BudgetItemWithActivity = BudgetItem & {
  activity: ActivityWithPhase;
};

export type ActivityWithCompositions = Activity & {
  phase: ConstructionPhase;
  compositions: (ActivityComposition & {
    material?: Material;
  })[];
};

export type SupplierCompany = typeof supplierCompanies.$inferSelect;
export type InsertSupplierCompany = z.infer<typeof insertSupplierCompanySchema>;

export type MaterialSupplierPrice = typeof materialSupplierPrices.$inferSelect;
export type InsertMaterialSupplierPrice = z.infer<typeof insertMaterialSupplierPriceSchema>;

export type SupplierCompanyWithUser = SupplierCompany & {
  user: User;
};

export type MaterialWithSupplierPrices = Material & {
  category: MaterialCategory;
  supplierPrices: (MaterialSupplierPrice & {
    supplier: SupplierCompany;
  })[];
};

export type Tool = typeof tools.$inferSelect;
export type InsertTool = z.infer<typeof insertToolSchema>;
export type LaborCategory = typeof laborCategories.$inferSelect;
export type InsertLaborCategory = z.infer<typeof insertLaborCategorySchema>;

export type UserMaterialPrice = typeof userMaterialPrices.$inferSelect;
export type InsertUserMaterialPrice = z.infer<typeof insertUserMaterialPriceSchema>;

export type MaterialWithCustomPrice = Material & {
  category: MaterialCategory;
  customPrice?: UserMaterialPrice;
  hasCustomPrice: boolean;
};

export type CompanyAdvertisement = typeof companyAdvertisements.$inferSelect;
export type InsertCompanyAdvertisement = z.infer<typeof insertCompanyAdvertisementSchema>;

export type SystemSetting = typeof systemSettings.$inferSelect;
export type InsertSystemSetting = z.infer<typeof insertSystemSettingSchema>;

export type AdvertisementWithSupplier = CompanyAdvertisement & {
  supplier: SupplierCompany;
};

export type ActivityCompositionWithDetails = ActivityComposition & {
  material?: Material;
  labor?: LaborCategory;
  tool?: Tool;
};

export type ConsultationMessage = typeof consultationMessages.$inferSelect;
export type InsertConsultationMessage = z.infer<typeof insertConsultationMessageSchema>;

export type ConsultationMessageWithUser = ConsultationMessage & {
  user?: User;
};

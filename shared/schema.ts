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
  isActive: boolean("is_active").notNull().default(true),
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

export const projects = pgTable("projects", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  client: text("client"),
  location: text("location"),
  startDate: timestamp("start_date"),
  userId: integer("user_id").references(() => users.id),
  status: text("status").notNull().default('planning'), // planning, active, completed, cancelled
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const budgets = pgTable("budgets", {
  id: serial("id").primaryKey(),
  projectId: integer("project_id").notNull().references(() => projects.id),
  phaseId: integer("phase_id").notNull().references(() => constructionPhases.id),
  total: decimal("total", { precision: 12, scale: 2 }).notNull().default('0'),
  status: text("status").notNull().default('draft'), // draft, active, completed
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

export const budgetItems = pgTable("budget_items", {
  id: serial("id").primaryKey(),
  budgetId: integer("budget_id").notNull().references(() => budgets.id),
  activityId: integer("activity_id").notNull().references(() => activities.id),
  quantity: decimal("quantity", { precision: 10, scale: 3 }).notNull(),
  unitPrice: decimal("unit_price", { precision: 10, scale: 2 }).notNull(),
  subtotal: decimal("subtotal", { precision: 12, scale: 2 }).notNull(),
});

// Composiciones de actividades - materiales y mano de obra que conforman cada actividad
export const activityCompositions = pgTable("activity_compositions", {
  id: serial("id").primaryKey(),
  activityId: integer("activity_id").notNull().references(() => activities.id),
  materialId: integer("material_id").references(() => materials.id), // null para mano de obra
  description: text("description").notNull(), // ej: "Mano de obra especializada", "Cemento Portland"
  unit: text("unit").notNull(),
  quantity: decimal("quantity", { precision: 10, scale: 4 }).notNull(), // rendimiento por unidad de actividad
  unitCost: decimal("unit_cost", { precision: 10, scale: 2 }).notNull(),
  type: text("type").notNull(), // 'material' o 'labor'
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

export type BudgetItemWithActivity = BudgetItem & {
  activity: ActivityWithPhase;
};

export type ActivityWithCompositions = Activity & {
  phase: ConstructionPhase;
  compositions: (ActivityComposition & {
    material?: Material;
  })[];
};

import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { AuthService, requireAuth, requireAdmin } from "./auth";
import { 
  insertMaterialSchema,
  insertProjectSchema,
  insertBudgetSchema,
  insertBudgetItemSchema,
  insertActivityCompositionSchema,
  insertCityPriceFactorSchema,
  insertSupplierCompanySchema,
  insertMaterialSupplierPriceSchema,
  insertToolSchema,
  insertLaborCategorySchema,
  insertActivitySchema
} from "@shared/schema";
import { z } from "zod";

export async function registerRoutes(app: Express): Promise<Server> {
  // Authentication routes
  app.post("/api/auth/register", async (req, res) => {
    try {
      const { user, token } = await AuthService.register(req.body);
      
      // Don't send password in response
      const { password, ...userWithoutPassword } = user;
      
      res.json({ user: userWithoutPassword, token });
    } catch (error: any) {
      console.error("Registration error:", error);
      res.status(400).json({ message: error.message });
    }
  });

  // Admin registration route
  app.post("/api/auth/register-admin", async (req, res) => {
    try {
      const userData = {
        ...req.body,
        role: 'admin'
      };
      const { user, token } = await AuthService.register(userData);
      
      // Don't send password in response
      const { password, ...userWithoutPassword } = user;
      
      res.json({ user: userWithoutPassword, token });
    } catch (error: any) {
      console.error("Admin registration error:", error);
      res.status(400).json({ message: error.message });
    }
  });

  app.post("/api/auth/login", async (req, res) => {
    try {
      const { user, token } = await AuthService.login(req.body);
      
      // Don't send password in response
      const { password, ...userWithoutPassword } = user;
      
      res.json({ user: userWithoutPassword, token });
    } catch (error: any) {
      console.error("Login error:", error);
      res.status(400).json({ message: error.message });
    }
  });

  app.get("/api/auth/me", requireAuth, async (req: any, res) => {
    try {
      const { password, ...userWithoutPassword } = req.user;
      res.json(userWithoutPassword);
    } catch (error) {
      console.error("Get user error:", error);
      res.status(500).json({ message: "Error fetching user data" });
    }
  });

  // Statistics
  app.get("/api/statistics", async (req, res) => {
    try {
      const stats = await storage.getStatistics();
      res.json(stats);
    } catch (error) {
      console.error("Error fetching statistics:", error);
      res.status(500).json({ message: "Failed to fetch statistics" });
    }
  });

  // Material Categories
  app.get("/api/material-categories", async (req, res) => {
    try {
      const categories = await storage.getMaterialCategories();
      res.json(categories);
    } catch (error) {
      console.error("Error fetching material categories:", error);
      res.status(500).json({ message: "Failed to fetch material categories" });
    }
  });

  // Construction Phases
  app.get("/api/construction-phases", async (req, res) => {
    try {
      const phases = await storage.getConstructionPhases();
      res.json(phases);
    } catch (error) {
      console.error("Error fetching construction phases:", error);
      res.status(500).json({ message: "Failed to fetch construction phases" });
    }
  });

  // Activities
  app.get("/api/activities", async (req, res) => {
    try {
      const { phaseId, withCompositions } = req.query;
      let activities;
      
      if (phaseId) {
        activities = await storage.getActivitiesByPhase(Number(phaseId));
      } else {
        activities = await storage.getActivities();
      }

      // Filter only activities with compositions if requested
      if (withCompositions === 'true') {
        const { db } = await import("./db");
        const { activityCompositions } = await import("@shared/schema");
        
        const activitiesWithCompositions = await db
          .selectDistinct({ activityId: activityCompositions.activityId })
          .from(activityCompositions);
        
        const compositionActivityIds = new Set(activitiesWithCompositions.map(a => a.activityId));
        activities = activities.filter(activity => compositionActivityIds.has(activity.id));
      }
      
      res.json(activities);
    } catch (error) {
      console.error("Error fetching activities:", error);
      res.status(500).json({ message: "Failed to fetch activities" });
    }
  });

  // Admin: Create activity
  app.post("/api/activities", requireAuth, requireAdmin, async (req, res) => {
    try {
      const activityData = insertActivitySchema.parse(req.body);
      const activity = await storage.createActivity(activityData);
      res.status(201).json(activity);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid activity data", errors: error.errors });
      }
      console.error("Error creating activity:", error);
      res.status(500).json({ message: "Failed to create activity" });
    }
  });

  // Admin: Update activity
  app.put("/api/activities/:id", requireAuth, requireAdmin, async (req, res) => {
    try {
      const activityData = insertActivitySchema.partial().parse(req.body);
      const activity = await storage.updateActivity(Number(req.params.id), activityData);
      res.json(activity);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid activity data", errors: error.errors });
      }
      console.error("Error updating activity:", error);
      res.status(500).json({ message: "Failed to update activity" });
    }
  });

  // Admin: Delete activity
  app.delete("/api/activities/:id", requireAuth, requireAdmin, async (req, res) => {
    try {
      const activityId = Number(req.params.id);
      
      // Check if activity has budget items
      const budgetItems = await storage.getBudgetItemsByActivity(activityId);
      if (budgetItems.length > 0) {
        return res.status(400).json({ 
          message: "Cannot delete activity with existing budget items" 
        });
      }
      
      // Delete compositions first
      await storage.deleteActivityCompositionsByActivity(activityId);
      
      // Delete activity
      await storage.deleteActivity(activityId);
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting activity:", error);
      res.status(500).json({ message: "Failed to delete activity" });
    }
  });

  // Activity Compositions
  app.get("/api/activity-compositions/:activityId", async (req, res) => {
    try {
      const activityId = Number(req.params.activityId);
      const compositions = await storage.getActivityCompositionsByActivity(activityId);
      res.json(compositions);
    } catch (error) {
      console.error("Error fetching activity compositions:", error);
      res.status(500).json({ message: "Failed to fetch activity compositions" });
    }
  });

  // Materials
  app.get("/api/materials", async (req, res) => {
    try {
      const { categoryId, search } = req.query;
      console.log("Materials query params:", { categoryId, search });
      let materials;
      
      if (search) {
        console.log("Searching materials with:", search);
        materials = await storage.searchMaterials(String(search));
      } else if (categoryId) {
        console.log("Filtering by category:", categoryId);
        materials = await storage.getMaterialsByCategory(Number(categoryId));
      } else {
        console.log("Getting all materials");
        materials = await storage.getMaterials();
      }
      
      console.log("Returning", materials.length, "materials");
      res.json(materials);
    } catch (error) {
      console.error("Error fetching materials:", error);
      res.status(500).json({ message: "Failed to fetch materials" });
    }
  });

  app.get("/api/materials/:id", async (req, res) => {
    try {
      const material = await storage.getMaterial(Number(req.params.id));
      if (!material) {
        return res.status(404).json({ message: "Material not found" });
      }
      res.json(material);
    } catch (error) {
      console.error("Error fetching material:", error);
      res.status(500).json({ message: "Failed to fetch material" });
    }
  });

  app.post("/api/materials", async (req, res) => {
    try {
      const materialData = insertMaterialSchema.parse(req.body);
      const material = await storage.createMaterial(materialData);
      res.status(201).json(material);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid material data", errors: error.errors });
      }
      console.error("Error creating material:", error);
      res.status(500).json({ message: "Failed to create material" });
    }
  });

  app.put("/api/materials/:id", async (req, res) => {
    try {
      const materialData = insertMaterialSchema.partial().parse(req.body);
      const material = await storage.updateMaterial(Number(req.params.id), materialData);
      res.json(material);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid material data", errors: error.errors });
      }
      console.error("Error updating material:", error);
      res.status(500).json({ message: "Failed to update material" });
    }
  });

  app.delete("/api/materials/:id", async (req, res) => {
    try {
      await storage.deleteMaterial(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting material:", error);
      res.status(500).json({ message: "Failed to delete material" });
    }
  });

  // Projects
  app.get("/api/projects", requireAuth, async (req: any, res) => {
    try {
      const userId = req.user.id;
      const projects = await storage.getProjectsByUser(userId);
      res.json(projects);
    } catch (error) {
      console.error("Error fetching projects:", error);
      res.status(500).json({ message: "Failed to fetch projects" });
    }
  });

  app.get("/api/projects/:id", async (req, res) => {
    try {
      const project = await storage.getProject(Number(req.params.id));
      if (!project) {
        return res.status(404).json({ message: "Project not found" });
      }
      res.json(project);
    } catch (error) {
      console.error("Error fetching project:", error);
      res.status(500).json({ message: "Failed to fetch project" });
    }
  });

  app.post("/api/projects", requireAuth, async (req: any, res) => {
    try {
      console.log("Datos recibidos para crear proyecto:", req.body);
      
      const { startDate, ...otherData } = req.body;
      const projectData = {
        ...otherData,
        userId: req.user.id,
        startDate: startDate ? new Date(startDate) : null
      };
      
      console.log("Datos del proyecto antes de validar:", projectData);
      
      const validatedData = insertProjectSchema.parse(projectData);
      console.log("Datos validados:", validatedData);
      
      const project = await storage.createProject(validatedData);
      res.status(201).json(project);
    } catch (error) {
      if (error instanceof z.ZodError) {
        console.error("Error de validación Zod:", error.errors);
        return res.status(400).json({ message: "Invalid project data", errors: error.errors });
      }
      console.error("Error creating project:", error);
      res.status(500).json({ message: "Failed to create project" });
    }
  });

  app.put("/api/projects/:id", async (req, res) => {
    try {
      const projectData = insertProjectSchema.partial().parse(req.body);
      const project = await storage.updateProject(Number(req.params.id), projectData);
      res.json(project);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid project data", errors: error.errors });
      }
      console.error("Error updating project:", error);
      res.status(500).json({ message: "Failed to update project" });
    }
  });

  app.delete("/api/projects/:id", requireAuth, async (req, res) => {
    try {
      await storage.deleteProject(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting project:", error);
      res.status(500).json({ message: "Failed to delete project" });
    }
  });

  // Budgets
  app.get("/api/budgets", requireAuth, async (req: any, res) => {
    try {
      const { projectId } = req.query;
      const userId = req.user.id;
      let budgets;
      
      if (projectId) {
        budgets = await storage.getBudgetsByProject(Number(projectId));
      } else {
        budgets = await storage.getBudgetsByUser(userId);
      }
      
      res.json(budgets);
    } catch (error) {
      console.error("Error fetching budgets:", error);
      res.status(500).json({ message: "Failed to fetch budgets" });
    }
  });

  app.get("/api/budgets/:id", async (req, res) => {
    try {
      const budget = await storage.getBudget(Number(req.params.id));
      if (!budget) {
        return res.status(404).json({ message: "Budget not found" });
      }
      res.json(budget);
    } catch (error) {
      console.error("Error fetching budget:", error);
      res.status(500).json({ message: "Failed to fetch budget" });
    }
  });

  app.post("/api/budgets", async (req, res) => {
    try {
      console.log("Creating budget with data:", req.body);
      const budgetData = insertBudgetSchema.parse(req.body);
      const budget = await storage.createBudget(budgetData);
      res.status(201).json(budget);
    } catch (error) {
      if (error instanceof z.ZodError) {
        console.error("Budget validation error:", error.errors);
        return res.status(400).json({ message: "Invalid budget data", errors: error.errors });
      }
      console.error("Error creating budget:", error);
      res.status(500).json({ message: "Failed to create budget" });
    }
  });

  // Budget Items
  app.get("/api/budgets/:budgetId/items", async (req, res) => {
    try {
      const items = await storage.getBudgetItems(Number(req.params.budgetId));
      res.json(items);
    } catch (error) {
      console.error("Error fetching budget items:", error);
      res.status(500).json({ message: "Failed to fetch budget items" });
    }
  });

  app.get("/api/budget-items/:budgetId", async (req, res) => {
    try {
      const items = await storage.getBudgetItems(Number(req.params.budgetId));
      res.json(items);
    } catch (error) {
      console.error("Error fetching budget items:", error);
      res.status(500).json({ message: "Failed to fetch budget items" });
    }
  });

  app.post("/api/budget-items", async (req, res) => {
    try {
      console.log("Creating budget item with data:", req.body);
      const itemData = insertBudgetItemSchema.parse(req.body);
      const item = await storage.createBudgetItem(itemData);
      res.status(201).json(item);
    } catch (error) {
      if (error instanceof z.ZodError) {
        console.error("Budget item validation error:", error.errors);
        return res.status(400).json({ message: "Invalid budget item data", errors: error.errors });
      }
      console.error("Error creating budget item:", error);
      res.status(500).json({ message: "Failed to create budget item" });
    }
  });

  app.post("/api/budgets/:budgetId/items", async (req, res) => {
    try {
      const itemData = insertBudgetItemSchema.parse({
        ...req.body,
        budgetId: Number(req.params.budgetId)
      });
      const item = await storage.createBudgetItem(itemData);
      res.status(201).json(item);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid budget item data", errors: error.errors });
      }
      console.error("Error creating budget item:", error);
      res.status(500).json({ message: "Failed to create budget item" });
    }
  });

  app.put("/api/budget-items/:id", async (req, res) => {
    try {
      const itemData = insertBudgetItemSchema.partial().parse(req.body);
      const item = await storage.updateBudgetItem(Number(req.params.id), itemData);
      res.json(item);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid budget item data", errors: error.errors });
      }
      console.error("Error updating budget item:", error);
      res.status(500).json({ message: "Failed to update budget item" });
    }
  });

  app.delete("/api/budget-items/:id", async (req, res) => {
    try {
      await storage.deleteBudgetItem(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting budget item:", error);
      res.status(500).json({ message: "Failed to delete budget item" });
    }
  });

  // Import materials from SQL file
  app.post("/api/import-materials", async (req, res) => {
    try {
      const { importMaterialsFromSQL } = await import("./import-materials");
      const result = await importMaterialsFromSQL();
      res.json(result);
    } catch (error) {
      console.error("Error importing materials:", error);
      res.status(500).json({ message: "Failed to import materials" });
    }
  });

  // Import complete data from SQL file (empresas, herramientas, mano de obra)
  app.post("/api/import-complete-data", requireAdmin, async (req, res) => {
    try {
      const { importCompleteDataFromSQL } = await import("./import-complete-data");
      const result = await importCompleteDataFromSQL();
      res.json(result);
    } catch (error) {
      console.error("Error importing complete data:", error);
      res.status(500).json({ message: "Failed to import complete data" });
    }
  });

  // Activity Compositions
  app.get("/api/activity-compositions", requireAuth, async (req, res) => {
    try {
      const compositions = await storage.getActivityCompositions();
      res.json(compositions);
    } catch (error) {
      console.error("Error fetching activity compositions:", error);
      res.status(500).json({ message: "Failed to fetch activity compositions" });
    }
  });

  app.get("/api/activities/:activityId/compositions", async (req, res) => {
    try {
      const compositions = await storage.getActivityCompositionsByActivity(Number(req.params.activityId));
      res.json(compositions);
    } catch (error) {
      console.error("Error fetching activity compositions:", error);
      res.status(500).json({ message: "Failed to fetch activity compositions" });
    }
  });

  app.post("/api/activity-compositions", requireAuth, async (req, res) => {
    try {
      console.log("Creating activity composition with data:", req.body);
      const compositionData = insertActivityCompositionSchema.parse(req.body);
      const composition = await storage.createActivityComposition(compositionData);
      res.status(201).json(composition);
    } catch (error) {
      if (error instanceof z.ZodError) {
        console.error("Activity composition validation error:", error.errors);
        return res.status(400).json({ message: "Invalid composition data", errors: error.errors });
      }
      console.error("Error creating activity composition:", error);
      res.status(500).json({ message: "Failed to create activity composition" });
    }
  });

  app.delete("/api/activity-compositions/:id", requireAuth, async (req, res) => {
    try {
      await storage.deleteActivityComposition(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting activity composition:", error);
      res.status(500).json({ message: "Failed to delete activity composition" });
    }
  });

  // Get compositions for a specific activity
  app.get("/api/activities/:id/compositions", async (req, res) => {
    try {
      const activityId = Number(req.params.id);
      const compositions = await storage.getActivityCompositionsByActivity(activityId);
      res.json(compositions);
    } catch (error) {
      console.error("Error fetching activity compositions:", error);
      res.status(500).json({ message: "Failed to fetch activity compositions" });
    }
  });

  // Get APU calculation for a specific activity
  app.get("/api/activities/:id/apu-calculation", async (req, res) => {
    try {
      const activityId = Number(req.params.id);
      const projectId = req.query.projectId ? Number(req.query.projectId) : undefined;
      
      const { calculateAPUPrice } = await import("./apu-calculator");
      const calculation = await calculateAPUPrice(activityId, projectId);
      
      res.json(calculation);
    } catch (error) {
      console.error("Error calculating APU:", error);
      res.status(500).json({ message: "Failed to calculate APU" });
    }
  });

  // Price settings routes (Admin only)
  app.get("/api/price-settings", requireAuth, async (req, res) => {
    try {
      const settings = await storage.getPriceSettings();
      res.json(settings);
    } catch (error) {
      console.error("Error getting price settings:", error);
      res.status(500).json({ message: "Failed to get price settings" });
    }
  });

  app.put("/api/price-settings", requireAuth, requireAdmin, async (req, res) => {
    try {
      const settings = await storage.updatePriceSettings(req.body);
      res.json(settings);
    } catch (error) {
      console.error("Error updating price settings:", error);
      res.status(500).json({ message: "Failed to update price settings" });
    }
  });

  app.post("/api/apply-price-adjustment", requireAuth, requireAdmin, async (req, res) => {
    try {
      const { factor, updatedBy } = req.body;
      const result = await storage.applyGlobalPriceAdjustment(factor, updatedBy);
      res.json(result);
    } catch (error) {
      console.error("Error applying price adjustment:", error);
      res.status(500).json({ message: "Failed to apply price adjustment" });
    }
  });

  // APU Import and Calculation
  app.post("/api/import-apu", requireAuth, async (req, res) => {
    try {
      const { importAPUCompositions } = await import("./import-apu");
      
      // Configurar timeout extendido para importación masiva
      req.setTimeout(30 * 60 * 1000); // 30 minutos
      res.setTimeout(30 * 60 * 1000);
      
      const result = await importAPUCompositions();
      res.json(result);
    } catch (error: any) {
      console.error("Error importing APU compositions:", error);
      res.status(500).json({ 
        message: "Failed to import APU compositions", 
        error: error?.message || "Error desconocido"
      });
    }
  });

  // Reorganize existing activities by phase
  app.post("/api/reorganize-activities", requireAuth, async (req, res) => {
    try {
      const { reorganizeExistingActivities } = await import("./reorganize-activities");
      const result = await reorganizeExistingActivities();
      res.json(result);
    } catch (error) {
      console.error("Error reorganizing activities:", error);
      res.status(500).json({ 
        message: "Error reorganizing activities",
        error: error instanceof Error ? error.message : "Unknown error"
      });
    }
  });

  app.get("/api/activities/:activityId/calculate-price", requireAuth, async (req, res) => {
    try {
      const { calculateActivityPrice } = await import("./import-apu");
      const price = await calculateActivityPrice(Number(req.params.activityId));
      res.json({ price });
    } catch (error) {
      console.error("Error calculating activity price:", error);
      res.status(500).json({ message: "Failed to calculate activity price" });
    }
  });

  // Calculate and update all activity prices
  app.post("/api/calculate-all-prices", requireAuth, async (req, res) => {
    try {
      const { updateActivityPricesFromCompositions } = await import("./price-calculator");
      const result = await updateActivityPricesFromCompositions();
      res.json(result);
    } catch (error) {
      console.error("Error calculating all activity prices:", error);
      res.status(500).json({ 
        message: "Error calculating activity prices",
        error: error instanceof Error ? error.message : "Unknown error"
      });
    }
  });

  // City Price Factors
  app.get("/api/city-price-factors", requireAuth, async (req, res) => {
    try {
      const factors = await storage.getCityPriceFactors();
      res.json(factors);
    } catch (error) {
      console.error("Error fetching city price factors:", error);
      res.status(500).json({ message: "Failed to fetch city price factors" });
    }
  });

  app.get("/api/city-price-factors/:city", requireAuth, async (req, res) => {
    try {
      const { city } = req.params;
      const { country = "Bolivia" } = req.query;
      const factor = await storage.getCityPriceFactor(city, country as string);
      if (!factor) {
        return res.status(404).json({ message: "City price factor not found" });
      }
      res.json(factor);
    } catch (error) {
      console.error("Error fetching city price factor:", error);
      res.status(500).json({ message: "Failed to fetch city price factor" });
    }
  });

  app.post("/api/city-price-factors", requireAuth, async (req, res) => {
    try {
      const factorData = insertCityPriceFactorSchema.parse(req.body);
      const factor = await storage.createCityPriceFactor(factorData);
      res.status(201).json(factor);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Validation error", errors: error.errors });
      }
      console.error("Error creating city price factor:", error);
      res.status(500).json({ message: "Failed to create city price factor" });
    }
  });

  app.patch("/api/city-price-factors/:id", requireAuth, async (req, res) => {
    try {
      const factorData = insertCityPriceFactorSchema.partial().parse(req.body);
      const factor = await storage.updateCityPriceFactor(Number(req.params.id), factorData);
      res.json(factor);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Validation error", errors: error.errors });
      }
      console.error("Error updating city price factor:", error);
      res.status(500).json({ message: "Failed to update city price factor" });
    }
  });

  app.delete("/api/city-price-factors/:id", requireAuth, async (req, res) => {
    try {
      await storage.deleteCityPriceFactor(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting city price factor:", error);
      res.status(500).json({ message: "Failed to delete city price factor" });
    }
  });

  // Update user location
  app.patch("/api/users/:id/location", requireAuth, async (req, res) => {
    try {
      const { city, country = "Bolivia" } = req.body;
      if (!city) {
        return res.status(400).json({ message: "City is required" });
      }
      const user = await storage.updateUserLocation(Number(req.params.id), city, country);
      res.json(user);
    } catch (error) {
      console.error("Error updating user location:", error);
      res.status(500).json({ message: "Failed to update user location" });
    }
  });

  // Geographic price adjustments
  app.post("/api/calculate-geographic-adjustment", requireAuth, async (req, res) => {
    try {
      const { basePrice, city, country = "Bolivia" } = req.body;
      if (!basePrice || !city) {
        return res.status(400).json({ message: "Base price and city are required" });
      }
      
      const { applyGeographicPriceAdjustment } = await import("./city-price-calculator");
      const adjustment = await applyGeographicPriceAdjustment(basePrice, city, country);
      
      if (!adjustment) {
        return res.status(404).json({ message: "City price factor not found" });
      }
      
      res.json(adjustment);
    } catch (error) {
      console.error("Error calculating geographic adjustment:", error);
      res.status(500).json({ message: "Failed to calculate geographic adjustment" });
    }
  });

  app.get("/api/city-price-info/:city", requireAuth, async (req, res) => {
    try {
      const { city } = req.params;
      const { country = "Bolivia" } = req.query;
      
      const { getCityPriceInfo } = await import("./city-price-calculator");
      const info = await getCityPriceInfo(city, country as string);
      
      if (!info) {
        return res.status(404).json({ message: "City price information not found" });
      }
      
      res.json(info);
    } catch (error) {
      console.error("Error fetching city price info:", error);
      res.status(500).json({ message: "Failed to fetch city price info" });
    }
  });

  // =============== SUPPLIER COMPANIES ROUTES ===============

  // Get all supplier companies
  app.get("/api/supplier-companies", async (req, res) => {
    try {
      const companies = await storage.getSupplierCompanies();
      res.json(companies);
    } catch (error) {
      console.error("Error fetching supplier companies:", error);
      res.status(500).json({ message: "Failed to fetch supplier companies" });
    }
  });

  // Get supplier company by ID
  app.get("/api/supplier-companies/:id", async (req, res) => {
    try {
      const company = await storage.getSupplierCompany(Number(req.params.id));
      if (!company) {
        return res.status(404).json({ message: "Supplier company not found" });
      }
      res.json(company);
    } catch (error) {
      console.error("Error fetching supplier company:", error);
      res.status(500).json({ message: "Failed to fetch supplier company" });
    }
  });

  // Get current user's supplier company
  app.get("/api/my-supplier-company", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      const company = await storage.getSupplierCompanyByUser(userId);
      res.json(company || null);
    } catch (error) {
      console.error("Error fetching user's supplier company:", error);
      res.status(500).json({ message: "Failed to fetch supplier company" });
    }
  });

  // Create supplier company
  app.post("/api/supplier-companies", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      
      // Check if user already has a supplier company
      const existingCompany = await storage.getSupplierCompanyByUser(userId);
      if (existingCompany) {
        return res.status(400).json({ message: "User already has a supplier company" });
      }

      const companyData = insertSupplierCompanySchema.parse({
        ...req.body,
        userId
      });
      
      const company = await storage.createSupplierCompany(companyData);
      res.status(201).json(company);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid company data", errors: error.errors });
      }
      console.error("Error creating supplier company:", error);
      res.status(500).json({ message: "Failed to create supplier company" });
    }
  });

  // Update supplier company
  app.put("/api/supplier-companies/:id", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      const companyId = Number(req.params.id);
      
      // Check if user owns this company
      const existingCompany = await storage.getSupplierCompany(companyId);
      if (!existingCompany || existingCompany.userId !== userId) {
        return res.status(403).json({ message: "Access denied" });
      }

      const companyData = insertSupplierCompanySchema.partial().parse(req.body);
      const company = await storage.updateSupplierCompany(companyId, companyData);
      res.json(company);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid company data", errors: error.errors });
      }
      console.error("Error updating supplier company:", error);
      res.status(500).json({ message: "Failed to update supplier company" });
    }
  });

  // =============== MATERIAL SUPPLIER PRICES ROUTES ===============

  // Get supplier prices for a material
  app.get("/api/materials/:materialId/supplier-prices", async (req, res) => {
    try {
      const materialId = Number(req.params.materialId);
      const prices = await storage.getMaterialSupplierPrices(materialId);
      res.json(prices);
    } catch (error) {
      console.error("Error fetching material supplier prices:", error);
      res.status(500).json({ message: "Failed to fetch supplier prices" });
    }
  });

  // Get supplier's material prices
  app.get("/api/supplier-companies/:supplierId/prices", async (req, res) => {
    try {
      const supplierId = Number(req.params.supplierId);
      const prices = await storage.getSupplierPrices(supplierId);
      res.json(prices);
    } catch (error) {
      console.error("Error fetching supplier prices:", error);
      res.status(500).json({ message: "Failed to fetch supplier prices" });
    }
  });

  // Create material supplier price
  app.post("/api/material-supplier-prices", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      
      // Get user's supplier company
      const company = await storage.getSupplierCompanyByUser(userId);
      if (!company) {
        return res.status(403).json({ message: "User must have a supplier company to add prices" });
      }

      const priceData = insertMaterialSupplierPriceSchema.parse({
        ...req.body,
        supplierId: company.id
      });
      
      const price = await storage.createMaterialSupplierPrice(priceData);
      res.status(201).json(price);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid price data", errors: error.errors });
      }
      console.error("Error creating material supplier price:", error);
      res.status(500).json({ message: "Failed to create supplier price" });
    }
  });

  // Update material supplier price
  app.put("/api/material-supplier-prices/:id", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      const priceId = Number(req.params.id);
      
      // Get user's supplier company
      const company = await storage.getSupplierCompanyByUser(userId);
      if (!company) {
        return res.status(403).json({ message: "Access denied" });
      }

      // Verify this price belongs to the user's company
      const supplierPrices = await storage.getSupplierPrices(company.id);
      const existingPrice = supplierPrices.find(p => p.id === priceId);
      if (!existingPrice) {
        return res.status(403).json({ message: "Access denied" });
      }

      const priceData = insertMaterialSupplierPriceSchema.partial().parse(req.body);
      const price = await storage.updateMaterialSupplierPrice(priceId, priceData);
      res.json(price);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid price data", errors: error.errors });
      }
      console.error("Error updating material supplier price:", error);
      res.status(500).json({ message: "Failed to update supplier price" });
    }
  });

  // Delete material supplier price
  app.delete("/api/material-supplier-prices/:id", requireAuth, async (req, res) => {
    try {
      const userId = (req as any).user.id;
      const priceId = Number(req.params.id);
      
      // Get user's supplier company
      const company = await storage.getSupplierCompanyByUser(userId);
      if (!company) {
        return res.status(403).json({ message: "Access denied" });
      }

      // Verify this price belongs to the user's company
      const supplierPrices = await storage.getSupplierPrices(company.id);
      const existingPrice = supplierPrices.find(p => p.id === priceId);
      if (!existingPrice) {
        return res.status(403).json({ message: "Access denied" });
      }

      await storage.deleteMaterialSupplierPrice(priceId);
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting material supplier price:", error);
      res.status(500).json({ message: "Failed to delete supplier price" });
    }
  });

  // =============== TOOLS ROUTES ===============
  
  app.get("/api/tools", async (req, res) => {
    try {
      const tools = await storage.getTools();
      res.json(tools);
    } catch (error) {
      console.error("Error fetching tools:", error);
      res.status(500).json({ message: "Failed to fetch tools" });
    }
  });

  app.get("/api/tools/:id", async (req, res) => {
    try {
      const tool = await storage.getTool(Number(req.params.id));
      if (!tool) {
        return res.status(404).json({ message: "Tool not found" });
      }
      res.json(tool);
    } catch (error) {
      console.error("Error fetching tool:", error);
      res.status(500).json({ message: "Failed to fetch tool" });
    }
  });

  app.post("/api/tools", requireAuth, async (req, res) => {
    try {
      const toolData = insertToolSchema.parse(req.body);
      const tool = await storage.createTool(toolData);
      res.status(201).json(tool);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid tool data", errors: error.errors });
      }
      console.error("Error creating tool:", error);
      res.status(500).json({ message: "Failed to create tool" });
    }
  });

  app.put("/api/tools/:id", requireAuth, async (req, res) => {
    try {
      const toolData = insertToolSchema.partial().parse(req.body);
      const tool = await storage.updateTool(Number(req.params.id), toolData);
      res.json(tool);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid tool data", errors: error.errors });
      }
      console.error("Error updating tool:", error);
      res.status(500).json({ message: "Failed to update tool" });
    }
  });

  app.delete("/api/tools/:id", requireAuth, async (req, res) => {
    try {
      await storage.deleteTool(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting tool:", error);
      res.status(500).json({ message: "Failed to delete tool" });
    }
  });

  // =============== LABOR CATEGORIES ROUTES ===============
  
  app.get("/api/labor-categories", async (req, res) => {
    try {
      const laborCategories = await storage.getLaborCategories();
      res.json(laborCategories);
    } catch (error) {
      console.error("Error fetching labor categories:", error);
      res.status(500).json({ message: "Failed to fetch labor categories" });
    }
  });

  app.get("/api/labor-categories/:id", async (req, res) => {
    try {
      const laborCategory = await storage.getLaborCategory(Number(req.params.id));
      if (!laborCategory) {
        return res.status(404).json({ message: "Labor category not found" });
      }
      res.json(laborCategory);
    } catch (error) {
      console.error("Error fetching labor category:", error);
      res.status(500).json({ message: "Failed to fetch labor category" });
    }
  });

  app.post("/api/labor-categories", requireAuth, async (req, res) => {
    try {
      const laborData = insertLaborCategorySchema.parse(req.body);
      const laborCategory = await storage.createLaborCategory(laborData);
      res.status(201).json(laborCategory);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid labor category data", errors: error.errors });
      }
      console.error("Error creating labor category:", error);
      res.status(500).json({ message: "Failed to create labor category" });
    }
  });

  app.put("/api/labor-categories/:id", requireAuth, async (req, res) => {
    try {
      const laborData = insertLaborCategorySchema.partial().parse(req.body);
      const laborCategory = await storage.updateLaborCategory(Number(req.params.id), laborData);
      res.json(laborCategory);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ message: "Invalid labor category data", errors: error.errors });
      }
      console.error("Error updating labor category:", error);
      res.status(500).json({ message: "Failed to update labor category" });
    }
  });

  app.delete("/api/labor-categories/:id", requireAuth, async (req, res) => {
    try {
      await storage.deleteLaborCategory(Number(req.params.id));
      res.status(204).send();
    } catch (error) {
      console.error("Error deleting labor category:", error);
      res.status(500).json({ message: "Failed to delete labor category" });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}

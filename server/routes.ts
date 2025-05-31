import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { AuthService, requireAuth, requireAdmin } from "./auth";
import { 
  insertMaterialSchema,
  insertProjectSchema,
  insertBudgetSchema,
  insertBudgetItemSchema 
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
      const { phaseId } = req.query;
      let activities;
      
      if (phaseId) {
        activities = await storage.getActivitiesByPhase(Number(phaseId));
      } else {
        activities = await storage.getActivities();
      }
      
      res.json(activities);
    } catch (error) {
      console.error("Error fetching activities:", error);
      res.status(500).json({ message: "Failed to fetch activities" });
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
  app.get("/api/projects", async (req, res) => {
    try {
      const projects = await storage.getProjects();
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

  app.post("/api/projects", async (req, res) => {
    try {
      const projectData = insertProjectSchema.parse(req.body);
      const project = await storage.createProject(projectData);
      res.status(201).json(project);
    } catch (error) {
      if (error instanceof z.ZodError) {
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

  // Budgets
  app.get("/api/budgets", async (req, res) => {
    try {
      const { projectId } = req.query;
      let budgets;
      
      if (projectId) {
        budgets = await storage.getBudgetsByProject(Number(projectId));
      } else {
        budgets = await storage.getBudgets();
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
      const budgetData = insertBudgetSchema.parse(req.body);
      const budget = await storage.createBudget(budgetData);
      res.status(201).json(budget);
    } catch (error) {
      if (error instanceof z.ZodError) {
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

  const httpServer = createServer(app);
  return httpServer;
}

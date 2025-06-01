import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Plus, Trash2 } from "lucide-react";
import { formatCurrency, calculateSubtotal } from "@/lib/utils";
import type { ActivityWithPhase } from "@shared/schema";

interface BudgetItemData {
  id: string;
  activityId: number;
  activity?: ActivityWithPhase;
  quantity: number;
  unitPrice: number;
  subtotal: number;
}

interface PhaseAccordionProps {
  phaseId: number;
  projectId: number;
  projectCity?: string;
  projectCountry?: string;
  onBudgetChange?: (budgetItems: BudgetItemData[], total: number) => void;
}

// Factores de precios por ciudad basados en los datos de la base de datos
const cityFactors: Record<string, number> = {
  "La Paz": 1.175,     // Promedio ponderado: (1.15*0.4 + 1.20*0.35 + 1.10*0.15 + 1.25*0.1)
  "Santa Cruz": 1.0,   // Ciudad base
  "Cochabamba": 0.955, // Promedio ponderado
  "Sucre": 1.0575,     // Promedio ponderado
  "Potosí": 1.2425,    // Promedio ponderado
  "Oruro": 1.1375,     // Promedio ponderado
  "Tarija": 0.9125,    // Promedio ponderado
  "Trinidad": 1.315,   // Promedio ponderado
  "Cobija": 1.3725     // Promedio ponderado
};

const applyGeographicFactor = (basePrice: number, city: string): number => {
  const factor = cityFactors[city] || 1.0;
  return basePrice * factor;
};

export default function PhaseAccordion({ phaseId, projectId, projectCity, projectCountry, onBudgetChange }: PhaseAccordionProps) {
  const [budgetItems, setBudgetItems] = useState<BudgetItemData[]>([]);

  const { data: activities } = useQuery<ActivityWithPhase[]>({
    queryKey: ["/api/activities", phaseId],
    queryFn: async () => {
      const response = await fetch(`/api/activities?phaseId=${phaseId}`);
      if (!response.ok) throw new Error('Failed to fetch activities');
      return response.json();
    }
  });

  // Agregar automáticamente el primer elemento cuando se cargan las actividades
  useEffect(() => {
    if (activities && activities.length > 0 && budgetItems.length === 0) {
      console.log('Agregando elemento inicial para fase:', phaseId, 'con', activities.length, 'actividades');
      const newItem: BudgetItemData = {
        id: Date.now().toString(),
        activityId: 0,
        quantity: 1,
        unitPrice: 0,
        subtotal: 0,
      };
      setBudgetItems([newItem]);
    }
  }, [activities, budgetItems.length, phaseId]);

  const addBudgetItem = () => {
    const newItem: BudgetItemData = {
      id: Date.now().toString(),
      activityId: 0,
      quantity: 1,
      unitPrice: 0,
      subtotal: 0,
    };
    setBudgetItems([...budgetItems, newItem]);
  };

  const removeBudgetItem = (id: string) => {
    setBudgetItems(budgetItems.filter(item => item.id !== id));
  };

  const updateBudgetItem = (id: string, field: keyof BudgetItemData, value: any) => {
    setBudgetItems(budgetItems.map(item => {
      if (item.id === id) {
        const updatedItem = { ...item, [field]: value };
        
        if (field === 'activityId') {
          const selectedActivity = activities?.find(a => a.id === value);
          updatedItem.activity = selectedActivity;
          
          // Auto-aplicar el precio unitario de la actividad seleccionada
          if (selectedActivity && selectedActivity.unitPrice) {
            let basePrice = parseFloat(selectedActivity.unitPrice);
            
            // Aplicar factor geográfico si se ha seleccionado una ciudad
            if (projectCity && projectCity !== 'Santa Cruz') {
              basePrice = applyGeographicFactor(basePrice, projectCity);
            }
            
            updatedItem.unitPrice = basePrice;
            console.log('Auto-aplicando precio unitario:', basePrice, 'para actividad:', selectedActivity.name, 'en ciudad:', projectCity || 'Santa Cruz (base)');
          }
        }
        
        // Siempre recalcular subtotal cuando cambien cantidad o precio
        updatedItem.subtotal = calculateSubtotal(updatedItem.quantity, updatedItem.unitPrice);
        
        return updatedItem;
      }
      return item;
    }));
  };

  const totalBudget = budgetItems.reduce((sum, item) => sum + item.subtotal, 0);
  const selectedPhase = activities?.[0]?.phase;

  // Notificar cambios al componente padre
  useEffect(() => {
    if (onBudgetChange) {
      onBudgetChange(budgetItems, totalBudget);
    }
  }, [budgetItems, totalBudget, onBudgetChange]);

  if (!selectedPhase) {
    return <div className="text-center text-gray-500">Cargando actividades...</div>;
  }

  // Debug logs
  console.log('Rendering PhaseAccordion:', { 
    phaseId, 
    activitiesCount: activities?.length || 0, 
    budgetItemsCount: budgetItems.length,
    budgetItems 
  });

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold">{selectedPhase.name}</h3>
      <p className="text-sm text-gray-600">{activities?.length || 0} actividades disponibles</p>
      <p className="text-sm text-blue-600">{budgetItems.length} elemento(s) en el presupuesto</p>
      
      <div className="border border-gray-300 rounded p-4">
        <h4 className="font-medium mb-4">Elementos del Presupuesto</h4>
        
        {budgetItems.length === 0 && (
          <p className="text-gray-500">No hay elementos</p>
        )}
        
        {budgetItems.map((item) => (
          <div key={item.id} className="border border-gray-200 rounded p-4 mb-4 bg-white">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <Label>Actividad</Label>
                <Select
                  value={item.activityId > 0 ? item.activityId.toString() : ""}
                  onValueChange={(value) => 
                    updateBudgetItem(item.id, 'activityId', parseInt(value))
                  }
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccionar" />
                  </SelectTrigger>
                  <SelectContent>
                    {activities?.map((activity) => (
                      <SelectItem key={activity.id} value={activity.id.toString()}>
                        {activity.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              
              <div>
                <Label>Cantidad</Label>
                <Input
                  type="number"
                  value={item.quantity}
                  onChange={(e) => 
                    updateBudgetItem(item.id, 'quantity', parseFloat(e.target.value) || 0)
                  }
                />
              </div>
              
              <div>
                <Label>Precio</Label>
                <Input
                  type="number"
                  value={item.unitPrice}
                  onChange={(e) => 
                    updateBudgetItem(item.id, 'unitPrice', parseFloat(e.target.value) || 0)
                  }
                />
              </div>
              
              <div className="flex items-end">
                <div className="flex-1">
                  <Label>Subtotal</Label>
                  <div className="font-bold">{formatCurrency(item.subtotal)}</div>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => removeBudgetItem(item.id)}
                  className="text-red-600"
                >
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            </div>
          </div>
        ))}
        
        <Button onClick={addBudgetItem} className="w-full">
          <Plus className="w-4 h-4 mr-2" />
          Agregar Elemento
        </Button>
        
        {budgetItems.length > 0 && (
          <div className="mt-4 p-4 bg-gray-100 rounded">
            <div className="font-bold text-lg">Total: {formatCurrency(totalBudget)}</div>
          </div>
        )}
      </div>
    </div>
  );
}
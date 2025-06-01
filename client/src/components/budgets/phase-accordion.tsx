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
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { Plus, Trash2, Eye } from "lucide-react";
import { formatCurrency, calculateSubtotal } from "@/lib/utils";
import ActivityDetailDialog from "@/components/activity-detail-dialog";
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
}

export default function PhaseAccordion({ phaseId }: PhaseAccordionProps) {
  const [budgetItems, setBudgetItems] = useState<BudgetItemData[]>([]);

  const { data: activities } = useQuery<ActivityWithPhase[]>({
    queryKey: ["/api/activities", { phaseId }],
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
      quantity: 0,
      unitPrice: 0,
      subtotal: 0,
    };
    setBudgetItems([...budgetItems, newItem]);
  };

  const removeBudgetItem = (id: string) => {
    setBudgetItems(budgetItems.filter(item => item.id !== id));
  };

  const updateBudgetItem = (id: string, field: keyof BudgetItemData, value: any) => {
    setBudgetItems(items => items.map(item => {
      if (item.id === id) {
        const updatedItem = { ...item, [field]: value };
        
        // Update activity when activityId changes
        if (field === 'activityId') {
          const activity = activities?.find(a => a.id === value);
          updatedItem.activity = activity;
          console.log('Auto-price debug:', { 
            activityId: value, 
            activity: activity?.name, 
            unitPriceString: activity?.unitPrice,
            unitPriceFloat: activity?.unitPrice ? parseFloat(activity.unitPrice) : 0,
            hasUnitPrice: !!activity?.unitPrice,
            isGreaterThanZero: activity?.unitPrice ? parseFloat(activity.unitPrice) > 0 : false
          });
          // Auto-fill unit price from activity's calculated price
          if (activity?.unitPrice) {
            const priceValue = parseFloat(activity.unitPrice);
            if (priceValue > 0) {
              updatedItem.unitPrice = priceValue;
              console.log('Price auto-filled:', updatedItem.unitPrice);
            }
          }
        }
        
        // Recalculate subtotal when quantity, unitPrice, or activityId changes
        if (field === 'quantity' || field === 'unitPrice' || field === 'activityId') {
          updatedItem.subtotal = calculateSubtotal(
            updatedItem.quantity,
            updatedItem.unitPrice
          );
        }
        
        return updatedItem;
      }
      return item;
    }));
  };

  const totalBudget = budgetItems.reduce((sum, item) => sum + item.subtotal, 0);
  const selectedPhase = activities?.[0]?.phase;

  if (!selectedPhase) {
    return <div className="text-center text-gray-500">Cargando actividades...</div>;
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold">{selectedPhase.name}</h3>
          <p className="text-sm text-gray-600">
            {activities?.length || 0} actividades disponibles
          </p>
        </div>
        <Badge variant="outline">
          {budgetItems.length} elemento{budgetItems.length !== 1 ? 's' : ''}
        </Badge>
      </div>

      <div className="border rounded-lg">
        <div className="flex items-center justify-between p-4 bg-gray-50 border-b">
          <span className="text-base font-medium">Elementos del Presupuesto ({budgetItems.length} elementos)</span>
          <div className="text-right">
            <div className="font-semibold text-primary">
              {formatCurrency(totalBudget)}
            </div>
            <div className="text-sm text-gray-600">
              Total estimado
            </div>
          </div>
        </div>
        <div className="p-4">
          <div className="space-y-4">
              {budgetItems.map((item) => (
                <Card key={item.id} className="p-4">
                  <div className="grid grid-cols-1 lg:grid-cols-12 gap-4 items-end">
                    <div className="lg:col-span-4">
                      <Label className="text-sm font-medium text-gray-700">
                        Actividad
                      </Label>
                      <div className="flex gap-2">
                        <Select
                          value={item.activityId > 0 ? item.activityId.toString() : ""}
                          onValueChange={(value) => {
                            console.log('=== SELECT TRIGGERED ===', value);
                            const activityId = parseInt(value);
                            
                            // Update activity first
                            updateBudgetItem(item.id, 'activityId', activityId);
                            
                            // Find the selected activity and auto-fill price
                            const selectedActivity = activities?.find(a => a.id === activityId);
                            console.log('Selected activity data:', selectedActivity);
                            
                            if (selectedActivity?.unitPrice) {
                              const priceValue = parseFloat(selectedActivity.unitPrice);
                              console.log('Price value parsed:', priceValue);
                              if (priceValue > 0) {
                                console.log('Setting unit price to:', priceValue);
                                // Use setTimeout to ensure the activity update is processed first
                                setTimeout(() => {
                                  updateBudgetItem(item.id, 'unitPrice', priceValue);
                                }, 50);
                              }
                            }
                          }}
                        >
                          <SelectTrigger>
                            <SelectValue placeholder="Seleccionar actividad" />
                          </SelectTrigger>
                          <SelectContent>
                            {activities?.map((activity) => (
                              <SelectItem key={activity.id} value={activity.id.toString()}>
                                {activity.name}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                        {item.activity && item.activity.name.includes("ANÁLISIS DE PRECIOS UNITARIOS") && (
                          <ActivityDetailDialog
                            activityId={item.activityId}
                            activityName={item.activity.name}
                            unitPrice={item.activity.unitPrice}
                          >
                            <Button
                              variant="outline"
                              size="icon"
                              className="shrink-0"
                              title="Ver desglose de APU"
                            >
                              <Eye className="w-4 h-4" />
                            </Button>
                          </ActivityDetailDialog>
                        )}
                      </div>
                    </div>

                    <div className="lg:col-span-2">
                      <Label className="text-sm font-medium text-gray-700">
                        Cantidad
                      </Label>
                      <Input
                        type="number"
                        step="0.001"
                        placeholder="0.00"
                        value={item.quantity || ""}
                        onChange={(e) => 
                          updateBudgetItem(item.id, 'quantity', parseFloat(e.target.value) || 0)
                        }
                      />
                    </div>

                    <div className="lg:col-span-1">
                      <Label className="text-sm font-medium text-gray-700">
                        Unidad
                      </Label>
                      <Input
                        value={item.activity?.unit || ""}
                        className="bg-gray-100"
                        readOnly
                      />
                    </div>

                    <div className="lg:col-span-2">
                      <Label className="text-sm font-medium text-gray-700">
                        Precio Unit.
                      </Label>
                      <Input
                        type="number"
                        step="0.01"
                        placeholder="0.00"
                        value={item.unitPrice || ""}
                        onChange={(e) => 
                          updateBudgetItem(item.id, 'unitPrice', parseFloat(e.target.value) || 0)
                        }
                      />
                    </div>

                    <div className="lg:col-span-2">
                      <Label className="text-sm font-medium text-gray-700">
                        Subtotal
                      </Label>
                      <Input
                        value={formatCurrency(item.subtotal)}
                        className="bg-gray-100 font-semibold"
                        readOnly
                      />
                    </div>

                    <div className="lg:col-span-1">
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => removeBudgetItem(item.id)}
                        className="text-red-600 hover:bg-red-50"
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </Card>
              ))}

              <Button
                variant="outline"
                onClick={addBudgetItem}
                className="w-full border-2 border-dashed border-gray-300 hover:border-primary hover:text-primary"
              >
                <Plus className="w-4 h-4 mr-2" />
                Agregar Elemento
              </Button>
            </div>
          </div>
        </div>

      {budgetItems.length > 0 && (
        <>
          <Separator />
          <div className="flex justify-between items-center p-4 bg-gray-50 rounded-lg">
            <div>
              <h4 className="font-semibold text-on-surface">Total de la Fase</h4>
              <p className="text-sm text-gray-600">
                {budgetItems.length} elemento{budgetItems.length !== 1 ? 's' : ''} • {selectedPhase?.name}
              </p>
            </div>
            <div className="text-right">
              <p className="text-2xl font-bold text-primary">
                {formatCurrency(totalBudget)}
              </p>
              <p className="text-sm text-gray-600">IVA incluido</p>
            </div>
          </div>
        </>
      )}
    </div>
  );
}

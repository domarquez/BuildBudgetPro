import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Settings, ArrowLeft, Plus } from "lucide-react";
import { Link } from "wouter";
import CustomActivityManager from "@/components/custom-activity-manager";
import ActivityCompositionEditor from "@/components/activity-composition-editor";

interface CustomActivity {
  id: string;
  originalActivityId?: number;
  customName: string;
  originalName?: string;
  unit: string;
  description?: string;
  materials: any[];
  labor: any[];
  equipment: any[];
  createdAt: string;
  updatedAt: string;
}

export default function CustomActivities() {
  const [editingActivity, setEditingActivity] = useState<CustomActivity | null>(null);

  const handleEditActivity = (activity: CustomActivity) => {
    setEditingActivity(activity);
  };

  const handleSaveActivity = (updatedActivity: CustomActivity) => {
    // Update localStorage
    const activities = JSON.parse(localStorage.getItem('userCustomActivities') || '[]');
    const index = activities.findIndex((a: CustomActivity) => a.id === updatedActivity.id);
    
    if (index >= 0) {
      activities[index] = updatedActivity;
      localStorage.setItem('userCustomActivities', JSON.stringify(activities));
    }
    
    setEditingActivity(null);
  };

  const handleCancelEdit = () => {
    setEditingActivity(null);
  };

  const handleActivitySelect = (activity: CustomActivity) => {
    // For now, just show a message. Later can integrate with budget creation
    alert(`Actividad "${activity.customName}" seleccionada. Funcionalidad de agregar a presupuesto próximamente.`);
  };

  if (editingActivity) {
    return (
      <ActivityCompositionEditor
        activity={editingActivity}
        onSave={handleSaveActivity}
        onCancel={handleCancelEdit}
      />
    );
  }

  return (
    <div className="container mx-auto py-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link href="/">
            <Button variant="ghost" size="sm" className="gap-2">
              <ArrowLeft className="w-4 h-4" />
              Volver al Dashboard
            </Button>
          </Link>
          <div>
            <h1 className="text-2xl font-bold">Actividades Personalizadas</h1>
            <p className="text-gray-600">
              Crea y gestiona tus propias actividades de construcción personalizadas
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Settings className="w-6 h-6 text-primary" />
        </div>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Actividades Creadas</p>
                <p className="text-2xl font-bold text-primary">
                  {JSON.parse(localStorage.getItem('userCustomActivities') || '[]').length}
                </p>
              </div>
              <div className="p-3 bg-blue-100 rounded-full">
                <Settings className="w-6 h-6 text-blue-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Materiales Personalizados</p>
                <p className="text-2xl font-bold text-green-600">
                  {JSON.parse(localStorage.getItem('userMaterialPrices') || '[]').length}
                </p>
              </div>
              <div className="p-3 bg-green-100 rounded-full">
                <Plus className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Actividades Copiadas</p>
                <p className="text-2xl font-bold text-orange-600">
                  {JSON.parse(localStorage.getItem('userCustomActivities') || '[]')
                    .filter((a: CustomActivity) => a.originalActivityId).length}
                </p>
              </div>
              <div className="p-3 bg-orange-100 rounded-full">
                <Settings className="w-6 h-6 text-orange-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Main Content */}
      <Tabs defaultValue="activities" className="space-y-6">
        <TabsList>
          <TabsTrigger value="activities">Mis Actividades</TabsTrigger>
          <TabsTrigger value="materials">Materiales Personalizados</TabsTrigger>
          <TabsTrigger value="guide">Guía de Uso</TabsTrigger>
        </TabsList>

        <TabsContent value="activities" className="space-y-6">
          <CustomActivityManager
            onActivitySelect={handleActivitySelect}
          />
        </TabsContent>

        <TabsContent value="materials" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Materiales Personalizados</CardTitle>
            </CardHeader>
            <CardContent>
              {(() => {
                const materials = JSON.parse(localStorage.getItem('userMaterialPrices') || '[]');
                
                if (materials.length === 0) {
                  return (
                    <div className="text-center py-8">
                      <p className="text-gray-600 mb-4">Aún no tienes materiales personalizados</p>
                      <p className="text-sm text-gray-500">
                        Ve a cualquier presupuesto y personaliza los precios de los materiales para agregarlos aquí
                      </p>
                    </div>
                  );
                }

                return (
                  <div className="space-y-3">
                    {materials.map((material: any) => (
                      <div key={material.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <div>
                          <p className="font-medium">{material.customName}</p>
                          <p className="text-sm text-gray-600">
                            Original: {material.originalName} • {material.unit}
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="font-medium">Bs {parseFloat(material.price).toFixed(2)}</p>
                          <p className="text-xs text-gray-500">
                            Guardado: {new Date(material.savedAt).toLocaleDateString()}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                );
              })()}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="guide" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Guía de Uso - Actividades Personalizadas</CardTitle>
            </CardHeader>
            <CardContent className="prose max-w-none">
              <div className="space-y-6">
                <div>
                  <h3 className="text-lg font-semibold mb-2">¿Qué son las actividades personalizadas?</h3>
                  <p className="text-gray-600">
                    Las actividades personalizadas te permiten crear y modificar actividades de construcción 
                    según tus necesidades específicas. Puedes cambiar nombres, precios, agregar o quitar 
                    materiales, y tener tu propia base de datos de actividades.
                  </p>
                </div>

                <div>
                  <h3 className="text-lg font-semibold mb-2">Cómo crear actividades personalizadas:</h3>
                  <ul className="list-decimal list-inside space-y-2 text-gray-600">
                    <li>Haz clic en "Nueva Actividad" para crear una desde cero</li>
                    <li>O ve a cualquier presupuesto y haz clic en "Copiar y Personalizar" en una actividad existente</li>
                    <li>Edita el nombre, descripción y unidad de medida</li>
                    <li>Agrega, modifica o elimina materiales, mano de obra y equipos</li>
                    <li>Guarda tu actividad personalizada</li>
                  </ul>
                </div>

                <div>
                  <h3 className="text-lg font-semibold mb-2">Personalizar materiales:</h3>
                  <ul className="list-decimal list-inside space-y-2 text-gray-600">
                    <li>En cualquier presupuesto, expande una actividad</li>
                    <li>Haz clic en el ícono de edición junto a un material</li>
                    <li>Cambia el nombre y precio del material</li>
                    <li>El material personalizado se guardará en tu lista</li>
                  </ul>
                </div>

                <div>
                  <h3 className="text-lg font-semibold mb-2">Usar en presupuestos:</h3>
                  <p className="text-gray-600">
                    Próximamente podrás usar tus actividades personalizadas directamente en nuevos presupuestos, 
                    creando una experiencia completamente personalizada para tus proyectos de construcción.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
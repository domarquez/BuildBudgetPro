import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Plus, Search, Building2, Eye } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import ActivityDetailDialog from "@/components/activity-detail-dialog";
import { formatCurrency } from "@/lib/utils";
import type { ActivityWithPhase } from "@shared/schema";

export default function Activities() {
  const [searchTerm, setSearchTerm] = useState("");

  const { data: activities, isLoading } = useQuery<ActivityWithPhase[]>({
    queryKey: ["/api/activities"],
  });

  const filteredActivities = activities?.filter(activity =>
    activity.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    activity.phase.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    activity.description?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const groupedActivities = filteredActivities?.reduce((acc, activity) => {
    const phaseName = activity.phase.name;
    if (!acc[phaseName]) {
      acc[phaseName] = [];
    }
    acc[phaseName].push(activity);
    return acc;
  }, {} as Record<string, ActivityWithPhase[]>);

  return (
    <div className="container mx-auto p-6">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Actividades de Construcción</h1>
          <p className="text-gray-600 mt-2">Gestiona las actividades disponibles por fase constructiva</p>
        </div>
        <Button>
          <Plus className="h-4 w-4 mr-2" />
          Nueva Actividad
        </Button>
      </div>

      <div className="mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
          <Input
            placeholder="Buscar actividades, fases o descripciones..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
        </div>
      </div>

      {isLoading ? (
        <div className="space-y-6">
          {Array.from({ length: 3 }).map((_, i) => (
            <Card key={i}>
              <CardHeader>
                <Skeleton className="h-6 w-48" />
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {Array.from({ length: 4 }).map((_, j) => (
                    <div key={j} className="flex justify-between items-center p-3 border rounded-lg">
                      <div className="space-y-2">
                        <Skeleton className="h-4 w-64" />
                        <Skeleton className="h-3 w-96" />
                      </div>
                      <Skeleton className="h-6 w-12" />
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <div className="space-y-6">
          {groupedActivities && Object.entries(groupedActivities).map(([phaseName, phaseActivities]) => (
            <Card key={phaseName}>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5 text-blue-600" />
                  {phaseName}
                  <Badge variant="secondary" className="ml-auto">
                    {phaseActivities.length} actividades
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {phaseActivities.map((activity) => (
                    <div
                      key={activity.id}
                      className="flex justify-between items-center p-4 border rounded-lg hover:bg-gray-50 transition-colors"
                    >
                      <div className="flex-1">
                        <h4 className="font-semibold text-gray-900">{activity.name}</h4>
                        <p className="text-sm text-gray-600 mt-1">{activity.description}</p>
                        <div className="flex items-center gap-4 mt-2">
                          <Badge variant="outline">
                            Unidad: {activity.unit}
                          </Badge>
                          {activity.unitPrice && parseFloat(activity.unitPrice) > 0 && (
                            <Badge variant="secondary">
                              {formatCurrency(parseFloat(activity.unitPrice))}
                            </Badge>
                          )}
                        </div>
                      </div>
                      
                      {/* Botón Ver APU para actividades con composiciones */}
                      {activity.name.includes("ANÁLISIS DE PRECIOS UNITARIOS") && (
                        <ActivityDetailDialog
                          activityId={activity.id}
                          activityName={activity.name}
                          unitPrice={activity.unitPrice || "0"}
                        >
                          <Button variant="outline" size="sm">
                            <Eye className="h-4 w-4 mr-2" />
                            Ver APU
                          </Button>
                        </ActivityDetailDialog>
                      )}
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}

          {filteredActivities?.length === 0 && (
            <Card>
              <CardContent className="text-center py-12">
                <Building2 className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                <h3 className="text-lg font-semibold text-gray-900 mb-2">No se encontraron actividades</h3>
                <p className="text-gray-600">
                  {searchTerm ? "Intenta con otros términos de búsqueda" : "No hay actividades registradas"}
                </p>
              </CardContent>
            </Card>
          )}
        </div>
      )}

      {activities && (
        <div className="mt-8 text-center text-sm text-gray-500">
          Total: {activities.length} actividades en {Object.keys(groupedActivities || {}).length} fases
        </div>
      )}
    </div>
  );
}
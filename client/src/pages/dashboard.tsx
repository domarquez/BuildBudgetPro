import { useQuery } from "@tanstack/react-query";
import { Link } from "wouter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { 
  Package, 
  Calculator, 
  TrendingUp, 
  Combine, 
  Plus,
  Edit,
  BarChart3,
  Upload,
  Home,
  Building2,
  FolderRoot
} from "lucide-react";
import { formatCurrency, formatNumber, formatRelativeTime } from "@/lib/utils";
import type { BudgetWithProject } from "@shared/schema";

interface Statistics {
  totalMaterials: number;
  totalActivities: number;
  activeBudgets: number;
  totalProjectValue: number;
}

export default function Dashboard() {
  const { data: stats, isLoading: statsLoading } = useQuery<Statistics>({
    queryKey: ["/api/statistics"],
  });

  const { data: recentBudgets, isLoading: budgetsLoading } = useQuery<BudgetWithProject[]>({
    queryKey: ["/api/budgets"],
  });

  const recentBudgetsDisplay = recentBudgets?.slice(0, 3) || [];

  return (
    <div className="p-6 space-y-6">
      {/* Dashboard Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Dashboard</h2>
          <p className="text-gray-600">Resumen general del sistema</p>
        </div>
        <Link href="/budgets">
          <Button className="bg-primary text-white hover:bg-primary-variant shadow-material">
            <Plus className="w-4 h-4 mr-2" />
            Nuevo Presupuesto
          </Button>
        </Link>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card className="shadow-material">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Total Materiales</p>
                {statsLoading ? (
                  <Skeleton className="h-8 w-16 mt-1" />
                ) : (
                  <p className="text-2xl font-bold text-on-surface">
                    {formatNumber(stats?.totalMaterials || 0)}
                  </p>
                )}
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Package className="w-6 h-6 text-primary" />
              </div>
            </div>
            <div className="mt-4 flex items-center text-sm">
              <span className="text-green-600">Activos</span>
              <span className="text-gray-600 ml-2">en inventario</span>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Presupuestos Activos</p>
                {statsLoading ? (
                  <Skeleton className="h-8 w-16 mt-1" />
                ) : (
                  <p className="text-2xl font-bold text-on-surface">
                    {formatNumber(stats?.activeBudgets || 0)}
                  </p>
                )}
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <Calculator className="w-6 h-6 text-green-600" />
              </div>
            </div>
            <div className="mt-4 flex items-center text-sm">
              <span className="text-green-600">En desarrollo</span>
              <span className="text-gray-600 ml-2">proyectos</span>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Valor Total Proyectos</p>
                {statsLoading ? (
                  <Skeleton className="h-8 w-24 mt-1" />
                ) : (
                  <p className="text-2xl font-bold text-on-surface">
                    {formatCurrency(stats?.totalProjectValue || 0)}
                  </p>
                )}
              </div>
              <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-secondary" />
              </div>
            </div>
            <div className="mt-4 flex items-center text-sm">
              <span className="text-green-600">Valor estimado</span>
              <span className="text-gray-600 ml-2">total</span>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Actividades Registradas</p>
                {statsLoading ? (
                  <Skeleton className="h-8 w-16 mt-1" />
                ) : (
                  <p className="text-2xl font-bold text-on-surface">
                    {formatNumber(stats?.totalActivities || 0)}
                  </p>
                )}
              </div>
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Combine className="w-6 h-6 text-purple-600" />
              </div>
            </div>
            <div className="mt-4 flex items-center text-sm">
              <span className="text-green-600">Disponibles</span>
              <span className="text-gray-600 ml-2">para uso</span>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Recent Activity and Quick Actions */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Budgets */}
        <Card className="shadow-material">
          <CardHeader className="border-b border-gray-200">
            <CardTitle className="text-lg font-semibold text-on-surface">
              Presupuestos Recientes
            </CardTitle>
          </CardHeader>
          <CardContent className="p-6 space-y-4">
            {budgetsLoading ? (
              <>
                {Array.from({ length: 3 }).map((_, i) => (
                  <div key={i} className="flex items-center justify-between p-4">
                    <div className="flex items-center space-x-3">
                      <Skeleton className="w-10 h-10 rounded-lg" />
                      <div>
                        <Skeleton className="h-4 w-32 mb-1" />
                        <Skeleton className="h-3 w-24" />
                      </div>
                    </div>
                    <div className="text-right">
                      <Skeleton className="h-4 w-20 mb-1" />
                      <Skeleton className="h-5 w-16" />
                    </div>
                  </div>
                ))}
              </>
            ) : recentBudgetsDisplay.length > 0 ? (
              recentBudgetsDisplay.map((budget) => (
                <div
                  key={budget.id}
                  className="flex items-center justify-between p-4 hover:bg-gray-50 rounded-lg cursor-pointer"
                  onClick={() => window.location.href = `/budgets/${budget.id}`}
                >
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                      {budget.project.name.toLowerCase().includes('casa') ? (
                        <Home className="w-5 h-5 text-white" />
                      ) : budget.project.name.toLowerCase().includes('edificio') ? (
                        <Building2 className="w-5 h-5 text-white" />
                      ) : (
                        <FolderRoot className="w-5 h-5 text-white" />
                      )}
                    </div>
                    <div>
                      <p className="font-medium text-on-surface">
                        {budget.project.name}
                      </p>
                      <p className="text-sm text-gray-600">
                        {budget.phase ? budget.phase.name : "Multifase"} • {formatRelativeTime(budget.createdAt!)}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-on-surface">
                      {formatCurrency(budget.total)}
                    </p>
                    <Badge
                      variant={budget.status === 'active' ? 'default' : 
                              budget.status === 'completed' ? 'secondary' : 'outline'}
                      className="mt-1"
                    >
                      {budget.status === 'active' ? 'Activo' : 
                       budget.status === 'completed' ? 'Completado' : 'Borrador'}
                    </Badge>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                <Calculator className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                <p>No hay presupuestos recientes</p>
                <p className="text-sm">Crea tu primer presupuesto para comenzar</p>
              </div>
            )}
          </CardContent>
          {recentBudgetsDisplay.length > 0 && (
            <div className="p-6 border-t border-gray-200">
              <Link href="/budgets">
                <Button variant="ghost" className="w-full text-primary hover:text-primary-variant">
                  Ver todos los presupuestos
                </Button>
              </Link>
            </div>
          )}
        </Card>

        {/* Quick Actions */}
        <Card className="shadow-material">
          <CardHeader className="border-b border-gray-200">
            <CardTitle className="text-lg font-semibold text-on-surface">
              Acciones Rápidas
            </CardTitle>
          </CardHeader>
          <CardContent className="p-6 space-y-4">
            <Link href="/budgets">
              <Button
                variant="outline"
                className="w-full flex items-center justify-start space-x-4 p-4 h-auto border-2 border-dashed border-gray-300 hover:border-primary hover:bg-blue-50"
              >
                <div className="w-12 h-12 bg-primary rounded-lg flex items-center justify-center">
                  <Plus className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <p className="font-medium text-on-surface">Crear Nuevo Presupuesto</p>
                  <p className="text-sm text-gray-600">Iniciar un nuevo proyecto de construcción</p>
                </div>
              </Button>
            </Link>

            <Link href="/materials">
              <Button
                variant="outline"
                className="w-full flex items-center justify-start space-x-4 p-4 h-auto border border-gray-200 hover:bg-gray-50"
              >
                <div className="w-12 h-12 bg-secondary rounded-lg flex items-center justify-center">
                  <Edit className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <p className="font-medium text-on-surface">Actualizar Precios</p>
                  <p className="text-sm text-gray-600">Gestionar precios de materiales</p>
                </div>
              </Button>
            </Link>

            <Button
              variant="outline"
              className="w-full flex items-center justify-start space-x-4 p-4 h-auto border border-gray-200 hover:bg-gray-50"
              disabled
            >
              <div className="w-12 h-12 bg-green-600 rounded-lg flex items-center justify-center">
                <BarChart3 className="w-6 h-6 text-white" />
              </div>
              <div className="text-left">
                <p className="font-medium text-gray-400">Generar Reporte</p>
                <p className="text-sm text-gray-400">Crear reportes de costos y análisis</p>
              </div>
            </Button>

            <Button
              variant="outline"
              className="w-full flex items-center justify-start space-x-4 p-4 h-auto border border-gray-200 hover:bg-gray-50"
              disabled
            >
              <div className="w-12 h-12 bg-purple-600 rounded-lg flex items-center justify-center">
                <Upload className="w-6 h-6 text-white" />
              </div>
              <div className="text-left">
                <p className="font-medium text-gray-400">Importar Datos</p>
                <p className="text-sm text-gray-400">Cargar materiales desde archivo</p>
              </div>
            </Button>
          </CardContent>
        </Card>
      </div>

      {/* Construction Phases Overview */}
      <Card className="shadow-material">
        <CardHeader className="border-b border-gray-200">
          <CardTitle className="text-lg font-semibold text-on-surface">
            Fases de Construcción
          </CardTitle>
          <p className="text-sm text-gray-600">Distribución de actividades por fase</p>
        </CardHeader>
        <CardContent className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div className="p-4 border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center justify-between mb-3">
                <h4 className="font-medium text-on-surface">Trabajos Preliminares</h4>
                <span className="text-sm text-gray-600">7 actividades</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2 mb-2">
                <div className="bg-primary h-2 rounded-full" style={{ width: '85%' }} />
              </div>
              <p className="text-xs text-gray-600">Disponible para uso</p>
            </div>

            <div className="p-4 border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center justify-between mb-3">
                <h4 className="font-medium text-on-surface">Movimiento de Tierras</h4>
                <span className="text-sm text-gray-600">10 actividades</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2 mb-2">
                <div className="bg-secondary h-2 rounded-full" style={{ width: '62%' }} />
              </div>
              <p className="text-xs text-gray-600">Disponible para uso</p>
            </div>

            <div className="p-4 border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center justify-between mb-3">
                <h4 className="font-medium text-on-surface">Obra Gruesa</h4>
                <span className="text-sm text-gray-600">28 actividades</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2 mb-2">
                <div className="bg-green-600 h-2 rounded-full" style={{ width: '73%' }} />
              </div>
              <p className="text-xs text-gray-600">Disponible para uso</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

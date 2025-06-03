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
  FolderRoot,
  Users,
  Truck
} from "lucide-react";
import { formatCurrency, formatNumber, formatRelativeTime } from "@/lib/utils";
import type { BudgetWithProject } from "@shared/schema";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface Statistics {
  totalMaterials: number;
  totalActivities: number;
  activeBudgets: number;
  totalProjectValue: number;
  totalUsers: number;
  totalSuppliers: number;
  totalProjects: number;
}

interface GrowthData {
  month: string;
  users: number;
  projects: number;
  budgets: number;
  suppliers: number;
}

export default function Dashboard() {
  const { data: stats, isLoading: statsLoading } = useQuery<Statistics>({
    queryKey: ["/api/statistics"],
  });

  const { data: growthData, isLoading: growthLoading } = useQuery<GrowthData[]>({
    queryKey: ["/api/growth-data"],
  });

  const { data: recentBudgets, isLoading: budgetsLoading } = useQuery<BudgetWithProject[]>({
    queryKey: ["/api/budgets"],
  });

  const recentBudgetsDisplay = recentBudgets?.slice(0, 3) || [];

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-on-surface">Panel Principal</h1>
          <p className="text-gray-600 mt-1">
            Vista general del sistema MICA
          </p>
        </div>
        <Link href="/new-project">
          <Button className="flex items-center gap-2">
            <Plus className="w-4 h-4" />
            Nuevo Presupuesto
          </Button>
        </Link>
      </div>

      {/* Compact Stats Overview */}
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-3">
        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Users className="w-5 h-5 text-primary mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.totalUsers || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Usuarios</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Calculator className="w-5 h-5 text-green-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.activeBudgets || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Presupuestos</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Building2 className="w-5 h-5 text-orange-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.totalProjects || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Proyectos</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Truck className="w-5 h-5 text-purple-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.totalSuppliers || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Proveedores</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Package className="w-5 h-5 text-blue-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.totalMaterials || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Materiales</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <Combine className="w-5 h-5 text-teal-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-12 mb-1" />
              ) : (
                <p className="text-lg font-bold text-on-surface">
                  {formatNumber(stats?.totalActivities || 0)}
                </p>
              )}
              <p className="text-xs text-gray-600">Actividades</p>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardContent className="p-3">
            <div className="flex flex-col items-center text-center">
              <TrendingUp className="w-5 h-5 text-yellow-600 mb-1" />
              {statsLoading ? (
                <Skeleton className="h-5 w-16 mb-1" />
              ) : (
                <p className="text-sm font-bold text-on-surface">
                  {formatCurrency(stats?.totalProjectValue || 0).replace(' Bs', '')} Bs
                </p>
              )}
              <p className="text-xs text-gray-600">Valor Total</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Growth Chart */}
      <Card className="shadow-material">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <BarChart3 className="w-5 h-5" />
            Crecimiento del Sistema (Últimos 6 Meses)
          </CardTitle>
        </CardHeader>
        <CardContent>
          {growthLoading ? (
            <div className="h-64 flex items-center justify-center">
              <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
            </div>
          ) : (
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={growthData || []}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="month" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line 
                    type="monotone" 
                    dataKey="users" 
                    stroke="#3B82F6" 
                    strokeWidth={2}
                    name="Usuarios"
                  />
                  <Line 
                    type="monotone" 
                    dataKey="projects" 
                    stroke="#F97316" 
                    strokeWidth={2}
                    name="Proyectos"
                  />
                  <Line 
                    type="monotone" 
                    dataKey="budgets" 
                    stroke="#10B981" 
                    strokeWidth={2}
                    name="Presupuestos"
                  />
                  <Line 
                    type="monotone" 
                    dataKey="suppliers" 
                    stroke="#8B5CF6" 
                    strokeWidth={2}
                    name="Proveedores"
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Recent Activity and Quick Actions */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Budgets */}
        <Card className="shadow-material">
          <CardHeader className="border-b border-gray-200">
            <CardTitle className="text-lg font-semibold text-on-surface">
              Presupuestos Recientes
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4">
            {budgetsLoading ? (
              <div className="space-y-3">
                {[...Array(3)].map((_, i) => (
                  <div key={i} className="flex items-center justify-between p-3 border border-gray-200 rounded-lg">
                    <div className="space-y-1">
                      <Skeleton className="h-4 w-48" />
                      <Skeleton className="h-3 w-32" />
                    </div>
                    <Skeleton className="h-6 w-20" />
                  </div>
                ))}
              </div>
            ) : recentBudgetsDisplay.length > 0 ? (
              <div className="space-y-3">
                {recentBudgetsDisplay.map((budget) => (
                  <div key={budget.id} className="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                    <div>
                      <p className="font-medium text-on-surface">{budget.project?.name || 'Proyecto sin nombre'}</p>
                      <p className="text-sm text-gray-600">
                        {budget.updatedAt ? formatRelativeTime(budget.updatedAt) : 'Fecha no disponible'}
                      </p>
                    </div>
                    <div className="text-right">
                      <Badge variant="secondary" className="mb-1">
                        {formatCurrency(budget.total || 0)}
                      </Badge>
                      <Link href={`/budget/${budget.id}`}>
                        <Button size="sm" variant="outline" className="ml-2">
                          <Edit className="w-3 h-3 mr-1" />
                          Ver
                        </Button>
                      </Link>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-500">
                <Calculator className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                <p>No hay presupuestos recientes</p>
                <Link href="/new-project">
                  <Button className="mt-3" size="sm">
                    Crear Primer Presupuesto
                  </Button>
                </Link>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <Card className="shadow-material">
          <CardHeader className="border-b border-gray-200">
            <CardTitle className="text-lg font-semibold text-on-surface">
              Acciones Rápidas
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4">
            <div className="grid grid-cols-2 gap-3">
              <Link href="/new-project">
                <Button variant="outline" className="w-full h-20 flex flex-col items-center justify-center gap-2">
                  <Plus className="w-6 h-6" />
                  <span className="text-sm">Nuevo Proyecto</span>
                </Button>
              </Link>
              
              <Link href="/materials">
                <Button variant="outline" className="w-full h-20 flex flex-col items-center justify-center gap-2">
                  <Package className="w-6 h-6" />
                  <span className="text-sm">Ver Materiales</span>
                </Button>
              </Link>
              
              <Link href="/activities">
                <Button variant="outline" className="w-full h-20 flex flex-col items-center justify-center gap-2">
                  <Combine className="w-6 h-6" />
                  <span className="text-sm">Actividades</span>
                </Button>
              </Link>
              
              <Link href="/suppliers">
                <Button variant="outline" className="w-full h-20 flex flex-col items-center justify-center gap-2">
                  <Truck className="w-6 h-6" />
                  <span className="text-sm">Proveedores</span>
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
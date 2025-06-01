import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { 
  Building2, 
  DollarSign, 
  Package,
  TrendingUp,
  Plus,
  Store
} from "lucide-react";
import { Link } from "wouter";

export default function SupplierDashboard() {
  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Panel de Empresa</h2>
          <p className="text-gray-600">Gestiona tu empresa proveedora y ofertas de precios</p>
        </div>
        <Link href="/supplier-pricing">
          <Button className="bg-primary text-white hover:bg-primary-variant">
            <Plus className="w-4 h-4 mr-2" />
            Nueva Cotización
          </Button>
        </Link>
      </div>

      {/* Estadísticas rápidas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Cotizaciones Activas</p>
                <p className="text-2xl font-bold text-on-surface">0</p>
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Materiales Cotizados</p>
                <p className="text-2xl font-bold text-on-surface">0</p>
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Package className="w-6 h-6 text-primary" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Estado de Empresa</p>
                <Badge variant="default" className="mt-1">Activa</Badge>
              </div>
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Building2 className="w-6 h-6 text-purple-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Acciones rápidas */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Acciones Rápidas</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <Link href="/supplier-pricing">
              <Button
                variant="outline"
                className="w-full flex items-center justify-start space-x-4 p-4 h-auto border-2 border-dashed border-gray-300 hover:border-primary hover:bg-blue-50"
              >
                <div className="w-12 h-12 bg-primary rounded-lg flex items-center justify-center">
                  <DollarSign className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <p className="font-medium text-on-surface">Gestionar Cotizaciones</p>
                  <p className="text-sm text-gray-600">Crear y actualizar ofertas de precios</p>
                </div>
              </Button>
            </Link>

            <Link href="/supplier-registration">
              <Button
                variant="outline"
                className="w-full flex items-center justify-start space-x-4 p-4 h-auto border border-gray-200 hover:bg-gray-50"
              >
                <div className="w-12 h-12 bg-secondary rounded-lg flex items-center justify-center">
                  <Store className="w-6 h-6 text-white" />
                </div>
                <div className="text-left">
                  <p className="font-medium text-on-surface">Perfil de Empresa</p>
                  <p className="text-sm text-gray-600">Actualizar información de tu empresa</p>
                </div>
              </Button>
            </Link>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Información de la Empresa</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div>
                <p className="text-sm text-gray-600">Tipo de Usuario</p>
                <Badge variant="outline">Empresa Proveedora</Badge>
              </div>
              <div>
                <p className="text-sm text-gray-600">Estado</p>
                <Badge variant="default">Activa</Badge>
              </div>
              <div>
                <p className="text-sm text-gray-600">Beneficios</p>
                <ul className="text-sm text-gray-600 list-disc list-inside mt-2">
                  <li>Crear cotizaciones para materiales</li>
                  <li>Competir por proyectos</li>
                  <li>Visibilidad en el marketplace</li>
                  <li>Conectar con arquitectos y constructores</li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
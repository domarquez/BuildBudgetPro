import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { useToast } from "@/hooks/use-toast";
import { DollarSign, TrendingUp, Settings, AlertTriangle } from "lucide-react";
import { formatCurrency, formatDate } from "@/lib/utils";
import { queryClient } from "@/lib/queryClient";
import type { PriceSettings } from "@shared/schema";

export default function PriceSettingsPage() {
  const [usdRate, setUsdRate] = useState("");
  const [inflationFactor, setInflationFactor] = useState("");
  const [globalFactor, setGlobalFactor] = useState("");
  const [updatedBy, setUpdatedBy] = useState("Administrador");
  const { toast } = useToast();

  // Get current price settings
  const { data: settings, isLoading } = useQuery<PriceSettings>({
    queryKey: ["/api/price-settings"],
  });

  // Update form values when settings load
  if (settings && !usdRate) {
    setUsdRate(settings.usdExchangeRate);
    setInflationFactor(settings.inflationFactor);
  }

  // Update price settings mutation
  const updateSettingsMutation = useMutation({
    mutationFn: async (data: Partial<PriceSettings>) => {
      return await fetch('/api/price-settings', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      }).then(res => res.json());
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/price-settings"] });
      toast({
        title: "Configuración actualizada",
        description: "Los parámetros de precios se actualizaron correctamente.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudieron actualizar los parámetros.",
        variant: "destructive",
      });
    },
  });

  // Apply global price adjustment mutation
  const applyAdjustmentMutation = useMutation({
    mutationFn: async (data: { factor: number; updatedBy: string }) => {
      return await fetch('/api/apply-price-adjustment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      }).then(res => res.json());
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      queryClient.invalidateQueries({ queryKey: ["/api/price-settings"] });
      toast({
        title: "Ajuste aplicado",
        description: `Se ajustaron ${data.affectedMaterials} materiales correctamente.`,
      });
      setGlobalFactor("");
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo aplicar el ajuste global.",
        variant: "destructive",
      });
    },
  });

  const handleUpdateSettings = () => {
    updateSettingsMutation.mutate({
      usdExchangeRate: usdRate,
      inflationFactor: inflationFactor,
      updatedBy: updatedBy
    });
  };

  const handleApplyGlobalAdjustment = () => {
    const factor = parseFloat(globalFactor);
    if (isNaN(factor) || factor <= 0) {
      toast({
        title: "Factor inválido",
        description: "El factor debe ser un número positivo.",
        variant: "destructive",
      });
      return;
    }

    if (confirm(`¿Está seguro de aplicar un factor de ${factor} a TODOS los precios? Esta acción no se puede deshacer.`)) {
      applyAdjustmentMutation.mutate({ factor, updatedBy });
    }
  };

  if (isLoading) {
    return <div className="p-6">Cargando configuración...</div>;
  }

  return (
    <div className="space-y-6 p-6">
      {/* Header */}
      <div>
        <h2 className="text-2xl font-bold text-on-surface">Configuración de Precios</h2>
        <p className="text-gray-600">Gestionar factores de cambio e inflación</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Current Settings */}
        <Card className="shadow-material">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Settings className="w-5 h-5" />
              Configuración Actual
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {settings && (
              <>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium">Tipo de cambio USD:</span>
                  <span className="font-mono">{settings.usdExchangeRate} BOB</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium">Factor de inflación:</span>
                  <span className="font-mono">{settings.inflationFactor}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium">Último ajuste global:</span>
                  <span className="font-mono">{settings.globalAdjustmentFactor}</span>
                </div>
                <Separator />
                <div className="text-xs text-gray-500">
                  Última actualización: {formatDate(settings.lastUpdated)}
                  {settings.updatedBy && ` por ${settings.updatedBy}`}
                </div>
              </>
            )}
          </CardContent>
        </Card>

        {/* Update Settings */}
        <Card className="shadow-material">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <DollarSign className="w-5 h-5" />
              Actualizar Parámetros
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="usd-rate">Tipo de cambio USD (BOB)</Label>
              <Input
                id="usd-rate"
                type="number"
                step="0.01"
                value={usdRate}
                onChange={(e) => setUsdRate(e.target.value)}
                placeholder="6.96"
              />
              <p className="text-xs text-gray-500 mt-1">
                Tipo de cambio oficial USD a bolivianos
              </p>
            </div>

            <div>
              <Label htmlFor="inflation-factor">Factor de inflación</Label>
              <Input
                id="inflation-factor"
                type="number"
                step="0.0001"
                value={inflationFactor}
                onChange={(e) => setInflationFactor(e.target.value)}
                placeholder="1.0000"
              />
              <p className="text-xs text-gray-500 mt-1">
                Factor para ajustes por inflación (1.0 = sin cambio)
              </p>
            </div>

            <div>
              <Label htmlFor="updated-by">Actualizado por</Label>
              <Input
                id="updated-by"
                value={updatedBy}
                onChange={(e) => setUpdatedBy(e.target.value)}
                placeholder="Nombre del administrador"
              />
            </div>

            <Button 
              onClick={handleUpdateSettings}
              disabled={updateSettingsMutation.isPending}
              className="w-full"
            >
              {updateSettingsMutation.isPending ? 'Actualizando...' : 'Actualizar Parámetros'}
            </Button>
          </CardContent>
        </Card>
      </div>

      {/* Global Price Adjustment */}
      <Card className="shadow-material border-orange-200">
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-orange-700">
            <AlertTriangle className="w-5 h-5" />
            Ajuste Global de Precios
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="bg-orange-50 p-4 rounded-lg border border-orange-200">
            <p className="text-sm text-orange-800">
              <strong>Atención:</strong> Esta función multiplica TODOS los precios de materiales por el factor especificado. 
              Use con precaución ya que esta acción no se puede deshacer automáticamente.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
            <div>
              <Label htmlFor="global-factor">Factor de ajuste</Label>
              <Input
                id="global-factor"
                type="number"
                step="0.01"
                value={globalFactor}
                onChange={(e) => setGlobalFactor(e.target.value)}
                placeholder="1.05"
              />
              <p className="text-xs text-gray-500 mt-1">
                Ej: 1.05 = aumentar 5%, 0.95 = reducir 5%
              </p>
            </div>

            <div>
              <Label htmlFor="admin-name">Nombre del administrador</Label>
              <Input
                id="admin-name"
                value={updatedBy}
                onChange={(e) => setUpdatedBy(e.target.value)}
                placeholder="Su nombre"
              />
            </div>

            <Button 
              onClick={handleApplyGlobalAdjustment}
              disabled={applyAdjustmentMutation.isPending || !globalFactor}
              variant="destructive"
              className="bg-orange-600 hover:bg-orange-700"
            >
              {applyAdjustmentMutation.isPending ? 'Aplicando...' : 'Aplicar Ajuste Global'}
            </Button>
          </div>

          <div className="text-xs text-gray-600">
            Ejemplos de uso:
            <ul className="list-disc list-inside mt-1 space-y-1">
              <li>1.10 - Incrementar todos los precios 10% por inflación</li>
              <li>0.90 - Reducir todos los precios 10% por deflación</li>
              <li>1.05 - Ajuste menor del 5% por variaciones del mercado</li>
            </ul>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
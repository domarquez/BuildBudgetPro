import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { useToast } from "@/hooks/use-toast";
import { Download, Upload, CheckCircle, AlertCircle } from "lucide-react";
import { apiRequest } from "@/lib/queryClient";

export default function APUImport() {
  const [importStatus, setImportStatus] = useState<{
    imported: number;
    errors: number;
  } | null>(null);
  const { toast } = useToast();

  const importAPU = useMutation({
    mutationFn: async () => {
      return await apiRequest("/api/import-apu", "POST");
    },
    onSuccess: (result: any) => {
      setImportStatus(result);
      toast({
        title: "Importación completada",
        description: `Se importaron ${result.imported} composiciones de actividades con ${result.errors} errores.`,
      });
    },
    onError: (error: Error) => {
      toast({
        title: "Error en la importación",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const handleImport = () => {
    setImportStatus(null);
    importAPU.mutate();
  };

  return (
    <div className="container mx-auto p-6 max-w-4xl">
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Importar Análisis de Precios Unitarios</h1>
          <p className="text-gray-600 mt-2">
            Importa composiciones de actividades basadas en análisis de precios unitarios estándar
          </p>
        </div>

        {/* Información sobre APUs */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Download className="h-5 w-5 text-blue-600" />
              Datos de APU Disponibles
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <p className="text-gray-700">
                Se importarán composiciones para las siguientes actividades basadas en análisis de precios unitarios:
              </p>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="border rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900">Excavación Manual</h3>
                  <p className="text-sm text-gray-600 mt-1">
                    Incluye mano de obra (ayudante y maestro albañil) con cargas sociales,
                    herramientas y gastos indirectos
                  </p>
                  <div className="mt-2 text-sm">
                    <span className="text-green-600 font-medium">Precio estimado: Bs 74.85/M³</span>
                  </div>
                </div>

                <div className="border rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900">Cimiento de Ladrillo Adobito</h3>
                  <p className="text-sm text-gray-600 mt-1">
                    Incluye cemento, arena, ladrillo adobito, agua, mano de obra 
                    especializada y gastos indirectos
                  </p>
                  <div className="mt-2 text-sm">
                    <span className="text-green-600 font-medium">Precio estimado: Bs 1,069.46/M³</span>
                  </div>
                </div>
              </div>

              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <div className="flex items-start gap-2">
                  <AlertCircle className="h-5 w-5 text-blue-600 mt-0.5" />
                  <div>
                    <h4 className="font-medium text-blue-900">Proceso de Importación</h4>
                    <p className="text-sm text-blue-700 mt-1">
                      El sistema buscará actividades similares en tu base de datos y asignará
                      las composiciones correspondientes. Los materiales se vincularán automáticamente
                      con los existentes en tu inventario.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Botón de importación */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Upload className="h-5 w-5 text-green-600" />
              Iniciar Importación
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <p className="text-gray-700">
                Haz clic en el botón para importar las composiciones de actividades.
                Este proceso puede tomar unos momentos.
              </p>
              
              <Button 
                onClick={handleImport} 
                disabled={importAPU.isPending}
                className="w-full md:w-auto"
              >
                {importAPU.isPending ? "Importando..." : "Importar Composiciones APU"}
              </Button>

              {importAPU.isPending && (
                <div className="space-y-2">
                  <div className="flex items-center gap-2 text-sm text-gray-600">
                    <div className="animate-spin rounded-full h-4 w-4 border-2 border-blue-600 border-t-transparent"></div>
                    Procesando análisis de precios unitarios...
                  </div>
                  <Progress value={undefined} className="w-full" />
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        {/* Resultados de la importación */}
        {importStatus && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <CheckCircle className="h-5 w-5 text-green-600" />
                Resultados de la Importación
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <div className="text-2xl font-bold text-green-700">
                      {importStatus.imported}
                    </div>
                    <div className="text-sm text-green-600">
                      Composiciones importadas exitosamente
                    </div>
                  </div>

                  {importStatus.errors > 0 && (
                    <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                      <div className="text-2xl font-bold text-yellow-700">
                        {importStatus.errors}
                      </div>
                      <div className="text-sm text-yellow-600">
                        Actividades no encontradas o con errores
                      </div>
                    </div>
                  )}
                </div>

                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <h4 className="font-medium text-blue-900 mb-2">Próximos pasos</h4>
                  <ul className="text-sm text-blue-700 space-y-1">
                    <li>• Las actividades ahora tienen composiciones definidas</li>
                    <li>• Puedes revisar y ajustar las composiciones en la sección de Actividades</li>
                    <li>• Los precios se calcularán automáticamente al crear presupuestos</li>
                    <li>• Los costos se actualizan cuando cambies precios de materiales</li>
                  </ul>
                </div>
              </div>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Download, Database, FileText, AlertCircle } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function AdminDatabase() {
  const [isExporting, setIsExporting] = useState(false);
  const { toast } = useToast();

  const handleExportDatabase = async () => {
    try {
      setIsExporting(true);
      
      // Get authentication token
      const token = localStorage.getItem('auth_token');
      const headers: Record<string, string> = {};
      if (token) {
        headers["Authorization"] = `Bearer ${token}`;
      }
      
      // Call the export endpoint
      const response = await fetch('/api/admin/export-database', {
        method: 'GET',
        headers,
        credentials: 'include',
      });

      if (!response.ok) {
        throw new Error('Failed to export database');
      }

      // Get the filename from the response headers
      const contentDisposition = response.headers.get('Content-Disposition');
      let filename = 'micaa_database_export.sql';
      if (contentDisposition) {
        const match = contentDisposition.match(/filename="?([^"]*)"?/);
        if (match) filename = match[1];
      }

      // Create blob and download
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);

      toast({
        title: "Exportación Exitosa",
        description: `Base de datos exportada como ${filename}`,
      });

    } catch (error) {
      console.error('Export error:', error);
      toast({
        title: "Error de Exportación",
        description: "No se pudo exportar la base de datos. Verifica tu conexión.",
        variant: "destructive",
      });
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <div className="container mx-auto p-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Administración de Base de Datos</h1>
        <p className="text-gray-600 mt-2">
          Herramientas para gestión y exportación de datos del sistema MICAA
        </p>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {/* Export Database Card */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Download className="w-5 h-5" />
              Exportar Base de Datos
            </CardTitle>
            <CardDescription>
              Descarga un archivo SQL completo con todas las tablas y datos del sistema
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button 
              onClick={handleExportDatabase}
              disabled={isExporting}
              className="w-full"
            >
              {isExporting ? (
                <>
                  <div className="animate-spin w-4 h-4 border-2 border-white border-t-transparent rounded-full mr-2" />
                  Exportando...
                </>
              ) : (
                <>
                  <Download className="w-4 h-4 mr-2" />
                  Descargar Exportación
                </>
              )}
            </Button>
            <p className="text-sm text-gray-500 mt-2">
              Incluye estructura de tablas y todos los datos actuales
            </p>
          </CardContent>
        </Card>

        {/* Database Stats Card */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Database className="w-5 h-5" />
              Estadísticas de BD
            </CardTitle>
            <CardDescription>
              Información sobre el estado actual de la base de datos
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Tablas:</span>
                <span className="font-medium">~20 tablas</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Materiales:</span>
                <span className="font-medium">1,762 registros</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Actividades:</span>
                <span className="font-medium">~450 registros</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Empresas:</span>
                <span className="font-medium">~150 registros</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Format Info Card */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileText className="w-5 h-5" />
              Formato de Exportación
            </CardTitle>
            <CardDescription>
              Detalles sobre el archivo SQL generado
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div className="flex items-center gap-2 text-sm">
                <span className="w-2 h-2 bg-green-500 rounded-full"></span>
                Estructura de tablas incluida
              </div>
              <div className="flex items-center gap-2 text-sm">
                <span className="w-2 h-2 bg-green-500 rounded-full"></span>
                Todos los datos actuales
              </div>
              <div className="flex items-center gap-2 text-sm">
                <span className="w-2 h-2 bg-green-500 rounded-full"></span>
                Compatible con PostgreSQL
              </div>
              <div className="flex items-center gap-2 text-sm">
                <span className="w-2 h-2 bg-blue-500 rounded-full"></span>
                Formato SQL estándar
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Important Notes */}
      <Card className="mt-6">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <AlertCircle className="w-5 h-5 text-amber-500" />
            Notas Importantes
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-2 text-sm text-gray-600">
            <p>• La exportación incluye todos los datos sensibles del sistema</p>
            <p>• El archivo se genera en tiempo real y puede tardar unos minutos</p>
            <p>• Guarda el archivo en un lugar seguro para respaldos</p>
            <p>• El formato SQL es compatible con sistemas PostgreSQL</p>
            <p>• Esta función está disponible solo para administradores</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { Upload, FileText, CheckCircle, AlertCircle } from "lucide-react";
import { apiRequest } from "@/lib/queryClient";

interface ExtractedCompany {
  name: string;
  address: string;
  phone: string;
  email: string;
  website: string;
  services: string;
  city: string;
  businessType: string;
}

export default function ImportCompanies() {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [extractedText, setExtractedText] = useState("");
  const [parsedCompanies, setParsedCompanies] = useState<ExtractedCompany[]>([]);
  const [isProcessing, setIsProcessing] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const { toast } = useToast();

  const handleFileSelect = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file && file.type === "application/pdf") {
      setSelectedFile(file);
    } else {
      toast({
        title: "Archivo no válido",
        description: "Por favor selecciona un archivo PDF",
        variant: "destructive",
      });
    }
  };

  const extractTextFromPDF = async () => {
    if (!selectedFile) return;

    setIsProcessing(true);
    const formData = new FormData();
    formData.append("pdf", selectedFile);

    try {
      const response = await apiRequest("POST", "/api/extract-pdf-text", formData);
      const data = await response.json();
      setExtractedText(data.text);
      
      toast({
        title: "Texto extraído",
        description: "PDF procesado correctamente. Ahora puedes analizar las empresas.",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "No se pudo extraer el texto del PDF",
        variant: "destructive",
      });
    } finally {
      setIsProcessing(false);
    }
  };

  const parseCompanies = () => {
    if (!extractedText) return;

    // Algoritmo para extraer empresas del texto
    const companies: ExtractedCompany[] = [];
    const lines = extractedText.split('\n').filter(line => line.trim());
    
    let currentCompany: Partial<ExtractedCompany> = {};
    let companyStarted = false;

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      
      // Detectar inicio de nueva empresa (usualmente nombre en mayúsculas o con logo)
      if (line.length > 3 && (line.toUpperCase() === line || line.includes('®') || line.includes('S.R.L') || line.includes('LTDA'))) {
        if (companyStarted && currentCompany.name) {
          companies.push(currentCompany as ExtractedCompany);
        }
        currentCompany = { name: line };
        companyStarted = true;
        continue;
      }

      if (companyStarted) {
        // Detectar teléfonos
        const phoneMatch = line.match(/(\+591|591)?\s*\(?\d{1,2}\)?\s*\d{6,8}/g);
        if (phoneMatch) {
          currentCompany.phone = phoneMatch[0];
        }

        // Detectar emails
        const emailMatch = line.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g);
        if (emailMatch) {
          currentCompany.email = emailMatch[0];
        }

        // Detectar websites
        const websiteMatch = line.match(/(www\.|https?:\/\/)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g);
        if (websiteMatch) {
          currentCompany.website = websiteMatch[0];
        }

        // Detectar direcciones (contienen "Av.", "Calle", números)
        if (line.includes('Av.') || line.includes('Calle') || line.includes('Zona') || /\d+/.test(line)) {
          currentCompany.address = line;
        }

        // Detectar ciudades bolivianas
        const cities = ['La Paz', 'Santa Cruz', 'Cochabamba', 'Oruro', 'Potosí', 'Tarija', 'Sucre', 'Beni', 'Pando'];
        const cityFound = cities.find(city => line.includes(city));
        if (cityFound) {
          currentCompany.city = cityFound;
        }

        // Si no es información específica, probablemente es descripción de servicios
        if (!phoneMatch && !emailMatch && !websiteMatch && !currentCompany.address && !currentCompany.services) {
          currentCompany.services = line;
        }
      }
    }

    // Agregar la última empresa
    if (companyStarted && currentCompany.name) {
      companies.push(currentCompany as ExtractedCompany);
    }

    // Limpiar y completar datos faltantes
    const cleanedCompanies = companies.map(company => ({
      name: company.name || "",
      address: company.address || "",
      phone: company.phone || "",
      email: company.email || "",
      website: company.website || "",
      services: company.services || "",
      city: company.city || "La Paz",
      businessType: detectBusinessType(company.name || "", company.services || "")
    }));

    setParsedCompanies(cleanedCompanies);
    
    toast({
      title: "Empresas analizadas",
      description: `Se encontraron ${cleanedCompanies.length} empresas en el documento`,
    });
  };

  const detectBusinessType = (name: string, services: string): string => {
    const text = (name + " " + services).toLowerCase();
    
    if (text.includes("construcción") || text.includes("constructora")) return "Construcción";
    if (text.includes("ferretería") || text.includes("herramientas")) return "Ferretería";
    if (text.includes("materiales") || text.includes("cemento") || text.includes("acero")) return "Distribución";
    if (text.includes("arquitectura") || text.includes("diseño")) return "Arquitectura";
    if (text.includes("ingeniería")) return "Ingeniería";
    if (text.includes("consultoría")) return "Consultoría";
    
    return "General";
  };

  const importCompanies = async () => {
    if (parsedCompanies.length === 0) return;

    setIsImporting(true);
    try {
      const response = await apiRequest("POST", "/api/import-companies-bulk", {
        companies: parsedCompanies
      });
      
      const result = await response.json();
      
      toast({
        title: "Importación exitosa",
        description: `Se importaron ${result.imported} empresas correctamente`,
      });
      
      // Limpiar el estado
      setSelectedFile(null);
      setExtractedText("");
      setParsedCompanies([]);
      
    } catch (error) {
      toast({
        title: "Error en importación",
        description: "No se pudieron importar las empresas",
        variant: "destructive",
      });
    } finally {
      setIsImporting(false);
    }
  };

  return (
    <div className="container mx-auto px-4 py-8 max-w-6xl">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
          Importar Empresas desde PDF
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Sube un archivo PDF con listado de empresas para extraer automáticamente la información
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Panel de carga */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <Upload className="w-5 h-5" />
              <span>1. Seleccionar PDF</span>
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="pdf-file">Archivo PDF</Label>
              <Input
                id="pdf-file"
                type="file"
                accept=".pdf"
                onChange={handleFileSelect}
                className="mt-1"
              />
            </div>
            
            {selectedFile && (
              <div className="p-3 bg-green-50 dark:bg-green-950 rounded-lg border border-green-200 dark:border-green-800">
                <div className="flex items-center space-x-2">
                  <FileText className="w-4 h-4 text-green-600" />
                  <span className="text-sm font-medium text-green-800 dark:text-green-200">
                    {selectedFile.name}
                  </span>
                </div>
                <p className="text-xs text-green-600 mt-1">
                  Tamaño: {(selectedFile.size / 1024 / 1024).toFixed(2)} MB
                </p>
              </div>
            )}

            <Button 
              onClick={extractTextFromPDF}
              disabled={!selectedFile || isProcessing}
              className="w-full"
            >
              {isProcessing ? "Extrayendo texto..." : "2. Extraer Texto"}
            </Button>
          </CardContent>
        </Card>

        {/* Panel de texto extraído */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <FileText className="w-5 h-5" />
              <span>Texto Extraído</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Textarea
              value={extractedText}
              onChange={(e) => setExtractedText(e.target.value)}
              placeholder="El texto extraído del PDF aparecerá aquí..."
              className="min-h-[300px] text-sm"
            />
            
            <Button 
              onClick={parseCompanies}
              disabled={!extractedText}
              className="w-full mt-4"
            >
              3. Analizar Empresas
            </Button>
          </CardContent>
        </Card>
      </div>

      {/* Empresas encontradas */}
      {parsedCompanies.length > 0 && (
        <Card className="mt-6">
          <CardHeader>
            <CardTitle className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <CheckCircle className="w-5 h-5 text-green-600" />
                <span>Empresas Encontradas ({parsedCompanies.length})</span>
              </div>
              <Button 
                onClick={importCompanies}
                disabled={isImporting}
                className="bg-green-600 hover:bg-green-700"
              >
                {isImporting ? "Importando..." : "4. Importar Todas"}
              </Button>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {parsedCompanies.map((company, index) => (
                <div key={index} className="p-4 border rounded-lg bg-gray-50 dark:bg-gray-800">
                  <h3 className="font-semibold text-sm mb-2">{company.name}</h3>
                  <div className="space-y-1 text-xs text-gray-600 dark:text-gray-400">
                    {company.address && <p><strong>Dirección:</strong> {company.address}</p>}
                    {company.phone && <p><strong>Teléfono:</strong> {company.phone}</p>}
                    {company.email && <p><strong>Email:</strong> {company.email}</p>}
                    {company.website && <p><strong>Web:</strong> {company.website}</p>}
                    <p><strong>Ciudad:</strong> {company.city}</p>
                    <p><strong>Tipo:</strong> {company.businessType}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
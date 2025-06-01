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
      const response = await fetch("/api/extract-pdf-text", {
        method: "POST",
        body: formData,
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
        }
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || "Error en el servidor");
      }

      const data = await response.json();
      setExtractedText(data.text);
      
      toast({
        title: "Texto extraído",
        description: "PDF procesado correctamente. Ahora puedes analizar las empresas.",
      });
    } catch (error) {
      console.error("Error extracting PDF:", error);
      toast({
        title: "Error",
        description: error instanceof Error ? error.message : "No se pudo extraer el texto del PDF",
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

        // Detectar productos y servicios específicos
        const servicePatterns = [
          /(?:especialistas?|expertos?)\s+en\s+(.+)/i,
          /(?:venta|distribución|fabricación|instalación|reparación)\s+de\s+(.+)/i,
          /(?:servicios?|productos?)\s*:?\s*(.+)/i,
          /(?:ofrecemos|brindamos|proporcionamos)\s+(.+)/i,
          /•\s*(.+)/,  // puntos de lista
          /-\s*(.+)/,  // guiones de lista
          /\*\s*(.+)/   // asteriscos de lista
        ];

        let serviceFound = false;
        for (const pattern of servicePatterns) {
          const match = line.match(pattern);
          if (match && match[1] && match[1].length > 5) {
            const service = match[1].trim();
            if (currentCompany.services) {
              currentCompany.services += " | " + service;
            } else {
              currentCompany.services = service;
            }
            serviceFound = true;
            break;
          }
        }

        // Si no se detectó como servicio específico, pero parece descripción de negocio
        if (!serviceFound && !phoneMatch && !emailMatch && !websiteMatch && 
            !currentCompany.address && line.length > 10 && line.length < 150) {
          
          // Verificar si contiene palabras indicadoras de servicios/productos
          const businessKeywords = [
            'materiales', 'construcción', 'venta', 'distribución', 'instalación',
            'reparación', 'mantenimiento', 'asesoría', 'consultoría', 'diseño',
            'fabricación', 'importación', 'comercialización', 'alquiler',
            'cemento', 'acero', 'madera', 'herramientas', 'pintura', 'cerámica',
            'ladrillos', 'bloques', 'arena', 'grava', 'tubería', 'cables',
            'pisos', 'azulejos', 'sanitarios', 'grifería', 'iluminación'
          ];
          
          const hasBusinessKeywords = businessKeywords.some(keyword => 
            line.toLowerCase().includes(keyword)
          );
          
          if (hasBusinessKeywords) {
            if (currentCompany.services) {
              currentCompany.services += " | " + line;
            } else {
              currentCompany.services = line;
            }
          }
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
    
    // Categorías específicas por productos/servicios
    const categories = [
      {
        type: "Cerámica y Revestimientos",
        keywords: ["cerámica", "ceramicos", "azulejos", "revestimientos", "pisos", "porcelanato", "baldosas", "enchapes"]
      },
      {
        type: "Acero y Metales", 
        keywords: ["acero", "hierro", "metal", "soldadura", "estructuras metálicas", "perfiles", "tubería metálica", "fierro"]
      },
      {
        type: "Madera y Carpintería",
        keywords: ["madera", "maderas", "carpintería", "muebles", "tableros", "contrachapado", "aglomerado"]
      },
      {
        type: "Ferretería y Herramientas",
        keywords: ["ferretería", "herramientas", "clavos", "tornillos", "pintura", "brochas", "martillos", "taladros"]
      },
      {
        type: "Materiales de Construcción",
        keywords: ["materiales", "cemento", "ladrillos", "bloques", "arena", "grava", "agregados", "hormigón", "concreto"]
      },
      {
        type: "Instalaciones Eléctricas",
        keywords: ["eléctrico", "electricidad", "cables", "instalaciones eléctricas", "tableros eléctricos", "luminarias"]
      },
      {
        type: "Instalaciones Sanitarias", 
        keywords: ["sanitarios", "plomería", "grifería", "tuberías", "conexiones", "desagües", "agua potable"]
      },
      {
        type: "Construcción y Obras",
        keywords: ["construcción", "constructora", "obras", "edificación", "infraestructura", "proyectos"]
      },
      {
        type: "Arquitectura y Diseño",
        keywords: ["arquitectura", "diseño", "planos", "proyectos arquitectónicos", "diseño interior"]
      },
      {
        type: "Ingeniería y Consultoría",
        keywords: ["ingeniería", "consultoría", "asesoría técnica", "supervisión", "estudios"]
      },
      {
        type: "Distribución y Comercialización",
        keywords: ["distribuidora", "distribución", "mayorista", "comercialización", "importación", "representaciones"]
      },
      {
        type: "Alquiler y Servicios",
        keywords: ["alquiler", "renta", "servicios", "mantenimiento", "reparación", "transporte"]
      }
    ];
    
    // Buscar la categoría más específica
    for (const category of categories) {
      const matchCount = category.keywords.filter(keyword => text.includes(keyword)).length;
      if (matchCount > 0) {
        return category.type;
      }
    }
    
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
        {/* Panel de entrada de datos */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <FileText className="w-5 h-5" />
              <span>1. Ingresar Datos</span>
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="pdf-file">Archivo PDF del Catálogo</Label>
              <Input
                id="pdf-file"
                type="file"
                accept=".pdf"
                onChange={handleFileSelect}
                className="mt-1"
              />
              <p className="text-xs text-blue-600 mt-1">
                Carga tu PDF y luego copia el texto desde el documento
              </p>
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
                <Button 
                  onClick={extractTextFromPDF}
                  disabled={isProcessing}
                  className="mt-2 w-full"
                  size="sm"
                >
                  {isProcessing ? "Procesando..." : "Procesar PDF"}
                </Button>
              </div>
            )}
            
            <div className="border-t pt-4">
              <Label htmlFor="manual-text">Importación Manual - Pega el texto del catálogo</Label>
              <p className="text-xs text-gray-600 mb-2">
                Copia todo el texto del catálogo y pégalo aquí. El sistema detectará automáticamente empresas, direcciones, teléfonos y rubros.
              </p>
              <Textarea
                id="manual-text"
                value={extractedText}
                onChange={(e) => setExtractedText(e.target.value)}
                placeholder="Pega aquí el texto completo del catálogo de empresas...

Ejemplo:
CONSTRUCTORA ABC S.R.L.
Av. América 1234, La Paz
Tel: 2-234-5678 | contacto@abc.com.bo
Especialistas en construcción y materiales

FERRETERÍA CENTRAL
Calle Comercio 567, Santa Cruz  
Teléf: 3-345-6789
Venta de herramientas y ferretería en general"
                className="min-h-[400px] text-sm"
              />
            </div>
          </CardContent>
        </Card>

        {/* Panel de análisis */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <FileText className="w-5 h-5" />
              <span>Análisis de Empresas</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div>
                <p className="text-sm text-gray-600 mb-2">
                  Estadísticas del texto:
                </p>
                <div className="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg text-xs">
                  <p>Caracteres: {extractedText.length}</p>
                  <p>Líneas: {extractedText.split('\n').length}</p>
                  <p>Palabras aproximadas: {extractedText.split(' ').length}</p>
                </div>
              </div>
              
              <Button 
                onClick={parseCompanies}
                disabled={!extractedText.trim()}
                className="w-full"
                size="lg"
              >
                3. Analizar y Extraer Empresas
              </Button>
              
              {parsedCompanies.length > 0 && (
                <div className="bg-green-50 dark:bg-green-950 p-3 rounded-lg">
                  <p className="text-sm font-medium text-green-800 dark:text-green-200">
                    ✅ {parsedCompanies.length} empresas encontradas
                  </p>
                </div>
              )}
            </div>
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
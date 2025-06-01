import { Link, useLocation } from "wouter";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarHeader,
} from "@/components/ui/sidebar";
import {
  PanelsTopLeft,
  Package,
  Combine,
  Calculator,
  BarChart3,
  Settings,
  Construction,
  DollarSign,
  MapPin,
  Building2,
  Store,
  Wrench,
  Users,
} from "lucide-react";

const menuItems = [
  {
    title: "PanelsTopLeft",
    url: "/dashboard",
    icon: PanelsTopLeft,
  },
  {
    title: "Materiales",
    url: "/materials",
    icon: Package,
  },
  {
    title: "Actividades",
    url: "/activities",
    icon: Combine,
  },
  {
    title: "Herramientas",
    url: "/tools",
    icon: Wrench,
  },
  {
    title: "Mano de Obra",
    url: "/labor",
    icon: Users,
  },
  {
    title: "Presupuestos",
    url: "/budgets",
    icon: Calculator,
  },
  {
    title: "Reportes",
    url: "/reports",
    icon: BarChart3,
  },
];

const marketplaceItems = [
  {
    title: "Empresas Proveedoras",
    url: "/suppliers",
    icon: Building2,
  },
  {
    title: "Mi Empresa",
    url: "/supplier-registration",
    icon: Store,
  },
];

const settingsItems = [
  {
    title: "Importar APU",
    url: "/apu-import",
    icon: Construction,
  },
  {
    title: "Configuración de Precios",
    url: "/price-settings",
    icon: DollarSign,
  },
  {
    title: "Factores por Ciudad",
    url: "/city-factors",
    icon: MapPin,
  },
  {
    title: "Configuración",
    url: "/settings",
    icon: Settings,
  },
];

export default function AppSidebar() {
  const [location] = useLocation();

  const isActive = (url: string) => {
    if (url === "/dashboard" && (location === "/" || location === "/dashboard")) {
      return true;
    }
    return location === url;
  };

  return (
    <Sidebar className="border-r">
      <SidebarHeader className="p-6">
        <div className="flex items-center space-x-2">
          <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
            <Construction className="w-4 h-4 text-white" />
          </div>
          <span className="text-lg font-semibold text-on-surface">ConstructPro</span>
        </div>
      </SidebarHeader>
      
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Sistema</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {menuItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive(item.url)}
                    className="w-full"
                  >
                    <Link href={item.url}>
                      <item.icon className="w-4 h-4" />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
        
        <SidebarGroup>
          <SidebarGroupLabel>Marketplace</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {marketplaceItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive(item.url)}
                    className="w-full"
                  >
                    <Link href={item.url}>
                      <item.icon className="w-4 h-4" />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup>
          <SidebarGroupLabel>Configuración</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {settingsItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive(item.url)}
                    className="w-full"
                  >
                    <Link href={item.url}>
                      <item.icon className="w-4 h-4" />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
      
      <SidebarFooter className="p-4 border-t">
        <div className="text-xs text-muted-foreground text-center">
          ConstructPro v1.0.0
        </div>
      </SidebarFooter>
    </Sidebar>
  );
}

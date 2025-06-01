import { Switch, Route } from "wouter";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { SidebarProvider } from "@/components/ui/sidebar";
import Dashboard from "@/pages/dashboard";
import Materials from "@/pages/materials";
import Activities from "@/pages/activities";
import Budgets from "@/pages/budgets";
import BudgetDetails from "@/pages/budget-details";
import PriceSettings from "@/pages/price-settings";
import APUImport from "@/pages/apu-import";
import CityFactors from "@/pages/city-factors";
import Suppliers from "@/pages/suppliers";
import SupplierRegistration from "@/pages/supplier-registration";
import Tools from "@/pages/tools";
import Labor from "@/pages/labor";
import AdminActivities from "@/pages/admin-activities";
import SupplierPricing from "@/pages/supplier-pricing";
import SupplierDashboard from "@/pages/supplier-dashboard";
import CompanyAdvertising from "@/pages/company-advertising";
import ImportCompanies from "@/pages/import-companies";
import ManageSuppliers from "@/pages/manage-suppliers";
import Marketplace from "@/pages/marketplace";
import Login from "@/pages/login";
import Register from "@/pages/register";
import PublicView from "@/pages/public-view";
import NotFound from "@/pages/not-found";
import AppSidebar from "@/components/layout/sidebar";
import AppHeader from "@/components/layout/header";
import { useAuth } from "@/hooks/useAuth";

function Router() {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Cargando...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return (
      <Switch>
        <Route path="/register" component={Register} />
        <Route path="/login" component={Login} />
        <Route path="/public" component={PublicView} />
        <Route path="/" component={PublicView} />
        <Route component={PublicView} />
      </Switch>
    );
  }

  return <AuthenticatedLayout />;
}

function AuthenticatedLayout() {
  return (
    <SidebarProvider>
      <div className="min-h-screen bg-surface">
        <AppSidebar />
        <div className="flex flex-col flex-1 lg:ml-64">
          <AppHeader />
          <main className="flex-1">
            <Switch>
              <Route path="/" component={Dashboard} />
              <Route path="/dashboard" component={Dashboard} />
              <Route path="/materials" component={Materials} />
              <Route path="/activities" component={Activities} />
              <Route path="/admin/activities" component={AdminActivities} />
              <Route path="/tools" component={Tools} />
              <Route path="/labor" component={Labor} />
              <Route path="/budgets" component={Budgets} />
              <Route path="/budgets/:id" component={BudgetDetails} />
              <Route path="/price-settings" component={PriceSettings} />
              <Route path="/apu-import" component={APUImport} />
              <Route path="/city-factors" component={CityFactors} />
              <Route path="/suppliers" component={Suppliers} />
              <Route path="/supplier-registration" component={SupplierRegistration} />
              <Route path="/supplier-dashboard" component={SupplierDashboard} />
              <Route path="/supplier-pricing" component={SupplierPricing} />
              <Route path="/company-advertising" component={CompanyAdvertising} />
              <Route path="/import-companies" component={ImportCompanies} />
        <Route path="/manage-suppliers" component={ManageSuppliers} />
              <Route path="/marketplace" component={Marketplace} />
              <Route component={NotFound} />
            </Switch>
          </main>
        </div>
      </div>
    </SidebarProvider>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <div className="min-h-screen bg-surface">
          <Router />
        </div>
        <Toaster />
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;

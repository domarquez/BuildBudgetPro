import { Building2 } from "lucide-react";

interface MicaaLogoProps {
  size?: "sm" | "md" | "lg" | "xl";
  showText?: boolean;
  className?: string;
  textClassName?: string;
}

export function MicaaLogo({ 
  size = "md", 
  showText = true, 
  className = "",
  textClassName = ""
}: MicaaLogoProps) {
  const sizeClasses = {
    sm: "w-6 h-6",
    md: "w-8 h-8", 
    lg: "w-12 h-12",
    xl: "w-16 h-16"
  };

  const textSizes = {
    sm: "text-lg",
    md: "text-xl",
    lg: "text-2xl", 
    xl: "text-3xl"
  };

  // SVG del logo MICAA basado en el constructor con casco
  const ConstructorIcon = () => (
    <svg 
      viewBox="0 0 64 64" 
      className={`${sizeClasses[size]} ${className}`}
      fill="none"
    >
      {/* Casco de seguridad */}
      <path 
        d="M16 18 C16 14, 20 10, 32 10 C44 10, 48 14, 48 18 L48 26 C48 28, 46 30, 44 30 L20 30 C18 30, 16 28, 16 26 Z" 
        fill="#FFD700" 
        stroke="#E6B800" 
        strokeWidth="1"
      />
      
      {/* Visera del casco */}
      <path 
        d="M14 26 L50 26 C50 24, 48 22, 46 22 L18 22 C16 22, 14 24, 14 26 Z" 
        fill="#F4C430"
      />
      
      {/* Cara del constructor */}
      <circle cx="32" cy="36" r="10" fill="#FDBCB4" stroke="#E3A082" strokeWidth="1"/>
      
      {/* Ojos */}
      <circle cx="28" cy="34" r="1.5" fill="#2C3E50"/>
      <circle cx="36" cy="34" r="1.5" fill="#2C3E50"/>
      
      {/* Sonrisa */}
      <path d="M28 38 Q32 42, 36 38" stroke="#E74C3C" strokeWidth="1.5" fill="none"/>
      
      {/* Camisa de constructor */}
      <rect x="20" y="46" width="24" height="12" rx="2" fill="#2C5530" stroke="#1E3A24" strokeWidth="1"/>
      
      {/* Brazos */}
      <rect x="14" y="48" width="6" height="8" rx="3" fill="#FDBCB4" stroke="#E3A082" strokeWidth="1"/>
      <rect x="44" y="48" width="6" height="8" rx="3" fill="#FDBCB4" stroke="#E3A082" strokeWidth="1"/>
      
      {/* Herramientas en el cinturón */}
      <rect x="22" y="54" width="2" height="4" fill="#8B4513"/>
      <rect x="26" y="54" width="2" height="4" fill="#C0C0C0"/>
      <rect x="30" y="54" width="2" height="4" fill="#FFD700"/>
      
      {/* Reflejo en el casco para darle brillo */}
      <ellipse cx="26" cy="20" rx="4" ry="2" fill="#FFFFFF" opacity="0.3"/>
    </svg>
  );

  return (
    <div className={`flex items-center space-x-2 ${className}`}>
      <ConstructorIcon />
      {showText && (
        <span className={`font-bold text-orange-600 dark:text-orange-400 ${textSizes[size]} ${textClassName}`}>
          MICAA
        </span>
      )}
    </div>
  );
}
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

  // SVG del logo MICAA minimalista y profesional
  const ConstructorIcon = () => (
    <svg 
      viewBox="0 0 24 24" 
      className={`${sizeClasses[size]} ${className}`}
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      {/* Casco de seguridad - parte superior */}
      <path d="M6 8c0-2.5 2.5-5 6-5s6 2.5 6 5v3c0 .5-.5 1-1 1H7c-.5 0-1-.5-1-1V8z" />
      
      {/* Visera del casco */}
      <path d="M4 11h16" />
      
      {/* Línea central del casco */}
      <path d="M9 8h6" />
      
      {/* Cabeza */}
      <circle cx="12" cy="15" r="2.5" />
      
      {/* Camisa/uniforme */}
      <path d="M8 18v3c0 .5.5 1 1 1h6c.5 0 1-.5 1-1v-3" />
      
      {/* Corbata */}
      <path d="M12 18v4" />
      <path d="M11 19l1-1 1 1" />
      
      {/* Brazos/mangas */}
      <path d="M8 18l-2 2v2" />
      <path d="M16 18l2 2v2" />
    </svg>
  );

  return (
    <div className={`flex items-center space-x-2 ${className}`}>
      <ConstructorIcon />
      {showText && (
        <span className={`font-bold text-gray-700 dark:text-gray-200 ${textSizes[size]} ${textClassName}`}>
          MICAA
        </span>
      )}
    </div>
  );
}
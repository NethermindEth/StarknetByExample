import { useEffect, useState } from "react";
import { useTheme } from "./useTheme";

export const ThemeImage = ({
  light,
  dark,
  alt,
  ...props
}: {
  light: string;
  dark: string;
  alt: string;
  [key: string]: any;
}) => {
  const [mounted, setMounted] = useState(false);
  const theme = useTheme();

  useEffect(() => {
    setMounted(true);
  }, []);
  if (!mounted) {
    return <img src={light} alt={alt} {...props} />;
  }

  // Client-side rendering after hydrating
  return <img src={theme === "light" ? light : dark} alt={alt} {...props} />;
};

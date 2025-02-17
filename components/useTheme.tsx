import { useEffect, useState } from "react";

export function useTheme() {
  const [theme, setTheme] = useState<"dark" | "light">(() => {
    if (typeof window === "undefined") return "light";
    return document.documentElement.classList.contains("dark")
      ? "dark"
      : "light";
  });

  useEffect(() => {
    const handleThemeChange = () => {
      const newTheme = document.documentElement.classList.contains("dark")
        ? "dark"
        : "light";
      setTheme(newTheme);
    };

    // Watch for class changes on documentElement
    const observer = new MutationObserver(handleThemeChange);
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class"],
    });

    return () => {
      observer.disconnect();
    };
  }, []);

  return theme;
}

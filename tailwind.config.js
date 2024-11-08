/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,ts,jsx,tsx}",
    "./pages/**/*.{md,mdx,js,ts,jsx,tsx}",
    "./footer.tsx",
    "./layout.tsx",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#ff4b01",
        secondary: "#1b1b50",
      },
    },
  },
  plugins: [],
};

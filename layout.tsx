import { useSidebarToggle } from "./components/useSidebarToggle";

export default function Root({ children }: { children: React.ReactNode }) {
  useSidebarToggle();
  return <div className="page-wrapper">{children}</div>;
}

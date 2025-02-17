import { useSidebarToggle } from "./components/useSidebarToggle";
import { useTracking } from "./components/useTracking";

export default function Root({ children }: { children: React.ReactNode }) {
  useTracking();
  useSidebarToggle();
  return <div className="page-wrapper">{children}</div>;
}

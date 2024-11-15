import { useEffect, useCallback } from "react";
import { createRoot } from "react-dom/client";

export const useSidebarToggle = () => {
  const createToggleButton = useCallback(() => {
    const SidebarToggle = () => (
      <div className="flex flex-col items-center justify-center">
        <button
          onClick={() =>
            document.documentElement.classList.toggle("sidebar_hidden")
          }
          className="flex items-center justify-center p-2 rounded vocs_DesktopTopNav_button"
          aria-label="Toggle sidebar"
        >
          <div className="vocs_Icon vocs_DesktopTopNav_icon">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              width="20"
              height="20"
              aria-hidden="true"
            >
              <path
                fill="currentColor"
                d="M2 6a1 1 0 011-1h18a1 1 0 110 2H3a1 1 0 01-1-1zM2 12.032a1 1 0 011-1h18a1 1 0 110 2H3a1 1 0 01-1-1zM3 17.064a1 1 0 100 2h18a1 1 0 000-2H3z"
              />
            </svg>
          </div>
        </button>
      </div>
    );

    return SidebarToggle;
  }, []);

  useEffect(() => {
    const targetNode = document.querySelector(".vocs_DocsLayout_gutterLeft");
    if (!targetNode) {
      console.warn("Target node for sidebar toggle not found");
      return;
    }

    const toggleContainer = document.createElement("div");
    toggleContainer.className = "sidebar_toggle flex justify-center";
    targetNode.appendChild(toggleContainer);

    const Toggle = createToggleButton();
    const root = createRoot(toggleContainer);
    root.render(<Toggle />);

    // Cleanup
    return () => {
      root.unmount();
      toggleContainer.remove();
    };
  }, [createToggleButton]);
};

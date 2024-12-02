import { Sidebar, SidebarItem } from "vocs";

const config: Sidebar = [
  {
    text: "Introduction",
    link: "/",
  },
  {
    text: "Getting Started",
    items: [
      {
        text: "Local environment setup",
        link: "/getting-started/env_setup",
      },
      {
        text: "Basics of a Starknet contract",
        items: [
          {
            text: "Storage",
            link: "/getting-started/basics/storage",
          },
          {
            text: "Interfaces, Visibility and Mutability",
            link: "/getting-started/basics/visibility-mutability",
          },
          {
            text: "Variables",
            link: "/getting-started/basics/variables",
          },
          {
            text: "Constructor",
            link: "/getting-started/basics/constructor",
          },
          {
            text: "Counter Example",
            link: "/getting-started/basics/counter",
          },
          {
            text: "Errors",
            link: "/getting-started/basics/errors",
          },
          {
            text: "Events",
            link: "/getting-started/basics/events",
          },
          {
            text: "Storing Custom Types",
            link: "/getting-started/basics/storing_custom_types",
          },
          {
            text: "Custom Types in Entrypoints",
            link: "/getting-started/basics/custom-types-in-entrypoints",
          },
          {
            text: "Mappings",
            link: "/getting-started/basics/mappings",
          },
          {
            text: "Documentation",
            link: "/getting-started/basics/documentation",
          },
        ],
      },
      {
        text: "Deploy and interact with contracts",
        items: [
          {
            text: "How to deploy",
            link: "/getting-started/interacting/how_to_deploy",
          },
          {
            text: "Calling other contracts",
            link: "/getting-started/interacting/calling_other_contracts",
          },
          {
            text: "Factory pattern",
            link: "/getting-started/interacting/factory",
          },
        ],
      },
      {
        text: "Testing contracts",
        link: "/getting-started/testing/",
        items: [
          {
            text: "With Snforge",
            link: "/getting-started/testing/testing-snforge",
          },
          {
            text: "With Cairo Test",
            link: "/getting-started/testing/testing-cairo-test",
          },
        ],
      },
      {
        text: "Syscalls Reference",
        link: "/getting-started/syscalls",
      },
    ],
  },
  {
    text: "Components",
    items: [
      {
        text: "Components How-To",
        link: "/components/how_to",
      },
      {
        text: "Components Dependencies",
        link: "/components/dependencies",
      },
      {
        text: "Storage Collisions",
        link: "/components/collisions",
      },
      {
        text: "Ownable",
        link: "/components/ownable",
      },
    ],
  },
  {
    text: "Applications",
    items: [
      {
        text: " Upgradeable Contract",
        link: "/applications/upgradeable_contract",
      },
      {
        text: "Defi Vault",
        link: "/applications/simple_vault",
      },
      {
        text: "ERC20 Token",
        link: "/applications/erc20",
      },
      {
        text: "ERC721 NFT",
        link: "/applications/erc721",
      },
      {
        text: "NFT Dutch Auction",
        link: "/applications/nft_dutch_auction",
      },
      {
        text: "Constant Product AMM",
        link: "/applications/constant-product-amm",
      },
      {
        text: "TimeLock",
        link: "/applications/timelock",
      },
      {
        text: "Staking",
        link: "/applications/staking",
      },
      {
        text: "Merkle Tree",
        link: "/applications/merkle_tree",
      },
      {
        text: "Simple Storage with Starknet-js",
        link: "/applications/simple_storage_starknetjs",
      },
      {
        text: "Crowdfunding Campaign",
        link: "/applications/crowdfunding",
      },
      {
        text: "AdvancedFactory: Crowdfunding",
        link: "/applications/advanced_factory",
      },
      {
        text: "Random Number Generator",
        link: "/applications/random_number_generator",
      },
      {
        text: "L1 <> L2 Token Bridge",
        link: "/applications/l1_l2_token_bridge",
      },
    ],
  },
  {
    text: "Advanced concepts",
    items: [
      {
        text: "Writing to any storage slot",
        link: "/advanced-concepts/write_to_any_slot",
      },
      {
        text: "Struct as mapping key",
        link: "/advanced-concepts/struct-mapping-key",
      },
      {
        text: "Hashing",
        link: "/advanced-concepts/hashing",
      },
      // Hidden until #123 is solved
      // {
      //   text: "Hash Solidity Compatible",
      //   link: "/advanced-concepts/hash-solidity-compatible"
      // },
      {
        text: "Optimisations",
        items: [
          {
            text: "Storage Optimisations",
            link: "/advanced-concepts/optimisations/store_using_packing",
          },
        ],
      },
      // Hidden as the content is not 100% correct
      // {
      //   text: "Account Abstraction",
      //   items: [
      //     {
      //       text: "AA on Starknet",
      //       link: "/advanced-concepts/account_abstraction",
      //     },
      //     {
      //       text: "Account Contract",
      //       link: "/advanced-concepts/account_abstraction/account_contract",
      //     },
      //   ],
      // },
      {
        text: "Library Calls",
        link: "/advanced-concepts/library_calls",
      },
      {
        text: "Plugins",
        link: "/advanced-concepts/plugins",
      },
      {
        text: "Signature Verification",
        link: "/advanced-concepts/signature_verification",
      },
      {
        text: "Sierra IR",
        link: "/advanced-concepts/sierra_ir",
      },
      {
        text: "Zk-Snarks",
        link: "/advanced-concepts/verify_proofs/snarkjs",
      },
    ],
  },
  {
    text: "Cairo cheatsheet",
    collapsed: true,
    items: [
      {
        text: "Felt",
        link: "/cairo_cheatsheet/felt",
      },
      {
        text: "Map",
        link: "/cairo_cheatsheet/mapping",
      },
      {
        text: "Arrays",
        link: "/cairo_cheatsheet/arrays",
      },
      {
        text: "loop",
        link: "/cairo_cheatsheet/loop",
      },
      {
        text: "while",
        link: "/cairo_cheatsheet/while",
      },
      {
        text: "if let",
        link: "/cairo_cheatsheet/if_let",
      },
      {
        text: "while let",
        link: "/cairo_cheatsheet/while_let",
      },
      {
        text: "Enums",
        link: "/cairo_cheatsheet/enums",
      },
      {
        text: "Match",
        link: "/cairo_cheatsheet/match",
      },
      {
        text: "Tuples",
        link: "/cairo_cheatsheet/tuples",
      },
      {
        text: "Struct",
        link: "/cairo_cheatsheet/struct",
      },
      {
        text: "Type casting",
        link: "/cairo_cheatsheet/type_casting",
      },
      {
        text: "Dict",
        link: "/cairo_cheatsheet/dict",
      },
    ],
  },
];

/**
 * Gets all top-level routes from the sidebar config
 * @param sidebar
 * @returns Array of route paths and their corresponding section names
 */
const getTopLevelRoutes = (sidebar: SidebarItem[]): Array<[string, string]> =>
  sidebar
    .filter((item) => item.text !== "Introduction") // Skip Introduction
    .map((item) => {
      // Convert the text to a URL-friendly format and get the first link if available
      const path =
        item.link || `/${item.text.toLowerCase().replace(/\s+/g, "-")}`;
      return [path.split("/")[1], item.text] as [string, string];
    });

/**
 * Generates a complete sidebar configuration with automatic route-based collapsing
 * @param sidebar
 * @returns Complete sidebar configuration object with route-specific collapsed states
 */
const generateSidebarConfig = (sidebar: SidebarItem[]): Sidebar => {
  // Initialize with the default route
  const config: Sidebar = {
    "/": sidebar,
  };

  // Configure for all top-level routes
  getTopLevelRoutes(sidebar).forEach(([route, sectionName]) => {
    config[`/${route}`] = sidebarFocusOn(sidebar, sectionName, true);
  });

  return config;
};

/**
 * Recursively modifies the sidebar structure to control which sections are collapsed
 * @param sidebar - The original sidebar configuration array
 * @param target - The section text to keep expanded (uncollapsed)
 * @param closeOther - Whether to force collapse all non-target sections
 * @returns Modified sidebar array with controlled collapsed states
 */
const sidebarFocusOn = (
  sidebar: SidebarItem[],
  target: string,
  closeOther: boolean = false
): SidebarItem[] =>
  sidebar.map((item) =>
    item.items && item.items.length > 0
      ? {
          ...item,
          collapsed: closeOther ? true : item.collapsed,
          items: sidebarFocusOn(item.items, target, closeOther),
        }
      : {
          ...item,
          collapsed: item.text === target ? item.collapsed : true,
        }
  );

export const routes = generateSidebarConfig(config);

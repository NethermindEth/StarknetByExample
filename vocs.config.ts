import { defineConfig } from "vocs";

export default defineConfig({
  rootDir: ".",
  title: "Starknet by Example",
  topNav: [
    {
      text: "GitHub",
      link: "https://github.com/NethermindEth/StarknetByExample",
    },
  ],
  sidebar: [
    {
      text: "Getting Started",
      items: [
        {
          text: "1. Basics of a Starknet contract",
          link: "/getting-started/basics/introduction",
          collapsed: false,
          items: [
            {
              text: "1.1. Storage",
              link: "/getting-started/basics/storage",
            },
            {
              text: "1.2. Constructor",
              link: "/getting-started/basics/constructor",
            },
            {
              text: "1.3. Variables",
              link: "/getting-started/basics/variables",
            },
            {
              text: "1.4. Visibility and Mutability",
              link: "/getting-started/basics/visibility-mutability",
            },
            {
              text: "1.5. Counter Example",
              link: "/getting-started/basics/counter",
            },
            {
              text: "1.6. Mappings",
              link: "/getting-started/basics/mappings",
            },
            {
              text: "1.7. Errors",
              link: "/getting-started/basics/errors",
            },
            {
              text: "1.8. Events",
              link: "/getting-started/basics/events",
            },
            {
              text: "1.9. Syscalls",
              link: "/getting-started/basics/syscalls",
            },
            {
              text: "1.10. Strings and ByteArrays",
              link: "/getting-started/basics/bytearrays-strings",
            },
            {
              text: "1.11. Storing Custom Types",
              link: "/getting-started/basics/storing-custom-types",
            },
            {
              text: "1.12. Custom types in entrypoints",
              link: "/getting-started/basics/custom-types-in-entrypoints",
            },
            {
              text: "1.13. Documentation",
              link: "/getting-started/basics/documentation",
            },
          ],
        },
        {
          text: "2. Deploy and interact with contracts",
          link: "/getting-started/interacting/interacting",
          collapsed: true,
          items: [
            {
              text: "2.1. Contract interfaces and Traits generation",
              link: "/getting-started/interacting/interfaces-traits",
            },
            {
              text: "2.2. Calling other contracts",
              link: "/getting-started/interacting/calling_other_contracts",
            },
            {
              text: "2.3. Factory pattern",
              link: "/getting-started/interacting/factory",
            },
          ],
        },
        {
          text: "3. Testing contracts",
          link: "/getting-started/testing/contract-testing",
        },
        {
          text: "4. Cairo cheatsheet",
          link: "/getting-started/cairo_cheatsheet/cairo_cheatsheet",
          collapsed: true,
          items: [
            {
              text: "4.1. Felt",
              link: "/getting-started/cairo_cheatsheet/felt",
            },
            {
              text: "4.2. LegacyMap",
              link: "/getting-started/cairo_cheatsheet/mapping",
            },
            {
              text: "4.3. Arrays",
              link: "/getting-started/cairo_cheatsheet/arrays",
            },
            {
              text: "4.4. loop",
              link: "/getting-started/cairo_cheatsheet/loop",
            },
            {
              text: "4.5. while",
              link: "/getting-started/cairo_cheatsheet/while",
            },
            {
              text: "4.6. if let",
              link: "/getting-started/cairo_cheatsheet/if_let",
            },
            {
              text: "4.7. while let",
              link: "/getting-started/cairo_cheatsheet/while_let",
            },
            {
              text: "4.8. Match",
              link: "/getting-started/cairo_cheatsheet/match",
            },
            {
              text: "4.9. Tuples",
              link: "/getting-started/cairo_cheatsheet/tuples",
            },
            {
              text: "4.10. Struct",
              link: "/getting-started/cairo_cheatsheet/struct",
            },
            {
              text: "4.11. Type casting",
              link: "/getting-started/cairo_cheatsheet/type_casting",
            },
          ],
        },
      ],
    },
    {
      text: "Components",
      items: [
        {
          text: "5. Components How-To",
          link: "/components/how_to",
        },
        {
          text: "6. Components Dependencies",
          link: "/components/dependencies",
        },
        {
          text: "7. Storage Collisions",
          link: "/components/collisions",
        },
        {
          text: "8. Ownable",
          link: "/components/ownable",
        },
      ],
    },
    {
      text: "Applications",
      items: [
        {
          text: "9. Upgradeable Contract",
          link: "/applications/upgradeable_contract",
        },
        {
          text: "10. Defi Vault",
          link: "/applications/simple_vault",
        },
        {
          text: "11. ERC20 Token",
          link: "/applications/erc20",
        },
        {
          text: "12. Constant Product AMM",
          link: "/applications/constant-product-amm",
        },
      ],
    },
    {
      text: "Advanced concepts",
      items: [
        {
          text: "13. Writing to any storage slot",
          link: "/advanced-concepts/write_to_any_slot",
        },
        // {
        //   text: "14. Storing Arrays",
        //   link: "/advanced-concepts/storing_arrays",
        // },
        {
          text: "15. Struct as mapping key",
          link: "/advanced-concepts/struct-mapping-key",
        },
        {
          text: "16. Hashing",
          link: "/advanced-concepts/hashing",
        },
        {
          text: "17. Optimisations",
          link: "/advanced-concepts/optimisations/optimisations",
          collapsed: false,
          items: [
            {
              text: "17.1. Storage Optimisations",
              link: "/advanced-concepts/optimisations/store_using_packing",
            },
          ],
        },
        // {
        //   text: "18. List",
        //   link: "/advanced-concepts/list",
        // },
        {
          text: "19. Plugins",
          link: "/advanced-concepts/plugins",
        },
        {
          text: "20. Signature Verification",
          link: "/advanced-concepts/signature_verification",
        },
      ],
    },
  ],
});

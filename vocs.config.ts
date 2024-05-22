import { defineConfig } from "vocs";

export default defineConfig({
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
          link: "/ch00/basics/introduction",
          collapsed: false,
          items: [
            {
              text: "1.1. Storage",
              link: "/ch00/basics/storage",
            },
            {
              text: "1.2. Constructor",
              link: "/ch00/basics/constructor",
            },
            {
              text: "1.3. Variables",
              link: "/ch00/basics/variables",
            },
            {
              text: "1.4. Visibility and Mutability",
              link: "/ch00/basics/visibility-mutability",
            },
            {
              text: "1.5. Counter Example",
              link: "/ch00/basics/counter",
            },
            {
              text: "1.6. Mappings",
              link: "/ch00/basics/mappings",
            },
            {
              text: "1.7. Errors",
              link: "/ch00/basics/errors",
            },
            {
              text: "1.8. Events",
              link: "/ch00/basics/events",
            },
            {
              text: "1.9. Syscalls",
              link: "/ch00/basics/syscalls",
            },
            {
              text: "1.10. Strings and ByteArrays",
              link: "/ch00/basics/bytearrays-strings",
            },
            {
              text: "1.11. Storing Custom Types",
              link: "/ch00/basics/storing-custom-types",
            },
            {
              text: "1.12. Custom types in entrypoints",
              link: "/ch00/basics/custom-types-in-entrypoints",
            },
            {
              text: "1.13. Documentation",
              link: "/ch00/basics/documentation",
            },
          ],
        },
        {
          text: "2. Deploy and interact with contracts",
          link: "/ch00/interacting/interacting",
          collapsed: true,
          items: [
            {
              text: "2.1. Contract interfaces and Traits generation",
              link: "/ch00/interacting/interfaces-traits",
            },
            {
              text: "2.2. Calling other contracts",
              link: "/ch00/interacting/calling_other_contracts",
            },
            {
              text: "2.3. Factory pattern",
              link: "/ch00/interacting/factory",
            },
          ],
        },
        {
          text: "3. Testing contracts",
          link: "/ch00/testing/contract-testing",
        },
        {
          text: "4. Cairo cheatsheet",
          link: "/ch00/cairo_cheatsheet/cairo_cheatsheet",
          collapsed: true,
          items: [
            {
              text: "4.1. Felt",
              link: "/ch00/cairo_cheatsheet/felt",
            },
            {
              text: "4.2. LegacyMap",
              link: "/ch00/cairo_cheatsheet/mapping",
            },
            {
              text: "4.3. Arrays",
              link: "/ch00/cairo_cheatsheet/arrays",
            },
            {
              text: "4.4. loop",
              link: "/ch00/cairo_cheatsheet/loop",
            },
            {
              text: "4.5. while",
              link: "/ch00/cairo_cheatsheet/while",
            },
            {
              text: "4.6. if let",
              link: "/ch00/cairo_cheatsheet/if_let",
            },
            {
              text: "4.7. while let",
              link: "/ch00/cairo_cheatsheet/while_let",
            },
            {
              text: "4.8. Match",
              link: "/ch00/cairo_cheatsheet/match",
            },
            {
              text: "4.9. Tuples",
              link: "/ch00/cairo_cheatsheet/tuples",
            },
            {
              text: "4.10. Struct",
              link: "/ch00/cairo_cheatsheet/struct",
            },
            {
              text: "4.11. Type casting",
              link: "/ch00/cairo_cheatsheet/type_casting",
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
          link: "/ch01/upgradeable_contract",
        },
        {
          text: "10. Defi Vault",
          link: "/ch01/simple_vault",
        },
        {
          text: "11. ERC20 Token",
          link: "/ch01/erc20",
        },
        {
          text: "12. Constant Product AMM",
          link: "/ch01/constant-product-amm",
        },
      ],
    },
    {
      text: "Advanced concepts",
      items: [
        {
          text: "13. Writing to any storage slot",
          link: "/ch02/write_to_any_slot",
        },
        {
          text: "14. Storing Arrays",
          link: "/ch02/storing_arrays",
        },
        {
          text: "15. Struct as mapping key",
          link: "/ch02/struct-mapping-key",
        },
        {
          text: "16. Hashing",
          link: "/ch02/hashing",
        },
        {
          text: "17. Optimisations",
          link: "/ch02/optimisations/optimisations",
          collapsed: false,
          items: [
            {
              text: "17.1. Storage Optimisations",
              link: "/ch02/optimisations/store_using_packing",
            },
          ],
        },
        {
          text: "18. List",
          link: "/ch02/list",
        },
        {
          text: "19. Plugins",
          link: "/ch02/plugins",
        },
        {
          text: "20. Signature Verification",
          link: "/ch02/signature_verification",
        },
      ],
    },
  ],
});

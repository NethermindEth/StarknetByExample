import { defineConfig } from "vocs";
import { routes } from "./routes";
import remarkMath from "remark-math";
import rehypeKatex from "rehype-katex";

// Shiki currently does not support cairo
// We temporarily use shiki fine grained bundle with custom cairo grammar
// This require custom highlighter, and patch of vocs to remove initial shiki instance

export default defineConfig({
  title: "Starknet by Example",
  // Theme configuration
  font: {
      google: "DM Sans",
  },
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [
      [
        rehypeKatex,
        {
          strict: false,
          displayMode: false,
          output: "mathml",
        },
      ],
    ],
  },
  editLink: {
    text: "Contribute",
    pattern:
      "https://github.com/NethermindEth/StarknetByExample/blob/vocs/pages/:path",
  },
  socials: [
    {
      icon: "github",
      link: "https://github.com/NethermindEth/StarknetByExample",
    },
    {
      icon: "telegram",
      link: "https://t.me/StarknetByExample",
    },
    {
      icon: "x",
      link: "https://x.com/nethermindstark",
    },
  ],
  sponsors: [
    {
      name: "Powered by",
      height: 60,
      items: [
        [
          {
            name: "Nethermind",
            link: "https://www.nethermind.io/",
            image: "/collaborators/Nethermind.svg",
          },
        ],
        [
          {
            name: "Starknet",
            link: "https://www.starknet.io",
            image: "/collaborators/Starknet.svg",
          },
          {
            name: "Onlydust",
            link: "https://app.onlydust.com/p/starknet-by-example",
            image: "/collaborators/Onlydust.svg",
          },
        ],
      ],
    },
    {
      name: "Ecosystem toolings",
      items: [
        [
          {
            name: "Voyager",
            link: "https://voyager.online",
            image: "/collaborators/Voyager.svg",
          },
        ],
        [
          {
            name: "Starknet RPC",
            link: "https://data.voyager.online",
            image: "/collaborators/Starknet_RPC.svg",
          },
          {
            name: "Juno",
            link: "https://github.com/NethermindEth/juno",
            image: "/collaborators/Juno.svg",
          },
          {
            name: "Starknet Remix Plugin",
            link: "https://remix.ethereum.org/?#activate=Starknet",
            image: "/collaborators/Starknet_Remix_Plugin.svg",
          },
        ],
      ],
    },
  ],
  sidebar: routes,
});

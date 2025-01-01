export default function Footer() {
  return (
    <div className="flex flex-col items-center pb-4 gap-2 opacity-50 hover:opacity-70 transition-opacity duration-500 ease-in-out">
      <img
        className="w-40"
        src="/collaborators/PoweredByNethermind.svg"
        alt="Powered By Nethermind"
      />
      <div className="footer_text text-xs flex flex-col items-center">
        <span>Released under the MIT License.</span>
        <span>© 2025 Nethermind. All Rights Reserved</span>
      </div>
    </div>
  );
}

export default function Footer() {
  return (
    <div className="flex flex-col items-center pb-2 gap-2">
      <img
        className="w-40"
        src="/collaborators/PoweredByNethermind.svg"
        alt="Powered By Nethermind"
      />
      <div className="footer_text text-xs flex flex-col items-center">
        <span>Released under the MIT License.</span>
        <span>© 2024 Nethermind. All Rights Reserved</span>
      </div>
    </div>
  );
}

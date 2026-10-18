{
	pkgs,
	lib,
	...
}:
let
	platforms = {
		"x86_64-linux" = "linux-x64";
		"aarch64-linux" = "linux-arm64";
		"armv7l-linux" = "linux-armhf";
		"powerpc64le-linux" = "linux-ppc64le";
		"s390x-linux" = "linux-s390x";
		"x86_64-darwin" = "darwin-x64";
		"aarch64-darwin" = "darwin-arm64";
		"x86_64-windows" = "win32-x64";
		"aarch64-windows" = "win32-arm64";
		"i686-windows" = "win32-ia32";
	};
	targetPlatform = platforms.${pkgs.stdenv.hostPlatform.system} or null;
	extensions = lib.importJSON ../../assets/vscode.extensions.json;

	buildExtension = publisher: name: extension:
		let
			source = extension.src;
			selectedPlatform =
				if targetPlatform != null && builtins.hasAttr targetPlatform source.platforms then targetPlatform
				else "universal";
			platformSource = source.platforms.${selectedPlatform} or null;
		in
		if platformSource == null then
			throw "VS Code extension ${publisher}.${name} has no VSIX for ${pkgs.stdenv.hostPlatform.system} and no universal fallback"
		else
		pkgs.vscode-utils.buildVscodeMarketplaceExtension {
			mktplcRef = {
				inherit publisher name;
				version = source.version;
				hash = platformSource.hash;
			} // lib.optionalAttrs (selectedPlatform != "universal") {
				arch = targetPlatform;
			};
			inherit (extension) meta;
		};
in
lib.mergeAttrsList [
	{
		catppuccin.catppuccin-vsc = pkgs.vscode-extensions.catppuccin.catppuccin-vsc.overrideAttrs (prev: {
			postFixup = ''
				substituteInPlace $out/share/vscode/extensions/catppuccin.catppuccin-vsc/dist/main.cjs \
					--replace-warn 'var Xt=async t=>{' 'var Xt=async t=>{return null;'
			'';
		});
	}
	(lib.mapAttrs (publisher: publisherExtensions:
		lib.mapAttrs (name: extension: buildExtension publisher name extension) publisherExtensions
	) extensions)
]

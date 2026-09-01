# 📦 Custom Packages Overlay

A Nixpkgs overlay providing packages that are either missing from nixpkgs or ship newer versions than what's currently available.

## Packages

| Package | Description |
|:---|:---|
| `cider-2` | [Cider](https://cider.sh/) **v4.x** — nixpkgs only ships v3.x because v4.x is proprietary/closed-source and cannot be distributed through nixpkgs due to licensing |
| `lsfg-vk` | [LSFG-VK](https://github.com/PancakeTAS/lsfg-vk) **v2.x dev** — nixpkgs only ships stable v1.x |
| `bun-baseline` | [Bun](https://bun.sh/) **baseline build** — for CPUs without AVX2 support (the default nixpkgs `bun` requires AVX2) |
| `cage-xtmapper` | [cage-xtmapper](https://github.com/Xtr126/cage-xtmapper) — input mapping tool for Waydroid, not available in nixpkgs |
| `geode-cli` | [Geode CLI](https://geode-sdk.org/) — Geometry Dash mod loader CLI, not available in nixpkgs |

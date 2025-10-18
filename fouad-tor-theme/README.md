# Fouad Tor — Hacker Theme 🚀👾

A neon hacker-style rebrand for Tor Browser: dark UI, glowing accents, custom banner, animated background, and your icon/logo. Ships as templates and an installer script so you don’t have to redistribute Tor binaries.

> Works with a local Tor Browser directory (portable bundle). No system files are modified unless you choose to install a desktop shortcut in your home folder.

---

## Features ✨
- **Neon dark UI** across toolbars/tabs with terminal fonts.
- **Animated hacker background** on pages and about pages.
- **Top “Fouad Tor” banner** with your logo on the left.
- **Custom homepage** `fouad-home.html` with links and neon card.
- **Emoticons**: 👾 on tabs, 🚀 on external links.
- **Desktop shortcut** named “Fouad Tor” with your icon.
- **Non-destructive**: Applies to a Tor profile directory; easy rollback.

---

## Repo Layout 📁
```
fouad-tor-theme/
├─ README.md
├─ scripts/
│  └─ install.sh
└─ templates/
   ├─ Fouad Tor.desktop
   ├─ userChrome.css
   ├─ userContent.css
   └─ fouad-home.html
```

You should add your icon file to the repo at:
```
assets/fouad-cyper-store.png
```
Then pass that path to the installer.

---

## Quick Start ⚡
1. Download Tor Browser and extract it. Example:
   - `/path/to/tor-browser-linux-x86_64-14.5.8/tor-browser`
2. Clone this repo.
3. Put your icon at `assets/fouad-cyper-store.png` (or any path you prefer).
4. Run the installer script with your Tor directory and icon path:

```bash
bash scripts/install.sh \
  --tor-dir "/path/to/tor-browser-linux-x86_64-14.5.8/tor-browser" \
  --icon "/absolute/path/to/assets/fouad-cyper-store.png"
```

What it does:
- Enables `userChrome.css`/`userContent.css` in the Tor profile.
- Writes the neon theme, banner, homepage, and emoticons.
- Creates a `Fouad Tor.desktop` shortcut on your Desktop (optional).

Launch via the shortcut, or run Tor Browser as usual.

---

## Options 🛠️
- `--name "Fouad Tor"`
  - Sets the shortcut/display name. Default: Fouad Tor.
- `--accent "#00ff7f"`
  - Neon accent color. Default: `#00ff7f`.
- `--make-shortcut`
  - Create `~/Desktop/Fouad Tor.desktop`.
- `--no-shortcut`
  - Skip creating the desktop entry.

---

## Uninstall ⏪
The installer makes backups before changes:
- `profile.default/chrome/userChrome.css.bak` (if existed)
- `profile.default/chrome/userContent.css.bak`
- `profile.default/user.js.bak`

To rollback, run:
```bash
bash scripts/install.sh --tor-dir "/path/to/tor-browser" --uninstall
```
Or manually restore the `.bak` files and remove the desktop shortcut.

---

## Notes & Safety 📜
- This project does not redistribute Tor Browser or modify system directories.
- It writes only to your Tor bundle’s profile and, optionally, to your `~/Desktop/` and `~/.local/bin/`.
- If your Tor Browser overwrites the bundled `.desktop` file on launch, use the standalone desktop shortcut this repo generates.

---

## Screenshots 📸
Add your screenshots/GIFs here to showcase the theme.

---

## Troubleshooting 🧰
- Theme not applied? Fully close Tor Browser and launch again.
- Icon not showing?
  - Ensure your icon path is absolute and readable.
  - Re-run the installer with the correct `--icon`.
- Banner overlaps page top? The theme adds padding; some pages with fixed headers may still need tweaks. Adjust `padding-top` in `userContent.css`.

---

## Credits 🙌
- Built on top of the Tor Browser profile customization mechanism using `userChrome.css` and `userContent.css`.

---

## License 🔑
MIT for the theme templates and scripts. Tor Browser is licensed by The Tor Project under their terms.

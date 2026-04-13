# SpendX - Telegram Mini App

Crypto-to-fiat card management app built as a Telegram Mini App.

## Quick Start

```bash
./build.sh      # Build index.html from JSX source
# Then push to GitHub — auto-deploys via GitHub Actions
```

## Structure

```
├── spendx-mvp-v3.jsx    # React source (edit this)
├── build.sh             # Build script
├── index.html           # Built output (auto-generated)
├── CLAUDE.md            # AI assistant context
└── .github/workflows/
    └── deploy.yml       # Auto-deploy on push
```

## Deploy

Push `index.html` to `main` branch → GitHub Actions deploys to Pages automatically.

**Live:** https://ntovt13.github.io/spendx-app/

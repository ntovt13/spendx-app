# CLAUDE.md - SpendX Telegram Mini App

## Project Overview
SpendX is a crypto-to-fiat fintech Telegram Mini App (MVP prototype). Single-file React app compiled via Babel standalone, deployed to GitHub Pages.

**Live URL:** https://ntovt13.github.io/spendx-app/
**Telegram Bot:** @SpendXBot (configured in BotFather with menu_button → web_app URL)

## Architecture

### Source Files
- `spendx-mvp-v3.jsx` — Main React source (~4000 lines, single component tree)
- `build.sh` — Compiles JSX → `index.html` (strips import, wraps in HTML with CDN scripts)
- `index.html` — Built output, served by GitHub Pages (~344 KB)

### Build & Deploy
```bash
chmod +x build.sh
./build.sh          # Produces index.html
git add index.html
git commit -m "update"
git push            # GitHub Actions auto-deploys to Pages
```

### Tech Stack
- React 18 (CDN: unpkg.com, production build)
- Babel Standalone (CDN: unpkg.com, compiles JSX in browser)
- Telegram WebApp SDK
- DM Sans + DM Mono fonts (Google Fonts)
- No build tools, no npm, no bundler — single HTML file

## Design System
```
Colors:
  --navy: #091428     --navy2: #0b1c34    --navy3: #0d1f3c
  --panel: #131d2f    --panel-light: #1a2740
  --accent: #1a5cff   --accent2: #4b8aff  --vivid: #93bdff
  --yellow: #e8ff2e   --lemon: #c8e000    --cta: #f5820d
  --green: #34d399    --error: #f87171
  --white: #f4f7ff    --silver: #dce6f8   --muted: #a3b5d6

Fonts: DM Sans (body/UI), DM Mono (prices/tags)
Border radius: 14-20px panels, 50px buttons
```

## Key Features (20)
1. Auth screen with Telegram login animation
2. Onboarding tutorial (2 phases: empty state + home with cards)
3. 6-language i18n (EN/RU/UK/DE/ES/TR) — 250+ translation keys
4. 5 card tiers (Essential/Plus/Prime/Supreme/Business)
5. Circuit SVG card skins + custom photo upload
6. 3D flip card with number/CVV reveal
7. Card lock/unlock with confirmation
8. KYC verification flow (3 stages)
9. 2FA setup (SMS + Google Authenticator)
10. Crypto top-up (USDT/USDC, 3 networks, QR, fee calculator)
11. Transaction history with search/filter
12. Transaction detail view
13. Card shop with crypto payment flow
14. Live crypto prices (CoinGecko API, fallback LI.FI)
15. Physical card pre-order with waitlist
16. Apple Pay setup guide
17. Language switcher (dropdown at root level, z-index 9999)
18. Eye toggle (hide/show balances)
19. FAQ accordion
20. Support link (Telegram group)

## Critical Rules

### Business Rules
- User CANNOT order a card until KYC = "verified"
- Telegram login possible WITHOUT KYC
- Card issuance requires completed KYC

### Translation System
- Object `T` at module level: `{ key: { en: "...", ru: "...", uk: "...", de: "...", es: "...", tr: "..." } }`
- Inside components: `const t = useT()` then `t("key")`
- Inside main app (outside Provider): `const tl = (key) => T[key]?.[lang] || T[key]?.en || key`
- **NEVER** use `t()` inside the T object definition — it causes `ReferenceError: Can't find variable: t`
- Always check for corrupted defs: `en: t("key")` inside T = FATAL BUG

### Code Quality Checks (run before every deploy)
```bash
# 1. Babel syntax
node -e "const b=require('@babel/core'),f=require('fs'); ..."

# 2. No corrupted T defs (en: t("...") inside T object)
grep 'en: t(' spendx-mvp-v3.jsx  # Must return 0 results

# 3. Brace balance
python3 -c "c=open('spendx-mvp-v3.jsx').read(); print(c.count('{')-c.count('}'), c.count('[')-c.count(']'))"
# Must be: 0 0

# 4. All components with t() have useT()
# 5. All t("key") keys exist in T object
```

### LangSwitcher Architecture
The language dropdown renders at the ROOT level of the app (not inside LangSwitcher component) to avoid z-index/stacking issues in Telegram WebView:
- `LangSwitcher` = just a button, calls `onOpen` prop
- `LangDropdown` = separate component, rendered in main app JSX at z-index 9999
- `openLangDD` function in main app measures button position

### Scroll Architecture
```
body (position:fixed, overflow:hidden)
  └─ .full-h (flex column, overflow:hidden)
       ├─ scrollRef div (flex:1, overflow:auto) ← ALL scrolling here
       ├─ TabBar (flexShrink:0)
       ├─ LangDropdown (z-index:9999)
       ├─ Tutorial (z-index:500)
       └─ Toast (z-index:999)
```

### Name Format
Always write: **Miklós Tóth** (with diacritics), professional name: **Nicolas Tovt**

### Formatting
- Use "-" instead of "—" (em dash) in all text
- Cover letters: navy/gold PDF style

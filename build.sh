#!/bin/bash
# SpendX Mini App - Build Script
# Compiles spendx-mvp-v3.jsx into a single index.html for GitHub Pages

set -e

echo "🔨 Building SpendX Mini App..."

# Extract JSX body (skip import line, convert export default)
tail -n +2 spendx-mvp-v3.jsx | sed 's/^export default function /function /' > /tmp/jsx-body.js

# Build index.html
cat > index.html << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover"/>
<meta name="theme-color" content="#091428"/>
<title>SpendX</title>
<script src="https://telegram.org/js/telegram-web-app.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<style>
*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html,body,#root{height:100%;width:100%;overflow:hidden;background:#091428;font-family:'DM Sans',sans-serif}
::-webkit-scrollbar{display:none}
</style>
<script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
<script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
<script crossorigin src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
</head>
<body>
<div id="root"></div>
<script type="text/babel" data-type="module">
const { useState, useEffect, createContext, useContext, useRef } = React;
HEADER

cat /tmp/jsx-body.js >> index.html

cat >> index.html << 'FOOTER'

ReactDOM.createRoot(document.getElementById("root")).render(<SpendXMVP3 />);
</script>
</body>
</html>
FOOTER

SIZE=$(wc -c < index.html | awk '{print int($1/1024)}')
echo "✅ Built index.html (${SIZE} KB)"

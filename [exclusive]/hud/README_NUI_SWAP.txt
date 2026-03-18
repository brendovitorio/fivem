# HUD - NUI trocada (antiga -> nova)

## O que foi feito
- A **NUI antiga** foi movida para `web-side_old_backup/`
- A **NUI nova** (React/Vite) foi adicionada em `web-src/`
- O build do Vite já está configurado para gerar automaticamente em `web-side/`
- Criado um **bridge** no client (`client-side/nui_bridge.lua`) para:
  - Enviar `action="updateHud"` / `action="toggleHud"` (como a NUI nova espera)
  - Mapear campos do HUD antigo para os nomes da NUI nova (ex: `heart -> health`, `armour -> armor`, `km -> speed`, etc)

> Eu NÃO alterei o estilo/visual da NUI nova. Só ajustei a ponte de dados para ela renderizar.

## Como compilar a NUI nova (Windows)
1. Instale Node.js LTS
2. Rode:
   - `build_nui.bat`

Isso vai gerar os arquivos finais (HTML/CSS/JS) dentro de `web-side/`.

## Como compilar manualmente (qualquer OS)
```bash
cd web-src
npm install
npm run build
```

## Depois do build
- Reinicie a resource no servidor:
  - `restart hud`

## Observação
Sem o build, o FiveM vai abrir um `web-side/index.html` de aviso (placeholder).
Depois do build, esse arquivo será substituído pelo bundle da NUI nova.

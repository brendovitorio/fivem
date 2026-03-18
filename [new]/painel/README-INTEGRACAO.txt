RECURSO AJUSTADO PARA O CORE REVOLT:
- fxmanifest alterado para usar @revolt/lib/utils.lua.
- Client/server configurados para priorizar interfaces e modulos do core revolt/rEVOLT.
- NUI nova convertida para FiveM (open/close, fetch callbacks, dashboards, civis, relatorios, mandados, BOLO, veiculos).
- Aba de veiculos ligada na tabela vehicles da base revolt.
- getInitialData agora monta patente usando a hierarquia Police quando o identity nao trouxer rank/patent.
- Alias de evento mantido: revolt:Mdt -> police:Mdt.
- Banco completo incluido em db/revolt_full_db.sql.
- Patch do recurso MDT incluido em db/revolt_police_mdt.sql.

OBSERVACOES:
- O recurso continua baseado em Tunnel/Proxy, que combina com o teu core revolt enviado.
- A NUI original em Vite foi preservada em nui-src-vite como referencia do frontend.
- A interface estatica entregue em web-side e a versao pronta para rodar no FiveM sem precisar buildar nada.

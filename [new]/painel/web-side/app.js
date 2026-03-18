const resourceName = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'police';
const app = document.getElementById('app');
const content = document.getElementById('content');
const sidebar = document.getElementById('sidebar');
const officerSubtitle = document.getElementById('officerSubtitle');
const notifBadge = document.getElementById('notifBadge');

const state = {
  visible: false,
  active: 'dashboard',
  officer: {
    name: 'Oficial',
    badge: '0000',
    rank: 'Oficial',
    unit: 'Polícia Revolt',
    isSuperior: false,
    stats: { arrests: 0, tickets: 0, reports: 0, warrants: 0 }
  },
  reports: [],
  warrants: [],
  civilian: null,
  civilians: [],
  vehicles: [],
  vehicleSearchTerm: '',
  civilSearchTerm: '',
  penalArticles: [],
  selectedArticles: [],
  articleForm: {
    id: null,
    title: '',
    description: '',
    fine: '',
    services: ''
  }
};

const menu = [
  ['dashboard', 'Dashboard'],
  ['civis', 'Civis'],
  ['veiculos', 'Veículos'],
  ['relatorios', 'Relatórios'],
  ['bolo', 'BOLO'],
  ['warrants', 'Mandados'],
  ['codigo-penal', 'Código Penal'],
  ['departamento', 'Departamento'],
  ['administracao', 'Administração', true],
];

async function nui(eventName, data = {}) {
  const res = await fetch(`https://${resourceName}/${eventName}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data),
  });
  const text = await res.text();
  try { return text ? JSON.parse(text) : {}; } catch { return text; }
}

function esc(str) {
  return String(str ?? '').replace(/[&<>"']/g, m => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  }[m]));
}

function pill(text, cls = 'blue') {
  return `<span class="pill ${cls}">${esc(text)}</span>`;
}

function money(v) {
  return Number(v || 0).toLocaleString('pt-BR');
}

function fmtUnix(ts) {
  const n = Number(ts || 0);
  return n > 0 ? new Date(n * 1000).toLocaleDateString('pt-BR') : '—';
}

function statusCls(status) {
  return status === 'Regular' ? 'green' : status === 'Apreendido' ? 'red' : 'gold';
}

function isSolved(v) {
  return v === true || v === 1 || v === '1' || v === 'true';
}

function sidebarHtml() {
  return menu
    .filter(([, , sup]) => !sup || state.officer.isSuperior)
    .map(([id, label]) => `<button class="nav-btn ${state.active === id ? 'active' : ''}" data-nav="${id}">${esc(label)}</button>`)
    .join('');
}

function syncHeader() {
  officerSubtitle.textContent = `${state.officer.name} • Badge ${state.officer.badge} • ${state.officer.rank}`;
  notifBadge.textContent = String((state.reports?.length || 0) + (state.warrants?.length || 0));
  sidebar.innerHTML = sidebarHtml();
}

function selectedArticlesFine() {
  return state.selectedArticles.reduce((acc, item) => acc + Number(item.fine || 0), 0);
}

function selectedArticlesServices() {
  return state.selectedArticles.reduce((acc, item) => acc + Number(item.services || 0), 0);
}

function toggleArticle(id) {
  id = Number(id);
  const exists = state.selectedArticles.some(item => Number(item.id) === id);

  if (exists) {
    state.selectedArticles = state.selectedArticles.filter(item => Number(item.id) !== id);
  } else {
    const article = state.penalArticles.find(item => Number(item.id) === id);
    if (article) state.selectedArticles.push(article);
  }

  render();
}

function fillArticleForm(id) {
  const article = state.penalArticles.find(item => Number(item.id) === Number(id));
  if (!article) return;

  state.articleForm = {
    id: article.id,
    title: article.title || '',
    description: article.description || '',
    fine: String(article.fine || ''),
    services: String(article.services || '')
  };

  render();
}

function clearArticleForm() {
  state.articleForm = {
    id: null,
    title: '',
    description: '',
    fine: '',
    services: ''
  };
  render();
}

async function loadPenalArticles() {
  const data = await nui('getPenalArticles');
  state.penalArticles = Array.isArray(data) ? data : (data.articles || []);
}

async function refreshData() {
  const data = await nui('getInitialData');

  state.officer = data.officer || state.officer;
  state.reports = data.reports || [];
  state.warrants = data.warrants || [];

  if (typeof data.isPoliceGeneral !== 'undefined') {
    state.officer.isSuperior = !!data.isPoliceGeneral || !!state.officer.isSuperior;
  }

  await loadPenalArticles();
  syncHeader();
  render();
}

function render() {
  syncHeader();
  if (state.active === 'dashboard') return renderDashboard();
  if (state.active === 'civis') return renderCivilians();
  if (state.active === 'relatorios') return renderReports();
  if (state.active === 'warrants') return renderWarrants();
  if (state.active === 'bolo') return renderBolo();
  if (state.active === 'veiculos') return renderVehicles();
  if (state.active === 'codigo-penal') return renderPenal();
  if (state.active === 'departamento') return renderDepartment();
  if (state.active === 'administracao') return renderAdmin();
}

function articlesSelectorHtml(prefix = 'default') {
  const selectedIds = state.selectedArticles.map(item => Number(item.id));

  return `
    <div class="article-select-wrap">
      <button type="button" class="article-select-trigger" data-toggle-article-dropdown="${prefix}">
        <div>
          <strong>Artigos aplicáveis</strong>
          <div class="tiny article-select-summary">
            ${state.selectedArticles.length
              ? `${state.selectedArticles.length} selecionado(s) • Multa: ${money(selectedArticlesFine())} • Serviços: ${selectedArticlesServices()}`
              : 'Selecione os artigos que o cidadão se enquadra'}
          </div>
        </div>
        <span class="article-select-arrow">▼</span>
      </button>

      <div class="article-select-dropdown hidden" id="articleDropdown-${prefix}">
        <div class="article-select-list">
          ${state.penalArticles.map(article => {
            const active = selectedIds.includes(Number(article.id));
            return `
              <label class="article-option ${active ? 'active' : ''}">
                <input
                  type="checkbox"
                  data-toggle-article="${article.id}"
                  ${active ? 'checked' : ''}
                >
                <div class="article-option-content">
                  <div class="article-option-title">
                    ${esc(article.id)} - ${esc(article.title)}
                  </div>
                  <div class="article-option-meta">
                    Multa: ${money(article.fine || 0)} • Serviços: ${esc(article.services || 0)}
                  </div>
                  ${article.description ? `<div class="article-option-desc">${esc(article.description)}</div>` : ''}
                </div>
              </label>
            `;
          }).join('') || `<div class="empty">Nenhum artigo cadastrado.</div>`}
        </div>
      </div>
    </div>
  `;
}

function renderDashboard() {
  content.innerHTML = `
    <div class="grid stack">
      <div>
        <h1 class="section-title">Dashboard</h1>
        <div class="section-sub">Visão geral do MDT da polícia.</div>
      </div>

      <div class="grid grid-4">
        <div class="card"><div class="muted">Oficial</div><div class="metric" style="font-size:22px">${esc(state.officer.name)}</div><div class="small muted">${esc(state.officer.unit)}</div></div>
        <div class="card"><div class="muted">Relatórios</div><div class="metric">${state.reports.length}</div></div>
        <div class="card"><div class="muted">Mandados</div><div class="metric">${state.warrants.length}</div></div>
        <div class="card"><div class="muted">Badge</div><div class="metric">${esc(state.officer.badge)}</div></div>
      </div>

      <div class="grid grid-2">
        <div class="card stack">
          <div class="row-between"><h3 style="margin:0">Aplicar multa</h3>${pill('Ação rápida')}</div>
          <input class="field" id="finePassport" placeholder="Passaporte">
          <input class="field" id="fineValue" placeholder="Valor da multa">
          <textarea class="field" id="fineReason" placeholder="Motivo da multa"></textarea>
          <button class="btn" id="issueFineBtn">Registrar multa</button>
        </div>

        <div class="card stack">
          <div class="row-between"><h3 style="margin:0">Efetuar prisão</h3>${pill('Operacional','green')}</div>
          <input class="field" id="prisonPassport" placeholder="Passaporte">
          <input class="field" id="prisonServices" placeholder="Serviços (ou deixa vazio para automático)">
          <input class="field" id="prisonFine" placeholder="Multa (ou deixa vazio para automático)">
          <textarea class="field" id="prisonReason" placeholder="Motivo da prisão"></textarea>
          ${articlesSelectorHtml('dashboard')}
          <button class="btn green" id="issuePrisonBtn">Efetuar prisão</button>
        </div>
      </div>

      <div class="grid grid-2">
        <div class="card">
          <h3 style="margin-top:0">Relatórios recentes</h3>
          <div class="list">
            ${state.reports.slice(0,5).map(r => `
              <div class="item">
                <div class="row-between">
                  <strong>${esc(r.victim_name || 'Sem nome')}</strong>
                  ${pill(isSolved(r.solved) ? 'Resolvido' : 'Pendente', isSolved(r.solved) ? 'green' : 'gold')}
                </div>
                <div class="tiny muted">Oficial: ${esc(r.police_name)} • ${esc(r.created_at)}</div>
                <div class="small pre">${esc(r.victim_report)}</div>
              </div>
            `).join('') || `<div class="empty">Sem relatórios.</div>`}
          </div>
        </div>

        <div class="card">
          <h3 style="margin-top:0">Mandados ativos</h3>
          <div class="list">
            ${state.warrants.slice(0,5).map(w => `
              <div class="item danger-left">
                <div class="row-between">
                  <strong>${esc(w.identity)}</strong>
                  ${pill(w.status,'red')}
                </div>
                <div class="tiny muted">Passaporte: ${esc(w.user_id)} • Oficial: ${esc(w.nidentity)}</div>
                <div class="small pre">${esc(w.reason)}</div>
              </div>
            `).join('') || `<div class="empty">Sem mandados.</div>`}
          </div>
        </div>
      </div>
    </div>
  `;
}

function renderCivilians() {
  const c = state.civilian;

  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Civis</h1>
        <div class="section-sub">Busque por nome, passaporte ou número de celular.</div>
      </div>

      <div class="card">
        <div class="search-row">
          <input class="field" id="civilSearchTerm" placeholder="Ex.: 4, Bryan, 999999999" value="${esc(state.civilSearchTerm || '')}">
          <button class="btn" id="civilSearchBtn">Buscar</button>
        </div>
      </div>

      <div class="card">
        <table class="table">
          <thead>
            <tr>
              <th>Passaporte</th>
              <th>Nome</th>
              <th>Telefone</th>
              <th>Multas</th>
              <th>Mandados</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            ${(state.civilians || []).map(cz => `
              <tr>
                <td>#${esc(cz.passport)}</td>
                <td><strong>${esc(cz.name)}</strong></td>
                <td>${esc(cz.phone)}</td>
                <td>${money(cz.fines || 0)}</td>
                <td>${esc(cz.warrants || 0)}</td>
                <td><button class="btn small-action" data-select-civil="${esc(cz.passport)}">Ver ficha</button></td>
              </tr>
            `).join('') || `<tr><td colspan="6" class="empty">Nenhum cidadão carregado.</td></tr>`}
          </tbody>
        </table>
      </div>

      ${c ? `
        <div class="grid grid-3">
          <div class="card">
            <strong style="font-size:22px">${esc(c.name)}</strong>
            <div class="muted small">Passaporte ${esc(c.passport)} • Telefone ${esc(c.phone)}</div>
            <div class="grid grid-3" style="margin-top:12px">
              <div class="item"><div class="metric">${money(c.fines || 0)}</div><div class="tiny muted">Multas</div></div>
              <div class="item"><div class="metric">${Number(c.warrants || 0)}</div><div class="tiny muted">Mandados</div></div>
              <div class="item"><div class="metric">${Number(c.prison || 0)}</div><div class="tiny muted">Serviços</div></div>
            </div>
          </div>

          <div class="card stack">
            <h3 style="margin:0">Multa rápida</h3>
            <input class="field" id="civilFineValue" placeholder="Valor">
            <textarea class="field" id="civilFineReason" placeholder="Motivo"></textarea>
            <button class="btn" id="civilFineBtn">Multar</button>
          </div>

          <div class="card stack">
            <h3 style="margin:0">Prisão rápida</h3>
            <input class="field" id="civilPrisonServices" placeholder="Serviços (ou deixa vazio para automático)">
            <input class="field" id="civilPrisonFine" placeholder="Multa (ou deixa vazio para automático)">
            <textarea class="field" id="civilPrisonReason" placeholder="Motivo"></textarea>
            ${articlesSelectorHtml('civil')}
            <button class="btn green" id="civilPrisonBtn">Prender</button>
          </div>
        </div>

        ${articlesSelectorHtml('civil')}

        <div class="card">
          <h3 style="margin-top:0">Histórico de prisões</h3>
          <div class="list">
            ${(c.records || []).map(r => `
              <div class="item">
                <div class="row-between">
                  <strong>${esc(r.police)}</strong>
                  <span class="tiny muted">${esc(r.date)}</span>
                </div>
                <div class="small muted">Serviços: ${esc(r.services)} • Multa: $${esc(r.fines)}</div>
                <div class="small pre">${esc(r.text)}</div>
              </div>
            `).join('') || `<div class="empty">Sem registros.</div>`}
          </div>
        </div>

        <div class="card">
          <h3 style="margin-top:0">Portes registrados</h3>
          <div class="list">
            ${(c.ports || []).map(p => `
              <div class="item">
                <div><strong>${esc(p.portType)}</strong></div>
                <div class="tiny muted">Serial: ${esc(p.serial)} • Emissão: ${esc(p.date)}</div>
              </div>
            `).join('') || `<div class="empty">Sem portes.</div>`}
          </div>
        </div>
      ` : ''}
    </div>
  `;
}

function renderReports() {
  content.innerHTML = `
    <div class="stack">
      <div class="row-between">
        <div>
          <h1 class="section-title">Relatórios</h1>
          <div class="section-sub">Boletins e ocorrências.</div>
        </div>
        <button class="btn" id="openReportCreate">Novo relatório</button>
      </div>

      <div class="card">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Vítima</th>
              <th>Oficial</th>
              <th>Status</th>
              <th>Data</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            ${state.reports.map(r => `
              <tr>
                <td>#${r.id}</td>
                <td>
                  <strong>${esc(r.victim_name)}</strong>
                  <div class="tiny muted">Passaporte: ${esc(r.victim_id)}</div>
                  <div class="small pre">${esc(r.victim_report)}</div>
                </td>
                <td>${esc(r.police_name)}</td>
                <td>${pill(isSolved(r.solved) ? 'Resolvido' : 'Pendente', isSolved(r.solved) ? 'green' : 'gold')}</td>
                <td>${esc(r.created_at)}</td>
                <td>
                  ${!isSolved(r.solved) ? `<button class="btn green small-action" data-solve-report="${r.id}">Resolver</button>` : ''}
                  <button class="btn red small-action" data-remove-report="${r.id}">Excluir</button>
                </td>
              </tr>
            `).join('') || `<tr><td colspan="6" class="empty">Sem relatórios.</td></tr>`}
          </tbody>
        </table>
      </div>

      <div class="card hidden" id="reportCreateCard">
        <div class="stack">
          <input class="field" id="reportVictimId" placeholder="Passaporte da vítima">
          <input class="field" id="reportVictimName" placeholder="Nome da vítima">
          <textarea class="field" id="reportText" placeholder="Descreva o ocorrido"></textarea>
          <div class="row">
            <button class="btn" id="saveReportBtn">Salvar relatório</button>
            <button class="btn ghost" id="cancelReportBtn">Cancelar</button>
          </div>
        </div>
      </div>
    </div>
  `;
}

function renderWarrants() {
  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Mandados</h1>
        <div class="section-sub">Cadastro e gerenciamento de mandados.</div>
      </div>

      <div class="card stack">
        <div class="grid grid-3">
          <input class="field" id="warrantPassport" placeholder="Passaporte">
          <input class="field" id="warrantName" placeholder="Nome">
          <button class="btn" id="createWarrantBtn">Adicionar mandado</button>
        </div>
        <textarea class="field" id="warrantReason" placeholder="Motivo do mandado"></textarea>
      </div>

      <div class="card">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Suspeito</th>
              <th>Oficial</th>
              <th>Status</th>
              <th>Data</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            ${state.warrants.map(w => `
              <tr>
                <td>#${w.id}</td>
                <td>
                  <strong>${esc(w.identity)}</strong>
                  <div class="tiny muted">Passaporte: ${esc(w.user_id)}</div>
                  <div class="small pre">${esc(w.reason)}</div>
                </td>
                <td>${esc(w.nidentity)}</td>
                <td>${pill(w.status,'red')}</td>
                <td>${esc(w.timeStamp)}</td>
                <td><button class="btn red small-action" data-remove-warrant="${w.id}">Excluir</button></td>
              </tr>
            `).join('') || `<tr><td colspan="6" class="empty">Sem mandados.</td></tr>`}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderBolo() {
  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">BOLO</h1>
        <div class="section-sub">Feed operacional aproveitando mandados ativos.</div>
      </div>

      ${state.warrants.map(w => `
        <div class="card danger-left">
          <div class="row-between">
            <div>
              <strong style="font-size:20px">${esc(w.identity)}</strong>
              <div class="tiny muted">Passaporte: ${esc(w.user_id)} • Oficial: ${esc(w.nidentity)}</div>
            </div>
            ${pill('Risco alto','red')}
          </div>
          <div class="small pre" style="margin-top:10px">${esc(w.reason)}</div>
          <div class="tiny muted" style="margin-top:10px">${esc(w.timeStamp)}</div>
        </div>
      `).join('') || `<div class="card empty">Nenhum BOLO ativo.</div>`}
    </div>
  `;
}

function renderVehicles() {
  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Veículos</h1>
        <div class="section-sub">Busca por placa ou passaporte do proprietário.</div>
      </div>

      <div class="card">
        <div class="search-row">
          <input class="field" id="vehicleSearchTerm" placeholder="Ex.: ABC1234 ou passaporte 4" value="${esc(state.vehicleSearchTerm)}">
          <button class="btn" id="vehicleSearchBtn">Buscar</button>
        </div>
      </div>

      <div class="card">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Placa</th>
              <th>Modelo</th>
              <th>Proprietário</th>
              <th>Status</th>
              <th>Taxa</th>
              <th>Aluguel</th>
            </tr>
          </thead>
          <tbody>
            ${state.vehicles.map(v => `
              <tr>
                <td>#${esc(v.id)}</td>
                <td><strong>${esc(v.plate)}</strong><div class="tiny muted">Passaporte: ${esc(v.passport)}</div></td>
                <td>${esc(v.model)}</td>
                <td><strong>${esc(v.owner)}</strong><div class="tiny muted">Telefone: ${esc(v.ownerPhone || 'Sem telefone')}</div></td>
                <td>${pill(v.status, statusCls(v.status))}</td>
                <td>${fmtUnix(v.tax)}</td>
                <td>${fmtUnix(v.rental)}</td>
              </tr>
            `).join('') || `<tr><td colspan="7" class="empty">Nenhum veículo carregado.</td></tr>`}
          </tbody>
        </table>
      </div>

      <div class="grid grid-3">
        <div class="card"><div class="muted">Encontrados</div><div class="metric">${state.vehicles.length}</div></div>
        <div class="card"><div class="muted">Regular</div><div class="metric">${state.vehicles.filter(v => v.status === 'Regular').length}</div></div>
        <div class="card"><div class="muted">Apreendido</div><div class="metric">${state.vehicles.filter(v => v.status === 'Apreendido').length}</div></div>
      </div>
    </div>
  `;
}

function renderPenal() {
  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Código Penal</h1>
        <div class="section-sub">Consulta e gerenciamento de artigos.</div>
      </div>

      ${state.officer.isSuperior ? `
        <div class="card stack">
          <div class="row-between">
            <h3 style="margin:0">Gerenciar Artigos</h3>
            ${pill('Comando Geral', 'red')}
          </div>

          <div class="grid grid-2">
            <input class="field" id="articleTitle" placeholder="Título do artigo" value="${esc(state.articleForm.title)}">
            <input class="field" id="articleFine" placeholder="Multa" value="${esc(state.articleForm.fine)}">
          </div>

          <div class="grid grid-2">
            <input class="field" id="articleServices" placeholder="Serviços" value="${esc(state.articleForm.services)}">
            <div class="item">
              <div class="tiny muted">ID em edição</div>
              <div><strong>${state.articleForm.id ? `#${esc(state.articleForm.id)}` : 'Novo artigo'}</strong></div>
            </div>
          </div>

          <textarea class="field" id="articleDescription" placeholder="Descrição">${esc(state.articleForm.description)}</textarea>

          <div class="row">
            <button class="btn" id="saveArticleBtn">${state.articleForm.id ? 'Salvar edição' : 'Adicionar artigo'}</button>
            <button class="btn ghost" id="clearArticleFormBtn">Limpar</button>
          </div>
        </div>
      ` : ''}

      <div class="card">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Artigo</th>
              <th>Multa</th>
              <th>Serviços</th>
              ${state.officer.isSuperior ? '<th></th>' : ''}
            </tr>
          </thead>
          <tbody>
            ${state.penalArticles.map(article => `
              <tr>
                <td>#${esc(article.id)}</td>
                <td>
                  <strong>${esc(article.title)}</strong>
                  <div class="small pre">${esc(article.description || '')}</div>
                </td>
                <td>${money(article.fine || 0)}</td>
                <td>${esc(article.services || 0)}</td>
                ${state.officer.isSuperior ? `
                  <td>
                    <button class="btn small-action" data-edit-article="${article.id}">Editar</button>
                    <button class="btn red small-action" data-delete-article="${article.id}">Apagar</button>
                  </td>
                ` : ''}
              </tr>
            `).join('') || `<tr><td colspan="${state.officer.isSuperior ? '5' : '4'}" class="empty">Nenhum artigo cadastrado.</td></tr>`}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderDepartment() {
  const latestReports = state.reports.slice(0, 5);
  const latestWarrants = state.warrants.slice(0, 5);

  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Departamento</h1>
        <div class="section-sub">Resumo institucional com atividade recente da unidade.</div>
      </div>

      <div class="grid grid-4">
        <div class="card"><div class="muted">Unidade</div><div class="metric" style="font-size:22px">${esc(state.officer.unit)}</div></div>
        <div class="card"><div class="muted">Badge</div><div class="metric">${esc(state.officer.badge)}</div></div>
        <div class="card"><div class="muted">Patente</div><div class="metric" style="font-size:22px">${esc(state.officer.rank)}</div></div>
        <div class="card"><div class="muted">Status</div><div class="metric">${esc(state.officer.status || '10-8')}</div></div>
      </div>

      <div class="grid grid-2">
        <div class="card">
          <h3 style="margin-top:0">Relatórios recentes</h3>
          <div class="list">
            ${latestReports.map(r => `
              <div class="item">
                <div class="row-between">
                  <strong>${esc(r.victim_name || 'Sem nome')}</strong>
                  ${pill(isSolved(r.solved) ? 'Resolvido' : 'Pendente', isSolved(r.solved) ? 'green' : 'gold')}
                </div>
                <div class="tiny muted">Oficial: ${esc(r.police_name)} • ${esc(r.created_at)}</div>
                <div class="small pre">${esc(r.victim_report)}</div>
              </div>
            `).join('') || `<div class="empty">Nenhum relatório lançado ainda.</div>`}
          </div>
        </div>

        <div class="card">
          <h3 style="margin-top:0">Mandados recentes</h3>
          <div class="list">
            ${latestWarrants.map(w => `
              <div class="item danger-left">
                <div class="row-between">
                  <strong>${esc(w.identity)}</strong>
                  ${pill(w.status || 'Procurado', w.status === 'Preso' ? 'green' : 'red')}
                </div>
                <div class="tiny muted">Passaporte: ${esc(w.user_id)} • Oficial: ${esc(w.nidentity)}</div>
                <div class="small pre">${esc(w.reason)}</div>
              </div>
            `).join('') || `<div class="empty">Nenhum mandado registrado.</div>`}
          </div>
        </div>
      </div>
    </div>
  `;
}

function renderAdmin() {
  const solved = state.reports.filter(r => isSolved(r.solved)).length;
  const pending = state.reports.length - solved;
  const arrestedWarrants = state.warrants.filter(w => (w.status || '').toLowerCase() === 'preso').length;

  content.innerHTML = `
    <div class="stack">
      <div>
        <h1 class="section-title">Administração</h1>
        <div class="section-sub">Visão resumida para superiores.</div>
      </div>

      <div class="grid grid-4">
        <div class="card"><div class="muted">Oficial</div><div class="metric" style="font-size:22px">${esc(state.officer.name)}</div></div>
        <div class="card"><div class="muted">Relatórios</div><div class="metric">${state.reports.length}</div><div class="tiny muted">Pendentes: ${pending}</div></div>
        <div class="card"><div class="muted">Resolvidos</div><div class="metric">${solved}</div></div>
        <div class="card"><div class="muted">Mandados</div><div class="metric">${state.warrants.length}</div><div class="tiny muted">Presos: ${arrestedWarrants}</div></div>
      </div>

      <div class="grid grid-2">
        <div class="card">
          <h3 style="margin-top:0">Pendências</h3>
          <div class="list">
            ${state.reports.filter(r => !isSolved(r.solved)).slice(0,5).map(r => `
              <div class="item">
                <div class="row-between">
                  <strong>${esc(r.victim_name || 'Sem nome')}</strong>
                  ${pill('Pendente','gold')}
                </div>
                <div class="tiny muted">${esc(r.created_at)}</div>
                <div class="small pre">${esc(r.victim_report)}</div>
              </div>
            `).join('') || `<div class="empty">Nada pendente.</div>`}
          </div>
        </div>

        <div class="card">
          <h3 style="margin-top:0">Mandados ativos</h3>
          <div class="list">
            ${state.warrants.filter(w => (w.status || '').toLowerCase() !== 'preso').slice(0,5).map(w => `
              <div class="item danger-left">
                <div class="row-between">
                  <strong>${esc(w.identity)}</strong>
                  ${pill(w.status || 'Procurado','red')}
                </div>
                <div class="tiny muted">Passaporte: ${esc(w.user_id)}</div>
                <div class="small pre">${esc(w.reason)}</div>
              </div>
            `).join('') || `<div class="empty">Nenhum mandado ativo.</div>`}
          </div>
        </div>
      </div>
    </div>
  `;
}

async function closeMdt() {
  app.classList.add('hidden');
  state.visible = false;
  await nui('closeSystem');
}

window.addEventListener('message', async (event) => {
  if (!event.data || !event.data.action) return;

  if (event.data.action === 'openSystem' || event.data.action === 'open') {
    app.classList.remove('hidden');
    state.visible = true;
    await refreshData();
  }

  if (event.data.action === 'closeSystem' || event.data.action === 'close') {
    app.classList.add('hidden');
    state.visible = false;
  }

  if (['reloadProcurados', 'reloadFine', 'reloadPrison', 'reloadPortes'].includes(event.data.action)) {
    await refreshData();
  }
});

document.addEventListener('click', async (e) => {
  const t = e.target.closest('button,[data-nav],[data-solve-report],[data-remove-report],[data-remove-warrant],[data-select-civil],[data-toggle-article],[data-toggle-article-dropdown],[data-edit-article],[data-delete-article]');
  
  if (!t) return;

  if (t.id === 'closeBtn') return closeMdt();
  if (t.id === 'refreshBtn') return refreshData();

  if (t.dataset.nav) {
    state.active = t.dataset.nav;
    return render();
  }

  if (t.dataset.toggleArticleDropdown) {
    const dropdown = document.getElementById(`articleDropdown-${t.dataset.toggleArticleDropdown}`);
    if (dropdown) {
      dropdown.classList.toggle('hidden');
    }
    return;
  }

  if (t.dataset.toggleArticle) {
    toggleArticle(t.dataset.toggleArticle);
    return;
  }

  if (t.dataset.editArticle) {
    fillArticleForm(t.dataset.editArticle);
    return;
  }

  if (t.dataset.deleteArticle) {
    const response = await nui('deletePenalArticle', { id: Number(t.dataset.deleteArticle) });
    if (response?.success !== false) {
      await loadPenalArticles();
      clearArticleForm();
    }
    return render();
  }

  if (t.id === 'clearArticleFormBtn') {
    clearArticleForm();
    return;
  }

  if (t.id === 'saveArticleBtn') {
    const payload = {
      id: state.articleForm.id ? Number(state.articleForm.id) : null,
      title: document.getElementById('articleTitle')?.value || '',
      description: document.getElementById('articleDescription')?.value || '',
      fine: Number(document.getElementById('articleFine')?.value || 0),
      services: Number(document.getElementById('articleServices')?.value || 0)
    };

    const route = payload.id ? 'updatePenalArticle' : 'createPenalArticle';
    const response = await nui(route, payload);

    if (response?.success !== false) {
      await loadPenalArticles();
      state.articleForm = { id: null, title: '', description: '', fine: '', services: '' };
    }

    return render();
  }

  if (t.id === 'issueFineBtn') {
    await nui('initFine', {
      passaporte: Number(document.getElementById('finePassport').value),
      multas: Number(document.getElementById('fineValue').value),
      texto: document.getElementById('fineReason').value,
      cnh: 0
    });
    return refreshData();
  }

  if (t.id === 'issuePrisonBtn') {
    if (!state.selectedArticles.length) {
      return alert('Selecione pelo menos 1 artigo.');
    }

    await nui('initPrison', {
      passaporte: Number(document.getElementById('prisonPassport').value),
      servicos: Number(document.getElementById('prisonServices').value || 0),
      multas: Number(document.getElementById('prisonFine').value || 0),
      texto: document.getElementById('prisonReason').value,
      associacao: 'Não informado',
      material: 'Não',
      url: '',
      militares: '',
      articles: state.selectedArticles
    });

    state.selectedArticles = [];
    return refreshData();
  }

  if (t.id === 'civilSearchBtn') {
    state.civilSearchTerm = document.getElementById('civilSearchTerm').value || '';
    const data = await nui('searchUser', { term: state.civilSearchTerm, passaporte: state.civilSearchTerm });
    const result = data.result || {};
    state.civilians = Array.isArray(result.results) ? result.results : [];
    state.civilian = state.civilians[0] || null;
    return render();
  }

  if (t.dataset.selectCivil) {
    state.civilian = (state.civilians || []).find(c => String(c.passport) === String(t.dataset.selectCivil)) || null;
    return render();
  }

  if (t.id === 'vehicleSearchBtn') {
    state.vehicleSearchTerm = document.getElementById('vehicleSearchTerm').value || '';
    const data = await nui('searchVehicles', { term: state.vehicleSearchTerm });
    state.vehicles = data.vehicles || [];
    return render();
  }

  if (t.id === 'civilFineBtn') {
    await nui('initFine', {
      passaporte: Number(state.civilian.passport),
      multas: Number(document.getElementById('civilFineValue').value),
      texto: document.getElementById('civilFineReason').value,
      cnh: 0
    });
    return refreshData();
  }

  if (t.id === 'civilPrisonBtn') {
    if (!state.selectedArticles.length) {
      return alert('Selecione pelo menos 1 artigo.');
    }

    await nui('initPrison', {
      passaporte: Number(state.civilian.passport),
      servicos: Number(document.getElementById('civilPrisonServices').value || 0),
      multas: Number(document.getElementById('civilPrisonFine').value || 0),
      texto: document.getElementById('civilPrisonReason').value,
      associacao: 'Não informado',
      material: 'Não',
      url: '',
      militares: '',
      articles: state.selectedArticles
    });

    state.selectedArticles = [];
    return refreshData();
  }

  if (t.id === 'openReportCreate') {
    document.getElementById('reportCreateCard').classList.remove('hidden');
    return;
  }

  if (t.id === 'cancelReportBtn') {
    document.getElementById('reportCreateCard').classList.add('hidden');
    return;
  }

  if (t.id === 'saveReportBtn') {
    await nui('addReport', {
      victim_id: document.getElementById('reportVictimId').value,
      victim_name: document.getElementById('reportVictimName').value,
      victim_report: document.getElementById('reportText').value
    });
    return refreshData();
  }

  if (t.dataset.solveReport) {
    await nui('setReportSolved', { id: Number(t.dataset.solveReport) });
    return refreshData();
  }

  if (t.dataset.removeReport) {
    await nui('setReportRemoved', { id: Number(t.dataset.removeReport) });
    return refreshData();
  }

  if (t.id === 'createWarrantBtn') {
    await nui('setWarrant', {
      passaporte: Number(document.getElementById('warrantPassport').value),
      nome: document.getElementById('warrantName').value,
      texto: document.getElementById('warrantReason').value
    });
    return refreshData();
  }

  if (t.dataset.removeWarrant) {
    await nui('deleteWarrant', { excluirpro: Number(t.dataset.removeWarrant) });
    return refreshData();
  }
});

document.addEventListener('input', (e) => {
  if (e.target.id === 'articleTitle') state.articleForm.title = e.target.value;
  if (e.target.id === 'articleDescription') state.articleForm.description = e.target.value;
  if (e.target.id === 'articleFine') state.articleForm.fine = e.target.value;
  if (e.target.id === 'articleServices') state.articleForm.services = e.target.value;
});

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape' && state.visible) closeMdt();
});

document.getElementById('closeBtn').addEventListener('click', closeMdt);
document.getElementById('refreshBtn').addEventListener('click', refreshData);
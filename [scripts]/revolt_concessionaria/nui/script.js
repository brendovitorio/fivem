
const resourceName = typeof GetParentResourceName === "function" ? GetParentResourceName() : "revolt_concessionaria";

const state = {
  config: {},
  vehList: [],
  myVehicles: [],
  topVehicles: [],
  selectedTab: "store",
  filtered: [],
  selectedVehicle: null,
  discount: 0,
  timerInterval: null
};

const app = document.getElementById("app");
const adminApp = document.getElementById("adminApp");
const grid = document.getElementById("vehicleGrid");
const emptyState = document.getElementById("emptyState");
const heroTitle = document.getElementById("heroTitle");
const heroSubtitle = document.getElementById("heroSubtitle");
const image = document.getElementById("vehicleImage");
const vehiclePrice = document.getElementById("vehiclePrice");
const vehicleModel = document.getElementById("vehicleModel");
const vehicleDesc = document.getElementById("vehicleDesc");
const chipClass = document.getElementById("chipClass");
const chipStock = document.getElementById("chipStock");
const chipCapacity = document.getElementById("chipCapacity");
const classFilter = document.getElementById("classFilter");
const searchInput = document.getElementById("searchInput");
const colorInput = document.getElementById("colorInput");
const buyBtn = document.getElementById("buyBtn");
const rentBtn = document.getElementById("rentBtn");
const testBtn = document.getElementById("testBtn");
const sellBtn = document.getElementById("sellBtn");
const timerBox = document.getElementById("timerBox");
const timerText = document.getElementById("timer");
const discountBadge = document.getElementById("discountBadge");

const fmtMoney = (value) => {
  const number = Number(value || 0);
  return "$ " + number.toLocaleString("pt-BR");
};

function post(name, data = {}) {
  return fetch(`https://${resourceName}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(data)
  }).then((r) => r.json()).catch(() => ({}));
}

function getVehicleImage(vehicle) {
  if (!vehicle) return "";
  const key = vehicle.vehicle || vehicle.name || "";
  const base = state.config.imgDir || "";
  const fallback = state.config.defaultImg || "";
  if (!base) return fallback;
  return `${base}${key}.png`;
}

function safeText(value, fallback = "Não informado") {
  return value === undefined || value === null || value === "" ? fallback : String(value);
}

function currentSourceList() {
  if (state.selectedTab === "owned") return state.myVehicles || [];
  if (state.selectedTab === "top") return state.topVehicles || [];
  return state.vehList || [];
}

function buildClassOptions() {
  const all = new Set();
  [state.vehList, state.myVehicles, state.topVehicles].flat().forEach((veh) => {
    if (veh && veh.class) all.add(veh.class);
  });
  classFilter.innerHTML = '<option value="all">Todas</option>';
  [...all].sort().forEach((cls) => {
    const option = document.createElement("option");
    option.value = cls;
    option.textContent = cls;
    classFilter.appendChild(option);
  });
}

function applyFilters() {
  const search = searchInput.value.trim().toLowerCase();
  const klass = classFilter.value;
  const list = currentSourceList();
  state.filtered = list.filter((veh) => {
    const hay = `${safeText(veh.modelo, "")} ${safeText(veh.vehicle, "")} ${safeText(veh.name, "")}`.toLowerCase();
    const matchSearch = !search || hay.includes(search);
    const matchClass = klass === "all" || veh.class === klass;
    return matchSearch && matchClass;
  });
  if (!state.selectedVehicle || !state.filtered.find((v) => (v.vehicle || v.name) === (state.selectedVehicle.vehicle || state.selectedVehicle.name))) {
    state.selectedVehicle = state.filtered[0] || null;
  }
  renderGrid();
  renderDetails();
}

function renderGrid() {
  grid.innerHTML = "";
  emptyState.classList.toggle("hidden", state.filtered.length !== 0);
  state.filtered.forEach((veh) => {
    const key = veh.vehicle || veh.name;
    const card = document.createElement("button");
    card.className = "vehicle-card" + ((state.selectedVehicle && (state.selectedVehicle.vehicle || state.selectedVehicle.name) === key) ? " active" : "");
    card.innerHTML = `
      <img src="${getVehicleImage(veh)}" onerror="this.src='${state.config.defaultImg || ""}'" alt="${safeText(veh.modelo)}" />
      <div class="row-between">
        <h4>${safeText(veh.modelo)}</h4>
        <span class="chip">${safeText(veh.class, "classe")}</span>
      </div>
      <div class="muted">spawn: ${safeText(veh.vehicle || veh.name)}</div>
      <div class="muted">estoque: ${safeText(veh.estoque, "-")}</div>
      <div class="price">${fmtMoney(veh.price)}</div>
    `;
    card.addEventListener("click", () => {
      state.selectedVehicle = veh;
      renderGrid();
      renderDetails();
    });
    grid.appendChild(card);
  });
}

function renderDetails() {
  const veh = state.selectedVehicle;
  const owned = state.selectedTab === "owned";
  sellBtn.classList.toggle("hidden", !owned);
  buyBtn.classList.toggle("hidden", owned);
  rentBtn.classList.toggle("hidden", owned);
  testBtn.classList.toggle("hidden", owned);

  if (!veh) {
    heroTitle.textContent = "Nenhum veículo selecionado";
    heroSubtitle.textContent = "Refine a busca ou troque a aba.";
    image.src = state.config.defaultImg || "";
    vehiclePrice.textContent = "$ 0";
    vehicleModel.textContent = "modelo";
    chipClass.textContent = "classe";
    chipStock.textContent = "estoque";
    chipCapacity.textContent = "porta-malas";
    vehicleDesc.textContent = "Nenhum veículo carregado.";
    return;
  }

  heroTitle.textContent = safeText(veh.modelo);
  heroSubtitle.textContent = `Spawn: ${safeText(veh.vehicle || veh.name)} • Classe: ${safeText(veh.class)}`;
  image.src = getVehicleImage(veh);
  image.onerror = function() { this.src = state.config.defaultImg || ""; };
  vehiclePrice.textContent = fmtMoney(veh.price);
  vehicleModel.textContent = safeText(veh.vehicle || veh.name);
  chipClass.textContent = safeText(veh.class, "sem classe");
  chipStock.textContent = `Estoque: ${safeText(veh.estoque, "-")}`;
  chipCapacity.textContent = `Porta-malas: ${safeText(veh.capacidade, "-")}`;
  vehicleDesc.textContent = owned
    ? "Este veículo já pertence a você. Use vender se quiser retornar parte do valor."
    : "Compre, alugue ou faça test drive. A cor deve ser informada em RGB, por exemplo: 255,255,255.";
}

async function refreshVehicles() {
  const res = await post("updateVehicles");
  if (res && res.vehList) {
    state.vehList = res.vehList || [];
    state.topVehicles = res.topVehicles || [];
    state.myVehicles = res.myVehicles || [];
    buildClassOptions();
    applyFilters();
  }
}

async function runAction(action) {
  const veh = state.selectedVehicle;
  if (!veh) return;
  const vehicle = veh.vehicle || veh.name;
  if (!vehicle) return;

  if (action === "buy") {
    await post("buy-vehicle", { vehicle, color: colorInput.value || "255,255,255" });
    refreshVehicles();
    return;
  }

  if (action === "sell") {
    await post("sell-vehicle", { vehicle });
    refreshVehicles();
    return;
  }

  if (action === "rent") {
    const tryRent = await post("try-rent", { vehicle });
    if (tryRent && tryRent.state) {
      const pay = await post("pay-rent", { vehicle });
      if (pay && pay.state) refreshVehicles();
    }
    return;
  }

  if (action === "test") {
    const tryTest = await post("try-test", { vehicle });
    if (tryTest && tryTest.state) {
      const pay = await post("pay-test", { vehicle });
      if (pay && pay.state) {
        await post("test-drive", { vehicle, price: pay.price || 0 });
      }
    }
  }
}

function setTab(tab) {
  state.selectedTab = tab;
  document.querySelectorAll(".tab-btn").forEach((el) => el.classList.toggle("active", el.dataset.tab === tab));
  applyFilters();
}

function show(payload) {
  state.config = payload.config || {};
  state.vehList = payload.vehList || [];
  state.topVehicles = payload.topVehicles || [];
  state.myVehicles = payload.myVehicles || [];
  app.classList.remove("hidden");
  adminApp.classList.add("hidden");
  discountBadge.textContent = `Desconto ativo: ${state.config.discount || 0}%`;
  buildClassOptions();
  setTab("store");
}

function hide() {
  app.classList.add("hidden");
}

function showAdmin() {
  adminApp.classList.remove("hidden");
}

function hideAdmin() {
  adminApp.classList.add("hidden");
}

function startTimer(seconds) {
  clearInterval(state.timerInterval);
  let remaining = Number(seconds || 0);
  timerBox.classList.remove("hidden");

  const update = () => {
    const mins = String(Math.floor(remaining / 60)).padStart(2, "0");
    const secs = String(remaining % 60).padStart(2, "0");
    timerText.textContent = `${mins}:${secs}`;
    if (remaining <= 0) {
      clearInterval(state.timerInterval);
      timerBox.classList.add("hidden");
    }
    remaining -= 1;
  };

  update();
  state.timerInterval = setInterval(update, 1000);
}

function stopTimer() {
  clearInterval(state.timerInterval);
  timerBox.classList.add("hidden");
}

window.addEventListener("message", (event) => {
  const data = event.data || {};
  if (data.action === "show") show(data);
  else if (data.action === "hide") hide();
  else if (data.action === "showAdmin") showAdmin();
  else if (data.action === "hideAdmin") hideAdmin();
  else if (data.action === "showTimer") startTimer(data.time);
  else if (data.action === "stopTimer") stopTimer();
});

document.getElementById("closeBtn").addEventListener("click", () => post("close"));
document.getElementById("adminClose").addEventListener("click", () => post("close"));
document.getElementById("endTestBtn").addEventListener("click", () => post("end-test"));

buyBtn.addEventListener("click", () => runAction("buy"));
rentBtn.addEventListener("click", () => runAction("rent"));
testBtn.addEventListener("click", () => runAction("test"));
sellBtn.addEventListener("click", () => runAction("sell"));

searchInput.addEventListener("input", applyFilters);
classFilter.addEventListener("change", applyFilters);

document.querySelectorAll(".tab-btn").forEach((btn) => {
  btn.addEventListener("click", () => setTab(btn.dataset.tab));
});

document.querySelectorAll("[data-admin]").forEach((btn) => {
  btn.addEventListener("click", () => {
    const mode = btn.dataset.admin;
    const vehicle = document.getElementById("adminVehicle").value.trim();
    const qtd = document.getElementById("adminQtd").value.trim();
    post("manageConce", { mode, vehicle, qtd });
  });
});

document.addEventListener("keyup", (e) => {
  if (e.key === "Escape") post("close");
});

window.classInstances = {};
globalThis.SelectedItem = {};
window.imageUrl = 'http://127.0.0.1/inventory/item';

window.normalizeItemKey = function (item) {
  if (!item) return '';
  const raw = String(item);
  const base = raw.split('-')[0];
  return base.toLowerCase();
};

window.getItemImageKey = function (itemData) {
  if (!itemData) return '';
  const direct = window.normalizeItemKey(itemData.png || itemData.index || itemData.baseItem || itemData.item);
  if (direct) return direct;
  const cfg = (globalThis.Config || {})[itemData.item] || (globalThis.Config || {})[window.normalizeItemKey(itemData.item)] || (globalThis.Config || {})[itemData.baseItem] || (globalThis.Config || {})[window.normalizeItemKey(itemData.baseItem)];
  return window.normalizeItemKey(cfg?.png || cfg?.index || itemData.baseItem || itemData.item);
};

window.getItemImageSrc = function (itemData) {
  const key = window.getItemImageKey(itemData);
  return `${window.imageUrl}/${key}.png`;
};

window.isOnline = true;

window.addEventListener('online', () => {
  window.isOnline = true;
  $('#app').removeClass('offline');
});

window.addEventListener('offline', () => {
  window.isOnline = false;
  $('#app').addClass('offline');
});

const Routes = {
  OPEN_INVENTORY: async (payload) => {
    const userInventory = await Client('GET_INVENTORY');
    window.classInstances.weapons = new Weapons(await Client('GET_WEAPONS'));
    window.classInstances.left = new Inventory(userInventory);
    const pickupData = await Client('GET_PICKUPS');
    if (pickupData.inventory && Object.keys(pickupData.inventory).length > 0) {
      window.classInstances.right = new Pickup(pickupData);
      $('#app').addClass('secondary-open');
    } else {
      $('.inventory.secondary').css('display', 'none');
      $('#app').removeClass('secondary-open');
    }
    $('body').css('display', 'flex').show();
    $('#app').css('display', 'flex').show();
    setTimeout(function () {
      setupSearchHighlight('.inventory.primary');
      setupSearchHighlight('.inventory.secondary');
    }, 50);
  },
  UPDATE_PICKUP: async (payload) => {
    if (window.classInstances?.right?.pickup) {
      const pickupData = await Client('GET_PICKUPS');
      window.classInstances.right = new Pickup(pickupData);
    }
  },
  OPEN_CHEST: async (payload) => {
    const userInventory = await Client('GET_INVENTORY');
    window.classInstances.left = new Inventory(userInventory);
    window.classInstances.right = new Chest(payload);
    $('#app').addClass('secondary-open');
    $('body').css('display', 'flex').show();
    $('#app').css('display', 'flex').show();
    setTimeout(function () {
      setupSearchHighlight('.inventory.primary');
      setupSearchHighlight('.inventory.secondary');
    }, 50);
  },
  CLOSE_INVENTORY: async (payload) => {
    const ignoreRight = payload.ignoreRight || false;
    Client('CLOSE_INVENTORY', {
      right:
        ignoreRight ||
        (window.classInstances.hasOwnProperty('right') &&
          !window.classInstances?.right?.pickup),
    });
    window.classInstances = {};
    $('#app').removeClass('secondary-open').hide();
    $('body').hide();
  },
  OPEN_INSPECT: async (payload) => {
    window.classInstances.left = new Inventory(payload.source);
    window.classInstances.right = new Inspect(payload.target);
    $('#app').addClass('secondary-open');
    $('body').css('display', 'flex').show();
    $('#app').css('display', 'flex').show();
    setTimeout(function () {
      setupSearchHighlight('.inventory.primary');
      setupSearchHighlight('.inventory.secondary');
    }, 50);
  },
  OPEN_SHOP: async (payload) => {
    const userInventory = await Client('GET_INVENTORY');
    window.classInstances.left = new Inventory(userInventory);
    window.classInstances.right = new Shop(payload);
    $('#app').addClass('secondary-open');
    $('body').css('display', 'flex').show();
    $('#app').css('display', 'flex').show();
    setTimeout(function () {
      setupSearchHighlight('.inventory.primary');
      setupSearchHighlight('.inventory.secondary');
    }, 50);
  },
  FORCE_UPDATE_INVENTORY: async (payload) => {
    if (window.classInstances.left && $('#app').is(':visible')) {
      const userInventory = await Client('GET_INVENTORY');
      window.classInstances.left = new Inventory(userInventory);
    }
  },
};

$(() => {
  window.addEventListener('message', async ({ data }) => {
    const { route, payload = {} } = data;
    if (!globalThis.Config) {
      globalThis.Config = await Client('REQUEST_ITEMS_CONFIG');
    }
    if (Routes[route]) {
      try {
        await Routes[route](payload);
      } catch (err) {}
    }
  });

  document.addEventListener('keydown', ({ key }) => {
    if (key === 'Escape') {
      const qModal = document.getElementById('quantity-modal');
      const qBackdrop = document.getElementById('quantity-modal-backdrop');
      if (qModal && qModal.getAttribute('aria-hidden') === 'false') {
        qModal.setAttribute('aria-hidden', 'true');
        if (qBackdrop) qBackdrop.setAttribute('aria-hidden', 'true');
        return;
      }
      Client('CLOSE_INVENTORY', {
        right: window.classInstances.hasOwnProperty('right'),
      });
      window.classInstances = {};
      $('#app').removeClass('secondary-open').hide();
      $('body').hide();
    }
  });
});

function Close() {
  Client('CLOSE_INVENTORY', {
    right: window.classInstances.hasOwnProperty('right'),
  });
  window.classInstances = {};
  $('#app').hide();
  $('body').hide();
}

const ACTION_ROUTES = {
  Usar: 'USE_ITEM',
  Enviar: 'SEND_ITEM',
  Excluir: 'DROP_ITEM',
};

function getAmountInput() {
  return $('#quantity-modal .item .amount input');
}
window.getAmountInput = getAmountInput;

function openQuantityModal(itemData, maxAmount, onConfirm, selectAll = false) {
  const modal = document.getElementById('quantity-modal');
  if (!modal) return;
  const itemAmountEl = modal.querySelector('.item-infos .item-amount');
  const itemImageEl = modal.querySelector('.item-infos .item-image');
  const itemWeightEl = modal.querySelector('.item-infos .item-weight');
  const inputEl = modal.querySelector('.item .amount input');
  const buttonsContainer = modal.querySelector('.buttons');
  const btnHalf = buttonsContainer?.querySelector('button:nth-child(1)');
  const btnQuarter = buttonsContainer?.querySelector('button:nth-child(2)');
  const btnAll = buttonsContainer?.querySelector('button:nth-child(3)');
  const btnCancel = modal.querySelector('.actions button:first-child');
  const btnConfirm = modal.querySelector('.actions button:last-child');

  const max = Math.max(1, Number(maxAmount) || 1);
  const defaultValue = selectAll ? max : Math.max(1, Math.floor(max / 2));
  const itemName =
    itemData.name ||
    globalThis.Config?.[itemData.item]?.name ||
    globalThis.Config?.[itemData.baseItem]?.name ||
    itemData.item ||
    'Item';
  const itemWeight =
    (itemData.weight != null ? Number(itemData.weight).toFixed(1) : '0') + 'kg';

  if (itemAmountEl) itemAmountEl.textContent = max + 'x';
  if (itemImageEl) {
    itemImageEl.src = window.getItemImageSrc(itemData);
    itemImageEl.alt = itemName;
    itemImageEl.onerror = function () {
      this.onerror = null;
      this.src =
        'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
    };
  }
  if (itemWeightEl) itemWeightEl.textContent = itemWeight;
  inputEl.min = 1;
  inputEl.max = max;
  inputEl.value = defaultValue;

  function setSelectedButton(selectedBtn) {
    buttonsContainer
      ?.querySelectorAll('button')
      .forEach((b) => b.classList.remove('selected'));
    selectedBtn?.classList.add('selected');
  }

  const backdrop = document.getElementById('quantity-modal-backdrop');
  function closeModal() {
    modal.setAttribute('aria-hidden', 'true');
    if (backdrop) backdrop.setAttribute('aria-hidden', 'true');
  }

  function confirm() {
    let val = parseInt(inputEl.value, 10);
    if (isNaN(val) || val < 1) val = 1;
    if (val > max) val = max;
    closeModal();
    onConfirm(val);
  }

  setSelectedButton(selectAll ? btnAll : btnHalf);

  btnHalf.onclick = function () {
    const v = Math.max(1, Math.floor(max / 2));
    inputEl.value = v;
    setSelectedButton(btnHalf);
  };
  btnQuarter.onclick = function () {
    const v = Math.max(1, Math.floor(max / 4));
    inputEl.value = v;
    setSelectedButton(btnQuarter);
  };
  btnAll.onclick = function () {
    inputEl.value = max;
    setSelectedButton(btnAll);
  };
  btnCancel.onclick = closeModal;
  btnConfirm.onclick = confirm;

  if (backdrop) backdrop.setAttribute('aria-hidden', 'false');
  modal.setAttribute('aria-hidden', 'false');
}

window.openQuantityModal = openQuantityModal;

async function runActionWithAmount(action, slotId, itemKey, amount) {
  const response = await Client(action, {
    slot: slotId,
    item: itemKey,
    amount: amount,
  });
  if (typeof response !== 'boolean' && response?.error) {
    Notify(response.error, 'error');
    return;
  }
  if (!response) return;
  window.classInstances.left.removeItem(
    slotId,
    response?.used_amount || amount
  );
  if (
    action === 'USE_ITEM' &&
    ((globalThis.Config[itemKey] || globalThis.Config[window.normalizeItemKey(itemKey)])?.type === 'equip' ||
      (globalThis.Config[itemKey] || globalThis.Config[window.normalizeItemKey(itemKey)])?.type === 'recharge')
  ) {
    window.classInstances.weapons = new Weapons(await Client('GET_WEAPONS'));
  }
}
window.runActionWithAmount = runActionWithAmount;

$(document).on('click', '#app .actions .action', function () {
  const actionLabel = $(this).find('h3').text().trim();
  const action = ACTION_ROUTES[actionLabel];
  if (!action) return;

  if (!globalThis.isOnline) {
    Notify('Sem conexão com a internet!', 'error');
    return;
  }
  if (!globalThis.SelectedItem || globalThis.SelectedItem.side !== 'left')
    return Notify('Selecione um item do seu inventário primeiro!', 'error');
  let { item, id, amount, name, weight } = globalThis.SelectedItem;
  if (!window.classInstances.left.items[id]) {
    id = window.classInstances.left.findSlotByItem(item);
    if (!id)
      return Notify('Selecione um item do seu inventário primeiro!', 'error');
  }
  const itemData = window.classInstances.left.items[id];
  const maxAmount = itemData ? itemData.amount : amount;
  openQuantityModal(
    {
      item: item,
      name: name || itemData?.name,
      weight: itemData?.weight ?? weight,
    },
    maxAmount,
    function (inputValue) {
      runActionWithAmount(action, id, item, inputValue);
    }
  );
});

$(document).on('click', '.item.slot-left', function () {
  if (window.classInstances.left)
    window.classInstances.left.selectItem('left', $(this).data('id'));
});

$(document).on('click', '.item.slot-right', function () {
  if (window.classInstances.right)
    window.classInstances.right.selectItem('right', $(this).data('id'));
});

$(document).on('click', '#app .store', function () {
  openStore();
});

function setupSearchHighlight(containerSelector) {
  const $container = $(containerSelector);
  if (!$container.length) return;
  const $input = $container.find(".search input[type='text']");
  if (!$input.length) return;
  $input.off('input.searchHighlight').on('input.searchHighlight', function () {
    const $inventory = $(this).closest('.inventory');
    const $itemsContainer = $inventory.find('.items').first();
    if (!$itemsContainer.length) return;
    const q = $(this).val().trim().toLowerCase();
    $itemsContainer.find('.item').removeClass('search-highlight');
    if (!q) return;
    const $matched = $itemsContainer
      .find('.item.slot-item')
      .filter(function () {
        const name = $(this).find('.name').text().toLowerCase();
        return name && name.includes(q);
      });
    if ($matched.length) {
      const el = $matched[0];
      $(el).addClass('search-highlight');
      el.scrollIntoView({
        behavior: 'smooth',
        block: 'nearest',
        inline: 'nearest',
      });
      setTimeout(function () {
        $(el).removeClass('search-highlight');
      }, 2500);
    }
  });
}

(function injectSearchHighlightStyle() {
  if (document.getElementById('search-highlight-style')) return;
  const style = document.createElement('style');
  style.id = 'search-highlight-style';
  style.textContent =
    '.item.search-highlight { box-shadow: 0 0 0 2px #b40000; outline: 2px solid #b40000; }';
  document.head.appendChild(style);
})();

async function Client(route, body = {}) {
  const res = await fetch(`http://${window.GetParentResourceName()}/${route}`, {
    method: 'POST',
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(body),
  });

  const response = await res.json();
  if (route === 'USE_ITEM' && !window.classInstances.left) return false;
  return response;
}

const NotifysType = {
  error: 'linear-gradient(to right, #ff3737c7, #b02020c7)',
  success: 'linear-gradient(to right, #56ab2f, #a8e063)',
};

function Notify(text, type) {
  Client('PLAY_SOUND', { sound: type });
  Toastify({
    text: text,
    className: type,
    duration: 3000,
    style: {
      'font-family': 'Roboto Condensed',
      'font-weight': '350',
      background:
        NotifysType[type] || 'linear-gradient(to right, #414d0b, #727a17)',
    },
  }).showToast();
}

function openStore() {
  fetch('https://inventory/openStore', { method: 'POST' });
}

if (!window.invokeNative) {
  globalThis.Config = {
    celular: { name: 'Celular', weight: 0.5, type: 'use' },
    mochila: { name: 'Mochila', weight: 2.0, type: 'use' },
    agua: { name: 'Água', weight: 0.3, type: 'use' },
    pao: { name: 'Pão', weight: 0.2, type: 'use' },
    money: { name: 'Dinheiro', weight: 0.001, type: 'money' },
    id_card: { name: 'RG', weight: 0.1, type: 'document' },
    WEAPON_PISTOL: { name: 'Pistola', weight: 1.5, type: 'equip' },
    WEAPON_KNIFE: { name: 'Faca', weight: 0.5, type: 'equip' },
    bandagem: { name: 'Bandagem', weight: 0.1, type: 'use' },
    radio: { name: 'Rádio', weight: 0.3, type: 'use' },
  };

  window.mockInventoryData = {
    inventory: {
      1: { item: 'celular', amount: 1 },
      2: { item: 'mochila', amount: 1 },
      3: { item: 'agua', amount: 3 },
      6: { item: 'pao', amount: 5 },
      7: { item: 'money', amount: 50000 },
      10: { item: 'bandagem', amount: 2 },
      15: { item: 'radio', amount: 1 },
    },
    weight: 15.5,
    max_weight: 50,
    profile: {
      name: 'Eduardo Naue da Silva Santos',
      phone: '(11) 99999-8888',
      job: 'Líder da Organização Criminal',
      wallet: 99999999999,
      makapoints: 9999999,
      image_url: '',
    },
  };

  window.mockChestData = {
    inventory: {
      1: { item: 'agua', amount: 10 },
      2: { item: 'pao', amount: 20 },
      5: { item: 'bandagem', amount: 5 },
    },
    weight: 8.5,
    max_weight: 100,
    chest_type: 'VEHICLE',
    title: 'Porta-Malas',
  };

  window.mockPickupData = {
    inventory: {
      1: { item: 'agua', amount: 3 },
      2: { item: 'pao', amount: 2 },
      5: { item: 'bandagem', amount: 1 },
      8: { item: 'radio', amount: 1 },
    },
    weight: 2.1,
    max_weight: 100,
  };

  window.mockWeaponsData = {
    WEAPON_PISTOL: { ammo: 50 },
    WEAPON_KNIFE: { ammo: 1 },
  };

  setTimeout(async () => {
    console.log('🎮 Simulando abertura do inventário...');

    window.classInstances.left = new Inventory(
      window.mockInventoryData,
      'left'
    );
    window.classInstances.weapons = new Weapons(window.mockWeaponsData);

    // window.classInstances.right = new Pickup(window.mockPickupData, "right");
    // window.classInstances.right = new Chest(window.mockChestData, 'right');

    if (!window.classInstances.right) {
      $('.inventory.secondary').css('display', 'none');
      $('#app').removeClass('secondary-open');
    } else {
      $('#app').addClass('secondary-open');
    }

    $('body').css('display', 'flex').show();

    setTimeout(function () {
      setupSearchHighlight('.inventory.primary');
      setupSearchHighlight('.inventory.secondary');
    }, 50);

    console.log('✅ Inventário aberto com sucesso!');
    console.log(
      '💡 Simulando abertura do CHÃO (pickup) - peso deve estar oculto no inventário secundário'
    );
  }, 1000);

  setTimeout(() => {
    $('.item').droppable({
      accept: '.slot-item',
      drop: async (event, ui) => {
        const self = window.classInstances[ui.draggable.data('side')];
        if (!self) return;
        const id = ui.draggable.data('id');
        const old = { side: ui.draggable.data('side'), id };
        const next = {
          side: event.target.dataset.side,
          id: event.target.dataset.id,
        };
        const isTargetEmpty = $(event.target).hasClass('empty');
        const hasSecondaryInventory = !!window.classInstances.right;

        if (isTargetEmpty && typeof window.openQuantityModal === 'function') {
          const itemData = self.items[id?.toString?.() ?? id];
          if (!itemData) return;

          if (!hasSecondaryInventory) {
            await self.changeItemPos(old, next, undefined, itemData.amount);
            self.selectItem(next.side, next.id);
            return;
          }

          window.openQuantityModal(
            {
              item: itemData.item,
              name: itemData.name,
              weight: itemData.weight,
            },
            itemData.amount,
            async (amount) => {
              await self.changeItemPos(old, next, undefined, amount);
              if (old.side !== next.side && window.classInstances[next.side]) {
                window.classInstances[next.side].selectItem(next.side, next.id);
              } else {
                self.selectItem(next.side, next.id);
              }
            },
            true
          );
          return;
        }

        await self.changeItemPos(
          old,
          next,
          event.ctrlKey ? 'ctrl' : event.shiftKey ? 'shift' : undefined
        );
        if (ui.draggable.data('side') !== event.target.dataset.side) {
          window.classInstances[event.target.dataset.side].selectItem(
            event.target.dataset.side,
            event.target.dataset.id
          );
        } else {
          self.selectItem(event.target.dataset.side, event.target.dataset.id);
        }
      },
    });
  }, 1500);
}

if (!window.invokeNative) {
  window.GetParentResourceName = () => 'inventory';

  if (typeof Toastify === 'undefined') {
    window.Notify = function (text, type) {
      console.log(`🔔 Notificação [${type}]: ${text}`);
      alert(`[${type.toUpperCase()}]\n${text}`);
    };
  }

  window.Client = async function (route, body = {}) {
    console.log(`📡 Client call: ${route}`, body);

    switch (route) {
      case 'REQUEST_ITEMS_CONFIG':
        return globalThis.Config;
      case 'GET_INVENTORY':
        return window.mockInventoryData;
      case 'GET_WEAPONS':
        return window.mockWeaponsData;
      case 'GET_PICKUPS':
        return { inventory: {} };
      case 'SWAP_SLOT':
        console.log('✅ Slot trocado');
        return true;
      case 'USE_ITEM':
        console.log('✅ Item usado');
        return true;
      case 'SEND_ITEM':
        console.log('✅ Item enviado');
        return true;
      case 'DROP_ITEM':
        console.log('✅ Item dropado');
        return true;
      case 'STORE_CHEST_ITEM':
        console.log('✅ Item guardado no baú');
        return true;
      case 'TAKE_CHEST_ITEM':
        console.log('✅ Item retirado do baú');
        return true;
      case 'CLOSE_INVENTORY':
        console.log('🚪 Inventário fechado');
        return true;
      case 'PLAY_SOUND':
        console.log('🔊 Som:', body.sound);
        return true;
      default:
        console.log('⚠️ Rota não mockada:', route);
        return false;
    }
  };
}

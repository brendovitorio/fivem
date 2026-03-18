function disableHiddenDropables() {
  const $container = $('.inventory.primary .items');
  if (!$container.length) return;
  $('.empty').each(function () {
    const elemTop = $(this).offset().top;
    const elemBottom = elemTop + $(this).outerHeight();

    const containerTop = $container.offset().top;
    const containerBottom = containerTop + $container.outerHeight();

    if (
      (elemBottom < containerTop || elemTop > containerBottom) &&
      Number($(this).data('id')) > 5
    ) {
      $(this).droppable('disable');
    } else {
      $(this).droppable('enable');
    }
  });
}

class Inventory {
  items;
  maxWeight = 0;
  currentWeight = 0;
  weightPercentage = 0;
  side;

  constructor(data, side = 'left', pickup = undefined) {
    const { inventory, weight, max_weight, profile } = data;
    this.pickup = pickup;
    this.items = this.parseItems(inventory);
    this.maxWeight = max_weight;
    this.currentWeight = weight;
    this.weightPercentage = (this.currentWeight * 100) / this.maxWeight;
    this.side = side;
    this.slotHeight = 0;
    this.slotWidth = 0;

    const userEl = document.querySelector('.left .user');
    if (userEl) {
      userEl.style.display = 'flex';
      if (profile) {
        const nameElement = document.querySelector(
          '.left .user .user-infos .name p'
        );
        if (nameElement) {
          nameElement.innerText = profile.name;
          nameElement.title = profile.name;
        }

        const phoneElement = document.querySelector(
          '.left .user .user-infos .infos .info:nth-child(1) p'
        );
        if (phoneElement) {
          const phoneText = profile.phone || 'N/A';
          phoneElement.innerText = phoneText;
          phoneElement.title = phoneText;
        }

        const jobElement = document.querySelector(
          '.left .user .user-infos .infos .info:nth-child(2) p'
        );
        if (jobElement) {
          const jobText = profile.job || 'Desempregado';
          jobElement.innerText = jobText;
          jobElement.title = jobText;
        }

        const walletElement = document.querySelector(
          '.left .user .user-infos .infos .info:nth-child(3) p'
        );
        if (walletElement) {
          const walletText = `R$${(profile.wallet || 0).toLocaleString(
            'pt-BR'
          )}`;
          walletElement.innerText = walletText;
          walletElement.title = walletText;
        }

        const pointsElement = document.querySelector(
          '.left .user .user-infos .infos .info:nth-child(5) p'
        );
        if (pointsElement) {
          const pointsText = (profile.makapoints || 0).toLocaleString('pt-BR');
          pointsElement.innerText = pointsText;
          pointsElement.title = pointsText;
        }

        if (profile.image_url) {
          const imgElement = document.querySelector('.left .user img');
          if (imgElement) imgElement.src = profile.image_url;
        }
      }
    }

    if (side === 'right') {
      for (const el of document.querySelectorAll('.onlyInventory')) {
        el.style.display = 'none';
      }
    }
    this.renderSlots(side);
    this.renderInfos(side);
  }
  findSlotByItem(name, ignoreSlot) {
    let _slot;

    Object.keys(this.items).forEach((slot) => {
      if (
        this.items[slot].item === name &&
        (!ignoreSlot || !ignoreSlot.includes(slot))
      ) {
        _slot = slot;
      }
    });

    return _slot;
  }
  refreshWeight() {
    // Esconde o peso apenas para lojas (mode) e pickups, não para baús (chest)
    if (this.side === 'right' && (this.mode || this.pickup)) {
      $('.inventory.secondary .weight').hide();
      return;
    }

    this.currentWeight = Object.values(this.items).reduce((total, num) => {
      if (num.weight) {
        return num.weight * num.amount + total;
      }
      return total;
    }, 0);

    // Para o inventário secundário (baú), usar a classe "secondary"
    const weightSelector =
      this.side === 'right'
        ? '.inventory.secondary .weight'
        : '.inventory.primary .weight';

    $(weightSelector).show();
    const $weightContainer = $(weightSelector);
    $weightContainer
      .find('p')
      .first()
      .html(
        `${this.currentWeight.toFixed(2)} / ${this.maxWeight.toLocaleString(
          'pt-BR'
        )} kg`
      );
    const numBars = 8;
    const activedCount = Math.min(
      numBars,
      Math.round((this.currentWeight / this.maxWeight) * numBars)
    );
    $weightContainer
      .find('.bar')
      .removeClass('actived')
      .each(function (i) {
        if (i < activedCount) $(this).addClass('actived');
      });
  }
  parseItems(items) {
    Object.keys(items).forEach((slot) => {
      const originalItem = items[slot].item;
      const rawBaseItem = String(originalItem || '').split('-')[0];
      const normalizedBaseItem = rawBaseItem.toLowerCase();
      const configItem =
        globalThis.Config[originalItem] ||
        globalThis.Config[rawBaseItem] ||
        globalThis.Config[String(originalItem || '').toLowerCase()] ||
        globalThis.Config[normalizedBaseItem];
      items[slot].item = originalItem;
      items[slot].baseItem = (configItem && (globalThis.Config[rawBaseItem] ? rawBaseItem : normalizedBaseItem)) || normalizedBaseItem;
      items[slot].name = configItem?.name;
      if (!items[slot].name) {
        delete items[slot];
      } else {
        items[slot].key = originalItem;
        items[slot].slot = slot;
        items[slot].weight = configItem?.weight;
      }
    });
    return items;
  }

  renderSlots(target = 'left') {
    if (target === 'left') {
      $('.inventory.primary .items').html('');
      $('.hotbar .items').empty();
    } else {
      $('.inventory.secondary .items').html('');
    }

    for (let i = 0; i < 58; i++) {
      const slot = i + 1;
      if (
        !this.items[slot.toString()] ||
        (this.items[slot.toString()] &&
          globalThis.Config[this.items[slot.toString()].item] || globalThis.Config[this.items[slot.toString()].baseItem])
      ) {
        let targetDiv =
          target === 'left'
            ? '.inventory.primary .items'
            : '.inventory.secondary .items';

        if (this.items[slot.toString()]) {
          const item = this.items[slot.toString()];
          if (i <= 4 && this.side == 'left') {
            $('.hotbar .items').append(this.getItemHtml(item, target, slot));
          } else {
            $(targetDiv).append(this.getItemHtml(item, target, slot));
          }
        } else {
          if (i <= 4 && this.side == 'left') {
            $(`.hotbar .items`).append(
              `<div class="item empty slot-${target} slot-${target}${slot}" data-side="${target}" data-id="${slot}"><p>${slot}</p><div class="slot">${slot}</div></div>`
            );
          } else {
            $(targetDiv).append(
              `<div class="item empty slot-${target} slot-${target}${slot}" data-side="${target}" data-id="${slot}">${this.getEmptySlotSvg()}</div>`
            );
          }
        }
      }
    }
    this.slotHeight = Math.floor($(`.item.slot-${target}`).height() / 2);
    this.slotWidth = Math.floor($(`.item.slot-${target}`).width() / 2);

    this.refreshWeight();
    this.updateDrag(target);
  }

  removeItem(slot, amount) {
    this.items[slot].amount -= amount;
    if (this.items[slot].item === 'mochila') {
      if (this.maxWeight <= 25) {
        this.maxWeight = 50;
      } else if (this.maxWeight === 50) {
        this.maxWeight = 75;
      } else if (this.maxWeight === 75) {
        this.maxWeight = 90;
      }
    }
    if (this.items[slot].amount <= 0) {
      delete this.items[slot];
    }
    this.renderSlots(this.side);
  }
  formatWeight(weight) {
    return `${weight.toFixed(1)}kg`;
  }

  getEmptySlotSvg() {
    return `<svg width="1.0625rem" height="1.1875rem" viewBox="0 0 17 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.766667 4.99862L8.5 9.49908M8.5 9.49908L16.2333 4.99862M8.5 9.49908V18.5M16.5 5.89871C16.4997 5.58302 16.4174 5.27297 16.2614 4.99966C16.1054 4.72635 15.8811 4.49939 15.6111 4.34155L9.38889 0.741179C9.11863 0.58318 8.81207 0.5 8.5 0.5C8.18793 0.5 7.88137 0.58318 7.61111 0.741179L1.38889 4.34155C1.1189 4.49939 0.894649 4.72635 0.738632 4.99966C0.582616 5.27297 0.50032 5.58302 0.5 5.89871V13.0994C0.50032 13.4151 0.582616 13.7252 0.738632 13.9985C0.894649 14.2718 1.1189 14.4988 1.38889 14.6566L7.61111 18.257C7.88137 18.415 8.18793 18.4982 8.5 18.4982C8.81207 18.4982 9.11863 18.415 9.38889 18.257L15.6111 14.6566C15.8811 14.4988 16.1054 14.2718 16.2614 13.9985C16.4174 13.7252 16.4997 13.4151 16.5 13.0994V5.89871Z" stroke="white" stroke-opacity="0.2" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
  }

  clearSlot($element) {
    const isHotbar = $element.closest('.hotbar .items').length > 0;
    if (isHotbar) {
      const slotNum = $element.data('id');
      $element.html(`<p>${slotNum}</p><div class="slot">${slotNum}</div>`);
    } else {
      $element.html(this.getEmptySlotSvg());
    }
  }

  setSlotHtml($element, html) {
    const isHotbar = $element.closest('.hotbar .items').length > 0;
    if (isHotbar) {
      const slotNum = $element.data('id');
      const $temp = $('<div>').html(html);
      $temp.find('.slot').remove();
      $temp.find('.name').remove();
      $element.html($temp.html());
      $element.append($(`<div class="slot">${slotNum}</div>`));
    } else {
      const $temp = $('<div>').html(html);
      $temp.find('.slot').remove();
      $element.html($temp.html());
    }
  }

  getItemHtml(item, target, slot, method = 'allDiv') {
    const amountStr = item.price ? `R$${item.price}` : `${item.amount}x`;
    const weightStr = this.formatWeight(item.weight);
    const imgSrc = window.getItemImageSrc(item);
    const nameStr = item.name || '';

    if (method === 'onlyItems') {
      return `
            <div class="top">
              <p class="amount">${amountStr}</p>
              <p class="weight">${weightStr}</p>
            </div>
            <img src="${imgSrc}" class="image" onerror="this.onerror=null;this.src='data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'" title="${item.name}"/>
            <p class="name">${nameStr}</p>
            `;
    }

    const isHotbar =
      target === 'left' && parseInt(slot) >= 1 && parseInt(slot) <= 5;
    const hotbarSlot = isHotbar
      ? `<div class="slot">${parseInt(slot)}</div>`
      : '';

    return `
        <div class="item populated slot-${target} slot-item slot-${target}${slot}" data-side="${target}" data-id="${slot}" title="${
      item.name
    }">
            <div class="top">
              <p class="amount">${amountStr}</p>
              <p class="weight">${weightStr}</p>
            </div>
            <img src="${imgSrc}" class="image" onerror="this.onerror=null;this.src='data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'"/>
            ${!isHotbar ? `<p class="name">${nameStr}</p>` : ''}
            ${hotbarSlot}
        </div>
        `;
  }

  renderInfos(side) {
    if (this.side === 'right' && (this.mode || this.pickup)) {
      $('.inventory.secondary .weight').hide();
      return;
    }

    this.refreshWeight();
  }

  getItems() {
    return this.items;
  }

  selectItem(side, itemId) {
    if (this.side === 'right') return;
    if (!this.items[itemId]) return;
    const item = { ...this.items[itemId], id: itemId, side };
    $('.item').removeClass('slot-active');

    globalThis.SelectedItem = item;
    $(`.slot-${side}${item.id}`).addClass('slot-active');
  }

  async changeItemPos(old, next, keyPressed, amountOverride) {
    if (old.side === next.side) {
      old.item = this.items[old.id.toString()];
      next.item = this.items[next.id.toString()];
      let inputValue;
      if (amountOverride !== undefined && amountOverride !== null) {
        inputValue = Math.max(
          1,
          Math.min(Number(amountOverride), old.item.amount)
        );
      } else {
        if (keyPressed === 'ctrl' && old.item.amount % 2 === 0) {
          inputValue = old.item.amount / 2;
        } else if (keyPressed === 'shift') {
          inputValue = 1;
        } else {
          inputValue = old.item.amount;
        }
      }
      if (inputValue > old.item.amount) {
        inputValue = old.item.amount;
      }
      if (
        old.side === 'right' &&
        (window.classInstances[old.side]?.mode ||
          window.classInstances[old.side]?.pickup)
      )
        return false;
      const response =
        old.side === 'right' ||
        (await Client('SWAP_SLOT', {
          from_slot: old.id,
          from_amount: inputValue,
          to_slot: next.id,
        }));
      if (!response) {
        return false;
      }
      if (!next.item) {
        if (old.item.amount <= inputValue) {
          const $oldSlot = $(`.slot-${old.side}${old.id}`);
          const $nextSlot = $(`.slot-${next.side}${next.id}`);
          const nextIsHotbar = $nextSlot.closest('.hotbar .items').length > 0;
          const contentForNext = nextIsHotbar
            ? $oldSlot.clone().find('.slot').remove().end().html()
            : this.getItemHtml(
                this.items[old.id.toString()],
                next.side,
                next.id,
                'onlyItems'
              );

          $oldSlot.removeClass('slot-item').addClass('empty');
          this.clearSlot($oldSlot);

          $nextSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml($nextSlot, contentForNext);
          this.items[next.id.toString()] = this.items[old.id.toString()];
          delete this.items[old.id.toString()];
        } else {
          this.items[old.id.toString()].amount -= inputValue;
          this.items[next.id.toString()] = {};
          Object.assign(
            this.items[next.id.toString()],
            this.items[old.id.toString()],
            { amount: inputValue }
          );
          const $nextSlot = $(`.slot-${next.side}${next.id}`);
          $nextSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml(
            $nextSlot,
            this.getItemHtml(
              this.items[next.id.toString()],
              next.side,
              next.id,
              'onlyItems'
            )
          );

          const $oldSlot = $(`.slot-${old.side}${old.id}`);
          $oldSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml(
            $oldSlot,
            this.getItemHtml(
              this.items[old.id.toString()],
              old.side,
              old.id,
              'onlyItems'
            )
          );
        }
      } else if (old.item.item === next.item.item) {
        if (old.item.amount <= inputValue) {
          this.items[next.id.toString()].amount += inputValue;
          const html = this.getItemHtml(
            this.items[next.id.toString()],
            next.side,
            next.id,
            'onlyItems'
          );
          const $oldSlot = $(`.slot-${old.side}${old.id}`);
          $oldSlot.removeClass('slot-item').addClass('empty');
          this.clearSlot($oldSlot);

          const $nextSlot = $(`.slot-${next.side}${next.id}`);
          $nextSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml($nextSlot, html);
          delete this.items[old.id.toString()];
        } else {
          this.items[old.id.toString()].amount -= inputValue;
          this.items[next.id.toString()].amount += inputValue;
          Object.assign(
            this.items[next.id.toString()],
            this.items[old.id.toString()],
            { amount: inputValue }
          );
          const $nextSlot = $(`.slot-${next.side}${next.id}`);
          $nextSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml(
            $nextSlot,
            this.getItemHtml(
              this.items[next.id.toString()],
              next.side,
              next.id,
              'onlyItems'
            )
          );

          const $oldSlot = $(`.slot-${old.side}${old.id}`);
          $oldSlot
            .removeClass('empty')
            .addClass('slot-item')
            .addClass(`slot-${next.side}`);
          this.setSlotHtml(
            $oldSlot,
            this.getItemHtml(
              this.items[old.id.toString()],
              old.side,
              old.id,
              'onlyItems'
            )
          );
        }
      } else if (old.item.item !== next.item.item) {
        const $oldSlot = $(`.slot-${old.side}${old.id}`);
        const $nextSlot = $(`.slot-${next.side}${next.id}`);
        const nextIsHotbar = $nextSlot.closest('.hotbar .items').length > 0;
        const oldIsHotbar = $oldSlot.closest('.hotbar .items').length > 0;
        const contentForNext = nextIsHotbar
          ? $oldSlot.clone().find('.slot').remove().end().html()
          : this.getItemHtml(
              this.items[old.id.toString()],
              next.side,
              next.id,
              'onlyItems'
            );
        const contentForOld = oldIsHotbar
          ? $nextSlot.clone().find('.slot').remove().end().html()
          : this.getItemHtml(
              this.items[next.id.toString()],
              old.side,
              old.id,
              'onlyItems'
            );

        this.setSlotHtml($nextSlot, contentForNext);
        this.setSlotHtml($oldSlot, contentForOld);

        const oldObj = JSON.parse(
          JSON.stringify(this.items[old.id.toString()])
        );
        const nextObj = JSON.parse(
          JSON.stringify(this.items[next.id.toString()])
        );
        nextObj.slot = next.id;
        oldObj.slot = old.id;
        this.items[next.id.toString()] = oldObj;
        this.items[old.id.toString()] = nextObj;
      }
      this.updateDrag(old.side);
    }
    if (old.side === 'left' && next.side === 'right') {
      old.item = this.items[old.id.toString()];
      const $input = getAmountInput();
      let inputValue =
        Number.parseInt($input.val()) > 0
          ? Number.parseInt($input.val())
          : old.item.amount;
      if (keyPressed === 'ctrl' && old.item.amount % 2 === 0) {
        inputValue = old.item.amount / 2;
      } else if (keyPressed === 'shift') {
        inputValue = 1;
      }
      if (inputValue > old.item.amount) {
        inputValue = old.item.amount;
      }
      await window.classInstances.right.putItem(old.id, inputValue, next.id);
    }

    if (old.side === 'right' && next.side === 'left') {
      if (window.classInstances.right.mode) {
        const $input = getAmountInput();
        let inputValue =
          Number.parseInt($input.val()) > 0 ? Number.parseInt($input.val()) : 1;
        if (keyPressed === 'ctrl' && old.item.amount % 2 === 0) {
          inputValue = old.item.amount / 2;
        } else if (keyPressed === 'shift') {
          inputValue = 1;
        }
        await window.classInstances.right.takeItem(old.id, inputValue, next.id);
      } else {
        old.item = window.classInstances.right.items[old.id.toString()];
        const $input = getAmountInput();
        let inputValue =
          Number.parseInt($input.val()) > 0
            ? Number.parseInt($input.val())
            : old.item.amount;
        if (keyPressed === 'ctrl' && old.item.amount % 2 === 0) {
          inputValue = old.item.amount / 2;
        } else if (keyPressed === 'shift') {
          inputValue = 1;
        }
        await window.classInstances.right.takeItem(old.id, inputValue, next.id);
      }
    }
  }
  updateDrag(target) {
    $(`.item.slot-${target}`).draggable({
      disabled: false,
      containment: '#app',
      cursorAt: {
        top: Math.floor($(`.item.slot-${target}`).height() / 2),
        left: Math.floor($(`.item.slot-${target}`).width() / 2),
      },
      start: (event, ui) => {
        this.selectItem(
          event.currentTarget.dataset.side,
          event.currentTarget.dataset.id
        );
        disableHiddenDropables();
        const $helper = ui.helper;
        const $img = $helper.find('img.image');
        if ($img.length && $img[0].src) {
          $img[0].style.opacity = '1';
          $img[0].style.visibility = 'visible';
        }
      },
      opacity: 0.9,
      cursor: 'grabbing',
      helper: 'clone',
      revert: false,
      hoverClass: 'item-selected',
    });

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

    $('#app .weapons').droppable({
      accept: '.slot-left',
      drop: async (event, ui) => {
        const self = window.classInstances[ui.draggable.data('side')];
        if (!self || ui.draggable.data('side') !== 'left') return;
        if (!globalThis.SelectedItem || globalThis.SelectedItem.side !== 'left')
          return Notify(
            'Selecione um item do seu inventário primeiro!',
            'error'
          );

        let { item, id } = globalThis.SelectedItem;
        const inputValue = 1;
        if (!window.classInstances.left.items[id]) {
          id = window.classInstances.left.findSlotByItem(item);
          if (!id)
            return Notify(
              'Selecione um item do seu inventário primeiro!',
              'error'
            );
        }
        if (globalThis.Config[item]?.type !== 'equip') {
          Notify('Este item não pode ser equipado!', 'error');
          return;
        }

        const response = await Client('USE_ITEM', {
          slot: id,
          item: item,
          amount: inputValue,
        });
        if (typeof response !== 'boolean' && response?.error) {
          Notify(response.error, 'error');
          return;
        }
        if (!response) {
          return;
        }
        if (response) {
          window.classInstances.left.removeItem(
            id,
            response?.used_amount || inputValue
          );
          if (
            globalThis.Config[item]?.type === 'equip' ||
            globalThis.Config[item]?.type === 'recharge'
          ) {
            window.classInstances.weapons = new Weapons(
              await Client('GET_WEAPONS')
            );
          }
        }
      },
    });

    $('#app .actions .action').droppable({
      accept: '.slot-left',
      hoverClass: 'ui-droppable-hover',
      drop: async (event, ui) => {
        const self = window.classInstances[ui.draggable.data('side')];
        if (!self || ui.draggable.data('side') !== 'left') return;
        self.selectItem('left', ui.draggable.data('id'));

        if (!globalThis.SelectedItem || globalThis.SelectedItem.side !== 'left')
          return Notify(
            'Selecione um item do seu inventário primeiro!',
            'error'
          );
        let { item, id, amount, name, weight } = globalThis.SelectedItem;
        if (!window.classInstances.left.items[id]) {
          id = window.classInstances.left.findSlotByItem(item);
          if (!id)
            return Notify(
              'Selecione um item do seu inventário primeiro!',
              'error'
            );
        }
        const itemData = window.classInstances.left.items[id];
        const maxAmount = itemData ? itemData.amount : amount;
        const actionLabel = $(event.target)
          .closest('.action')
          .find('h3')
          .text()
          .trim();
        const actionRoutes = {
          Usar: 'USE_ITEM',
          Enviar: 'SEND_ITEM',
          Excluir: 'DROP_ITEM',
        };
        const action = actionRoutes[actionLabel];
        if (!action) return;
        if (typeof window.openQuantityModal !== 'function') return;

        window.openQuantityModal(
          {
            item: item,
            name: name || itemData?.name,
            weight: itemData?.weight ?? weight,
          },
          maxAmount,
          async (inputValue) => {
            const response = await Client(action, {
              slot: id,
              item: item,
              amount: inputValue,
            });
            if (typeof response !== 'boolean' && response?.error) {
              Notify(response.error, 'error');
              return;
            }
            if (!response) return;
            window.classInstances.left.removeItem(
              id,
              response?.used_amount || inputValue
            );
            if (
              action === 'USE_ITEM' &&
              (globalThis.Config[item]?.type === 'equip' ||
                globalThis.Config[item]?.type === 'recharge')
            ) {
              window.classInstances.weapons = new Weapons(
                await Client('GET_WEAPONS')
              );
            }
          }
        );
      },
    });

    $('.empty').draggable({
      disabled: true,
    });
  }
}

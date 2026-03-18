class Weapons {
  weapons;
  selected;
  constructor(weapons) {
    this.weapons = weapons;
    this.renderWeapons();
  }
  async manageWeapons(type = 'selected') {
    if (!globalThis.isOnline) {
      Notify('Sem conexão com a internet!', 'error');
      return;
    }
    if (type === 'selected') {
      const response = await Client('MANAGE_WEAPONS', {
        weapons: [this.selected],
      });
      if (!response || response?.error) {
        Notify(response?.error || 'Erro', 'error');
        return;
      }
      if (response.success) {
        delete this.weapons[this.selected];
        this.renderWeapons();
        window.classInstances.left = new Inventory(
          await Client('GET_INVENTORY')
        );
      }
    } else if (type === 'all') {
      const response = await Client('MANAGE_WEAPONS', {
        weapons: Object.keys(this.weapons),
      });
      if (!response || response?.error) {
        Notify(response?.error || 'Erro', 'error');
        return;
      }
      if (response.success) {
        this.weapons = {};
        this.renderWeapons();
        window.classInstances.left = new Inventory(
          await Client('GET_INVENTORY')
        );
      }
    }
  }
  renderWeapons() {
    const sec = document.querySelector('.inventory.secondary');
    if (sec) sec.style.display = 'none';
    const $weapons = $('#app .weapons');
    if (!$weapons.length) return;
    $weapons.empty();
    Object.keys(this.weapons).forEach((weapon) => {
      if (!weapon.includes('PARACHUTE')) {
        const weaponName = weapon.toLowerCase();
        const weaponElement = $(`
					<div class="weapon" data-weapon="${weaponName}">
						<img src="${window.getItemImageSrc({ item: weaponName, baseItem: weaponName })}" onerror="this.onerror=null;this.src='data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'"/>
					</div>
				`);
        $weapons.append(weaponElement);
      }
    });
  }
}
$(document).on('click', '#app .weapons .weapon', function () {
  $('.selected-weapon').removeClass('selected-weapon');
  $(this).addClass('selected-weapon');
  window.classInstances.weapons.selected = $(this).data('weapon');
});

$(document).on('dblclick', '#app .weapons .weapon', () => {
  window.classInstances.weapons.manageWeapons('selected');
});

(() => {
  const hud = document.getElementById('hud');
  const speedWrap = document.getElementById('speedWrap');

  const $ = (id) => document.getElementById(id);

  const els = {
    direction: $('direction'),
    streetText: $('streetText'),
    timeText: $('timeText'),
    weatherText: $('weatherText'),

    healthFill: $('healthFill'),

    armorValue: $('armorValue'),
    armorFill: $('armorFill'),

    hungerValue: $('hungerValue'),
    hungerFill: $('hungerFill'),

    thirstValue: $('thirstValue'),
    thirstFill: $('thirstFill'),

    stressValue: $('stressValue'),
    stressFill: $('stressFill'),

    staminaFill: $('staminaFill'),
    staminaMarker: $('staminaMarker'),

    voiceBars: $('voiceBars'),

    speedHundreds: $('speedHundreds'),
    speedRest: $('speedRest'),
    gearValue: $('gearValue'),
    rpmBars: $('rpmBars'),

    fuelFill: $('fuelFill'),

    engineControl: $('engineControl'),
    seatbeltControl: $('seatbeltControl'),
    doorControl: $('doorControl'),
  };

  const state = {
    show: true,

    health: 100,
    armor: 100,
    hunger: 100,
    thirst: 100,
    stress: 100,
    stamina: 100,

    direction: 'NW',
    streetName: 'VESPUCCI BLVD',
    areaName: 'LA MESA',
    time: '12:11 PM',
    weather: 'CLEAR',

    speed: 0,
    fuel: 55,
    rpm: 0,
    gear: 'N',

    seatbelt: false,
    engineOn: false,
    doorOpen: false,
    isLock: false,

    voiceLevel: 2,
    isTalking: false,
    inVehicle: false,
  };

  const animated = {
    health: 100,
    armor: 100,
    hunger: 100,
    thirst: 100,
    stress: 100,
    stamina: 100,
    fuel: 55,
  };

  let hideTimer = null;
  let rafId = null;

  function clamp(n, min, max) {
    n = Number(n);
    return Number.isFinite(n) ? Math.max(min, Math.min(max, n)) : min;
  }

  function lerp(current, target, factor) {
    if (Math.abs(target - current) < 0.05) return target;
    return current + (target - current) * factor;
  }

  function formatWeather(value) {
    const map = {
      CLEAR: 'CLEAR',
      CLOUDS: 'CLOUDS',
      EXTRASUNNY: 'SUNNY',
      OVERCAST: 'OVERCAST',
      RAIN: 'RAIN',
      THUNDER: 'THUNDER',
      FOG: 'FOG',
      SMOG: 'SMOG',
      SNOW: 'SNOW',
      BLIZZARD: 'BLIZZARD',
    };
    return map[String(value || '').toUpperCase()] || String(value || 'CLEAR').toUpperCase();
  }

  function parseVoiceLevel(value) {
    const raw = String(value || '').toLowerCase();

    if (raw.includes('megafone') || raw.includes('alto')) return 3;
    if (raw.includes('medio') || raw.includes('médio') || raw.includes('normal')) return 2;
    if (raw.includes('baixo')) return 1;
    if (raw.includes('offline')) return 0;

    const num = Number(value);
    if (Number.isFinite(num)) return clamp(num, 0, 3);

    return 2;
  }

  function setProgressWidth(el, value, maxWidth) {
    if (!el) return;
    const width = Math.round((clamp(value, 0, 100) / 100) * maxWidth);
    el.style.width = `${width}px`;
  }

  function setControlState(el, mode) {
    if (!el) return;
    el.classList.remove('off', 'warn', 'danger', 'locked', 'unlocked');
    if (mode) el.classList.add(mode);
  }

  function buildVoiceBars(level, talking) {
    if (!els.voiceBars) return;

    const safeLevel = clamp(level, 0, 3);
    els.voiceBars.classList.toggle('talking', !!talking);
    els.voiceBars.innerHTML = '';

    for (let i = 1; i <= 3; i++) {
      const bar = document.createElement('div');
      bar.className = 'tiny-bar' + (i <= safeLevel ? ' active' : '');
      els.voiceBars.appendChild(bar);
    }
  }

  function buildRpmBars(speed, rpm) {
    if (!els.rpmBars) return;

    const count = 24;
    const normalizedRpm = rpm > 1 ? clamp(rpm / 100, 0, 1) : clamp(rpm, 0, 1);
    const normalizedSpeed = clamp(speed / 180, 0, 1);
    const normalized = Math.max(normalizedRpm, normalizedSpeed);
    const active = Math.round(normalized * count);

    els.rpmBars.innerHTML = '';
    els.rpmBars.classList.toggle('overboost', speed > 140);

    for (let i = 0; i < count; i++) {
      const bar = document.createElement('div');
      bar.className = 'rpm-bar' + (i < active ? ' active' : ' off');
      els.rpmBars.appendChild(bar);
    }
  }

  function updateVehicleVisibility(inVehicle) {
    if (!speedWrap) return;

    if (inVehicle) {
      if (hideTimer) clearTimeout(hideTimer);
      speedWrap.classList.add('show-soft');
      speedWrap.classList.remove('hidden-soft');
      return;
    }

    if (hideTimer) clearTimeout(hideTimer);
    hideTimer = setTimeout(() => {
      speedWrap.classList.remove('show-soft');
      speedWrap.classList.add('hidden-soft');
    }, 220);
  }

  function setHexHealth(value) {
    if (!els.healthFill) return;

    const health = clamp(value, 0, 100);

    /* mesmo valor do CSS stroke-dasharray */
    const totalLength = 320;
    const hiddenLength = totalLength * (1 - health / 100);

    els.healthFill.style.strokeDasharray = `${totalLength}`;
    els.healthFill.style.strokeDashoffset = `${hiddenLength}`;
  }

  function drawStatic() {
    if (hud) {
      hud.classList.toggle('hidden', !state.show);
      hud.classList.toggle('on-foot', !state.inVehicle);
    }

    const speedNum = Math.round(clamp(state.speed, 0, 999));
    const speedText = String(speedNum).padStart(3, '0');
    const gear = speedNum <= 0 ? 'N' : String(state.gear || 'N').toUpperCase();

    if (els.direction) els.direction.textContent = (state.direction || 'N').toUpperCase();

    if (els.streetText) {
      els.streetText.textContent =
        [state.streetName, state.areaName].filter(Boolean).join(' - ') || 'SEM LOCALIZAÇÃO';
    }

    if (els.timeText) els.timeText.textContent = state.time || '00:00';
    if (els.weatherText) els.weatherText.textContent = formatWeather(state.weather);

    if (els.speedHundreds) {
      els.speedHundreds.textContent = speedText[0];
      els.speedHundreds.classList.toggle('active', speedNum >= 100);
    }

    if (els.speedRest) els.speedRest.textContent = speedText.slice(1);
    if (els.gearValue) els.gearValue.textContent = gear;

    buildVoiceBars(state.voiceLevel, state.isTalking);
    buildRpmBars(speedNum, state.rpm);

    setControlState(els.engineControl, state.engineOn ? null : 'danger');
    setControlState(els.seatbeltControl, state.seatbelt ? null : 'warn');

    if (state.doorOpen) {
      setControlState(els.doorControl, 'danger');
    } else {
      setControlState(els.doorControl, state.isLock ? 'locked' : 'unlocked');
    }

    updateVehicleVisibility(state.inVehicle);
  }

  function drawAnimated() {
    if (els.armorValue) els.armorValue.textContent = Math.round(animated.armor);
    if (els.hungerValue) els.hungerValue.textContent = Math.round(animated.hunger);
    if (els.thirstValue) els.thirstValue.textContent = Math.round(animated.thirst);
    if (els.stressValue) els.stressValue.textContent = Math.round(animated.stress);

    setHexHealth(animated.health);

    setProgressWidth(els.armorFill, animated.armor, 40);
    setProgressWidth(els.hungerFill, animated.hunger, 40);
    setProgressWidth(els.thirstFill, animated.thirst, 40);
    setProgressWidth(els.stressFill, animated.stress, 40);

    if (els.staminaFill && els.staminaMarker) {
      const staminaWidth = Math.round((clamp(animated.stamina, 0, 100) / 100) * 172);
      els.staminaFill.style.width = `${staminaWidth}px`;
      els.staminaMarker.style.left = `${Math.max(0, Math.min(172, staminaWidth))}px`;
    }

    if (els.fuelFill) {
      const fuelHeight = Math.max(0, Math.min(88, (clamp(animated.fuel, 0, 100) / 100) * 88));
      els.fuelFill.style.height = `${fuelHeight}px`;
    }
  }

  function animate() {
    let moving = false;

    for (const key of Object.keys(animated)) {
      const factor = key === 'stamina' ? 0.12 : 0.20;
      const next = lerp(animated[key], state[key], factor);

      if (next !== state[key]) moving = true;
      animated[key] = next;
    }

    drawAnimated();

    if (moving) {
      rafId = requestAnimationFrame(animate);
    } else {
      rafId = null;
    }
  }

  function syncAnimatedLoop() {
    if (rafId == null) {
      rafId = requestAnimationFrame(animate);
    }
  }

  function render() {
    drawStatic();
    syncAnimatedLoop();
  }

  window.addEventListener('message', (event) => {
    const d = event.data || {};

    if (d.action === 'toggleHud') {
      state.show = !!d.show;
      render();
      return;
    }

    if (d.hudIsActive !== undefined && d.action == null) {
      state.show = !!d.hudIsActive;
      render();
      return;
    }

    if (d.action && d.action !== 'updateHud') return;

    if (d.health != null || d.heart != null || d.hp != null) {
      state.health = clamp(d.health ?? d.heart ?? d.hp, 0, 100);
    }

    if (d.armor != null || d.armour != null) {
      state.armor = clamp(d.armor ?? d.armour, 0, 100);
    }

    if (d.hunger != null) state.hunger = clamp(d.hunger, 0, 100);
    if (d.thirst != null) state.thirst = clamp(d.thirst, 0, 100);
    if (d.stamina != null) state.stamina = clamp(d.stamina, 0, 100);
    if (d.stress != null) state.stress = clamp(d.stress, 0, 100);

    if (d.direction != null) state.direction = d.direction;
    if (d.streetName != null || d.location != null) state.streetName = d.streetName ?? d.location;
    if (d.areaName != null || d.crossing != null) state.areaName = d.areaName ?? d.crossing;
    if (d.time != null || d.hour != null) state.time = d.time ?? d.hour;
    if (d.weather != null) state.weather = d.weather;

    if (d.speed != null || d.km != null || d.velocity != null) {
      state.speed = clamp(d.speed ?? d.km ?? d.velocity, 0, 999);
    }

    if (d.fuel != null || d.gas != null) {
      state.fuel = clamp(d.fuel ?? d.gas, 0, 100);
    }

    if (d.rpm != null) state.rpm = d.rpm;
    if (d.gear != null) state.gear = d.gear;

    if (d.show != null || d.hudIsActive != null) {
      state.show = !!(d.show ?? d.hudIsActive);
    }

    if (d.seatbelt != null || d.isSeatBelt != null) {
      state.seatbelt = !!(d.seatbelt ?? d.isSeatBelt);
    }

    if (d.engineOn != null || d.engine != null) {
      state.engineOn = d.engineOn != null ? !!d.engineOn : Number(d.engine) > 0;
    }

    if (d.doorOpen != null) state.doorOpen = !!d.doorOpen;
    if (d.isLock != null) state.isLock = !!d.isLock;

    if (d.talkIsActive != null || d.voiceLevel != null || d.voice != null) {
      state.voiceLevel = parseVoiceLevel(d.talkIsActive ?? d.voiceLevel ?? d.voice);
    }

    if (d.isTalking != null) state.isTalking = !!d.isTalking;
    if (d.inVehicle != null) state.inVehicle = !!d.inVehicle;

    render();
  });

  render();
})();
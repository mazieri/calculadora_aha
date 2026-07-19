/* ============================================================
   heart3d.js — Coração humano 3D animado (fundo fixo, tema escuro)
   Calculadora PREVENT™ pt-BR
   ------------------------------------------------------------
   Modelo: Human Reference Atlas / NIH Visible Human Female
           (CC BY 4.0 — ver web/assets/3d/ATTRIBUTION.md)
   Stack : three.js r185 vendorado em web/assets/3d/ (sem CDN).

   INTEGRAÇÃO (duas tags no <head>; NENHUM container no HTML):

     <script type="importmap">
       { "imports": { "three": "./assets/3d/three.module.min.js" } }
     </script>
     <script type="module" src="heart3d.js"></script>

     <!-- Camada de FALLBACK (renderizada pelo Jaspr, só o SVG): -->
     <div class="heart-bg" aria-hidden="true">
       <img class="heart-bg__fallback" src="assets/heart.svg" alt="" />
     </div>

   MONTAGEM (fora da árvore do Jaspr):
   - O próprio script cria <div id="heart3d-layer" class="heart3d-layer">
     e o insere como PRIMEIRO filho de <body>. O Jaspr nunca renderiza
     nem reconcilia esse elemento, então o canvas sobrevive à hidratação.
   - O fallback SVG da camada .heart-bg nasce ESCONDIDO via CSS e só
     reaparece se o script sinalizar falha (body.heart3d-failed).
   - Quando o modelo está pronto e renderizando, o script adiciona a
     classe .heart3d-ready ao <body>: é apenas um marcador de estado
     p/ devtools/testes (junto de window.__heart3d) — não há regra
     CSS para ela.
   - Idempotente: rodar 2x não duplica (guarda de boot + reuso da
     layer existente); se o canvas for removido do DOM, ele é
     re-anexado automaticamente no próximo frame.

   ROTA ATUAL → CSS:
   - document.body.dataset.route é mantido atualizado ('/' → 'home',
     '/doc' → 'doc'), inclusive em navegação client-side do SPA
     (hook em history.pushState/replaceState + popstate). O JS NÃO
     muda opacidade — quem faz o dimming é o CSS, via
     body[data-route="doc"] .heart3d-layer { … }.

   MOVIMENTO:
   - Modo NATURAL (padrão): sístole/diástole por região, via
     deslocamento de vértices ao longo da NORMAL injetado com
     onBeforeCompile no material do músculo (heart_mat). Faixa
     atrial (superior) contrai ~120 ms ANTES da ventricular
     (inferior), com amplitude ~1/3; artérias/veias têm amplitude
     própria (padrão 0). O scale global do grupo vira só um
     "respiro" sutil. Se o shader falhar, cai automaticamente
     para o batimento global clássico (lub-dub em scale).
   - Ciclo de 857 ms (~70 bpm) nos dois modos; desligado quando
     prefers-reduced-motion: reduce.

   COMO AJUSTAR: tudo fica no bloco CONFIG abaixo — enquadramento
   (fillH/fillW/ndcX/ndcY), batimento global (beat) e movimento
   natural (natural: amplitudes, fases, faixas de Y, modo
   'normal'|'radial', liga/desliga).
   ============================================================ */

import * as THREE from 'three';
import { GLTFLoader } from './assets/3d/jsm/loaders/GLTFLoader.js';
import { RoomEnvironment } from './assets/3d/jsm/environments/RoomEnvironment.js';

const CONFIG = {
  modelUrl: 'assets/3d/heart.glb',      // caminho relativo (deploy em subpath ok)
  layerId: 'heart3d-layer',             // container criado e controlado pelo JS
  readyClass: 'heart3d-ready',          // classe aplicada ao <body> quando o 3D assume
  failedClass: 'heart3d-failed',        // classe aplicada ao <body> quando o 3D falha (→ mostra fallback)
  bpm: 70,                              // ~batimento a 70 bpm (ciclo = 60000/bpm ≈ 857 ms)

  // --- Enquadramento no hero -------------------------------------
  // Coração grande, preenchendo a 1ª área: altura ≈ 88% da viewport,
  // âncora à esquerda (centro a ~32% da largura ⇒ 2/3 esq / 1/3 dir).
  fillH: 0.88,                          // altura do coração = 88% da viewport
  fillW: 0.55,                          // largura máx = 55% da viewport (trava mobile)
  ndcX: -0.36,                          // centro do coração em x: 32% da largura (NDC -1..1)
  ndcY: 0.0,                            // verticalmente centralizado
  fov: 35,
  accent: 0xe5484d,                     // acento do tema
  sway: { amplitude: 0.12, period: 14 },// rotação lenta e sutil (±7°, ciclo de 14 s)
  baseRotation: { x: 0.05, y: -0.5, z: 0.0 }, // pose 3/4 — ajuste fino do ângulo aqui

  // --- Batimento global (scale lub-dub no grupo) ------------------
  // Com o modo natural ativo, o protagonista é o movimento regional;
  // o scale global fica sutil (ampNatural × amplitude clássica).
  // ampClassic é usado quando o modo natural está desligado/falhou.
  beat: { ampNatural: 0.25, ampClassic: 1.0 },

  // --- Movimento NATURAL: sístole/diástole por região -------------
  // Deslocamento de vértices injetado via onBeforeCompile:
  //  - faixa ATRIAL = topo da malha do músculo (heart_mat), em Y local
  //  - faixa VENTRICULAR = resto (ápice), com fase atrasada e amp. maior
  //  - artérias/veias usam vesselAmp (uniforme, sem faixas)
  natural: {
    enabled: true,          // false → só o batimento global clássico
    mode: 'normal',         // 'normal' (ao longo da normal do vértice)
                            // | 'radial' (radial a partir do centro de massa
                            //   da faixa — use se a normal estalar/artefatar)
    ventAmp: 0.020,         // amplitude ventricular (unidades do modelo;
                            // altura do músculo ≈ 0.75 → ~2,7% de contração)
    atrAmp: 0.007,          // amplitude atrial (~1/3 da ventricular)
    vesselAmp: 0.0,         // artérias/veias: 0 = paradas (fisiológico)
    atrLeadMs: 120,         // sístole atrial começa 120 ms ANTES da ventricular
    ventStart: 0.24,        // início da sístole ventricular no ciclo (0..1;
                            // alinhado à subida do "dub" do lub-dub clássico)
    attack: 0.10,           // contração rápida: fração do ciclo até o pico
    release: 0.62,          // relaxamento termina nesta fração do ciclo
                            // (smoothstep: relaxa mais devagar que contrai)
    atrFrac: 0.30,          // % superior da malha do músculo = faixa atrial
    blendFrac: 0.12,        // largura da transição suave atrial↔ventricular
                            // (fração da altura do músculo)
    inward: true,           // true = contrai p/ dentro (sístole real encolhe)
  },
};

/* ------------------------------------------------------------
   Rota atual exposta ao CSS via document.body.dataset.route.
   Instalado no escopo do módulo (independe de WebGL/.heart-bg) e
   é idempotente — rodar 2x não duplica os hooks.
   ------------------------------------------------------------ */
function currentRoute() {
  const p = (location.pathname || '/').replace(/\/+$/, '') || '/';
  if (p === '/' || p === '/index.html') return 'home';
  if (p === '/doc' || p === '/doc.html') return 'doc';
  return p.replace(/^\//, '');
}

function syncRouteAttr() {
  if (document.body) document.body.dataset.route = currentRoute();
}

(function installRouteHooks() {
  const h = window.history;
  if (h.__heart3dRouteHooked) return;       // idempotente
  h.__heart3dRouteHooked = true;
  for (const m of ['pushState', 'replaceState']) {
    const orig = h[m];
    h[m] = function (...args) {
      const ret = orig.apply(this, args);
      syncRouteAttr();
      return ret;
    };
  }
  window.addEventListener('popstate', syncRouteAttr);
})();

syncRouteAttr(); // módulos ES são deferred; o <body> normalmente já existe

// Batimento lub-dub: 1 → 1.06 (lub) → 1.02 → 1.08 (dub) → 1 → pausa
const BEAT_KEYS = [
  [0.00, 1.00],
  [0.12, 1.06],   // lub  (~103 ms)
  [0.22, 1.02],   //      (~188 ms)
  [0.34, 1.08],   // dub  (~291 ms)
  [0.50, 1.00],   //      (~429 ms)
  [1.00, 1.00],   // pausa até o fim do ciclo
];

// amp escala a amplitude do scale global (1 = clássico; <1 = sutil)
function beatScale(t01, amp) {
  for (let i = 1; i < BEAT_KEYS.length; i++) {
    if (t01 <= BEAT_KEYS[i][0]) {
      const [t0, v0] = BEAT_KEYS[i - 1];
      const [t1, v1] = BEAT_KEYS[i];
      const u = (t01 - t0) / (t1 - t0);
      const e = u * u * (3 - 2 * u); // smoothstep
      return 1 + (v0 + (v1 - v0) * e - 1) * amp;
    }
  }
  return 1;
}

function webglAvailable() {
  try {
    const c = document.createElement('canvas');
    return !!(
      window.WebGLRenderingContext &&
      (c.getContext('webgl2') || c.getContext('webgl'))
    );
  } catch (e) {
    return false;
  }
}

/* Sinaliza ao CSS que o 3D falhou → o fallback SVG (escondido por
   padrão) é exibido. A classe vai no <body>, que o Jaspr não re-renderiza. */
function signalFailure(reason) {
  try {
    if (document.body) document.body.classList.add(CONFIG.failedClass);
  } catch (_) { /* sem body ainda — ignora */ }
  if (reason !== undefined) console.warn('[heart3d] fallback SVG ativo:', reason);
}

/* ------------------------------------------------------------
   GLSL injetado no material (modo natural).

   h3dPulse(ph): pulso assimétrico no ciclo — contração rápida
   (smoothstep 0→uH3dAttack) e relaxamento lento
   (smoothstep uH3dAttack→uH3dRelease, invertido).

   Faixas: peso atrial = smoothstep na altura Y local em torno de
   uH3dYTrans (±uH3dBlend); o complementar é o peso ventricular.
   ------------------------------------------------------------ */
const NATURAL_PARS = /* glsl */ `
uniform float uH3dOn;
uniform float uH3dAtrPh;
uniform float uH3dVentPh;
uniform float uH3dAtrAmp;
uniform float uH3dVentAmp;
uniform float uH3dVesselAmp;
uniform float uH3dYTrans;
uniform float uH3dBlend;
uniform float uH3dAttack;
uniform float uH3dRelease;
uniform float uH3dSign;
uniform vec3 uH3dAtrCenter;
uniform vec3 uH3dVentCenter;

float h3dPulse(float ph) {
  float up = smoothstep(0.0, uH3dAttack, ph);
  float down = 1.0 - smoothstep(uH3dAttack, uH3dRelease, ph);
  return up * down;
}
`;

// Músculo (heart_mat): peso por faixa de altura + fases distintas
const NATURAL_DISPLACE_MUSCLE = /* glsl */ `
{
  float h3dW = smoothstep(uH3dYTrans - uH3dBlend, uH3dYTrans + uH3dBlend, position.y);
  float h3dAmp = uH3dSign * uH3dOn * (
      h3dW * uH3dAtrAmp * h3dPulse(uH3dAtrPh) +
      (1.0 - h3dW) * uH3dVentAmp * h3dPulse(uH3dVentPh));
  #ifdef H3D_RADIAL
    vec3 h3dCenter = mix(uH3dVentCenter, uH3dAtrCenter, h3dW);
    vec3 h3dDelta = position - h3dCenter;
    transformed += h3dDelta / max(length(h3dDelta), 1e-4) * h3dAmp;
  #else
    transformed += objectNormal * h3dAmp;
  #endif
}
`;

// Vasos (artery_mat/vein_mat): amplitude uniforme (padrão 0), fase ventricular
const NATURAL_DISPLACE_VESSEL = /* glsl */ `
{
  float h3dAmp = uH3dSign * uH3dOn * uH3dVesselAmp * h3dPulse(uH3dVentPh);
  #ifdef H3D_RADIAL
    vec3 h3dDelta = position - uH3dVentCenter;
    transformed += h3dDelta / max(length(h3dDelta), 1e-4) * h3dAmp;
  #else
    transformed += objectNormal * h3dAmp;
  #endif
}
`;

/* ------------------------------------------------------------
   Layer própria, FORA da árvore gerenciada pelo Jaspr.
   Criada uma única vez como primeiro filho de <body>; se já
   existir (script rodou 2x), a existente é reutilizada.
   ------------------------------------------------------------ */
function ensureLayer() {
  let layer = document.getElementById(CONFIG.layerId);
  if (!layer) {
    layer = document.createElement('div');
    layer.id = CONFIG.layerId;
    layer.className = 'heart3d-layer';
    layer.setAttribute('aria-hidden', 'true');
    document.body.insertBefore(layer, document.body.firstChild);
  } else if (layer.parentNode !== document.body || document.body.firstChild !== layer) {
    // Se alguém moveu/re-anexou a layer, volta ela p/ o topo do <body>
    document.body.insertBefore(layer, document.body.firstChild);
  }
  return layer;
}

let booted = false; // guarda de idempotência: boot roda no máximo 1x

function boot() {
  if (booted) return;                      // script executado 2x → no-op
  booted = true;

  syncRouteAttr();                         // garante data-route mesmo sem 3D
  if (!document.body) return;              // segurança extra (módulo já é deferred)
  if (!document.querySelector('.heart-bg')) return; // página sem camada de fundo
  if (!webglAvailable()) { signalFailure('WebGL indisponível'); return; }

  const layer = ensureLayer();

  let renderer;
  try {
    renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true,                           // fundo transparente
      powerPreference: 'high-performance',
    });
  } catch (e) {
    layer.remove();                          // sem renderer → sem layer vazia
    signalFailure(e);
    return;
  }
  renderer.setClearColor(0x000000, 0);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.1;

  const canvas = renderer.domElement;
  layer.appendChild(canvas);

  // Se o contexto WebGL for perdido depois do boot (reset de GPU etc.),
  // o canvas morre silenciosamente — sinaliza falha p/ exibir o fallback SVG.
  canvas.addEventListener('webglcontextlost', (e) => {
    e.preventDefault();
    signalFailure('contexto WebGL perdido');
  });

  const scene = new THREE.Scene();

  // --- Iluminação (tema escuro: rim/fill em #e5484d + luz neutra) ---
  scene.add(new THREE.HemisphereLight(0x2e2e38, 0x0a0a0b, 0.9));

  const key = new THREE.DirectionalLight(0xfff1ec, 1.35); // luz neutra morna
  key.position.set(2.4, 1.8, 3.2);
  scene.add(key);

  const rim = new THREE.DirectionalLight(CONFIG.accent, 3.0); // rim vermelho atrás-esq
  rim.position.set(-3.6, 1.4, -2.2);
  scene.add(rim);

  const fill = new THREE.DirectionalLight(CONFIG.accent, 0.55); // fill sutil frente-esq
  fill.position.set(-2.2, -1.2, 2.6);
  scene.add(fill);

  // Ambiente PBR suave (especulares discretas no tecido)
  const pmrem = new THREE.PMREMGenerator(renderer);
  scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;
  pmrem.dispose();

  const camera = new THREE.PerspectiveCamera(CONFIG.fov, 1, 0.01, 100);

  // --- Hierarquia: posição (layout) > pose (tilt) > batimento > modelo ---
  const positionGroup = new THREE.Group();
  const tiltGroup = new THREE.Group();
  const beatGroup = new THREE.Group();
  positionGroup.add(tiltGroup);
  tiltGroup.add(beatGroup);
  scene.add(positionGroup);
  tiltGroup.rotation.set(
    CONFIG.baseRotation.x,
    CONFIG.baseRotation.y,
    CONFIG.baseRotation.z
  );

  let modelSize = new THREE.Vector3(1.07, 1.6, 0.86); // chute; refinado pós-load
  let ready = false;

  // --- Estado do movimento natural --------------------------------
  const n = CONFIG.natural;
  const cycleMs = 60000 / CONFIG.bpm;      // 857 ms

  // Uniforms COMPARTILHADOS entre os programas injetados (atualiza 1x/frame)
  const NU = {
    uH3dOn: { value: 0.0 },
    uH3dAtrPh: { value: 0.9 },             // fase parada (pulso = 0)
    uH3dVentPh: { value: 0.9 },
    uH3dAtrAmp: { value: n.atrAmp },
    uH3dVentAmp: { value: n.ventAmp },
    uH3dVesselAmp: { value: n.vesselAmp },
    uH3dYTrans: { value: 0.0 },            // calculado pós-load
    uH3dBlend: { value: 0.05 },            // calculado pós-load
    uH3dAttack: { value: n.attack },
    uH3dRelease: { value: n.release },
    uH3dSign: { value: n.inward ? -1.0 : 1.0 },
    uH3dAtrCenter: { value: new THREE.Vector3() },
    uH3dVentCenter: { value: new THREE.Vector3() },
  };

  // Materiais injetados + originais p/ restaurar no fallback
  const naturalState = { active: false, materials: [] };

  function disableNatural(reason) {
    if (!naturalState.active) return;
    naturalState.active = false;
    NU.uH3dOn.value = 0.0;
    for (const entry of naturalState.materials) {
      entry.mat.onBeforeCompile = entry.obc;
      if (entry.hadCpck) entry.mat.customProgramCacheKey = entry.cpck;
      else delete entry.mat.customProgramCacheKey;
      entry.mat.needsUpdate = true;        // recompila o shader original
    }
    console.warn(`[heart3d] movimento natural desativado (${reason}); ` +
      'usando o batimento global clássico (lub-dub em scale).');
    if (window.__heart3d) window.__heart3d.natural = false;
  }

  // Se o shader injetado falhar ao compilar, cai p/ o batimento global
  renderer.debug.onShaderError = (gl, program) => {
    disableNatural(`erro ao compilar shader: ${gl.getProgramInfoLog(program)}`);
  };

  // Injeta o deslocamento no material via onBeforeCompile.
  // kind: 'muscle' (faixas de Y + 2 fases) | 'vessel' (amp. uniforme)
  function injectNatural(mat, kind) {
    const entry = {
      mat,
      obc: mat.onBeforeCompile,
      hadCpck: Object.prototype.hasOwnProperty.call(mat, 'customProgramCacheKey'),
      cpck: mat.customProgramCacheKey,
    };
    const define = n.mode === 'radial' ? '#define H3D_RADIAL 1\n' : '';
    const displace =
      kind === 'muscle' ? NATURAL_DISPLACE_MUSCLE : NATURAL_DISPLACE_VESSEL;
    mat.onBeforeCompile = (shader) => {
      Object.assign(shader.uniforms, NU);
      shader.vertexShader =
        define +
        shader.vertexShader
          .replace('#include <common>', '#include <common>\n' + NATURAL_PARS)
          .replace('#include <begin_vertex>', '#include <begin_vertex>\n' + displace);
    };
    mat.customProgramCacheKey = () => `heart3d-natural-${kind}-${n.mode}`;
    mat.needsUpdate = true;
    naturalState.materials.push(entry);
  }

  function layout() {
    const w = layer.clientWidth || window.innerWidth;
    const h = layer.clientHeight || window.innerHeight;
    renderer.setSize(w, h);
    camera.aspect = w / h;

    const fovRad = THREE.MathUtils.degToRad(camera.fov);
    const fitH = modelSize.y / (2 * Math.tan(fovRad / 2)) / CONFIG.fillH;
    const fitW =
      modelSize.x / (2 * Math.tan(fovRad / 2) * camera.aspect) / CONFIG.fillW;
    const dist = Math.max(fitH, fitW);
    camera.position.set(0, 0, dist);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();

    const visH = 2 * dist * Math.tan(fovRad / 2);
    const visW = visH * camera.aspect;
    positionGroup.position.set(
      CONFIG.ndcX * (visW / 2),
      CONFIG.ndcY * (visH / 2),
      0
    );
  }

  function styleMaterials(root) {
    const styles = {
      heart_mat: { color: 0x8f1d22, roughness: 0.52, emissive: 0x2a0507, emissiveIntensity: 0.35 },
      artery_mat: { color: 0xd03436, roughness: 0.45, emissive: 0x200404, emissiveIntensity: 0.3 },
      vein_mat: { color: 0x3a5a7c, roughness: 0.5, emissive: 0x05070c, emissiveIntensity: 0.3 },
    };
    root.traverse((obj) => {
      if (!obj.isMesh) return;
      const mats = Array.isArray(obj.material) ? obj.material : [obj.material];
      for (const m of mats) {
        const s = styles[m.name];
        if (s) {
          m.color.setHex(s.color);
          m.roughness = s.roughness;
          m.metalness = 0.0;
          m.emissive.setHex(s.emissive);
          m.emissiveIntensity = s.emissiveIntensity;
        }
        m.envMapIntensity = 0.4;
        m.needsUpdate = true;
      }
    });
  }

  // Calcula a fronteira atrial↔ventricular (em Y local da malha do
  // músculo) e os centros de massa das duas faixas (modo 'radial').
  function setupNatural(model) {
    let yMin = Infinity;
    let yMax = -Infinity;
    const atr = new THREE.Vector3();
    const vent = new THREE.Vector3();
    let nAtr = 0;
    let nVent = 0;
    const v = new THREE.Vector3();

    // 1ª passada: bbox Y da(s) malha(s) do músculo
    model.traverse((obj) => {
      if (!obj.isMesh) return;
      const mats = Array.isArray(obj.material) ? obj.material : [obj.material];
      if (!mats.some((m) => m.name === 'heart_mat')) return;
      obj.geometry.computeBoundingBox();
      const bb = obj.geometry.boundingBox;
      yMin = Math.min(yMin, bb.min.y);
      yMax = Math.max(yMax, bb.max.y);
    });
    if (!(yMax > yMin)) return false;      // malha do músculo não achada

    const yTrans = yMax - n.atrFrac * (yMax - yMin);
    NU.uH3dYTrans.value = yTrans;
    NU.uH3dBlend.value = Math.max(n.blendFrac * (yMax - yMin), 1e-3);

    // 2ª passada: centros de massa das faixas (espaço local == cena;
    // os nós do GLB não têm transform próprio)
    model.traverse((obj) => {
      if (!obj.isMesh) return;
      const mats = Array.isArray(obj.material) ? obj.material : [obj.material];
      if (!mats.some((m) => m.name === 'heart_mat')) return;
      const pos = obj.geometry.attributes.position;
      for (let i = 0; i < pos.count; i++) {
        v.fromBufferAttribute(pos, i);
        if (v.y > yTrans) { atr.add(v); nAtr++; }
        else { vent.add(v); nVent++; }
      }
    });
    if (nAtr) NU.uH3dAtrCenter.value.copy(atr.multiplyScalar(1 / nAtr));
    if (nVent) NU.uH3dVentCenter.value.copy(vent.multiplyScalar(1 / nVent));

    // Injeta: músculo com faixas/fases; vasos com amplitude própria
    model.traverse((obj) => {
      if (!obj.isMesh) return;
      const mats = Array.isArray(obj.material) ? obj.material : [obj.material];
      for (const m of mats) {
        if (m.name === 'heart_mat') injectNatural(m, 'muscle');
        else if (m.name === 'artery_mat' || m.name === 'vein_mat') injectNatural(m, 'vessel');
      }
    });
    return naturalState.materials.length > 0;
  }

  new GLTFLoader().load(
    CONFIG.modelUrl,
    (gltf) => {
      const model = gltf.scene;
      styleMaterials(model);
      beatGroup.add(model);

      const box = new THREE.Box3().setFromObject(beatGroup);
      box.getSize(modelSize);

      // Modo natural: injeta deslocamento por região no(s) material(is)
      if (n.enabled) {
        try {
          naturalState.active = setupNatural(model);
        } catch (e) {
          naturalState.active = false;
          console.warn('[heart3d] falha ao preparar o movimento natural:', e);
        }
      }

      ready = true;
      layout();
      // Marcador de estado p/ devtools/testes (junto de window.__heart3d).
      // Não há regra CSS para .heart3d-ready: o fallback SVG nasce
      // escondido e só reaparece via body.heart3d-failed. A classe vai
      // no <body>, que o Jaspr não re-renderiza.
      document.body.classList.add(CONFIG.readyClass);
      window.__heart3d = {
        ready: true,
        natural: naturalState.active,      // hook p/ validação
        mode: naturalState.active ? n.mode : 'global',
        route: currentRoute(),
      };
    },
    undefined,
    (err) => {
      signalFailure(err);
      window.__heart3d = { ready: false, error: String(err) };
    }
  );

  // --- Movimento: regional (natural) + batimento global + sway ---
  const motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
  const t0 = performance.now();
  let rafId = 0;

  // Hook de teste/CI: ?heart3dframes=N renderiza N frames e para o loop
  // (determinístico p/ screenshot headless; 0/ausente = loop infinito).
  const maxFrames =
    parseInt(new URLSearchParams(location.search).get('heart3dframes') || '0', 10) || 0;
  let frameCount = 0;

  const frac = (x) => ((x % 1) + 1) % 1;

  function frame(now) {
    if (maxFrames > 0 && frameCount >= maxFrames) {
      rafId = 0; // para o loop após N frames RENDERIZADOS
    } else {
      rafId = requestAnimationFrame(frame);
    }
    if (!ready || document.hidden) return;
    frameCount++;

    // Auto-recuperação: se o canvas sumiu do DOM por qualquer motivo,
    // re-anexa na layer (e recria a layer se ela também sumiu).
    if (!canvas.isConnected) {
      ensureLayer().appendChild(canvas);
    }

    const elapsed = now - t0;

    if (motionQuery.matches) {
      beatGroup.scale.setScalar(1);
      tiltGroup.rotation.y = CONFIG.baseRotation.y;
      NU.uH3dOn.value = 0.0;               // congela o deslocamento regional
    } else {
      const t01 = (elapsed % cycleMs) / cycleMs;
      // Scale global: sutil quando o modo natural está ativo
      const amp = naturalState.active ? CONFIG.beat.ampNatural : CONFIG.beat.ampClassic;
      beatGroup.scale.setScalar(beatScale(t01, amp));

      if (naturalState.active) {
        // Fases do ciclo: sístole atrial antecede a ventricular em atrLeadMs
        const lead = n.atrLeadMs / cycleMs;   // 120 ms / 857 ms ≈ 0.14
        NU.uH3dVentPh.value = frac(t01 - n.ventStart);
        NU.uH3dAtrPh.value = frac(t01 - n.ventStart + lead);
        NU.uH3dOn.value = 1.0;
      }

      const sway =
        Math.sin((elapsed / 1000) * ((2 * Math.PI) / CONFIG.sway.period)) *
        CONFIG.sway.amplitude;
      tiltGroup.rotation.y = CONFIG.baseRotation.y + sway;
    }
    renderer.render(scene, camera);
  }

  function start() {
    if (!rafId) rafId = requestAnimationFrame(frame);
  }
  function stop() {
    cancelAnimationFrame(rafId);
    rafId = 0;
  }

  const onMotionPrefChange = () => {
    beatGroup.scale.setScalar(1);
    NU.uH3dOn.value = 0.0;
  };
  if (motionQuery.addEventListener) motionQuery.addEventListener('change', onMotionPrefChange);
  else if (motionQuery.addListener) motionQuery.addListener(onMotionPrefChange); // Safari < 14
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) stop();
    else start();
  });

  let resizeTimer = 0;
  window.addEventListener('resize', () => {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(layout, 60);
  });

  layout();
  start();
}

// Módulos ES são deferred por padrão (documento já parseado), mas se o
// script for carregado de outra forma, aguarda o <body> existir.
if (document.body) {
  boot();
} else {
  document.addEventListener('DOMContentLoaded', boot, { once: true });
}

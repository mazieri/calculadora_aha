# Atribuição — Modelo 3D do coração (`heart.glb`)

## Obra original

- **Nome:** VH_F_Heart + VH_F_Blood_Vasculature_Heart (v1.2) — *3D Reference Object for the Female Heart*,
  parte da **Human Reference Atlas (HRA) — CCF 3D Reference Object Library**, derivada dos dados do
  **NIH Visible Human Project® (Visible Human Female)**.
- **Autora/Instituição:** HuBMAP Consortium / Cyberinfrastructure for Network Science Center (CNS),
  Indiana University (Human Reference Atlas). Dados-fonte: U.S. National Library of Medicine, NIH.
- **Página de origem:** https://humanatlas.io/3d-reference-library
- **Repositório/fonte do arquivo:** https://github.com/hubmapconsortium/ccf-3d-reference-object-library
  - `VH_Female/v1.2/VH_F_Heart.glb`
  - `VH_Female/v1.2/VH_F_Blood_Vasculature_Heart.glb`
- **Licença:** **Creative Commons Attribution 4.0 International (CC BY 4.0)**
  - Texto da licença: https://creativecommons.org/licenses/by/4.0/
  - LICENSE do repositório-fonte: https://github.com/hubmapconsortium/ccf-3d-reference-object-library/blob/main/LICENSE

## Modificações realizadas neste projeto

- Fusão dos dois modelos (câmaras/valvas + vasos) em um único `heart.glb`.
- Remoção dos segmentos longos da aorta descendente (`VH_F_descending_aorta_b`) e da veia cava
  inferior (`VH_F_inferior_vena_cava_b`) para enquadrar a silhueta do coração.
- Recentralização no ponto de origem e normalização de escala (maior dimensão = 1,6 unidades).
- Cores de material reajustadas em runtime pelo `web/heart3d.js` para o tema escuro do site.

## Texto de crédito sugerido para o site (pt-BR)

> Modelo 3D do coração: Human Reference Atlas (HuBMAP Consortium / CNS, Indiana University),
> a partir de dados do NIH Visible Human Project — licença CC BY 4.0.

---

# Bibliotecas vendoradas (em `web/assets/3d/`)

- **three.js r185 (0.185.1)** — `three.core.min.js`, `three.module.min.js`,
  `jsm/loaders/GLTFLoader.js`, `jsm/utils/BufferGeometryUtils.js`, `jsm/utils/SkeletonUtils.js`,
  `jsm/environments/RoomEnvironment.js`
  - Fonte: https://github.com/mrdoob/three.js (pacote npm `three@0.185.1`, via jsDelivr)
  - Licença: **MIT** (cabeçalho de licença preservado nos arquivos)

# Calculadora PREVENT™ pt-BR

> ⚠️ **Projeto educacional e NÃO oficial.** Esta é uma tradução e adaptação
> educacional em português (Brasil) da calculadora **PREVENT™** da American
> Heart Association (AHA). Não tem vínculo, endosso ou aprovação da AHA.
> A calculadora oficial está disponível em:
> <https://professional.heart.org/en/guidelines-and-statements/prevent-calculator>

## O que a calculadora faz

As equações **PREVENT** (Predicting Risk of cardiovascular disease EVENTs)
estimam o risco de doença cardiovascular em três desfechos:

- **DCV total** (doença cardiovascular total)
- **ASCVD** (doença cardiovascular aterosclerótica)
- **IC** (insuficiência cardíaca)

em dois horizontes temporais: **10 anos** e **30 anos** (o horizonte de 30 anos
é estimado apenas para idades até 59 anos).

As equações foram validadas para **adultos de 30 a 79 anos sem doença
cardiovascular prévia** (prevenção primária). Pessoas com DCV já estabelecida
estão em prevenção secundária e as equações não se aplicam.

## Como rodar localmente

Pré-requisitos: [Dart SDK](https://dart.dev/get-dart) (3.10+) e a CLI do Jaspr:

```bash
dart pub global activate jaspr_cli
dart pub get
```

Servidor de desenvolvimento:

```bash
jaspr serve
```

O site fica disponível em `http://localhost:8080`.

## Build de produção

```bash
jaspr build
```

O site estático é gerado em `build/jaspr/` (Jaspr 0.23 em modo `static`).

## Testes

```bash
dart test
```

Os testes validam o motor de cálculo contra vetores publicados do pacote
`preventr` (CRAN), um gabarito independente validado contra a calculadora
oficial da AHA.

## Deploy

O deploy é feito automaticamente no **GitHub Pages** pelo workflow
`.github/workflows/deploy.yml` a cada push na branch `main` (ou manualmente
via *workflow dispatch*). O build usa `jaspr build` e publica o conteúdo de
`build/jaspr/`.

**Pré-requisito:** no repositório do GitHub, habilite o Pages em
*Settings → Pages → Build and deployment → Source: GitHub Actions*.

## Estrutura do projeto

```
lib/
  app.dart            # Componente raiz da página
  engine/             # Motor de cálculo (equações PREVENT, CKD-EPI 2021, IMC)
  components/         # Componentes da UI (hero, formulário, resultados, rodapé)
web/
  main.dart           # Entry point do site estático
  assets/             # Assets (SVG do coração etc.)
  *.css               # Estilos
test/                 # Testes do motor (vetores do pacote preventr)
docs/                 # Documentação técnica adicional
.github/workflows/    # CI/CD (deploy no GitHub Pages)
```

## Fontes científicas

- **Equações PREVENT (desenvolvimento e validação):** Khan SS, Matsushita K,
  Sang Y, et al. Development and Validation of the American Heart Association
  Predicting Risk of cardiovascular disease EVENTs (PREVENT) Equations.
  *Circulation*. 2024;149:430–449.
  DOI: [10.1161/CIRCULATIONAHA.123.067626](https://doi.org/10.1161/CIRCULATIONAHA.123.067626)
- **Declaração científica PREVENT (2023):** Khan SS, Coresh J, Pencina MJ,
  et al. Novel Prediction Equations for Absolute Risk Assessment of Total
  Cardiovascular Disease Incorporating Cardiovascular-Kidney-Metabolic Health:
  A Scientific Statement From the American Heart Association. *Circulation*.
  2023;148:1982–2004.
  DOI: [10.1161/CIRCULATIONAHA.123.067476](https://doi.org/10.1161/CIRCULATIONAHA.123.067476)
- **Equação CKD-EPI 2021 (eGFR, creatinina, sem raça):** Inker LA, Eneanya ND,
  Coresh J, et al. New Creatinine- and Cystatin C–Based Equations to Estimate
  GFR without Race. *N Engl J Med*. 2021;385:1737–1749.
  DOI: [10.1056/NEJMoa2102953](https://doi.org/10.1056/NEJMoa2102953)
- **Guideline de hipertensão 2025 (AHA/ACC)** — referência para o limiar de
  risco de 7,5% em 10 anos utilizado na interpretação das categorias.
- **Coeficientes e implementação de referência:** repositório oficial da AHA
  [AHA-DS-Analytics/PREVENT](https://github.com/AHA-DS-Analytics/PREVENT) e
  pacote R [`preventr`](https://cran.r-project.org/package=preventr) (CRAN).

## Nota sobre o SDI

O modelo PREVENT completo inclui o *Social Deprivation Index* (SDI), um índice
baseado em dados censitários **dos Estados Unidos**. O SDI **não se aplica a
pessoas fora dos EUA** e, por isso, esta calculadora usa o modelo sem o ajuste
de SDI (equivalente ao cálculo oficial quando o CEP não é informado).

## Disclaimer médico

Esta ferramenta tem **finalidade exclusivamente educacional e informativa**.
Ela **não** é um dispositivo médico, **não** substitui avaliação clínica,
diagnóstico ou tratamento por profissional de saúde qualificado, e **não**
emite recomendações terapêuticas. As estimativas de risco são probabilidades
populacionais e podem não refletir o risco individual. Não inicie, interrompa
ou altere qualquer medicação com base nestes resultados. Em caso de dúvidas
sobre sua saúde cardiovascular, procure um médico. Em situação de emergência,
procure atendimento médico imediato.

---

PREVENT™ é uma marca da American Heart Association. Este projeto é uma
tradução/adaptação educacional independente e sem fins comerciais.

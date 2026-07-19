/// Conteúdo da página /doc — documentação oficial da calculadora PREVENT™.
///
/// AUTORIA: todo o conteúdo original (inglês) é de autoria da
/// American Heart Association (AHA), transcrito das páginas oficiais
/// (acesso em 18/07/2026):
/// - Calculadora PREVENT (seções abaixo da calculadora):
///   https://professional.heart.org/en/guidelines-and-statements/prevent-risk-calculator/prevent-calculator
/// - Sobre a calculadora PREVENT:
///   https://professional.heart.org/en/guidelines-and-statements/about-prevent-calculator
/// - FAQ das equações PREVENT (PDF):
///   https://professional.heart.org/en/-/media/PHD-Files/Guidelines-and-Statements/PREVENT/PREVENT-FAQs-FINAL-082825.pdf
///
/// A versão em português (pt-BR) é uma tradução educacional NÃO OFICIAL,
/// sem qualquer afiliação com a AHA. Em caso de dúvida, prevalece o
/// original em inglês nas páginas oficiais.
library;

/// Par de textos: original em inglês [en] e tradução pt-BR [pt].
class DocText {
  const DocText(this.en, this.pt);

  final String en;
  final String pt;
}

/// Bloco de conteúdo de uma seção: parágrafo único ou lista de bullets.
class DocBlock {
  const DocBlock.paragraph(this.paragraph) : bullets = const [];

  const DocBlock.bullets(this.bullets) : paragraph = null;

  final DocText? paragraph;
  final List<DocText> bullets;

  bool get isBullets => paragraph == null;
}

/// Seção da documentação (ancorável via [id]).
class DocSection {
  const DocSection({required this.id, required this.title, required this.blocks});

  final String id;
  final DocText title;
  final List<DocBlock> blocks;
}

/// Fonte bibliográfica (com link opcional — sem link vira texto puro).
class DocSource {
  const DocSource({required this.label, this.url});

  final DocText label;
  final String? url;
}

/// URL oficial da calculadora PREVENT (AHA).
const officialCalculatorUrl =
    'https://professional.heart.org/en/guidelines-and-statements/prevent-risk-calculator/prevent-calculator';

/// URL oficial da página "About PREVENT" (AHA).
const officialAboutUrl = 'https://professional.heart.org/en/guidelines-and-statements/about-prevent-calculator';

/// URL oficial do PDF de FAQ das equações PREVENT (AHA).
const officialFaqUrl =
    'https://professional.heart.org/en/-/media/PHD-Files/Guidelines-and-Statements/PREVENT/PREVENT-FAQs-FINAL-082825.pdf';

/// Rótulo da seção de fontes (índice + título da seção na página /doc).
const docTextSources = DocText('Sources', 'Fontes');

/// Rótulo acessível dos botões "voltar ao topo" na página /doc.
const docTextBackToTop = DocText('Back to top', 'Voltar ao topo');

/// Aviso de autoria/tradução exibido no topo da página /doc.
const docAttribution = DocText(
  'Content originally published by the American Heart Association (AHA) '
      'on the official pages linked below. The English text shown here is a '
      'transcription of the original; the pt-BR version is an unofficial, '
      'educational translation with no affiliation to the AHA. Whenever in '
      'doubt, the original English content on the official pages prevails.',
  'Conteúdo originalmente publicado pela American Heart Association (AHA) '
      'nas páginas oficiais indicadas abaixo. O texto em inglês exibido aqui é '
      'uma transcrição do original; a versão em português (pt-BR) é uma '
      'tradução educacional NÃO OFICIAL, sem qualquer afiliação com a AHA. '
      'Em caso de dúvida, prevalece o conteúdo original em inglês nas páginas '
      'oficiais.',
);

/// Seções da documentação (original em inglês + tradução pt-BR).
const docSections = <DocSection>[
  // ------------------------------------------------------------------
  DocSection(
    id: 'o-que-e',
    title: DocText('What is PREVENT?', 'O que é o PREVENT?'),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'Developed in 2023, the American Heart Association Predicting Risk '
              'of cardiovascular disease EVENTs (PREVENT™) equations estimate '
              '10-year and 30-year risk for total cardiovascular disease (CVD), '
              'including atherosclerotic CVD (ASCVD) and heart failure (HF) with '
              'outcome-specific equations. It is the first risk tool that '
              'combines cardiovascular, kidney, and metabolic health measurements '
              'to support primary prevention-focused treatment decisions.',
          'Desenvolvidas em 2023, as equações PREVENT™ (Predicting Risk of '
              'cardiovascular disease EVENTs) da American Heart Association '
              'estimam o risco em 10 e 30 anos de doença cardiovascular (DCV) '
              'total, incluindo DCV aterosclerótica (ASCVD) e insuficiência '
              'cardíaca (IC), com equações específicas por desfecho. É a '
              'primeira ferramenta de risco que combina medidas de saúde '
              'cardiovascular, renal e metabólica para apoiar decisões de '
              'tratamento voltadas à prevenção primária.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations were derived and validated using data from '
              'over 6.5 million adults across multiple datasets from all over the '
              'U.S. The derivation samples included patients receiving care at '
              'multiple health systems (Optum, Geisinger) and population-based '
              'cohorts or research studies (Atherosclerosis Risk in Communities, '
              'Cardiovascular Health Study, Coronary Artery Risk Development in '
              'Young Adults, Jackson Heart Study, Framingham Heart Study, '
              'Multi-Ethnic Study of Atherosclerosis). It is validated for adults '
              'ages 30–79 years who do not have a history of CVD.',
          'As equações PREVENT foram derivadas e validadas com dados de mais '
              'de 6,5 milhões de adultos, em múltiplos conjuntos de dados de '
              'todos os Estados Unidos. As amostras de derivação incluíram '
              'pacientes atendidos em vários sistemas de saúde (Optum, Geisinger) '
              'e coortes populacionais ou estudos de pesquisa (Atherosclerosis '
              'Risk in Communities, Cardiovascular Health Study, Coronary Artery '
              'Risk Development in Young Adults, Jackson Heart Study, Framingham '
              'Heart Study e Multi-Ethnic Study of Atherosclerosis). As equações '
              'são validadas para adultos de 30 a 79 anos sem histórico de DCV.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations are designed to estimate cardiovascular '
              'disease risk based on cardiovascular, kidney and metabolic health '
              'factors, and aim to help clinicians assess cardiovascular disease '
              'risk and facilitate clinician-patient discussions to optimize '
              'primary prevention of cardiovascular disease, which includes the '
              'prevention of atherosclerotic cardiovascular disease and heart '
              'failure.',
          'As equações PREVENT foram concebidas para estimar o risco de '
              'doença cardiovascular a partir de fatores de saúde cardiovascular, '
              'renal e metabólica, e visam ajudar profissionais de saúde a '
              'avaliar o risco cardiovascular e facilitar a conversa entre '
              'profissional e paciente, de modo a otimizar a prevenção primária '
              'da doença cardiovascular — o que inclui a prevenção da doença '
              'cardiovascular aterosclerótica e da insuficiência cardíaca.',
        ),
      ),
      DocBlock.bullets([
        DocText(
          'The PREVENT equations are based on contemporary data from more '
              'than 6.5 million diverse U.S. adults and are more applicable to '
              'the general U.S. population than previous tools.',
          'As equações PREVENT são baseadas em dados contemporâneos de mais '
              'de 6,5 milhões de adultos norte-americanos diversos e são mais '
              'aplicáveis à população geral dos EUA do que as ferramentas '
              'anteriores.',
        ),
        DocText(
          'The equations can estimate 10-year and 30-year risk for total '
              'cardiovascular disease in people from ages 30-79 without known '
              'cardiovascular disease.',
          'As equações estimam o risco em 10 e 30 anos de doença '
              'cardiovascular total em pessoas de 30 a 79 anos sem doença '
              'cardiovascular conhecida.',
        ),
        DocText(
          'PREVENT includes kidney and metabolic health factors in the '
              'equations for a more comprehensive and precise estimation of risk '
              'compared with previous tools.',
          'O PREVENT inclui fatores de saúde renal e metabólica nas '
              'equações, permitindo uma estimativa de risco mais abrangente e '
              'precisa em comparação com as ferramentas anteriores.',
        ),
        DocText(
          'These equations are intended for use by clinicians to inform '
              'clinician-patient discussions and guide primary '
              'prevention-focused treatment decisions in alignment with the '
              'latest relevant clinical guidelines.',
          'Essas equações destinam-se ao uso por profissionais de saúde, '
              'para embasar a conversa profissional–paciente e orientar decisões '
              'de tratamento focadas em prevenção primária, em alinhamento com '
              'as diretrizes clínicas relevantes mais recentes.',
        ),
      ]),
    ],
  ),

  // ------------------------------------------------------------------
  DocSection(
    id: 'como-usar',
    title: DocText(
      'How to use and interpret the results',
      'Como usar e interpretar os resultados',
    ),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations estimate absolute 10-year and 30-year risk '
              'for total CVD (PREVENT-CVD), ASCVD (PREVENT-ASCVD) and HF '
              '(PREVENT-HF).',
          'As equações PREVENT estimam o risco absoluto em 10 e 30 anos de '
              'DCV total (PREVENT-CVD), ASCVD (PREVENT-ASCVD) e IC (PREVENT-HF).',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'This tool is designed for use by clinicians. For accurate results '
              'and appropriate interpretation, risk should be calculated using '
              'your actual, up-to-date clinical information from recent '
              'laboratory tests and evaluations performed by a clinician. The '
              'PREVENT equations are intended to inform clinician–patient '
              'discussions and guide primary prevention-focused treatment '
              'decisions in alignment with the latest relevant clinical '
              'guidelines.',
          'Esta ferramenta foi concebida para uso por profissionais de '
              'saúde. Para resultados precisos e interpretação adequada, o risco '
              'deve ser calculado com as informações clínicas reais e '
              'atualizadas, provenientes de exames laboratoriais e avaliações '
              'recentes realizados por um profissional de saúde. As equações '
              'PREVENT destinam-se a embasar a conversa profissional–paciente e '
              'a orientar decisões de tratamento focadas em prevenção primária, '
              'em alinhamento com as diretrizes clínicas relevantes mais '
              'recentes.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The risk estimate provided by the PREVENT calculator reflects the '
              'likelihood that a person with similar risk factors will develop '
              'the specified cardiovascular outcome over the next 10 or 30 '
              'years. To aid in understanding, risk may be framed as “X out of '
              '100 people like you may develop CVD over the next 10 or 30 years” '
              'and should be paired with an explanation that cardiovascular risk '
              'is modifiable. Whenever possible or available, these discussions '
              'should include specific, guideline-based prevention strategies.',
          'A estimativa de risco fornecida pela calculadora PREVENT reflete '
              'a probabilidade de uma pessoa com fatores de risco semelhantes '
              'desenvolver o desfecho cardiovascular especificado nos próximos '
              '10 ou 30 anos. Para facilitar a compreensão, o risco pode ser '
              'apresentado como “X em cada 100 pessoas como você podem '
              'desenvolver DCV nos próximos 10 ou 30 anos”, sempre acompanhado '
              'da explicação de que o risco cardiovascular é modificável. Sempre '
              'que possível, essas conversas devem incluir estratégias '
              'específicas de prevenção baseadas em diretrizes.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations estimate CVD risk using required clinical '
              'information at the current encounter. When input predictors are '
              'changed with treatment (e.g., initiation of blood pressure '
              'medication or statin therapy), the PREVENT equations are not '
              'intended to calculate change in risk.',
          'As equações PREVENT estimam o risco de DCV a partir das '
              'informações clínicas obrigatórias da avaliação atual. Quando os '
              'preditores de entrada mudam com o tratamento (por exemplo, início '
              'de anti-hipertensivo ou estatina), as equações PREVENT não se '
              'destinam a calcular a variação do risco.',
        ),
      ),
    ],
  ),

  // ------------------------------------------------------------------
  DocSection(
    id: 'entradas',
    title: DocText(
      'Required and optional inputs',
      'Entradas obrigatórias e opcionais',
    ),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'The PREVENT calculator, based on the PREVENT equations, uses '
              'required clinical information to estimate risk of CVD. When any '
              'of the required variables (including sex, age, total cholesterol, '
              'HDL cholesterol, systolic blood pressure, BMI, eGFR, diabetes, '
              'current smoking status, antihypertensive use, and lipid-lowering '
              'therapy use) are missing or out-of-range, the calculator will not '
              'generate a risk estimate.',
          'A calculadora PREVENT, baseada nas equações PREVENT, utiliza '
              'informações clínicas obrigatórias para estimar o risco de DCV. '
              'Quando qualquer uma das variáveis obrigatórias (incluindo sexo, '
              'idade, colesterol total, colesterol HDL, pressão arterial '
              'sistólica, IMC, eGFR, diabetes, tabagismo atual, uso de '
              'anti-hipertensivos e uso de terapia hipolipemiante) está ausente '
              'ou fora da faixa, a calculadora não gera uma estimativa de risco.',
        ),
      ),
      DocBlock.bullets([
        DocText('Sex', 'Sexo'),
        DocText('Age', 'Idade'),
        DocText('Total cholesterol', 'Colesterol total'),
        DocText('HDL cholesterol', 'Colesterol HDL'),
        DocText('Systolic blood pressure', 'Pressão arterial sistólica'),
        DocText('Body mass index (BMI)', 'Índice de massa corporal (IMC)'),
        DocText(
          'Estimated glomerular filtration rate (eGFR)',
          'Taxa de filtração glomerular estimada (eGFR)',
        ),
        DocText('Diabetes', 'Diabetes'),
        DocText('Current smoking status', 'Tabagismo atual'),
        DocText(
          'Antihypertensive medication use',
          'Uso de anti-hipertensivos',
        ),
        DocText(
          'Lipid-lowering therapy use',
          'Uso de terapia hipolipemiante',
        ),
      ]),
      DocBlock.paragraph(
        DocText(
          'The following three predictors, urine albumin-creatinine ratio '
              '(UACR), hemoglobin A1c (HbA1c), and social deprivation index '
              '(SDI), are optional and can further personalize the risk '
              'estimate. If these values are not available, the calculator will '
              'still provide a risk estimate using the required inputs only.',
          'Os três preditores a seguir — relação albumina-creatinina '
              'urinária (UACR), hemoglobina glicada (HbA1c) e índice de privação '
              'social (SDI) — são opcionais e podem personalizar ainda mais a '
              'estimativa de risco. Se esses valores não estiverem disponíveis, '
              'a calculadora ainda fornecerá uma estimativa de risco usando '
              'apenas as entradas obrigatórias.',
        ),
      ),
      DocBlock.bullets([
        DocText(
          'Urine albumin-creatinine ratio (UACR)',
          'Relação albumina-creatinina urinária (UACR)',
        ),
        DocText('Hemoglobin A1c (HbA1c)', 'Hemoglobina glicada (HbA1c)'),
        DocText(
          'Social deprivation index (SDI) — based on ZIP code; only '
              'applicable to adults living in the U.S.',
          'Índice de privação social (SDI) — baseado no CEP (ZIP code); '
              'aplicável apenas a adultos que vivem nos Estados Unidos',
        ),
      ]),
      DocBlock.paragraph(
        DocText(
          'The PREVENT calculator uses U.S. standard units to predict risk '
              '(e.g., mg/dL for cholesterol). Please convert SI units into U.S. '
              'standard units prior to use.',
          'A calculadora PREVENT utiliza unidades padrão dos Estados Unidos '
              'para estimar o risco (por exemplo, mg/dL para colesterol). '
              'Converta unidades do Sistema Internacional (SI) para as unidades '
              'padrão dos EUA antes de usar.',
        ),
      ),
    ],
  ),

  // ------------------------------------------------------------------
  DocSection(
    id: 'desfechos',
    title: DocText(
      'Outcomes and time horizons',
      'Desfechos e horizontes de tempo',
    ),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations provide separate outcome-specific 10-year '
              'and 30-year risk estimates for total cardiovascular disease '
              '(PREVENT-CVD), atherosclerotic cardiovascular disease '
              '(PREVENT-ASCVD), and heart failure (PREVENT-HF) to support shared '
              'decision-making about preventive care. The default setting is to '
              'display the PREVENT-CVD results. Each outcome may be displayed '
              'separately by selecting that outcome. Because ASCVD and HF are '
              'modeled independently, their combined risk may be higher than the '
              'total CVD estimate.',
          'As equações PREVENT fornecem estimativas de risco separadas e '
              'específicas por desfecho, em 10 e 30 anos, para doença '
              'cardiovascular total (PREVENT-CVD), doença cardiovascular '
              'aterosclerótica (PREVENT-ASCVD) e insuficiência cardíaca '
              '(PREVENT-HF), apoiando a tomada de decisão compartilhada sobre '
              'cuidados preventivos. A configuração padrão exibe os resultados '
              'do PREVENT-CVD; cada desfecho pode ser exibido separadamente ao '
              'selecioná-lo. Como ASCVD e IC são modelados de forma '
              'independente, a soma de seus riscos pode ser maior do que a '
              'estimativa de DCV total.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'Outcomes represent incident fatal or non-fatal myocardial '
              'infarction, stroke, and heart failure.',
          'Os desfechos representam infarto do miocárdio fatal ou não fatal '
              'incidente, acidente vascular cerebral (AVC) e insuficiência '
              'cardíaca.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'For total CVD risk estimated using the PREVENT-CVD equations, no '
              'formal cutoffs or thresholds have been established to define high '
              '30-year risk in current guidelines. The PREVENT equations can be '
              'used to estimate long-term CVD risk and support clinician–patient '
              'discussions about prevention strategies and current '
              'guideline-directed prevention recommendations.',
          'Para o risco de DCV total estimado pelas equações PREVENT-CVD, '
              'não foram estabelecidos pontos de corte ou limiares formais para '
              'definir risco alto em 30 anos nas diretrizes atuais. As equações '
              'PREVENT podem ser usadas para estimar o risco cardiovascular de '
              'longo prazo e apoiar a conversa profissional–paciente sobre '
              'estratégias de prevenção e as recomendações preventivas vigentes '
              'baseadas em diretrizes.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The PREVENT calculator now provides an estimated PREVENT-Age, '
              'which translates an individual’s predicted cardiovascular risk '
              'into an equivalent “risk age” or “heart age” based on the '
              'PREVENT-CVD equations. When PREVENT-Age exceeds chronological '
              'age, this suggests a higher-than-expected predicted '
              'cardiovascular risk relative to peers of the same age; when '
              'PREVENT-Age is lower, this suggests a more favorable risk '
              'profile. It also reports age- and sex-specific percentiles for '
              '30-year PREVENT-CVD risk to provide population-based context for '
              'absolute risk estimates. Both are intended to complement absolute '
              'risk estimates, are only valid for the base equations, and may '
              'help facilitate clinician–patient discussions.',
          'A calculadora PREVENT passou a fornecer também a estimativa de '
              'PREVENT-Age, que traduz o risco cardiovascular previsto de uma '
              'pessoa em uma “idade de risco” ou “idade do coração” equivalente, '
              'com base nas equações PREVENT-CVD. Quando a PREVENT-Age supera a '
              'idade cronológica, isso sugere um risco cardiovascular previsto '
              'maior do que o esperado em relação a pessoas da mesma idade; '
              'quando é menor, sugere um perfil de risco mais favorável. A '
              'calculadora também informa percentis específicos por idade e sexo '
              'para o risco de PREVENT-CVD em 30 anos, dando contexto '
              'populacional às estimativas de risco absoluto. Ambos os recursos '
              'visam complementar as estimativas de risco absoluto, são válidos '
              'apenas para as equações base e podem facilitar a conversa '
              'profissional–paciente.',
        ),
      ),
    ],
  ),

  // ------------------------------------------------------------------
  DocSection(
    id: 'categorias',
    title: DocText(
      'Risk categories and guideline thresholds',
      'Categorias de risco e limiares das diretrizes',
    ),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'The 2025 AHA/ACC High Blood Pressure Guideline recommends using '
              'the PREVENT-CVD outcome specific equation to estimate 10-year '
              'risk of total CVD to inform management decisions for Stage 1 '
              'hypertension (systolic blood pressure 130–139 mm Hg or diastolic '
              'blood pressure 80–89 mm Hg) among adults without known CVD, '
              'diabetes, or chronic kidney disease. For adults with Stage 1 '
              'hypertension at increased CVD risk with the PREVENT-CVD '
              'equations, which is defined as a 10-year risk of total CVD '
              '≥7.5%, initiating antihypertensive therapy is recommended. Among '
              'adults with a 10-year risk of total CVD <7.5%, initiation of '
              'antihypertensive therapy is recommended if average SBP remains '
              '≥130 mm Hg or average DBP remains ≥80 mm Hg after a 3-6-month '
              'trial of lifestyle intervention.',
          'A Diretriz de Hipertensão Arterial 2025 da AHA/ACC recomenda o '
              'uso da equação específica PREVENT-CVD para estimar o risco de DCV '
              'total em 10 anos e embasar decisões de manejo da hipertensão '
              'estágio 1 (pressão arterial sistólica 130–139 mmHg ou diastólica '
              '80–89 mmHg) em adultos sem DCV, diabetes ou doença renal crônica '
              'conhecidas. Para adultos com hipertensão estágio 1 e risco '
              'aumentado de DCV pelas equações PREVENT-CVD — definido como risco '
              'de DCV total em 10 anos ≥ 7,5% — recomenda-se iniciar terapia '
              'anti-hipertensiva. Para adultos com risco de DCV total em 10 '
              'anos < 7,5%, recomenda-se iniciar terapia anti-hipertensiva se a '
              'PAS média permanecer ≥ 130 mmHg ou a PAD média permanecer ≥ 80 '
              'mmHg após 3 a 6 meses de intervenção no estilo de vida.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The 2026 Dyslipidemia Guideline recommends using the '
              'PREVENT-ASCVD outcome-specific equations to estimate ASCVD risk '
              'to inform management decisions for lipid-lowering therapy (LLT) '
              'among adults without known ASCVD or subclinical atherosclerosis '
              'with an LDL-C between 70–189 mg/dL (1.8–4.9 mmol/L). With more '
              'accurate risk estimates, LLT is recommended for adults with a '
              '10-year ASCVD risk ≥5% (intermediate and high risk) and is '
              'reasonable for those with a 10-year ASCVD risk of 3% to <5% '
              '(borderline risk) after clinician–patient discussion. In selected '
              'adults aged 30–59 years at low 10-year ASCVD risk (<3%) but with '
              'LDL-C 160–189 mg/dL or 30-year ASCVD risk ≥10%, statin therapy is '
              'reasonable. A high-intensity statin is recommended for high '
              '10-year ASCVD risk (≥10%).',
          'A Diretriz de Dislipidemia 2026 recomenda o uso das equações '
              'específicas PREVENT-ASCVD para estimar o risco de ASCVD e embasar '
              'decisões de manejo da terapia hipolipemiante (LLT) em adultos sem '
              'ASCVD conhecida ou aterosclerose subclínica, com LDL-C entre 70 e '
              '189 mg/dL (1,8–4,9 mmol/L). Com estimativas de risco mais '
              'precisas, a LLT é recomendada para adultos com risco de ASCVD em '
              '10 anos ≥ 5% (risco intermediário e alto) e é razoável para '
              'aqueles com risco de ASCVD em 10 anos de 3% a <5% (risco '
              'limítrofe), após discussão entre profissional e paciente. Em '
              'adultos selecionados de 30 a 59 anos com risco baixo de ASCVD em '
              '10 anos (<3%), mas com LDL-C 160–189 mg/dL ou risco de ASCVD em '
              '30 anos ≥ 10%, a estatina é razoável. Para risco alto de ASCVD em '
              '10 anos (≥10%), recomenda-se estatina de alta intensidade.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'Other co-existing conditions may lead to underestimation of an '
              'individual patient’s absolute risk of CVD. These have been '
              'defined in the 2019 Primary Prevention Guidelines as “Risk '
              'Enhancing Factors” and are listed below.',
          'Outras condições coexistentes podem levar à subestimativa do '
              'risco absoluto de DCV de um paciente individual. Essas condições '
              'foram definidas nas Diretrizes de Prevenção Primária de 2019 como '
              '“fatores agravantes de risco” (Risk Enhancing Factors), listados '
              'a seguir.',
        ),
      ),
      DocBlock.bullets([
        DocText(
          'Family history of premature ASCVD (males, age <55 y; females, '
              'age <65 y)',
          'História familiar de ASCVD prematura (homens com menos de 55 '
              'anos; mulheres com menos de 65 anos)',
        ),
        DocText(
          'Primary hypercholesterolemia (LDL-C, 160–189 mg/dL '
              '[4.1–4.8 mmol/L]; non–HDL-C 190–219 mg/dL [4.9–5.6 mmol/L])',
          'Hipercolesterolemia primária (LDL-C 160–189 mg/dL '
              '[4,1–4,8 mmol/L]; não-HDL-C 190–219 mg/dL [4,9–5,6 mmol/L])',
        ),
        DocText(
          'Chronic kidney disease (eGFR 15–59 mL/min/1.73 m2 with or '
              'without albuminuria; not treated with dialysis or kidney '
              'transplantation)',
          'Doença renal crônica (eGFR 15–59 mL/min/1,73 m², com ou sem '
              'albuminúria; sem tratamento com diálise ou transplante renal)',
        ),
        DocText(
          'Chronic inflammatory conditions, such as psoriasis, RA, lupus, '
              'or HIV/AIDS',
          'Condições inflamatórias crônicas, como psoríase, artrite '
              'reumatoide, lúpus ou HIV/AIDS',
        ),
        DocText(
          'History of premature menopause (before age 40 y) or history of '
              'adverse pregnancy outcomes',
          'História de menopausa prematura (antes dos 40 anos) ou de '
              'desfechos adversos na gravidez',
        ),
        DocText(
          'Persistently elevated primary hypertriglyceridemia (≥175 mg/dL, '
              'non-fasting)',
          'Hipertrigliceridemia primária persistentemente elevada '
              '(≥175 mg/dL, sem jejum)',
        ),
        DocText(
          'Elevated biomarkers, if measured (high-sensitivity C-reactive '
              'protein ≥2.0 mg/L, Lp(a) ≥50 mg/dL or ≥125 nmol/L, ApoB '
              '≥130 mg/dL, ABI <0.9)',
          'Biomarcadores elevados, se dosados (proteína C-reativa '
              'ultrassensível ≥2,0 mg/L, Lp(a) ≥50 mg/dL ou ≥125 nmol/L, ApoB '
              '≥130 mg/dL, índice tornozelo-braquial <0,9)',
        ),
      ]),
      DocBlock.paragraph(
        DocText(
          'On this educational website, 10-year results are displayed in '
              'four bands — low (<5%), borderline (5% to <7.5%), intermediate '
              '(7.5% to <20%) and high (≥20%) — with the ≥7.5% threshold from '
              'the 2025 AHA/ACC High Blood Pressure Guideline highlighted for '
              'reference. These bands are a didactic presentation and do not '
              'replace guideline-based decision-making.',
          'Neste site educacional, os resultados de 10 anos são apresentados '
              'em quatro faixas — baixo (<5%), limítrofe (5% a <7,5%), '
              'intermediário (7,5% a <20%) e alto (≥20%) — com destaque para o '
              'limiar de ≥7,5% da Diretriz de Hipertensão 2025 da AHA/ACC como '
              'referência. Essas faixas são uma apresentação didática e não '
              'substituem a tomada de decisão baseada em diretrizes.',
        ),
      ),
    ],
  ),

  // ------------------------------------------------------------------
  DocSection(
    id: 'elegibilidade',
    title: DocText(
      'Eligibility and limitations',
      'Elegibilidade e limitações',
    ),
    blocks: [
      DocBlock.paragraph(
        DocText(
          'Use the PREVENT equations for adults ages 30–79 without known '
              'CVD.',
          'Use as equações PREVENT para adultos de 30 a 79 anos sem DCV '
              'conhecida.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'Do not use the PREVENT equations for adults with known CVD, '
              'evidence of severe subclinical CVD (e.g., left ventricular '
              'ejection fraction <40%, coronary artery calcium ≥300), positive '
              'genetic testing for a variant known to be pathogenic or for an '
              'inherited cardiovascular condition, end-stage kidney disease, or '
              'limited life expectancy (<1 year).',
          'Não use as equações PREVENT para adultos com DCV conhecida, '
              'evidência de DCV subclínica grave (por exemplo, fração de ejeção '
              'do ventrículo esquerdo <40%, cálcio coronariano ≥300), teste '
              'genético positivo para variante sabidamente patogênica ou para '
              'condição cardiovascular hereditária, doença renal em estágio '
              'terminal ou expectativa de vida limitada (<1 ano).',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'Out-of-range values should be managed as clinically indicated. '
              'Risk could still be estimated with the closest in-range value but '
              'may represent an over- or under-estimate.',
          'Valores fora da faixa devem ser manejados conforme a indicação '
              'clínica. O risco ainda pode ser estimado com o valor mais '
              'próximo dentro da faixa, mas pode representar uma superestimativa '
              'ou subestimativa.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'While the PREVENT calculator can be used outside the U.S., the '
              'PREVENT equations were developed and validated with data from '
              'U.S. adults. Therefore, they should be used with caution outside '
              'the U.S. for clinical care. Country-specific evaluation should be '
              'considered before implementation as variation in risk factor '
              'profiles, clinical practice patterns, and competing mortality '
              'risks across different countries may lead to differences in CVD '
              'risk. The PREVENT equations with the optional SDI predictor are '
              'only applicable to adults living in the U.S.',
          'Embora a calculadora PREVENT possa ser usada fora dos Estados '
              'Unidos, as equações PREVENT foram desenvolvidas e validadas com '
              'dados de adultos norte-americanos. Por isso, devem ser usadas com '
              'cautela fora dos EUA no cuidado clínico. Recomenda-se avaliação '
              'específica por país antes da implementação, pois variações nos '
              'perfis de fatores de risco, nos padrões de prática clínica e nos '
              'riscos competitivos de mortalidade entre países podem levar a '
              'diferenças no risco de DCV. As equações PREVENT com o preditor '
              'opcional SDI são aplicáveis apenas a adultos que vivem nos EUA.',
        ),
      ),
      DocBlock.paragraph(
        DocText(
          'The PREVENT equations were developed using a large, diverse '
              'dataset and incorporate measurable health factors, such as BMI, '
              'blood pressure, diabetes, and social drivers of health (including '
              'a zip code–based social deprivation index), that accurately '
              'reflect an individual’s cardiovascular risk. The PREVENT '
              'equations provide risk estimates based on clinical and social '
              'variables that holistically capture risk of cardiovascular '
              'outcomes even without including race as a predictor. It '
              'demonstrates high accuracy across all racial and ethnic groups, '
              'with predicted risk closely matching observed risk, eliminating '
              'the need for race-specific equations.',
          'As equações PREVENT foram desenvolvidas com um conjunto de dados '
              'amplo e diverso e incorporam fatores de saúde mensuráveis — como '
              'IMC, pressão arterial, diabetes e determinantes sociais de saúde '
              '(incluindo um índice de privação social baseado no CEP) — que '
              'refletem com precisão o risco cardiovascular do indivíduo. As '
              'equações PREVENT fornecem estimativas de risco baseadas em '
              'variáveis clínicas e sociais que capturam de forma holística o '
              'risco de desfechos cardiovasculares, mesmo sem incluir raça como '
              'preditor. Elas demonstram alta precisão em todos os grupos '
              'raciais e étnicos, com risco previsto muito próximo do risco '
              'observado, eliminando a necessidade de equações específicas por '
              'raça.',
        ),
      ),
    ],
  ),
];

/// Fontes oficiais e científicas (seção final da página /doc).
const docSources = <DocSource>[
  DocSource(
    label: DocText(
      'Khan SS, Matsushita K, Sang Y, et al. Development and Validation of '
          'the American Heart Association Predicting Risk of Cardiovascular '
          'Disease EVENTs (PREVENT) Equations. Circulation, 2024;149(6):430-449. DOI: '
          '10.1161/CIRCULATIONAHA.123.067626.',
      'Khan SS, Matsushita K, Sang Y, et al. Development and Validation of '
          'the American Heart Association Predicting Risk of Cardiovascular '
          'Disease EVENTs (PREVENT) Equations. Circulation, 2024;149(6):430-449. DOI: '
          '10.1161/CIRCULATIONAHA.123.067626.',
    ),
    url: 'https://doi.org/10.1161/CIRCULATIONAHA.123.067626',
  ),
  DocSource(
    label: DocText(
      'Khan SS, Coresh J, Pencina MJ, et al. Novel Prediction Equations for '
          'Absolute Risk Assessment of Total Cardiovascular Disease '
          'Incorporating Cardiovascular-Kidney-Metabolic Health: A Scientific '
          'Statement From the American Heart Association. Circulation, '
          '2023;148(24):1982–2004. DOI: 10.1161/CIR.0000000000001191.',
      'Khan SS, Coresh J, Pencina MJ, et al. Novel Prediction Equations for '
          'Absolute Risk Assessment of Total Cardiovascular Disease '
          'Incorporating Cardiovascular-Kidney-Metabolic Health: A Scientific '
          'Statement From the American Heart Association. Circulation, '
          '2023;148(24):1982–2004. DOI: 10.1161/CIR.0000000000001191.',
    ),
    url: 'https://doi.org/10.1161/CIR.0000000000001191',
  ),
  DocSource(
    label: DocText(
      'About the PREVENT Calculator — American Heart Association (official '
          'page)',
      'Sobre a calculadora PREVENT — American Heart Association (página '
          'oficial)',
    ),
    url: officialAboutUrl,
  ),
  DocSource(
    label: DocText(
      'The American Heart Association PREVENT™ Online Calculator (official '
          'page)',
      'Calculadora online PREVENT™ da American Heart Association (página '
          'oficial)',
    ),
    url: officialCalculatorUrl,
  ),
  DocSource(
    label: DocText(
      'American Heart Association PREVENT™ Equations — Frequently Asked '
          'Questions (PDF, official)',
      'Equações PREVENT™ da American Heart Association — Perguntas '
          'Frequentes (PDF, oficial)',
    ),
    url: officialFaqUrl,
  ),
  DocSource(
    label: DocText(
      '2025 AHA/ACC/AANP/AAPA/ABC/ACCP/ACPM/AGS/AMA/ASPC/NMA/PCNA/SGIM '
          'Guideline for the Prevention, Detection, Evaluation and Management '
          'of High Blood Pressure in Adults.',
      'Diretriz 2025 AHA/ACC/AANP/AAPA/ABC/ACCP/ACPM/AGS/AMA/ASPC/NMA/PCNA/'
          'SGIM para Prevenção, Detecção, Avaliação e Manejo da Hipertensão '
          'Arterial em Adultos.',
    ),
  ),
  DocSource(
    label: DocText(
      'Inker LA, et al. New Creatinine- and Cystatin C–Based Equations to '
          'Estimate GFR without Race (CKD-EPI 2021). New England Journal of '
          'Medicine, 2021. DOI: 10.1056/NEJMoa2102953.',
      'Inker LA, et al. New Creatinine- and Cystatin C–Based Equations to '
          'Estimate GFR without Race (CKD-EPI 2021). New England Journal of '
          'Medicine, 2021. DOI: 10.1056/NEJMoa2102953.',
    ),
    url: 'https://doi.org/10.1056/NEJMoa2102953',
  ),
  DocSource(
    label: DocText(
      'AHA-DS-Analytics/PREVENT — open-source PREVENT code (GitHub, access '
          'via AHA license agreement)',
      'AHA-DS-Analytics/PREVENT — código aberto do PREVENT (GitHub, acesso '
          'mediante termo de licença da AHA)',
    ),
    url: 'https://github.com/AHA-DS-Analytics/PREVENT',
  ),
];

<script setup lang="ts">
import { useSceneColors } from './composables/useSceneColors'
import { usePageAnimations } from './composables/usePageAnimations'
const year = new Date().getFullYear()
const baseUrl = import.meta.env.BASE_URL

const highlights = [
  { value: '約20年', label: '制御・計測から業務・Webまで' },
  { value: '一貫対応', label: '提案・見積りから現地立上げまで' },
  { value: 'PL / PM', label: 'チームを率いる開発経験' },
  { value: '英語対応', label: '仕様策定・海外メーカとの通訳' },
]

const services = [
  {
    number: '01',
    title: '業務システムの開発・再構築',
    description:
      '業務フローや既存コードを読み解き、必要な仕様を整理。要件定義から設計・製作・テスト・導入まで対応します。',
    tags: ['VB.NET', 'RDB', '既存仕様解析'],
  },
  {
    number: '02',
    title: '制御・計測システム',
    description:
      '製造ラインの自動試験や、PLC・センサを用いた計測システムを開発。現場で確実に動く仕組みを、立上げまで届けます。',
    tags: ['リアルタイム制御', 'PLC', '計測器通信'],
  },
  {
    number: '03',
    title: 'Webアプリ・業務自動化',
    description:
      'Excel VBA資産のGAS化や社内Webアプリを開発。日々の運用をヒアリングし、業務に合う使いやすい形に整えます。',
    tags: ['Google Apps Script', 'React', 'TypeScript'],
  },
  {
    number: '04',
    title: 'AI活用・開発プロセス改善',
    description:
      'GitHub Copilotの指示書標準化や、生成AIによるパッチ適用手順を整備。個人の工夫を、チームで再現できる開発手順にします。',
    tags: ['GitHub Copilot', 'Gemini', '開発標準化'],
  },
]

const projects = [
  {
    category: 'MANUFACTURING',
    title: '通信機器の量産ライン・自動試験システム',
    period: '2005.04 — 2013.03',
    role: '生産技術 / SE',
    summary:
      'FOMA・LTE系の通信端末や基地局装置の量産ラインを立上げ。工程設計から自動試験、試験データ管理、品質管理まで担当しました。',
    details: [
      'VB.NET・VBAと計測器・治具制御を組み合わせた自動試験システムを構築',
      'RHEL・MySQL・Sambaによる試験データ管理サーバを構築・運用',
      '工程能力の管理と関係部門との調整を通して、安定した生産を支援',
    ],
    tags: ['VB.NET', 'VBA', 'MySQL', 'GPIB', 'RHEL'],
  },
  {
    category: 'MEASUREMENT & CONTROL',
    title: '製鉄所向け計測システム・技術営業',
    period: '2014.04 — 2022.03',
    role: 'PL / 3〜7名',
    summary:
      'PLCと温度計・ガス計・水分計などを使う計測システムを担当。提案・見積りから設計、製作、現地立上げまで一貫して推進しました。',
    details: [
      '案件実行計画、予算管理、基本設計、テスト計画と推進を担当',
      '50ms周期のWindowsリアルタイムプログラミングに対応',
      '新型計測機器の研究開発、海外OEM先との英語対応・会議通訳を経験',
    ],
    tags: ['VB.NET', 'PLC / MELSEC', 'TCP / UDP', 'MODBUS'],
  },
  {
    category: 'AI & DEVELOPMENT',
    title: '生成AIをチームで使うための開発手順整備',
    period: '2025.06 —',
    role: 'SE / 開発プロセス改善',
    summary:
      'GitHub CopilotとGeminiを業務プロセスに組み込み、既存システムのカスタマイズ開発を支える手順を整備しました。',
    details: [
      '英語化・簡潔な指示・差分出力によるCopilot指示書の標準化',
      'ソースをMarkdownへ集約し、生成AIに変更内容を指示する手順を整備',
      '生成されたパッチスクリプトで、関連ファイルを一括更新する流れを確立',
    ],
    tags: ['GitHub Copilot', 'Gemini', 'Python', 'Git Bash'],
  },
  {
    category: 'DEVELOPER TOOLS',
    title: '結合テストのエビデンス記録ツール「omnicat」',
    period: '2025.06 —',
    role: 'SE / ツール開発',
    summary:
      '画面コピー・DBダンプ・帳票PDFの記録作業を支えるデスクトップツールを開発。テスト時の記録から比較・レポート出力までをまとめました。',
    details: [
      'プロジェクト・テストケース単位で保存先を管理し、ショートカットキーで記録',
      '画面コピーへの注釈・コメント追加と、既設・新設データの比較に対応',
      '判定と判定根拠を含むHTMLエビデンスレポートを出力',
    ],
    tags: ['VB.NET', '.NET 10', 'WPF', 'Scriban', 'HtmlTags'],
  },
  {
    category: 'WEB & AUTOMATION',
    title: 'Google Workspace移行に伴う社内Webアプリ開発',
    period: '2025.06 —',
    role: 'SE / 業務ヒアリング・開発',
    summary:
      'Microsoft OfficeからGoogle Workspaceへの移行に伴い、ExcelマクロをGASへ置換。業務要件の整理から社内Webアプリの開発まで担当しました。',
    details: [
      '手作業だった製品見積りを、Webの見積りシミュレータとして実装',
      '案件開始時のテンプレートフォルダを一括コピーするGASツールを開発',
      '利用頻度の高いExcel VBAをGASへ移行',
    ],
    tags: ['GAS', 'React', 'TypeScript', 'Tailwind CSS', 'clasp'],
  },
]

const career = [
  {
    period: '2005 — 2014',
    title: '通信機器メーカ / 生産技術',
    description:
      '通信機器の量産ライン構築、自動試験システム、製造品質管理に従事。',
  },
  {
    period: '2014 — 2022',
    title: '製鉄関連エンジニアリング会社 / PL',
    description:
      '製鉄所向け計測システムの提案・開発・現地立上げと、新技術の研究開発を担当。',
  },
  {
    period: '2022 —',
    title: 'フリーランス / radix-studio',
    description:
      '業務システムの再構築、製造系ソフト開発、テスト自動化、GASアプリ開発、AI活用推進に従事。',
  },
]

const skillGroups = [
  {
    title: '業務・Windowsアプリ',
    items: ['VB.NET / .NET', 'WPF', 'VBA / Access', 'MySQL / PostgreSQL', 'Oracle'],
  },
  {
    title: 'Web・業務自動化',
    items: ['Google Apps Script', 'React / TypeScript', 'Tailwind CSS', 'Django', 'clasp'],
  },
  {
    title: '制御・計測・インフラ',
    items: ['PLC / MELSEC', 'TCP / UDP / RS232C', 'MODBUS / GPIB', 'RHEL', 'Docker'],
  },
  {
    title: '品質・開発プロセス',
    items: ['Python', 'Selenium / Playwright', 'Feature / Gherkin', 'Git', 'GitHub Copilot / Gemini'],
  },
]

const principles = [
  {
    number: '01',
    title: '現場から、要件を見つける。',
    description:
      '使う人の声と実際の運用を確認し、本当に負担を減らせる要件を探ります。関係者と信頼を築くことも、開発の一部です。',
  },
  {
    number: '02',
    title: '動くところまで、届ける。',
    description:
      '提案や実装で終わらず、テスト・導入・現地立上げまで。製造現場で培った、最後まで確かめる姿勢を大切にしています。',
  },
  {
    number: '03',
    title: '工夫を、チームの力にする。',
    description:
      '新しい技術は、導入するだけでなく使える手順に。AI活用や自動化も、チームで共有・再現できる形に整えます。',
  },
]

usePageAnimations()

useSceneColors()
</script>

<template>
  <v-app>
    <a class="skip-link" href="#main-content">メインコンテンツへ</a>

    <header class="site-header">
      <div class="page-width header-inner">
        <a class="brand" :href="baseUrl" aria-label="radix-studio ホーム">
          <span class="brand-mark" aria-hidden="true"></span>
          radix-studio<span class="brand-dot">.</span>
        </a>
        <nav class="navigation" aria-label="メインナビゲーション">
          <a href="#about">About</a>
          <a href="#services">Services</a>
          <a href="#projects">Projects</a>
          <a href="#availability">参画について</a>
        </nav>
      </div>
    </header>

    <v-main id="main-content" tabindex="-1">
      <section class="scene-section" aria-labelledby="hero-title" data-scene="hero">
        <div class="page-width hero">
        <div class="hero-copy">
          <p class="eyebrow">FREELANCE SOFTWARE ENGINEER / TOKYO</p>
          <h1 id="hero-title">
            現場を知る。<br />
            <span>仕組みで、応える。</span>
          </h1>
          <p class="hero-description">
            制御・計測システムから、業務システム、Webアプリまで。<br />
            約20年の経験をもとに、課題の整理から設計・開発、<br class="desktop-break" />
            導入・立上げまで一貫して取り組みます。
          </p>
          <div class="hero-actions">
            <a class="primary-link" href="#projects">
              取り組んできたこと <span aria-hidden="true">↗</span>
            </a>
            <a class="secondary-link" href="#availability">参画条件を見る</a>
          </div>
          <div class="hero-signature">
            <span class="signature-name">根深 渓太 / Nebuka Keita</span>
            <span>フリーランスエンジニア / radix-studio</span>
          </div>
        </div>

        <div class="hero-art" aria-hidden="true">
          <div class="art-orbit orbit-one"></div>
          <div class="art-orbit orbit-two"></div>
          <div class="art-card art-card-back"></div>
          <div class="art-card art-card-front">
            <div class="art-dots"><i></i><i></i><i></i></div>
            <div class="art-code">&lt;build /&gt;</div>
            <div class="art-line line-long"></div>
            <div class="art-line line-medium"></div>
            <div class="art-line line-short"></div>
            <div class="art-divider"></div>
            <div class="art-caption">FIELD → DESIGN → DEVELOPMENT</div>
          </div>
          <div class="art-label">Built for the real world.</div>
        </div>
      
        </div>
      </section>

      <div class="page-width highlight-grid" aria-label="経験と対応領域">
        <div v-for="item in highlights" :key="item.value" class="highlight-item">
          <span class="highlight-value">{{ item.value }}</span>
          <span class="highlight-label">{{ item.label }}</span>
        </div>
      </div>

      <section id="about" class="about-section section-anchor scene-section" aria-labelledby="about-title" data-scene="about">
        <div class="page-width about-layout">
          <div>
            <p class="eyebrow">ABOUT</p>
            <h2 id="about-title">技術者としての根っこは、<br />製造現場にあります。</h2>
          </div>
          <div class="about-copy">
            <p>
              フリーランスエンジニアの根深渓太です。通信機器の量産ラインや自動試験システムの構築を出発点に、
              製鉄所の計測システム、業務システム、Webアプリケーションへと領域を広げてきました。
            </p>
            <p>
              大切にしているのは、「現場で確実に動くものを最後まで届ける」こと。
              提案・見積りから要件定義、設計、製作、テスト、現地立上げまで経験しています。
              PL・PMとしてのチーム推進や、英語での仕様策定・海外メーカとの通訳にも対応できます。
            </p>
            <p>
              現在はGitHub Copilotや生成AIも開発に取り入れ、
              チームで使える指示書や作業手順の標準化、テストの効率化に取り組んでいます。
            </p>
            <ul class="profile-facts">
              <li>東京都を拠点に活動</li>
              <li>千歳科学技術大学卒業（学士）</li>
              <li>社長賞1級受賞・特許出願の実績</li>
            </ul>
          </div>
        </div>
      </section>

      <section id="services" class="section-anchor scene-section" aria-labelledby="services-title" data-scene="services">
        <div class="page-width">
        <div class="section-heading">
          <div>
            <p class="eyebrow">WHAT I DO</p>
            <h2 id="services-title">お手伝いできること</h2>
          </div>
          <p class="section-caption">課題の整理から、実装と運用まで。</p>
        </div>
        <div class="service-grid">
          <v-card v-for="item in services" :key="item.number" tag="article" class="service-card">
            <span class="card-number">{{ item.number }}</span>
            <h3>{{ item.title }}</h3>
            <p class="service-description">{{ item.description }}</p>
            <ul class="tag-list" aria-label="関連する技術と領域">
              <li v-for="tag in item.tags" :key="tag">{{ tag }}</li>
            </ul>
          </v-card>
        </div>
      
        </div>
      </section>

      <section id="projects" class="projects-section section-anchor scene-section" aria-labelledby="projects-title" data-scene="projects">
        <div class="page-width">
          <div class="section-heading">
            <div>
              <p class="eyebrow">SELECTED EXPERIENCE</p>
              <h2 id="projects-title">取り組んできたこと</h2>
            </div>
            <p class="section-caption">製造現場から、開発チームの生産性改善まで。</p>
          </div>
          <div class="project-list">
            <v-card v-for="project in projects" :key="project.title" tag="article" class="project-card">
              <div class="project-meta">
                <p class="eyebrow">{{ project.category }}</p>
                <span class="project-period">{{ project.period }}</span>
                <span class="project-role">{{ project.role }}</span>
              </div>
              <div class="project-body">
                <h3>{{ project.title }}</h3>
                <p class="project-summary">{{ project.summary }}</p>
                <ul class="project-details">
                  <li v-for="detail in project.details" :key="detail">{{ detail }}</li>
                </ul>
                <ul class="tag-list" aria-label="使用技術">
                  <li v-for="tag in project.tags" :key="tag">{{ tag }}</li>
                </ul>
              </div>
            </v-card>
          </div>
          <p class="project-note">
            掲載内容は担当経験の概要です。顧客名・契約情報・非公開資料は掲載していません。
          </p>
        </div>
      </section>

      <section class="scene-section" aria-labelledby="career-title" data-scene="career">
        <div class="page-width">
        <div class="section-heading">
          <div>
            <p class="eyebrow">CAREER</p>
            <h2 id="career-title">これまでの歩み</h2>
          </div>
        </div>
        <ol class="career-list">
          <li v-for="item in career" :key="item.period" class="career-item">
            <span class="career-period">{{ item.period }}</span>
            <div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.description }}</p>
            </div>
          </li>
        </ol>
      
        </div>
      </section>

      <section class="technology-section scene-section" aria-labelledby="skills-title" data-scene="skills">
        <div class="page-width">
          <div class="section-heading">
            <div>
              <p class="eyebrow">SKILLS & TECHNOLOGIES</p>
              <h2 id="skills-title">現場と開発をつなぐ技術</h2>
            </div>
          </div>
          <div class="skills-grid">
            <article v-for="group in skillGroups" :key="group.title" class="skill-group">
              <h3>{{ group.title }}</h3>
              <ul class="technology-list">
                <li v-for="item in group.items" :key="item">{{ item }}</li>
              </ul>
            </article>
          </div>
          <p class="skills-note">
            技術だけでなく、業務プロセス分析、要件定義、DB・画面設計、
            テスト設計、レビュー、提案・見積り、予算管理にも対応します。
          </p>
        </div>
      </section>

      <section class="scene-section" aria-labelledby="approach-title" data-scene="approach">
        <div class="page-width">
        <div class="section-heading">
          <div>
            <p class="eyebrow">MY APPROACH</p>
            <h2 id="approach-title">仕事で大切にしていること</h2>
          </div>
        </div>
        <div class="principle-list">
          <article v-for="item in principles" :key="item.number" class="principle">
            <span class="principle-number">{{ item.number }}</span>
            <h3>{{ item.title }}</h3>
            <p>{{ item.description }}</p>
          </article>
        </div>
      
        </div>
      </section>

      <section id="availability" class="availability-section section-anchor scene-section" aria-labelledby="availability-title" data-scene="availability">
        <div class="page-width availability-layout">
          <div>
            <p class="eyebrow">AVAILABILITY</p>
            <h2 id="availability-title">参画について</h2>
            <p class="availability-description">
              業務システム開発、既存システムの改善、<br class="desktop-break" />
              開発プロセスの効率化などの案件を希望しています。
            </p>
          </div>
          <dl class="availability-details">
            <div>
              <dt>参画可能日</dt>
              <dd><time datetime="2027-04-01">2027年4月1日より</time></dd>
            </div>
            <div>
              <dt>勤務形態</dt>
              <dd>フルリモート または 都内近郊</dd>
            </div>
            <div>
              <dt>出張</dt>
              <dd>対応可能</dd>
            </div>
          </dl>
        </div>
      </section>
    </v-main>

    <footer class="site-footer">
      <div class="page-width footer-inner">
        <div>
          <a class="brand footer-brand" :href="baseUrl">radix-studio.</a>
          <p>根深 渓太 / Nebuka Keita — Freelance Software Engineer</p>
        </div>
        <small>© {{ year }} radix-studio</small>
      </div>
    </footer>
  </v-app>
</template>

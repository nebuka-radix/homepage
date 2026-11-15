#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
PROJECT_ROOT="${SCRIPT_DIR:h}"
cd "$PROJECT_ROOT"

die() {
  print -u2 -- "エラー: $*"
  exit 1
}

for command_name in node npm git; do
  command -v "$command_name" >/dev/null 2>&1 \
    || die "${command_name} が見つかりません。"
done

[[ -f package.json ]] || die "package.json が見つかりません。"
[[ -f src/App.vue ]] || die "src/App.vue が見つかりません。"
[[ -f src/styles/main.css ]] || die "src/styles/main.css が見つかりません。"
[[ -f index.html ]] || die "index.html が見つかりません。"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || die "Gitリポジトリではありません。"

GIT_ROOT="$(git rev-parse --show-toplevel)"
[[ "${GIT_ROOT:A}" == "$PROJECT_ROOT" ]] \
  || die "Gitリポジトリのルートで実行してください。"

[[ -z "$(git status --porcelain --untracked-files=no)" ]] \
  || die "追跡済みファイルに未コミットの変更があります。先に整理してください。"

git var GIT_AUTHOR_IDENT >/dev/null 2>&1 \
  || die "git config user.name と user.email を設定してください。"

[[ -d node_modules ]] || npm ci

cat > src/App.vue <<'EOF'
<script setup lang="ts">
const year = new Date().getFullYear()
const baseUrl = import.meta.env.BASE_URL

const services = [
  {
    number: '01',
    title: 'Webアプリケーション開発',
    description:
      '使う人にとってのわかりやすさと、育てやすい設計を大切に。業務に合わせたWebアプリケーションを開発します。',
    tags: ['Vue / React', 'TypeScript', 'UI / UX'],
  },
  {
    number: '02',
    title: '業務改善・自動化',
    description:
      '日々の繰り返し作業や、分散した情報を整理。Google Apps Scriptやスクリプトを活用し、業務の手間を減らします。',
    tags: ['Google Apps Script', '業務ツール', '自動化'],
  },
  {
    number: '03',
    title: '既存システムの解析・改善',
    description:
      '既存コードと実際の動作を読み解き、仕様を整理。現場の運用を踏まえながら、改善や保守につなげます。',
    tags: ['仕様化', 'リバースエンジニアリング', '保守・改善'],
  },
]

const principles = [
  {
    number: '01',
    title: 'まず、業務を理解する。',
    description:
      '何を作るかだけでなく、誰が、どんな場面で使うのか。目的や運用を整理するところから取り組みます。',
  },
  {
    number: '02',
    title: '小さく作り、確かめる。',
    description:
      '動くものを通して認識を合わせ、検証と改善を重ねながら、必要な形へ近づけます。',
  },
  {
    number: '03',
    title: 'その先の運用まで考える。',
    description:
      '見た目の整合性だけでなく、保守性や変更のしやすさも重視し、使い続けられる仕組みを目指します。',
  },
]

const technologies = [
  'TypeScript',
  'React',
  'Vue',
  'Vuetify',
  'Google Apps Script',
  'VB.NET',
  'Git',
  '生成AIの活用',
]
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
          <a href="#approach">Approach</a>
        </nav>
      </div>
    </header>

    <v-main id="main-content" tabindex="-1">
      <section class="hero page-width" aria-labelledby="hero-title">
        <div class="hero-copy">
          <p class="eyebrow">FREELANCE SOFTWARE ENGINEER / SAPPORO</p>
          <h1 id="hero-title">
            日々の仕事に、<br />
            <span>ちょうどいい仕組みを。</span>
          </h1>
          <p class="hero-description">
            Webアプリケーションの開発から、業務の自動化、<br class="desktop-break" />
            既存システムの改善まで。<br />
            現場の課題を読み解き、使い続けられる形にします。
          </p>
          <a class="primary-link" href="#services">
            できることを見る <span aria-hidden="true">↗</span>
          </a>
          <div class="hero-signature">
            <span class="signature-name">Keita Nebuka</span>
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
            <div class="art-caption">IDEA → DESIGN → DEVELOPMENT</div>
          </div>
          <div class="art-label">Make work simpler.</div>
        </div>
      </section>

      <section id="about" class="about-section section-anchor">
        <div class="page-width about-layout">
          <div>
            <p class="eyebrow">ABOUT</p>
            <h2>技術と業務の、<br />間に立つエンジニア。</h2>
          </div>
          <div class="about-copy">
            <p>
              北海道札幌市を拠点に、radix-studioとして活動する
              フリーランスエンジニア、Keita Nebukaです。
            </p>
            <p>
              フロントエンド開発や業務アプリケーションの設計、
              Google Apps Scriptによる自動化、既存システムの解析・仕様化に取り組んでいます。
            </p>
            <p>
              大切にしているのは、技術ありきではなく、実際の仕事に合うこと。
              使いやすさと保守性の両面から、無理なく使い続けられる仕組みを考えます。
            </p>
          </div>
        </div>
      </section>

      <section
        id="services"
        class="page-width section-block section-anchor"
        aria-labelledby="services-title"
      >
        <div class="section-heading">
          <div>
            <p class="eyebrow">WHAT I DO</p>
            <h2 id="services-title">できること</h2>
          </div>
          <p class="section-caption">つくる。つなぐ。より良くする。</p>
        </div>

        <div class="service-grid">
          <v-card
            v-for="service in services"
            :key="service.number"
            tag="article"
            class="service-card"
          >
            <span class="card-number">{{ service.number }}</span>
            <h3>{{ service.title }}</h3>
            <p class="service-description">{{ service.description }}</p>
            <ul class="tag-list" aria-label="関連する技術と領域">
              <li v-for="tag in service.tags" :key="tag">{{ tag }}</li>
            </ul>
          </v-card>
        </div>
      </section>

      <section
        id="approach"
        class="page-width section-block section-anchor approach-section"
        aria-labelledby="approach-title"
      >
        <div class="section-heading">
          <div>
            <p class="eyebrow">MY APPROACH</p>
            <h2 id="approach-title">大切にしていること</h2>
          </div>
        </div>

        <div class="principle-list">
          <article
            v-for="principle in principles"
            :key="principle.number"
            class="principle"
          >
            <span class="principle-number">{{ principle.number }}</span>
            <h3>{{ principle.title }}</h3>
            <p>{{ principle.description }}</p>
          </article>
        </div>
      </section>

      <section class="technology-section" aria-labelledby="technology-title">
        <div class="page-width technology-layout">
          <div>
            <p class="eyebrow">TOOLS & TECHNOLOGIES</p>
            <h2 id="technology-title">課題に合わせて、<br />技術を選ぶ。</h2>
          </div>
          <ul class="technology-list" aria-label="扱う技術やツール">
            <li v-for="technology in technologies" :key="technology">
              {{ technology }}
            </li>
          </ul>
        </div>
      </section>
    </v-main>

    <footer class="site-footer">
      <div class="page-width footer-inner">
        <div>
          <a class="brand footer-brand" :href="baseUrl">radix-studio.</a>
          <p>Software development, with your work in mind.</p>
        </div>
        <small>© {{ year }} radix-studio</small>
      </div>
    </footer>
  </v-app>
</template>
EOF

cat > src/styles/main.css <<'EOF'
:root {
  font-family:
    -apple-system, BlinkMacSystemFont, "Helvetica Neue",
    "Hiragino Kaku Gothic ProN", "Hiragino Sans", Meiryo, sans-serif;
  font-synthesis: none;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
}

html { overflow-y: auto; }
body { margin: 0; }
a { color: inherit; }
button, a { -webkit-tap-highlight-color: transparent; }
:focus-visible { outline: 3px solid #405ce8; outline-offset: 5px; }

.v-application {
  background: #f8f9fc !important;
  color: #19263d !important;
}

.page-width {
  width: min(1184px, calc(100% - 80px));
  margin-inline: auto;
}

.section-anchor { scroll-margin-top: 32px; }
.site-header { border-bottom: 1px solid #e6eaf2; }

.header-inner {
  min-height: 100px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 24px;
}

.brand {
  display: inline-flex;
  align-items: center;
  text-decoration: none;
  font-size: 23px;
  font-weight: 750;
  letter-spacing: -0.06em;
}

.brand-mark {
  width: 23px;
  height: 23px;
  margin-right: 11px;
  border-radius: 7px;
  background: #405ce8;
  transform: rotate(-12deg);
}

.brand-dot { color: #405ce8; }
.navigation { display: flex; gap: 30px; }
.navigation a {
  padding-block: 10px;
  text-decoration: none;
  color: #536178;
  font-size: 13px;
}
.navigation a:hover { color: #405ce8; }

.hero {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  align-items: center;
  gap: 36px;
  padding-block: 108px 100px;
}

.eyebrow {
  margin-bottom: 20px;
  color: #405ce8;
  font-size: 11px;
  font-weight: 700;
  line-height: 1.8;
  letter-spacing: 0.16em;
}

h1 {
  font-size: clamp(34px, 4.1vw, 58px);
  line-height: 1.55;
  font-weight: 750;
  letter-spacing: -0.055em;
}

h1 span { color: #405ce8; }

.hero-description {
  margin-top: 26px;
  color: #536178;
  font-size: 15px;
  line-height: 2.1;
}

.primary-link {
  display: inline-flex;
  align-items: center;
  justify-content: space-between;
  gap: 32px;
  min-height: 52px;
  margin-top: 32px;
  padding: 14px 22px;
  border: 1px solid #405ce8;
  border-radius: 12px;
  background: #405ce8;
  color: white;
  font-size: 14px;
  text-decoration: none;
}
.primary-link:hover { background: #3049c5; }

.hero-signature {
  display: flex;
  flex-direction: column;
  gap: 5px;
  margin-top: 42px;
  color: #64748b;
  font-size: 11px;
}
.signature-name {
  color: #19263d;
  font-size: 16px;
  font-weight: 650;
  letter-spacing: 0.02em;
}

.hero-art {
  position: relative;
  min-height: 400px;
  display: grid;
  place-items: center;
  isolation: isolate;
}

.art-orbit {
  position: absolute;
  z-index: -1;
  width: 350px;
  height: 350px;
  border: 1px solid #dfe5f5;
  border-radius: 50%;
}
.orbit-two { width: 260px; height: 260px; }

.art-card {
  width: 290px;
  height: 236px;
  border: 1px solid #e2e7f3;
  border-radius: 22px;
}
.art-card-back {
  position: absolute;
  background: #e9edff;
  transform: translate(18px, 8px) rotate(10deg);
}
.art-card-front {
  padding: 26px;
  background: #fff;
  box-shadow: 0 24px 70px #233d8012;
  transform: rotate(-5deg);
}
.art-dots { display: flex; gap: 5px; }
.art-dots i {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #d9dfed;
}
.art-code {
  margin-block: 23px 18px;
  color: #405ce8;
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 30px;
  font-weight: 600;
}
.art-line {
  height: 6px;
  margin-top: 9px;
  border-radius: 6px;
  background: #edf0f7;
}
.line-long { width: 87%; }
.line-medium { width: 65%; }
.line-short { width: 76%; }
.art-divider { height: 1px; margin-top: 22px; background: #edf0f7; }
.art-caption {
  margin-top: 12px;
  color: #64748b;
  font-size: 8px;
  letter-spacing: 0.1em;
}
.art-label {
  position: absolute;
  bottom: 28px;
  right: 4px;
  padding: 14px 20px;
  border: 1px solid #e2e7f3;
  border-radius: 12px;
  background: #fff;
  color: #405ce8;
  font-size: 12px;
  box-shadow: 0 10px 30px #233d8008;
}

.about-section {
  padding-block: 76px;
  border-block: 1px solid #e6eaf2;
  background: #fff;
}
.about-layout, .technology-layout {
  display: grid;
  grid-template-columns: 1fr 1.4fr;
  gap: 80px;
}
h2 {
  font-size: clamp(25px, 3vw, 34px);
  line-height: 1.65;
  letter-spacing: -0.04em;
  font-weight: 700;
}
.about-copy { padding-top: 4px; }
.about-copy p {
  color: #536178;
  font-size: 14px;
  line-height: 2.15;
}
.about-copy p + p { margin-top: 18px; }

.section-block { padding-block: 88px; }
.section-heading {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 24px;
  margin-bottom: 36px;
}
.section-heading .eyebrow { margin-bottom: 12px; }
.section-caption { color: #64748b; font-size: 13px; }

.service-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
}
.service-card {
  display: flex;
  flex-direction: column;
  padding: 32px 26px;
  border: 1px solid #e4e9f3;
}
.card-number {
  margin-bottom: 36px;
  color: #405ce8;
  font-size: 13px;
  font-weight: 600;
}
h3 { font-size: 18px; line-height: 1.7; letter-spacing: -0.03em; }
.service-description {
  margin-block: 18px 28px;
  color: #536178;
  font-size: 13px;
  line-height: 2;
}
.tag-list, .technology-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 0;
  list-style: none;
}
.tag-list { margin-top: auto; }
.tag-list li {
  padding: 5px 9px;
  border-radius: 6px;
  background: #f3f5fb;
  color: #536178;
  font-size: 10px;
}

.approach-section { padding-top: 0; }
.principle { 
  display: grid;
  grid-template-columns: 40px 1fr 1.35fr;
  gap: 28px;
  align-items: baseline;
  padding-block: 28px;
  border-top: 1px solid #dfe5ef;
}
.principle:last-child { border-bottom: 1px solid #dfe5ef; }
.principle-number { color: #405ce8; font-size: 12px; }
.principle p { color: #536178; font-size: 13px; line-height: 2; }

.technology-section { padding-block: 72px; background: #edf1fa; }
.technology-list { align-content: center; gap: 12px; }
.technology-list li {
  padding: 12px 17px;
  border: 1px solid #dfe5f1;
  border-radius: 10px;
  background: #ffffffb3;
  color: #43516a;
  font-size: 13px;
}

.footer-inner {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  padding-block: 42px;
}
.footer-brand { font-size: 20px; }
.footer-inner p { margin-top: 10px; color: #64748b; font-size: 11px; }
.footer-inner small { color: #64748b; font-size: 11px; }

.skip-link {
  position: fixed;
  top: 12px;
  left: 16px;
  z-index: 1000;
  padding: 12px 18px;
  border-radius: 8px;
  background: #fff;
  transform: translateY(-200%);
}
.skip-link:focus { transform: translateY(0); }

@media (max-width: 960px) {
  .page-width { width: calc(100% - 48px); }
  .hero { gap: 16px; padding-block: 72px; }
  .hero-art { transform: scale(0.85); }
  .about-layout, .technology-layout { gap: 36px; }
  .service-grid { grid-template-columns: 1fr; }
  .card-number { margin-bottom: 18px; }
  .principle { grid-template-columns: 32px 1fr; gap: 12px; }
  .principle p { grid-column: 2; }
}

@media (max-width: 700px) {
  .page-width { width: calc(100% - 40px); }
  .header-inner { min-height: 82px; gap: 16px; flex-wrap: wrap; padding-block: 18px; }
  .brand { font-size: 21px; }
  .navigation { gap: 18px; }
  .navigation a { font-size: 11px; }
  .hero { grid-template-columns: 1fr; padding-block: 56px 32px; }
  .hero .eyebrow { font-size: 9px; }
  h1 { font-size: clamp(28px, 6.7vw, 42px); }
  .hero-description { font-size: 14px; }
  .desktop-break { display: none; }
  .hero-art { min-height: 330px; margin-top: 4px; }
  .art-label { right: 0; bottom: 10px; }
  .about-layout, .technology-layout { grid-template-columns: 1fr; gap: 28px; }
  .about-section, .technology-section { padding-block: 52px; }
  .section-block { padding-block: 56px; }
  .approach-section { padding-top: 0; }
  .section-heading { flex-direction: column; align-items: flex-start; gap: 12px; }
  .footer-inner { align-items: flex-start; flex-direction: column; }
}

@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
  .primary-link, .navigation a { transition: background-color 160ms, color 160ms; }
}
EOF

# タイトルと説明文を更新
node --input-type=module <<'EOF'
import fs from 'node:fs'

const file = 'index.html'
let html = fs.readFileSync(file, 'utf8')

const title = 'radix-studio | Keita Nebuka — フリーランスエンジニア'
const description =
  '札幌を拠点に活動するフリーランスエンジニア、Keita Nebuka。Webアプリケーション開発、業務の自動化、既存システムの解析・改善に取り組んでいます。'

if (!/<title>[\s\S]*?<\/title>/i.test(html)) {
  throw new Error('index.html のtitle要素が見つかりません。')
}

html = html.replace(/<title>[\s\S]*?<\/title>/i, `<title>${title}</title>`)

const metaDescription = `<meta name="description" content="${description}" />`
const existingDescription = /<meta\b(?=[^>]*\bname=["']description["'])[^>]*>/i

if (existingDescription.test(html)) {
  html = html.replace(existingDescription, metaDescription)
} else {
  html = html.replace('</head>', `    ${metaDescription}\n  </head>`)
}

fs.writeFileSync(file, html)
EOF

print -- "型チェックと本番ビルドを実行します..."
npm run build

print -- ""
print -- "プロフィールページへの更新が完了しました。"
print -- "確認: npm run dev"
print -- "未追跡ファイルも含め、変更をコミットします。"

git add .
git commit -m 'フリーランスエンジニアの紹介ページに更新'
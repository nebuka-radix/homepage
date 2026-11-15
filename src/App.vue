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

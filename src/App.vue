<script setup lang="ts">
const year = new Date().getFullYear()
const baseUrl = import.meta.env.BASE_URL
</script>

<template>
  <v-app>
    <a class="skip-link" href="#main-content">
      メインコンテンツへ
    </a>

    <header class="site-header">
      <v-container class="site-container header-inner">
        <a class="brand" :href="baseUrl" aria-label="ホーム">
          <span class="brand-mark" aria-hidden="true"></span>
          <span>Homepage</span>
        </a>
        <span class="header-caption">A new space, coming soon.</span>
      </v-container>
    </header>

    <v-main id="main-content" tabindex="-1">
      <v-container class="site-container main-container">
        <section class="intro" aria-labelledby="page-title">
          <v-chip
            color="primary"
            variant="tonal"
            size="small"
            class="status-chip"
          >
            UNDER CONSTRUCTION
          </v-chip>

          <h1 id="page-title">
            ここから、<br />
            新しいページを。
          </h1>

          <p class="intro-description">
            現在、公開に向けて準備を進めています。
          </p>
        </section>

        <v-card class="content-placeholder" tag="section" aria-labelledby="content-title">
          <div class="placeholder-symbol" aria-hidden="true">
            <span></span><span></span><span></span>
          </div>
          <p class="eyebrow">CONTENTS</p>
          <h2 id="content-title">コンテンツは準備中です</h2>
          <p>こちらに、今後お知らせする内容を掲載します。</p>
        </v-card>
      </v-container>
    </v-main>

    <footer class="site-footer">
      <v-container class="site-container">
        <v-divider />
        <div class="footer-inner">
          <span>Homepage</span>
          <small>© {{ year }} Homepage</small>
        </div>
      </v-container>
    </footer>
  </v-app>
</template>

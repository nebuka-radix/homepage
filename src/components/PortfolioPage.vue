<script setup lang="ts">
import source from '../generated/portfolio.json'

type Figure = {
  src: string
  caption: string
}

type Block =
  | { type: 'paragraph'; text: string }
  | { type: 'heading'; level: number; text: string }
  | ({ type: 'figure' } & Figure)

type Portfolio = {
  slug: string
  title: string
  tags: string[]
  repositoryUrl: string
  summary: string
  thumbnail: Figure
  blocks: Block[]
}

const items = source as Portfolio[]
const base = import.meta.env.BASE_URL
const listUrl = `${base}portfolio/`
const relativePath = window.location.pathname.slice(base.length)
const parts = relativePath.split('/').filter(Boolean)
const detailMode = parts[1] === 'items'
const slug = parts[2] ?? ''
const item = detailMode ? items.find((value) => value.slug === slug) : undefined

const detailUrl = (value: Portfolio) =>
  `${listUrl}items/${value.slug}/`

const imageUrl = (value: string) => `${base}${value}`
</script>

<template>
  <section
    class="scene-section section-anchor portfolio-section"
    data-scene="portfolio"
    aria-labelledby="portfolio-page-title"
  >
    <div class="page-width">
      <template v-if="!detailMode">
        <div class="section-heading">
          <div>
            <p class="eyebrow">PORTFOLIO</p>
            <h1 id="portfolio-page-title" class="portfolio-page-title">
              ポートフォリオ
            </h1>
          </div>
        </div>

        <p class="portfolio-introduction">
          公開しているアプリケーションや開発ツールをご紹介します。
        </p>

        <div v-if="items.length" class="portfolio-grid">
          <article v-for="work in items" :key="work.slug" class="portfolio-card">
            <a :href="detailUrl(work)" class="portfolio-thumbnail-link">
              <img
                class="portfolio-thumbnail"
                :src="imageUrl(work.thumbnail.src)"
                :alt="work.thumbnail.caption"
                loading="lazy"
              />
            </a>

            <ul class="tag-list portfolio-tags" aria-label="タグ">
              <li v-for="tag in work.tags" :key="tag">{{ tag }}</li>
            </ul>

            <h2 class="portfolio-work-title">
              <a :href="detailUrl(work)">{{ work.title }}</a>
            </h2>

            <p class="portfolio-description">{{ work.summary }}</p>
            <div class="portfolio-links">
              <a :href="detailUrl(work)">詳細を見る <span aria-hidden="true">→</span></a>
            </div>
          </article>
        </div>

        <div v-else class="portfolio-empty">
          <h2>公開準備中です</h2>
          <p>制作物の紹介を順次追加していきます。</p>
        </div>
      </template>

      <template v-else-if="item">
        <a class="portfolio-back" :href="listUrl">← ポートフォリオ一覧</a>

        <ul class="tag-list portfolio-tags" aria-label="タグ">
          <li v-for="tag in item.tags" :key="tag">{{ tag }}</li>
        </ul>

        <h1 id="portfolio-page-title" class="portfolio-page-title">{{ item.title }}</h1>
        <p class="portfolio-introduction">{{ item.summary }}</p>

        <div class="portfolio-links portfolio-detail-links">
          <a
            :href="item.repositoryUrl"
            target="_blank"
            rel="noopener noreferrer"
          >
            リポジトリを見る
            <span class="portfolio-visually-hidden">（新しいタブで開く）</span>
            <span aria-hidden="true">↗</span>
          </a>
        </div>

        <figure class="portfolio-cover">
          <img
            :src="imageUrl(item.thumbnail.src)"
            :alt="item.thumbnail.caption"
          />
        </figure>

        <div class="portfolio-body">
          <template v-for="(block, index) in item.blocks" :key="index">
            <p v-if="block.type === 'paragraph'">{{ block.text }}</p>

            <h2 v-else-if="block.type === 'heading' && block.level === 2">
              {{ block.text }}
            </h2>

            <h3 v-else-if="block.type === 'heading'">
              {{ block.text }}
            </h3>

            <figure v-else-if="block.type === 'figure'">
              <img
                :src="imageUrl(block.src)"
                :alt="block.caption"
                loading="lazy"
              />
              <figcaption>{{ block.caption }}</figcaption>
            </figure>
          </template>
        </div>

        <a class="portfolio-back" :href="listUrl">← ポートフォリオ一覧へ戻る</a>
      </template>

      <template v-else>
        <h1 id="portfolio-page-title" class="portfolio-page-title">
          制作物が見つかりません
        </h1>
        <a class="portfolio-back" :href="listUrl">ポートフォリオ一覧へ戻る</a>
      </template>
    </div>
  </section>
</template>

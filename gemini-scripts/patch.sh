#!/bin/zsh
set -euo pipefail

# スクリプトの配置場所からプロジェクトルートを特定
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

# 本スクリプトではNode.js 22以上を前提とする
node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 22 ? 0 : 1)' \
  || die "Node.js 22以上を使用してください。現在: $(node -v)"

# 既存ファイルを誤って上書きしない
for target in \
  package.json package-lock.json \
  index.html vite.config.ts tsconfig.json \
  src public node_modules
do
  if [[ -e "$target" || -L "$target" ]]; then
    die "${target} が存在します。上書きを避けるため停止しました。"
  fi
done

# 親リポジトリ内での誤実行を防止
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_ROOT="$(git rev-parse --show-toplevel)"
  [[ "${GIT_ROOT:A}" == "$PROJECT_ROOT" ]] \
    || die "親ディレクトリのGitリポジトリ内です。配置場所を確認してください。"

  [[ -z "$(git status --porcelain --untracked-files=no)" ]] \
    || die "追跡済みファイルに未コミットの変更があります。先に整理してください。"
else
  git init -b main
fi

git var GIT_AUTHOR_IDENT >/dev/null 2>&1 \
  || die "git config user.name と user.email を設定してください。"

print -- "プロジェクトを作成します: $PROJECT_ROOT"

mkdir -p src/plugins src/styles public

# 既存の.gitignoreは保持して設定を追記
if [[ ! -f .gitignore ]]; then
  touch .gitignore
fi

if ! grep -Fqx '# homepage project ignores' .gitignore; then
  cat >> .gitignore <<'EOF'

# homepage project ignores
node_modules/
dist/
.vite/
coverage/
*.tsbuildinfo

# Local environment and secrets
.env
.env.*
!.env.example

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# macOS / editors
.DS_Store
.AppleDouble
.LSOverride
.idea/
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
*.swp
*.swo
EOF
fi

cat > package.json <<'EOF'
{
  "name": "homepage",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "engines": {
    "node": ">=22.0.0"
  },
  "scripts": {
    "dev": "vite",
    "typecheck": "vue-tsc --noEmit",
    "build": "npm run typecheck && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.5.0",
    "vuetify": "^3.7.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.2.0",
    "typescript": "~5.7.2",
    "vite": "^6.0.0",
    "vue-tsc": "^2.2.0"
  }
}
EOF

cat > vite.config.ts <<'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  base: '/homepage/',
  plugins: [vue()],
})
EOF

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "types": ["vite/client"]
  },
  "include": ["src/**/*.ts", "src/**/*.vue"]
}
EOF

cat > index.html <<'EOF'
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#f7f8fc" />
    <title>Homepage</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
EOF

cat > src/main.ts <<'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import './styles/main.css'

createApp(App).use(vuetify).mount('#app')
EOF

cat > src/plugins/vuetify.ts <<'EOF'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import {
  VApp,
  VMain,
  VContainer,
  VCard,
  VChip,
  VDivider,
} from 'vuetify/components'

export default createVuetify({
  components: {
    VApp,
    VMain,
    VContainer,
    VCard,
    VChip,
    VDivider,
  },
  theme: {
    defaultTheme: 'homepageLight',
    themes: {
      homepageLight: {
        dark: false,
        colors: {
          background: '#F7F8FC',
          surface: '#FFFFFF',
          primary: '#405CE8',
          secondary: '#64748B',
          'on-background': '#17243B',
          'on-surface': '#17243B',
          'on-primary': '#FFFFFF',
        },
      },
    },
  },
  defaults: {
    VCard: {
      elevation: 0,
      rounded: 'xl',
    },
  },
})
EOF

cat > src/App.vue <<'EOF'
<script setup lang="ts">
const year = new Date().getFullYear()
</script>

<template>
  <v-app>
    <a class="skip-link" href="#main-content">
      メインコンテンツへ
    </a>

    <header class="site-header">
      <v-container class="site-container header-inner">
        <a class="brand" :href="import.meta.env.BASE_URL" aria-label="ホーム">
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

html {
  overflow-y: auto;
}

body {
  margin: 0;
}

a {
  color: inherit;
}

:focus-visible {
  outline: 3px solid #405ce8;
  outline-offset: 5px;
}

.site-container {
  max-width: 1120px !important;
  padding-inline: 32px;
}

.site-header {
  background: rgba(255, 255, 255, 0.85);
  border-bottom: 1px solid #e8ecf4;
}

.header-inner {
  min-height: 88px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  text-decoration: none;
  font-size: 20px;
  font-weight: 750;
  letter-spacing: -0.04em;
}

.brand-mark {
  width: 30px;
  height: 30px;
  border-radius: 10px;
  background: linear-gradient(135deg, #405ce8, #90a6ff);
  box-shadow: 0 5px 14px #405ce824;
}

.header-caption {
  color: #64748b;
  font-size: 12px;
  letter-spacing: 0.04em;
}

.main-container {
  padding-top: clamp(56px, 9vw, 112px);
  padding-bottom: 80px;
}

.intro {
  margin-bottom: 52px;
}

.status-chip {
  font-weight: 700;
  letter-spacing: 0.1em;
}

h1 {
  margin: 26px 0 22px;
  font-size: clamp(36px, 6vw, 68px);
  font-weight: 750;
  line-height: 1.35;
  letter-spacing: -0.045em;
}

.intro-description {
  color: #64748b;
  font-size: 16px;
  line-height: 1.9;
}

.content-placeholder {
  padding: clamp(32px, 5vw, 60px);
  border: 1px solid #e5eaf3;
  box-shadow: 0 18px 60px #17243b05 !important;
}

.placeholder-symbol {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  margin-bottom: 30px;
  border-radius: 16px;
  background: #eef1ff;
}

.placeholder-symbol span {
  width: 5px;
  border-radius: 4px;
  background: #405ce8;
}

.placeholder-symbol span:nth-child(1) { height: 14px; }
.placeholder-symbol span:nth-child(2) { height: 24px; }
.placeholder-symbol span:nth-child(3) { height: 18px; }

.eyebrow {
  margin-bottom: 12px;
  color: #405ce8;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.16em;
}

.content-placeholder h2 {
  margin-bottom: 12px;
  font-size: clamp(20px, 3vw, 26px);
  line-height: 1.6;
  letter-spacing: -0.03em;
}

.content-placeholder > p:last-child {
  color: #64748b;
  font-size: 14px;
  line-height: 1.9;
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  padding-block: 24px;
  color: #64748b;
  font-size: 13px;
}

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

.skip-link:focus {
  transform: translateY(0);
}

@media (max-width: 600px) {
  .site-container {
    padding-inline: 24px;
  }

  .header-inner {
    min-height: 76px;
  }

  .header-caption {
    display: none;
  }

  .main-container {
    padding-bottom: 56px;
  }
}
EOF

# Vueテンプレート内から安全に参照できるよう変数化
node --input-type=module <<'EOF'
import fs from 'node:fs'

const file = 'src/App.vue'
let source = fs.readFileSync(file, 'utf8')
source = source.replace(
  'const year = new Date().getFullYear()',
  'const year = new Date().getFullYear()\nconst baseUrl = import.meta.env.BASE_URL',
)
source = source.replace(
  ':href="import.meta.env.BASE_URL"',
  ':href="baseUrl"',
)
fs.writeFileSync(file, source)
EOF

print -- "依存関係をインストールします..."
npm install

print -- "型チェックと本番ビルドを実行します..."
npm run build

print -- ""
print -- "プロジェクトの作成とビルドが完了しました。"
print -- "開発サーバー: npm run dev"
print -- "表示URL: http://localhost:5173/homepage/"
print -- "これから、未追跡ファイルも含めて変更をコミットします。"

git add .
git commit -m 'Vuetify3のライトテーマでホームページの雛形を作成'
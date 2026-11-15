import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const root = fileURLToPath(new URL('../', import.meta.url))
const sourceRoot = path.join(root, 'content/portfolio')
const generatedRoot = path.join(root, 'src/generated')
const assetsRoot = path.join(root, 'public/portfolio-assets')
const pagesRoot = path.join(root, 'portfolio/items')
const marker = '.portfolio-generator'
const imageExtensions = new Set(['.png', '.jpg', '.jpeg', '.webp', '.avif', '.gif'])

const fail = (message) => {
  throw new Error(message)
}

const plain = (value) =>
  value.replace(/\\([%&#_$}{\\])/g, '$1').trim()

function stripComments(source) {
  let output = ''

  for (let i = 0; i < source.length; i++) {
    if (source[i] === '\\' && i + 1 < source.length) {
      output += source[i] + source[++i]
    } else if (source[i] === '%') {
      while (i < source.length && source[i] !== '\n') i++
      output += '\n'
    } else {
      output += source[i]
    }
  }

  return output
}

function parsePortfolio(source, filename) {
  const text = stripComments(source)
  let position = 0
  let inside = false
  let ended = false
  let started = false
  let paragraph = ''

  const metadata = {}
  const blocks = []

  const error = (message) => fail(`${filename}: ${message}`)
  const skip = () => {
    while (/\s/.test(text[position] ?? '') && position < text.length) position++
  }

  const argument = () => {
    skip()
    if (text[position] !== '{') error('コマンドの引数 { ... } が必要です。')
    position++

    let depth = 1
    let value = ''

    while (position < text.length) {
      const character = text[position++]

      if (character === '\\' && position < text.length) {
        value += character + text[position++]
        continue
      }

      if (character === '{') depth++
      if (character === '}') depth--

      if (depth === 0) return value
      value += character
    }

    error('閉じていない波括弧があります。')
  }

  const flush = () => {
    for (const value of paragraph.split(/\n\s*\n/)) {
      const content = plain(value.replace(/\s*\n\s*/g, ' '))
      if (content) blocks.push({ type: 'paragraph', text: content })
    }
    paragraph = ''
  }

  while (position < text.length) {
    if (text[position] !== '\\') {
      const character = text[position++]
      if (inside) paragraph += character
      else if (!/\s/.test(character)) error('本文はportfolio環境の中に記述してください。')
      continue
    }

    position++
    const escaped = text[position]

    if (escaped && '%&#_$}{\\'.includes(escaped)) {
      if (!inside) error('環境の外に本文があります。')
      paragraph += '\\' + escaped
      position++
      continue
    }

    const match = text.slice(position).match(/^[A-Za-z]+/)
    if (!match) error('不正なコマンドです。')

    const command = match[0]
    position += command.length

    if (command === 'begin') {
      if (argument().trim() !== 'portfolio' || started || ended) {
        error('portfolio環境は1つだけ指定してください。')
      }
      inside = true
      started = true
      continue
    }

    if (command === 'end') {
      if (argument().trim() !== 'portfolio' || !inside) {
        error('portfolio環境の終了が不正です。')
      }
      flush()
      inside = false
      ended = true
      continue
    }

    if (ended) error('portfolio環境の終了後にコマンドは記述できません。')

    if (command === 'fig') {
      const image = plain(argument())
      const caption = plain(argument())

      if (!image || !caption) error('figには画像パスと説明が必要です。')

      if (inside) {
        flush()
        blocks.push({ type: 'figure', source: image, caption })
      } else {
        if (metadata.thumbnail) error('サムネイルは1つだけ指定してください。')
        metadata.thumbnail = { source: image, caption }
      }
      continue
    }

    if (inside && ['section', 'subsection'].includes(command)) {
      flush()
      const heading = plain(argument())
      if (!heading) error('見出しが空です。')
      blocks.push({
        type: 'heading',
        level: command === 'section' ? 2 : 3,
        text: heading,
      })
      continue
    }

    if (!inside && ['title', 'tag', 'repos', 'summary'].includes(command)) {
      if (metadata[command] !== undefined) {
        error(`${command}が重複しています。`)
      }
      metadata[command] = plain(argument())
      continue
    }

    error(`未対応のコマンドです: \\${command}`)
  }

  if (!started || !ended || inside) error('portfolio環境が正しく閉じられていません。')

  for (const key of ['title', 'tag', 'repos', 'summary', 'thumbnail']) {
    if (!metadata[key]) error(`${key}が指定されていません。`)
  }

  const tags = [...new Set(metadata.tag.split(',').map((v) => v.trim()).filter(Boolean))]
  if (!tags.length) error('タグを1つ以上指定してください。')
  if (!blocks.length) error('詳細説明が空です。')

  let repository
  try {
    repository = new URL(metadata.repos)
  } catch {
    error('リポジトリURLが不正です。')
  }

  if (repository.protocol !== 'https:' || repository.username || repository.password) {
    error('リポジトリURLは認証情報を含まないHTTPS URLにしてください。')
  }

  return {
    title: metadata.title,
    tags,
    repositoryUrl: repository.href,
    summary: metadata.summary,
    thumbnail: metadata.thumbnail,
    blocks,
  }
}

function ownedDirectory(directory) {
  if (fs.existsSync(directory)) {
    if (fs.lstatSync(directory).isSymbolicLink()) {
      fail(`生成先にシンボリックリンクは使用できません: ${directory}`)
    }
    if (!fs.existsSync(path.join(directory, marker))) {
      fail(`生成先に管理外のディレクトリがあります: ${directory}`)
    }
  }
}

function resetDirectory(directory) {
  if (fs.existsSync(directory)) fs.rmSync(directory, { recursive: true })
  fs.mkdirSync(directory, { recursive: true })
  fs.writeFileSync(path.join(directory, marker), 'Generated. Do not edit.\n')
}

const escapeHtml = (text) => text.replace(/[&<>"']/g, (character) => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[character]))

fs.mkdirSync(sourceRoot, { recursive: true })
const items = []
const assets = []

for (const entry of fs.readdirSync(sourceRoot, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
  if (entry.isSymbolicLink()) fail(`作品フォルダにシンボリックリンクは使用できません: ${entry.name}`)
  if (!entry.isDirectory()) continue

  const slug = entry.name
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug)) {
    fail(`作品フォルダ名は半角英小文字・数字・ハイフンにしてください: ${slug}`)
  }

  const directory = path.join(sourceRoot, slug)
  const texFile = path.join(directory, 'index.tex')
  if (!fs.existsSync(texFile)) fail(`${slug}/index.texがありません。`)

  const realDirectory = fs.realpathSync(directory)
  const item = parsePortfolio(fs.readFileSync(texFile, 'utf8'), `${slug}/index.tex`)
  const imageMap = new Map()

  const image = (figure) => {
    const file = path.resolve(directory, figure.source)
    if (!fs.existsSync(file)) fail(`${slug}: 画像がありません: ${figure.source}`)

    const realFile = fs.realpathSync(file)
    if (!realFile.startsWith(realDirectory + path.sep) || !fs.statSync(realFile).isFile()) {
      fail(`${slug}: 画像は作品フォルダ内のファイルを指定してください。`)
    }

    const extension = path.extname(realFile).toLowerCase()
    if (!imageExtensions.has(extension)) {
      fail(`${slug}: 未対応の画像形式です: ${figure.source}`)
    }

    if (!imageMap.has(realFile)) {
      const name = `image-${imageMap.size + 1}${extension}`
      const relative = `portfolio-assets/${slug}/${name}`
      imageMap.set(realFile, relative)
      assets.push({ source: realFile, relative })
    }

    return { src: imageMap.get(realFile), caption: figure.caption }
  }

  items.push({
    slug,
    title: item.title,
    tags: item.tags,
    repositoryUrl: item.repositoryUrl,
    summary: item.summary,
    thumbnail: image(item.thumbnail),
    blocks: item.blocks.map((block) =>
      block.type === 'figure'
        ? { type: 'figure', ...image(block) }
        : block,
    ),
  })
}

// 原稿と画像をすべて検証してから、生成先を更新する
ownedDirectory(assetsRoot)
ownedDirectory(pagesRoot)

const rootHtml = fs.readFileSync(path.join(root, 'index.html'), 'utf8')
if (!/<title>[\s\S]*?<\/title>/.test(rootHtml)) fail('index.htmlにtitleがありません。')

resetDirectory(assetsRoot)
resetDirectory(pagesRoot)
fs.mkdirSync(generatedRoot, { recursive: true })

for (const asset of assets) {
  const destination = path.join(root, 'public', asset.relative)
  fs.mkdirSync(path.dirname(destination), { recursive: true })
  fs.copyFileSync(asset.source, destination)
}

const entries = {}

for (const item of items) {
  const directory = path.join(pagesRoot, item.slug)
  fs.mkdirSync(directory)

  const title = `${escapeHtml(item.title)} | ポートフォリオ | NEBUKA KEITA`
  let html = rootHtml.replace(/<title>[\s\S]*?<\/title>/, () => `<title>${title}</title>`)

  const description = `<meta name="description" content="${escapeHtml(item.summary)}" />`
  const descriptionPattern = /<meta\b(?=[^>]*\bname=["']description["'])[^>]*>/i

  html = descriptionPattern.test(html)
    ? html.replace(descriptionPattern, () => description)
    : html.replace('</head>', () => `  ${description}\n</head>`)

  const filename = path.join(directory, 'index.html')
  fs.writeFileSync(filename, html)
  entries[`portfolio-${item.slug}`] = filename
}

fs.writeFileSync(
  path.join(generatedRoot, 'portfolio.json'),
  JSON.stringify(items, null, 2) + '\n',
)

fs.writeFileSync(
  path.join(generatedRoot, 'portfolio-entries.mjs'),
  `export default ${JSON.stringify(entries, null, 2)}\n`,
)

console.log(`ポートフォリオ生成完了: ${items.length}件`)

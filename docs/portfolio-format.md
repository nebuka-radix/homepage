# ポートフォリオの記述仕様

## 配置

content/portfolio/作品の識別子/index.tex

画像も同じ作品フォルダ内に配置します。
作品フォルダ名が詳細ページのURLに使われます。

詳細ページ:
 /homepage/portfolio/items/作品の識別子/

## 原稿例

下記のリポジトリURLを実際のURLに置き換え、
指定した画像を配置してから使用してください。

```latex
\title{制作物のタイトル}
\tag{TypeScript, Vue, 業務改善}
\repos{[https://github.com/OWNER/REPOSITORY](https://github.com/OWNER/REPOSITORY)}
\summary{制作物を一言で説明します。}

\fig{thumbnail.webp}{制作物のメイン画面}

\begin{portfolio}

\section{開発の背景}

ここに背景を記述します。

空行で段落を分けます。
同じ段落内の改行は空白として扱います。

\section{主な機能}

\subsection{機能の紹介}

ここに説明を記述します。

\fig{screen-01.webp}{操作画面の例}

\section{工夫した点}

ここに設計や実装で工夫した点を記述します。

\end{portfolio}
```

## ルール

- title・tag・repos・summaryはそれぞれ1回、環境の前に記述します。
- tagは半角カンマ区切りです。前後の空白は除去します。
- reposには認証情報を含まないHTTPS URLを指定します。
- 環境の前のfigはサムネイルです。1つ必要です。
- 環境内のfigは参考図です。0個以上記述できます。
- figの引数は「画像パス」「説明」の2つです。
- 画像の説明はキャプションおよび代替テキストに使います。
- 画像は作品フォルダ内のPNG・JPEG・WebP・AVIF・GIFに対応します。
- SVG・PDFの直接表示には対応しません。
- 詳細説明は環境内に記述します。
- section・subsection以外の本文用コマンドには未対応です。
- HTML、任意のLaTeXマクロ、外部ファイルの読み込みは実行しません。
- %以降はコメントです。文字として使う場合は \% と記述します。
- \& \_ \# \$ \{ \} \\ のエスケープに対応します。
- 数式・itemize・textbfなどは今回の対応範囲に含みません。
- 掲載順は作品フォルダ名の順です。
- 公開対象の作品だけをcontent/portfolioに配置してください。

## 編集後

開発サーバーを停止して npm run dev を再実行すると再生成します。
原稿・画像の変更の自動監視は今回の実装には含みません。

手動生成:
 npm run portfolio:generate

公開ビルド:
 npm run build

開発・本番ビルド前に生成処理が自動実行されます。

生成先:
 src/generated/portfolio.json
 src/generated/portfolio-entries.mjs
 public/portfolio-assets/
 portfolio/items/

生成先はGit管理対象外です。
生成先に置いたファイルは次回生成時に削除・再作成されます。
必ずcontent/portfolio内の原稿・画像を編集してください。

作品を削除するときは作品フォルダを削除し、再生成します。

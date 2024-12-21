---
date: '2024-12-21T16:27:29+09:00'
title: 'Hugo-PaperModでOpenGraph画像のフォールバックを設定する方法'
slug: 'set-fallback-for-opengraph-image-in-hugo-papermod'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
---

タイトルについて、現状の公式ドキュメントの記載だと設定の優先順位が分かりづらかったので整理した。

## 実行環境

- Hugo: v0.137
- PaperMod: v8.0

```bash
$ hugo version
hugo v0.137.0-59c115813595cba1b1c0e70b867e734992648d1b+extended windows/amd64 BuildDate=2024-11-04T16:04:06Z VendorInfo=gohugoio
$ git submodule foreach 'git log -1 --oneline'
Entering 'themes/PaperMod'
3e53621 (HEAD -> master, origin/master, origin/HEAD) Update PaperMod version to v8+ in license.css and license.js
```

## 結論

`hugo.yaml` の params の images で`static/images`に配置[^1]したフォールバック対象の画像を設定する:

[^1]: Hugoではstaticディレクトリに置いたファイルがそのまま公開URLに反映されるため

```yaml
params:
  images:
    - "images/default-cover.jpg"
```

### 確認方法

ローカル環境

1. `hugo`コマンドでビルドして以下を確認する。
	1. `public/images/default-cover.jpg`が生成されていること
	2. `public/index.html`のmetaタグに以下が含まれていること:
```html
<meta property="og:image" content="https://example.com/images/default-cover.jpg">
```

デプロイ後

- [OpenGraph](https://opengraph.dev/)などでデプロイしたURLを入力し、サムネイルが正しく表示されるかを確認する。

## 説明

PaperModのOpenGraph画像選択ロジックは以下の順序で処理される。

1. [opengraph.html](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/templates/opengraph.html)
2. [\_funcs/get-page-images.html](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/templates/_funcs/get-page-images.html)

その結果、以下の優先順位で画像が選択される:

1. Frontmatterの`cover.image`で指定された画像
2. Frontmatterの`images`で指定された最初の画像
3. Page Bundle内のファイル名に`feature`, `cover`, `thumbnail`を含む画像
4. `site.Params.images`で指定された最初の画像

つまり、最後に読み取られるhugo.yamlの設定がフォールバックになる。

## 参考

- [Features / Mods | PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#opengraph-support)
- [Variables · adityatelange/hugo-PaperMod Wiki](https://github.com/adityatelange/hugo-PaperMod/wiki/Variables#site-variables-under-params)

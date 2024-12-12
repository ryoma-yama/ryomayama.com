---
date: '2024-12-12T14:54:30+09:00'
title: 'Bluesky (bsky.app) への共有リンクを Hugo (PaperMod) に追加する方法'
slug: 'adding-bluesky-share-link-to-hugo-papermod'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
  - Bluesky
---

Blueskyは旧Twitter・現Xからの移住先として最近話題の分散型SNSだ。分散型であることから、ユーザーが属するサーバーは個々で異なり、記事を共有する先を一意に特定するのが技術的に難しい。この点を理由に、PaperModではBluesky共有リンクの実装が見送られている[^1]。

[^1]: > we cant have a single domain for a decentralised platform. you can't make it customisable because you need to ask user where he/she want to post it. | [add share icon for bluesky by geowarin · Pull Request #1629 · adityatelange/hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod/pull/1629#issuecomment-2480481785)

しかし、BlueskyのWebクライアントである **bsky.app** のWebAPIを介することで、共有リンクをクリックしたユーザーのログイン状態に応じて所属サーバー（例: 公式サーバーの`bsky.social`）が動的に選択される仕組みが提供されている。この仕組みを利用すれば、分散型SNSの課題を回避しつつ記事を共有できる。

ということで、以下では、この共有リンクをPaperModに追加する手順を説明する。

なおこの記事では、テーマとしてPaperModを用いているが、テンプレートのコードについては他のテーマでも参考になると思う。

では、早速手順に移ろう。

## 実行環境

- Hugo: v0.137.0
- PaperMod: v8.0
- Bash: v4.4.23

```bash
$ hugo version
hugo v0.137.0-59c115813595cba1b1c0e70b867e734992648d1b+extended windows/amd64 BuildDate=2024-11-04T16:04:06Z VendorInfo=gohugoio
$ git submodule foreach 'git log -1 --oneline'
Entering 'themes/PaperMod'
3e53621 (HEAD -> master, origin/master, origin/HEAD) Update PaperMod version to v8+ in license.css and license.js
$ bash --version
GNU bash, version 4.4.23(1)-release (x86_64-pc-msys)
```

## PaperModの共有リンク表示部分をカスタマイズする

Hugoには標準でテーマを部分的に上書きしてカスタマイズできる方法がある。ここでは、プロジェクトのルートディレクトリ内のlayoutsフォルダに配置されたテンプレートは、テーマ内の同名ファイルよりも優先されるルールを利用する[^2]。

[^2]: [Hugo | Customize a Theme # Override Template Files](https://gohugobrasil.netlify.app/themes/customizing/#override-template-files)

まず、[PaperModの共有リンク表示部分](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/share_icons.html)をコピーする。ルートディレクトリで以下のコマンドを使えば一発でコピーできる。

```bash
install -D themes/papermod/layouts/partials/share_icons.html layouts/partials/share_icons.html
```

そして、ifブロックが並んでいる階層に以下のコードを追加する。

```html
    {{- if (cond ($custom) (in $ShareButtons "bluesky") (true)) }}
    <li>
        <a target="_blank" rel="noopener noreferrer" aria-label="share {{ $title | plainify }} on Bluesky (bsky.app)"
            href="https://bsky.app/intent/compose?text={{ $title | plainify | htmlEscape }}%20{{ $pageurl | htmlEscape }}{{ if ne ($.Scratch.Get "tags") "" }}%20{{ printf "#%s" (replace ($.Scratch.Get "tags") "," " #") }}{{ end }}">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 32 448 448" xml:space="preserve" height="30px" width="30px" fill="currentColor"><!--!Font Awesome Free 6.7.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M64 32C28.7 32 0 60.7 0 96L0 416c0 35.3 28.7 64 64 64l320 0c35.3 0 64-28.7 64-64l0-320c0-35.3-28.7-64-64-64L64 32zM224 247.4c14.5-30 54-85.8 90.7-113.3c26.5-19.9 69.3-35.2 69.3 13.7c0 9.8-5.6 82.1-8.9 93.8c-11.4 40.8-53 51.2-90 44.9c64.7 11 81.2 47.5 45.6 84c-67.5 69.3-97-17.4-104.6-39.6c0 0 0 0 0 0l-.3-.9c-.9-2.6-1.4-4.1-1.8-4.1s-.9 1.5-1.8 4.1c-.1 .3-.2 .6-.3 .9c0 0 0 0 0 0c-7.6 22.2-37.1 108.8-104.6 39.6c-35.5-36.5-19.1-73 45.6-84c-37 6.3-78.6-4.1-90-44.9c-3.3-11.7-8.9-84-8.9-93.8c0-48.9 42.9-33.5 69.3-13.7c36.7 27.5 76.2 83.4 90.7 113.3z"/></svg>
        </a>
    </li>
    {{- end }}
```

このコードについて順を追って簡潔に説明する。
1. ifブロック: 設定ファイルの`ShareButtons`項目の値に`bluesky`がある場合にこの要素を表示する。
2. aタグ: `blusky.app`の投稿作成API[^3]を利用した共有リンクを作成する。このリンクでは旧Twitterへの共有リンクと同様に、記事タイトルをテキスト、記事タグをハッシュタグとして生成する。タグがない場合はハッシュタグ部分を省略する。
3. SVGタグ: 公式ドキュメントに記載のあるFontAwesomeのSVG[^4]を用いる。このSVGは元々が真四角ではなく横長で上下に余白を取っているので、ここで表示するときにはviewBoxプロパティで調整している。

[^3]: [Action Intent Links | Bluesky](https://docs.bsky.app/docs/advanced-guides/intent-links)

[^4]: [Square Bluesky Icon | Font Awesome](https://fontawesome.com/icons/square-bluesky?f=brands&s=solid)

## 設定ファイルでBlueskyの共有ボタンを有効化する

hugo.yamlに以下の記載を追加する

```yaml
params:
  shareButtons:
    - bluesky
```

あとはビルドして表示されることを確認して、実際に自分の記事を共有リンクから共有するのを試してみる。

```bash
hugo server
```

## まとめ

以上の手順でHugo (PaperMod) に Blueskyへの投稿共有リンクを追加できる。

全体的な修正内容については[このコミット](https://github.com/ryoma-yama/ryomayama.com/commit/48c79933126aaf9ef097de624c1642044ad393b1)を参照してほしい。

## 参考

- [Go template functions, operators, and statements | Hugo](https://gohugo.io/functions/go-template/)

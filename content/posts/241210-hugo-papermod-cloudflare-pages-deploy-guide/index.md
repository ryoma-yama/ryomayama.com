---
date: '2024-12-10T22:37:04+09:00'
title: 'Hugo (PaperMod)で作成したサイトをCloudflare Pagesにデプロイする手順'
slug: 'hugo-papermod-cloudflare-pages-deploy-guide'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
  - Cloudflare
  - GitHub
---

HugoはGoベースの静的サイト作成ツールである。これをリポジトリとしてのGitHubと静的ファイル配信サービスのCloudflare Pagesを使うと簡単かつ無料でサイトを公開できる。ということで、今回はその手順を説明する。

なお、Hugoでサイトを作ろうとする人はGitなど知識があると考えて細かい説明は省略する。また、今回は手順を単純化するためにHugoのテーマはブログ向けの"PaperMod"を用いる。そして、コマンドを実行する場所はシェルを前提とする。

##  執筆時の実行環境

```zsh
~ $ sw_vers           
ProductName:		macOS
ProductVersion:		14.7.1
BuildVersion:		23H222
~ $ zsh --version
zsh 5.9 (x86_64-apple-darwin23.0)
```

## 前提

- [Install Hugo](https://gohugo.io/installation/)
- [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## サイトを作成してテーマにPaperModを設定する

設定ファイルをTOMLからより可読性の高いYAMLにしてサイトを作成し、移動する。
```bash
hugo new site ryomayama.com --format yaml
cd ryomayama.com
```

Gitリポジトリとして初期化し、PaperModをサブモジュールとして入れる。
```bash
git init
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

設定ファイルでテーマをPaperModに設定し、ビルド成果物をGit管理下から外す。
```bash
echo 'theme: ["PaperMod"]' >> hugo.yaml
echo "public/" >> .gitignore
```

##  最初の記事を作成する

以下のコマンドで最初の記事を作成する。
```bash
hugo new posts/first-post.md
```

作成したファイルを開き、下書き・ドラフトを解除（`draft: true` を `draft: false` に変更・または項目を削除）、"Hello, world!"などの文言を試しに入れてみる。以下が例。
```md
---
date: '2024-12-07T17:41:19+09:00'
title: 'First Post'
---

Hello, world!
```

開発サーバーを起動して表示確認する
```bash
hugo server
```

## タイトルとドメインを変更する

- `hugo.yaml`ファイルを開いて以下の値を変更する。
	- baseURL: サイトのドメイン。Cloudflare Pagesにデプロイする際にカスタムドメインを使用したい場合はそれに変更する。Cloudflare Pagesが用意するドメインを使用する場合は変更しなくてOK。
	- languageCode: サイトの主要言語[^1]。日本語なら`ja`。
	- title: サイトのタイトル。好きなタイトルに変更する。
- 以下が例。
```yaml
baseURL: https://example.org/
languageCode: ja
title: ryomayama.com
theme: ["PaperMod"]
```

[^1]: [Language | Hugo](https://gohugo.io/methods/site/language/)

##  ついでにREADME.mdを作成する

他の端末でもこの環境を動かす際に必要な情報を書いておくといい。

例は[GitHubのこのコミット](https://github.com/ryoma-yama/ryomayama.com/blob/e7437fe962abd471cacd31911375e3da798ad31d/README.md?plain=1)を参照のこと。コピペして適宜修正するなりして使ってくれ。

## 確認してコミットする

ここまで諸々確認して、問題なければステージングしてコミットする。
```bash
git add .
git commit -m "Initial commit"
```

## GitHubにリポジトリを作成する

具体的な手順は省略。公開範囲はPublicまたはPrivateのどちらでも構わない。**リポジトリの初期化はしないこと**。

作成したら、GitHubにあるコマンドでローカルからPublishする。

## Cloudflare Pagesにデプロイする

Cloudflareにアカウントを作成する手順は画面通りにするだけなので省略。以降はログイン後の手順。

1. LoginしてDashboardを開く。
2. Menuの"Workers & Pages"を開き、Pagesのタブに切替、Gitに接続をクリック。先ほどサイトを作成したリポジトリを選択する。以降は標準でこのリポジトリのmainブランチへのコミットがデプロイのトリガーになる。
3. 「ビルドとデプロイのセットアップ」にて、**カスタムドメインを使うかどうかでビルドコマンドが変わる**。
	1. カスタムドメインを使う場合: `hugo.yaml`のbaseURLにカスタムドメインを記載していればデフォルトの`hugo`のままでOK
	2. カスタムドメインを使わない場合: ビルドコマンドを `hugo -b $CF_PAGES_URL` に変更してCloudflare Pagesが用意するドメインを利用する。この環境変数は自動で設定されるのでこちらで指定する必要はない。
4. また、**ビルド時の環境変数としてHugoのVersionを設定する**必要がある。Cloudflare Pages標準のHugoのVersionだとPaperModをビルドできないので、ビルドを確認したローカルのVersionを指定する必要がある。ローカルに戻って `hugo version` でversionを確認して、これを `HUGO_VERSION=0.137.0` のように設定する。
5. 保存してデプロイする。デプロイができてから実際にデプロイ先でサイトが見られるようになるまでには数分程度かかるので逸る気持ちを抑えて待ってほしい。
	1. あと、カスタムドメインを設定したい場合はこのデプロイ後の画面に「カスタムドメインを設定する」というメニューがあるのでそこから設定できる。

## 終わりに

このような感じでCloudflareを使うと無料かつ簡単にHugoでサイトを作成できる。Hugoには他にも多様なテーマがあるので色々と試してみるといい。

ちなみに、PaperModはHugoで最もスター数が多いテーマ[^2]であり、その分使用者も多くナレッジがある。このブログでもこれからPaperModでの設定例を取り上げていこうと思うので、参考にしてもらえたら幸いである。

[^2]: [hugo-theme · GitHub Topics](https://github.com/topics/hugo-theme)

なお、この記事を書いた後に気付いたのだが、内容の多くはCloudflareの公式ガイドに近いものだった。しかし、この記事では素晴らしいテーマであるPaperModの魅力を紹介し、使い回しが効くREADMEの例を提供できたことに価値があると考えている。

## 参考

- [Installation | Hugo](https://gohugo.io/installation/)
- [Install / Update PaperMod | PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-installation/)
- [Hugo · Cloudflare Pages docs](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)

---
date: '2024-12-12T14:54:30+09:00'
title: 'How to Add a Bluesky (bsky.app) Share Link to Hugo (PaperMod)'
slug: 'adding-bluesky-share-link-to-hugo-papermod'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
  - Bluesky
---

Bluesky is a decentralized social network based on the AT Protocol that has recently gained attention as an alternative to the former Twitter (now X). Due to its decentralized nature, user servers vary, making it technically challenging to create a universal sharing link. For this reason, Bluesky share links are not natively implemented in PaperMod[^1].

[^1]: > we cant have a single domain for a decentralised platform. you can't make it customisable because you need to ask user where he/she want to post it. | [add share icon for bluesky by geowarin · Pull Request #1629 · adityatelange/hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod/pull/1629#issuecomment-2480481785)

However, Bluesky's web client, **bsky.app**, provides a mechanism via its Web API to dynamically select the appropriate server based on the login state of the user clicking the share link (e.g., the official server `bsky.social`). By leveraging this mechanism, articles can be shared without encountering the challenges posed by decentralization.

This guide explains how to add a share link to PaperMod using the Web API.

Although the theme used here is PaperMod, the template modifications discussed may also serve as a reference for other themes.

Let’s proceed to the steps.

## Environment

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

## Customizing the Share Link Section in PaperMod

Hugo provides a standard method to customize theme components by overriding specific parts. Templates placed in the `layouts` directory within the root of the project take precedence over those with the same name in the theme directory[^2].

[^2]: [Hugo | Customize a Theme # Override Template Files](https://gohugobrasil.netlify.app/themes/customizing/#override-template-files)

First, copy the [share link section from PaperMod](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/share_icons.html). This can be done with the following command from the root directory:

```bash
install -D themes/papermod/layouts/partials/share_icons.html layouts/partials/share_icons.html
```

Next, add the following code to the same level where the `if` blocks are defined:

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

### Code Breakdown

1. **if block**: Displays the element only if `bluesky` is included in the `ShareButtons` configuration.
2. **`a` tag**: Creates the share link using `bsky.app`’s post creation API[^3]. Similar to the share link for the former Twitter, this uses the article title as text and article tags as hashtags. If no tags exist, the hashtag part is omitted.
3. **SVG tag**: Uses FontAwesome’s SVG for the Bluesky logo[^4]. The `viewBox` property adjusts the logo, as it originally includes extra vertical padding.

[^3]: [Action Intent Links | Bluesky](https://docs.bsky.app/docs/advanced-guides/intent-links)

[^4]: [Square Bluesky Icon | Font Awesome](https://fontawesome.com/icons/square-bluesky?f=brands&s=solid)

## Enabling the Bluesky Share Button in the Configuration File

Add the following entry to `hugo.yaml`:

```yaml
params:
  shareButtons:
    - bluesky
```

Afterward, build the site and verify the share button appears. Test sharing an article via the link.

```bash
hugo server
```

## Conclusion

By following the steps outlined above, a Bluesky share link can be added to Hugo (PaperMod).

For a detailed overview of the changes, refer to [this commit](https://github.com/ryoma-yama/ryomayama.com/commit/48c79933126aaf9ef097de624c1642044ad393b1).

## References

- [Go template functions, operators, and statements | Hugo](https://gohugo.io/functions/go-template/)

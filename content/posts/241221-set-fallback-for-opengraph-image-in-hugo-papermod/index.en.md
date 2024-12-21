---
date: '2024-12-21T16:27:29+09:00'
title: 'How to Set a Fallback OpenGraph Image in Hugo-PaperMod'
slug: 'set-fallback-for-opengraph-image-in-hugo-papermod'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
---

The prioritization of settings in the official documentation is not clearly outlined, so this guide organizes the process.

## Environment

- Hugo: v0.137
- PaperMod: v8.0

```bash
$ hugo version
hugo v0.137.0-59c115813595cba1b1c0e70b867e734992648d1b+extended windows/amd64 BuildDate=2024-11-04T16:04:06Z VendorInfo=gohugoio
$ git submodule foreach 'git log -1 --oneline'
Entering 'themes/PaperMod'
3e53621 (HEAD -> master, origin/master, origin/HEAD) Update PaperMod version to v8+ in license.css and license.js
```

## Conclusion

Configure a fallback image placed in the `static/images` directory[^1] by specifying it in the `params.images` section of `hugo.yaml`:

[^1]: In Hugo, files in the `static` directory are directly reflected in the public URL.

```yaml
params:
  images:
    - "images/default-cover.jpg"
```

### Verification Steps

#### Local Environment

1. Run the `hugo` command to build the site and verify the following:
   1. The file `public/images/default-cover.jpg` is generated.
   2. The `public/index.html` file includes the following `<meta>` tag:
   
   ```html
   <meta property="og:image" content="https://example.com/images/default-cover.jpg">
   ```

#### After Deployment

- Use tools like [OpenGraph](https://opengraph.dev/) to check the deployed URL and confirm that the thumbnail displays correctly.

## Explanation

The OpenGraph image selection logic in PaperMod follows this order:

1. [opengraph.html](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/templates/opengraph.html)
2. [\_funcs/get-page-images.html](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/templates/_funcs/get-page-images.html)

The image selection prioritization is as follows:

1. An image specified in the `cover.image` field of the front matter.
2. The first image specified in the `images` field of the front matter.
3. Images in the Page Bundle whose filenames include `feature`, `cover`, or `thumbnail`.
4. The first image specified in `site.Params.images`.

Thus, the `hugo.yaml` setting is used as the fallback in this hierarchy.

## References

- [Features / Mods | PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#opengraph-support)
- [Variables · adityatelange/hugo-PaperMod Wiki](https://github.com/adityatelange/hugo-PaperMod/wiki/Variables#site-variables-under-params)

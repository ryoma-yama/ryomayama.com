---
date: '2024-12-10T22:37:04+09:00'
title: 'How to Deploy a Hugo (PaperMod) Site to Cloudflare Pages'
slug: 'hugo-papermod-cloudflare-pages-deploy-guide'
categories:
  - Guides
tags:
  - Hugo
  - PaperMod
  - Cloudflare
  - GitHub
---

Hugo is a static site generator built with Go. By using GitHub as a repository and Cloudflare Pages as a static file hosting service, it is possible to publish a site easily and at no cost. This guide outlines the steps required for deployment.

For simplicity, it is assumed that readers have basic knowledge of Git and related tools. The blog-oriented theme "PaperMod" will be used as an example, and the commands are intended to be executed in a shell environment.

## Environment Used for This Guide

```zsh
~ $ sw_vers           
ProductName:		macOS
ProductVersion:		14.7.1
BuildVersion:		23H222
~ $ zsh --version
zsh 5.9 (x86_64-apple-darwin23.0)
```

## Prerequisites

- [Install Hugo](https://gohugo.io/installation/)
- [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Creating a Site and Setting the PaperMod Theme

Create a site with YAML as the configuration file format and navigate to the directory.

```bash
hugo new site ryomayama.com --format yaml
cd ryomayama.com
```

Initialize the site as a Git repository and add PaperMod as a submodule.

```bash
git init
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

Set PaperMod as the theme in the configuration file and exclude the build output directory from version control.

```bash
echo 'theme: ["PaperMod"]' >> hugo.yaml
echo "public/" >> .gitignore
```

## Creating the First Post

Create the first post using the following command.

```bash
hugo new posts/first-post.md
```

Edit the created file, disable the draft status (`draft: true` → `draft: false` or remove the key), and add sample content like "Hello, world!" as shown in the example below.

```md
---
date: '2024-12-07T17:41:19+09:00'
title: 'First Post'
---

Hello, world!
```

Start the development server to preview the site.

```bash
hugo server
```

## Updating the Title and Domain

Edit the `hugo.yaml` file to update the following settings:

- `baseURL`: The site's domain. Use a custom domain if deploying to Cloudflare Pages with one. If using the default domain provided by Cloudflare Pages, no changes are needed.
- `languageCode`: The primary language of the site (e.g., `ja` for Japanese).
- `title`: The title of the site.

Example configuration:

```yaml
baseURL: https://example.org/
languageCode: ja
title: ryomayama.com
theme: ["PaperMod"]
```

## Creating a README.md File

It is useful to include information in a `README.md` file for replicating the environment on other devices. An example can be found in [this GitHub commit](https://github.com/ryoma-yama/ryomayama.com/blob/e7437fe962abd471cacd31911375e3da798ad31d/README.md?plain=1). Copy and modify it as needed.

## Committing Changes

After verifying the setup, stage and commit the changes.

```bash
git add .
git commit -m "Initial commit"
```

## Creating a GitHub Repository

Create a new repository on GitHub. The repository can be either public or private. **Do not initialize the repository.**

Publish the local repository to GitHub using the command provided in the GitHub interface.

## Deploying to Cloudflare Pages

Create a Cloudflare account and log in. Follow the steps below from the dashboard:

1. Navigate to "Workers & Pages" > "Pages" and click "Connect to Git." Select the repository created earlier. By default, commits to the `main` branch will trigger deployments.
2. In the "Build and Deploy" setup:
   - If using a custom domain, ensure the custom domain is specified in the `baseURL` of `hugo.yaml` and leave the build command as `hugo`.
   - If not using a custom domain, set the build command to `hugo -b $CF_PAGES_URL` to use the domain provided by Cloudflare Pages. The `$CF_PAGES_URL` environment variable is automatically set.
3. Specify the Hugo version as a build environment variable, as the default Hugo version may not support PaperMod. Confirm the version locally with `hugo version` and set it (e.g., `HUGO_VERSION=0.137.0`).

Save the settings and deploy the site. Deployment takes a few minutes. After deployment, you can configure a custom domain from the dashboard if desired.

## Conclusion

Using Cloudflare Pages, you can create and deploy a Hugo site for free with minimal effort. Hugo also offers a variety of themes, making it worthwhile to explore different options.

PaperMod is one of the most popular Hugo themes[^2], widely supported with abundant user-created resources. This blog will continue to cover configuration examples for PaperMod.

[^2]: [hugo-theme · GitHub Topics](https://github.com/topics/hugo-theme)

Much of the content aligns with Cloudflare's official guide; however, this article emphasizes the PaperMod theme and includes practical examples, such as reusable README files.


## References

- [Installation | Hugo](https://gohugo.io/installation/)
- [Install / Update PaperMod | PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-installation/)
- [Hugo · Cloudflare Pages docs](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)

# My Blog

- Live Site: [ryomayama.com](https://ryomayama.com)
- Theme: [PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## Prerequisites

- [Install Hugo](https://gohugo.io/installation/)
- [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Setup

```sh
git clone https://github.com/ryoma-yama/ryomayama.com.git
cd example.com
git submodule update --init --recursive
```

## Create a new post

Generate `posts/${currentDate}-${slug}/index.md` based on the given `${slug}`.
```sh
bin/create-new-post.sh ${slug}
```

Default command:
```sh
hugo new posts/<article-name>.md
```

## Start the development server (include drafts):

```sh
hugo server -D
```

## License

- **Code**: The code in this repository (including Hugo configurations and theme customizations) is licensed under the MIT License.
- **Articles**: The articles and written content in this repository are licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

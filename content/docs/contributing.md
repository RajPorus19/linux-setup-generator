---
title: "Contributing"
weight: 1
---

Linux Setup Generator is open source and contributions of all kinds are welcome — whether that is adding a new program, fixing a bug, improving the UI, or reporting an issue.

## Submitting a pull request

The repository is hosted on GitHub at [github.com/RajPorus19/linux-setup-generator](https://github.com/RajPorus19/linux-setup-generator).

To contribute code or content:

1. **Fork** the repository using the Fork button at the top-right of the GitHub page.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/linux-setup-generator.git
   cd linux-setup-generator
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b my-feature
   ```
4. **Make your changes** and test them locally with `hugo server -b http://localhost:1313 -p 1313`.
5. **Commit and push** your branch:
   ```bash
   git add .
   git commit -m "Add: describe your change"
   git push origin my-feature
   ```
6. **Open a pull request** on GitHub from your branch to `main`.

A short description of what you changed and why is very helpful for review.

## Reporting an issue

If a program does not install correctly, a script contains an error, or something on the site looks broken, please [open an issue on GitHub](https://github.com/RajPorus19/linux-setup-generator/issues).

To help fix the problem as quickly as possible, please include:

- **The distro you selected** (e.g. Ubuntu, Arch, Void)
- **The program(s) that caused the issue** (name or slug)
- **What went wrong** — the exact error message from your terminal if you have one
- **What you expected to happen**

The more detail you provide, the easier it is to reproduce and fix the bug.

## Other ways to help

- **Add a missing program** — see the [Add a program](/docs/add-a-program/) guide.
- **Add a new distro** — see the [Add a distro](/docs/add-a-distro/) guide.
- **Improve descriptions** — if a program description is unclear or wrong, a PR to fix it is very welcome.
- **Star the repo** — it helps others find the project.

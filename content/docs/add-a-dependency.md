---
title: "Add a dependency"
weight: 5
---

The `content/dependencies/` folder is for low-level build-time packages — shared libraries, `-dev` headers, compiler toolchains, and similar prerequisites that programs need in order to be compiled from source. They are **not** shown to users in the program catalog or the setup generator, but the script generator can find and install them automatically when a `CUSTOM_INSTALL` program lists them in its `dependencies` field.

## When to use dependencies vs programs

| Use `content/programs/` | Use `content/dependencies/` |
|---|---|
| End-user tools (editors, terminals, browsers) | Build-time libs (`libssl-dev`, `cmake`, `pkg-config`) |
| Something a user would consciously choose to install | A prerequisite that is pulled in automatically |
| Has a meaningful description for a non-technical audience | Irrelevant or confusing to show in the catalog |

## Step 1 — Create the dependency folder

Inside `content/dependencies/`, create a folder named after the dependency's slug:

```
content/dependencies/libssl-dev/
```

## Step 2 — Create program.json

The format is identical to a program's `program.json`:

```json
{
  "name": "libssl-dev",
  "slug": "libssl-dev",
  "description": "OpenSSL development headers, required to build programs that use TLS.",
  "categories": ["build"],
  "package_names": {
    "default": "libssl-dev",
    "arch": "openssl",
    "void": "libressl-devel"
  }
}
```

The `name`, `slug`, `description`, and `package_names` fields work exactly the same as for programs.

## Step 3 — Reference it from a program

In the `program.json` of the program that needs this dependency, add it to the `dependencies` array using the slug:

```json
{
  "name": "My Tool",
  "slug": "my-tool",
  "package_names": { "default": "CUSTOM_INSTALL" },
  "dependencies": ["libssl-dev", "cmake"]
}
```

When the generator encounters `my-tool`, it will resolve `libssl-dev` and `cmake`, look them up in both `content/programs/` and `content/dependencies/`, and add their package names to the install command before running `my-tool`'s `install.sh`.

## Dependencies that are themselves custom-built

If a dependency is also not available through the standard package manager, set its package name to `"CUSTOM_INSTALL"` and add an `install.sh` inside the dependency folder:

```
content/dependencies/my-lib/
├── program.json          ← package_names: { "default": "CUSTOM_INSTALL" }
└── custom_install/
    └── install.sh
```

The generator handles this recursively — it will build `my-lib` from source before building whatever depends on it, no matter how deep the chain goes.

## Lookup order

When the generator resolves a dependency slug, it searches `content/programs/` first, then `content/dependencies/`. This means a slug that exists in both places will always resolve to the program entry. In practice, slugs should be unique across both folders.

## Submit a pull request

Once your dependency is in place and everything tests correctly, open a pull request against the main repository:

**[github.com/RajPorus19/linux-setup-generator](https://github.com/RajPorus19/linux-setup-generator)**

Fork the repo, push your changes to a branch, and open a PR from that branch to `main`. See the [Contributing](/docs/contributing/) guide for a step-by-step walkthrough.

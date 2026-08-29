#!/usr/bin/env node
// Builds the precompiled RailsAdmin assets that ship with the gem.
//
//   src/rails_admin/base.js          -> app/assets/builds/rails_admin.js
//   src/rails_admin/styles/base.scss -> app/assets/builds/rails_admin.css
//
// These files are committed to the repository so that applications can serve
// RailsAdmin without a JavaScript build step (Propshaft, Sprockets, importmap).
// Run `yarn build` (or `rake rails_admin:build_assets`) after changing anything
// under src/; CI fails if the committed output is stale.

import { build } from "esbuild";
import * as sass from "sass";
import { mkdir, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const outDir = resolve(root, "app/assets/builds");
const banner =
  "/*! RailsAdmin - generated from src/, do not edit - https://github.com/railsadminteam/rails_admin */";

async function buildJs() {
  const result = await build({
    entryPoints: [resolve(root, "src/rails_admin/base.js")],
    bundle: true,
    format: "iife",
    minify: true,
    target: ["es2020"],
    legalComments: "none",
    banner: { js: banner },
    define: { "process.env.NODE_ENV": '"production"' },
    outfile: resolve(outDir, "rails_admin.js"),
    write: true,
  });
  for (const warning of result.warnings) console.warn(warning.text);
}

async function buildCss() {
  const { css } = sass.compile(
    resolve(root, "src/rails_admin/styles/base.scss"),
    {
      loadPaths: [resolve(root, "node_modules")],
      style: "compressed",
      quietDeps: true,
      silenceDeprecations: [
        "import",
        "global-builtin",
        "color-functions",
        "if-function",
        "abs-percent",
      ],
    }
  );
  // src/ keeps the webpack-style `~` prefix as the Sass default so bundler-based
  // setups keep resolving Font Awesome from node_modules. For the shipped file we
  // rewrite it to an asset-pipeline path; the fonts live in vendor/assets/fonts.
  const rewritten = css
    .replace(/^﻿/, "")
    .replaceAll("~@fortawesome/fontawesome-free/webfonts/", "rails_admin/");
  await writeFile(
    resolve(outDir, "rails_admin.css"),
    `${banner}\n${rewritten}`
  );
}

await mkdir(outDir, { recursive: true });
await Promise.all([buildJs(), buildCss()]);

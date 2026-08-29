// Builds the :external-mode RailsAdmin assets for the dummy app.
import { build } from "esbuild";
import * as sass from "sass";
import { writeFileSync, mkdirSync } from "node:fs";

mkdirSync("app/assets/builds", { recursive: true });

await build({
  entryPoints: ["app/frontend/rails_admin.js"],
  bundle: true,
  format: "iife",
  outfile: "app/assets/builds/rails_admin.js",
  define: { "process.env.NODE_ENV": '"test"' },
});

const { css } = sass.compile("app/frontend/rails_admin.scss", {
  loadPaths: ["node_modules", "../../node_modules"],
  silenceDeprecations: [
    "import",
    "global-builtin",
    "color-functions",
    "if-function",
    "abs-percent",
  ],
  quietDeps: true,
});
writeFileSync("app/assets/builds/rails_admin.css", css.replace(/^﻿/, ""));

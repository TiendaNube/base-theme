import esbuild from "esbuild";

const isWatch = process.argv.includes("--watch");

const ctx = await esbuild.context({
  entryPoints: ["__src/js/index.js"],
  outfile: "static/js/gaius-v1791895369967.js",

  bundle: true,
  minify: true, // 🔥 minifica sempre
  sourcemap: false,
  target: ["es2018"],
  format: "iife",
  platform: "browser",

  logLevel: "info",
});

if (isWatch) {
  await ctx.watch();
  console.log("👀 esbuild em watch mode");
} else {
  await ctx.rebuild();
  await ctx.dispose();
}

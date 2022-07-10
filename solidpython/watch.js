#!/usr/bin/env node

const fs = require("fs");
const { exec } = require("child_process");

function main() {
  const filesToBuild = process.argv.slice(2);

  if (filesToBuild.length == 0) {
    usage();
    process.exit(1);
  }

  watch(filesToBuild);
}

function watch(filesToBuild) {
  console.log("Watching:", filesToBuild.join(", "));
  let timeoutId = null;

  fs.watch(".", (event, filename) => {
    if (event === "change" && filename && filename.endsWith(".py")) {
      if (timeoutId != null) clearTimeout(timeoutId);

      timeoutId = setTimeout(() => {
        timeoutId = null;
        filesToBuild.forEach(buildFile);
      }, 300);
    }
  });
}

function buildFile(filename) {
  console.info(`- Detected changes, rebuilding ${filename}...`);
  exec(`python3 ${filename}`);
  console.info(`- Done building ${filename}`);
}

function usage() {
  console.info("Usage: watch.js <file.py>...");
}

main();

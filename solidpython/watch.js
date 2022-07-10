#!/usr/bin/env node

const fs = require("fs");
const { exec } = require("child_process");

function main() {
  const filesToBuild = process.argv.slice(2);

  if (filesToBuild.length == 0) {
    usage();
    process.exit(1);
  }

  filesToBuild.forEach(buildFile);
  watch(filesToBuild, [".", ...dirs(".")]);
}

function dirs(root) {
  return fs
    .readdirSync(root, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name);
}

// On OSX only "rename" is sent.
const EVENTS = ["change", "rename"];

function watch(filesToBuild, dirsToWatch) {
  console.info("- Files to build:", filesToBuild.join(", "));
  let timeoutId = null;

  dirsToWatch.forEach((dir) => {
    console.info(`- Watching ${dir}`);
    fs.watch(dir, (event, filename) => {
      if (EVENTS.includes(event) && filename && filename.endsWith(".py")) {
        if (timeoutId != null) clearTimeout(timeoutId);

        timeoutId = setTimeout(() => {
          console.info(`- Detected change in ${filename}`);
          timeoutId = null;
          filesToBuild.forEach(buildFile);
        }, 300);
      }
    });
  });
}

function buildFile(filename) {
  console.info(`- Building ${filename}...`);
  exec(`python3 ${filename}`);
  console.info(`- Done building ${filename}`);
}

function usage() {
  console.info("Usage: watch.js <file.py>...");
}

main();

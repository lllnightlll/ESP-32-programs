const { spawn } = require("child_process");
const path = require("path");

const root = path.resolve(__dirname, "..");
const isWindows = process.platform === "win32";
const command = isWindows ? "py" : "python3";
const args = isWindows ? ["-3", "-m", "platformio"] : ["-m", "platformio"];

const child = spawn(
  command,
  [...args, "run", "-e", "esp32s3", "-t", "upload", "-t", "monitor"],
  { cwd: root, stdio: "inherit" }
);

child.on("error", (error) => {
  console.error(error.message);
  process.exit(1);
});

child.on("exit", (code) => {
  process.exit(code ?? 1);
});

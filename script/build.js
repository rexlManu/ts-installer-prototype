var fs = require("fs");

var ENDPOINT = "index.sh";
var LANGUAGES = "./lang/";
var VERSION = "1.0";

var declares = [
  {
    trigger: "include",
    run: (params) => {
      var path = "./" + params[0] + ".sh";
      return fs
        .readFileSync(path, "utf-8")
        .split(/\r|\n/)
        .filter((line) => !line.startsWith("#"))
        .join("\n");
    },
  },
  {
    trigger: "languages",
    run: (params) => {
      var langs = fs
        .readdirSync(LANGUAGES)
        .map((file) => JSON.parse(fs.readFileSync(LANGUAGES + file, "utf-8")));
      return `languages=(${langs
        .map((lang) => `'${lang.language}'`)
        .join(" ")})\n${langs
        .map((lang) => `language_${lang.language}='${JSON.stringify(lang)}'`)
        .join("\n")}`;
    },
  },
];
var DECLARE_REGEX = /@\w*\((.*)?\)/;

var content = fs.readFileSync(ENDPOINT, "utf-8").split(/\r|\n/);

content = content.map((line) => {
  if (!line.match(DECLARE_REGEX)) return line;
  var declare = declares.filter(
    (declare) =>
      declare.trigger == line.replace(/\((.*)?\)/, "").replace(/@/, "")
  )[0];
  if (!declare) return `# Declare ${line} not found.`;
  return declare.run(
    line
      .replace(/@\w*\(/, "")
      .replace(/\)/, "")
      .replaceAll(/'/g, "")
      .split(/\s?,\s?/)
  );
});

fs.writeFileSync(
  "dist/script.sh",
  content.join("\n").replace(/%version%/, VERSION)
);

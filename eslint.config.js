import globals from "globals";
import pluginJs from "@eslint/js";


export default [
  { languageOptions: { globals: globals.browser } },
  // root: true
  // extends: silverwind
  pluginJs.configs.recommended,
];

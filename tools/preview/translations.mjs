import fs from "node:fs";

/**
 * config/translations.txt is a list of blocks:
 *
 *   es "Ver Todo"
 *   pt "Ver Tudo"
 *   en "See All"
 *
 * Templates call `'Ver Todo' | translate` with the Spanish string as the key.
 * Returns a Map es → pt (falls back to the key when there is no pt line).
 */
export function loadTranslations(file) {
  const map = new Map();
  if (!fs.existsSync(file)) return map;
  let es = null;
  for (const raw of fs.readFileSync(file, "utf8").split(/\r?\n/)) {
    const m = raw.match(/^(es|pt|en|es_mx)\s+"(.*)"\s*$/);
    if (!m) {
      if (raw.trim() === "") es = null;
      continue;
    }
    const [, lang, text] = m;
    if (lang === "es") {
      es = text;
      if (!map.has(es)) map.set(es, es);
    } else if (lang === "pt" && es !== null) {
      map.set(es, text);
    }
  }
  return map;
}

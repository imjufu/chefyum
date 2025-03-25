import { Dictionary, Locales } from "./dictionaries";

export function t(
  dict: Dictionary,
  path: string | string[],
  replacements?: { [key: string]: string },
): string | string[] {
  const translate = (path: string): string => {
    let translated:
      | { [key: string]: { [key: string]: string } }
      | { [key: string]: string }
      | string = dict.trans;
    for (const key of path.split(".")) {
      if (!(key in translated)) {
        console.error(
          `"${path}" is not translated in "${dict.locale}" dictionary`,
        );
        return path;
      }
      translated = translated[key];
    }

    if (typeof translated !== "string") {
      console.error(`"${path}" is a collection in dictionary: ${dict.locale}`);
      return path;
    }

    if (replacements) {
      for (const key of Object.keys(replacements)) {
        translated = (translated as string).replace(
          `:${key}:`,
          replacements[key],
        );
      }
    }

    return translated;
  };

  if (Array.isArray(path)) {
    return path.map((k) => translate(k));
  }

  return translate(path);
}

export function d(
  date: string | null | undefined,
  locale: Locales,
  options?: Intl.DateTimeFormatOptions,
) {
  if (!date) return "";
  return new Date(date).toLocaleString(locale, {
    dateStyle: "medium",
    timeStyle: "short",
    ...options,
  });
}

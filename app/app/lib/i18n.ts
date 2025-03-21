export function t(dict: { [key: string]: string }, key: string | string[]) {
  const translate = (key: string) => {
    let translated = null;
    if (!(key in dict)) {
      console.error(
        `"${key}" is not translated in dictionary: ${JSON.stringify(dict)}`,
      );
      translated = key;
    } else {
      translated = dict[key];
    }
    return [translated];
  };

  if (Array.isArray(key)) {
    return key.map((k) => translate(k));
  }

  return translate(key);
}

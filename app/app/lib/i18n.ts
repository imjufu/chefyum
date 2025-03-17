export function t(dict: { [key: string]: string }, key: string | string[]) {
  const translate = (key: string) => {
    const translated = dict[key];
    if (!translated) {
      console.error(
        `"${key}" is not translated in dictionary: ${JSON.stringify(dict)}`,
      );
      return key;
    }
    return [translated];
  };

  if (Array.isArray(key)) {
    return key.map((k) => translate(k));
  }

  return translate(key);
}

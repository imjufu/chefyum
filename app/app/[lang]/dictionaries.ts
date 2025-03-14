import "server-only";

export type Dictionary = { [key: string]: { [key: string]: string } };
export type Locales = "fr";

const dictionaries = {
  fr: () => import("./dictionaries/fr.json").then((module) => module.default),
};

export const getDictionary = async (locale: Locales) =>
  await dictionaries[locale]();

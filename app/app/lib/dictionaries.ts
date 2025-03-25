import "server-only";

export type Locales = "fr";
export type Dictionary = {
  locale: Locales;
  trans: { [key: string]: { [key: string]: string } };
};

const dictionaries = {
  fr: () => import("@/app/locales/fr.json").then((module) => module.default),
};

export const getDictionary = async (locale: Locales) => {
  return {
    locale,
    trans: await dictionaries[locale](),
  };
};

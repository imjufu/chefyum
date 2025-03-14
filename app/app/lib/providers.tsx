"use client";

import {
  createContext,
  Dispatch,
  PropsWithChildren,
  SetStateAction,
  useState,
} from "react";
import { Session } from "./definitions";
import { Dictionary } from "../[lang]/dictionaries";

export const AuthContext = createContext<{
  currentSession: Session | null;
  setCurrentSession: Dispatch<SetStateAction<Session>>;
}>({
  currentSession: null,
  setCurrentSession: () => null,
});

export const IntContext = createContext<{
  dictionary: Dictionary;
  setDictionary: Dispatch<SetStateAction<Dictionary>>;
}>({
  dictionary: {},
  setDictionary: () => {},
});

export function AppContextProvider({
  session: initialSession,
  dictionary: initialDictionary,
  children,
}: PropsWithChildren<{ session: Session; dictionary: Dictionary }>) {
  const [dictionary, setDictionary] = useState(initialDictionary);
  const [currentSession, setCurrentSession] = useState(initialSession);

  return (
    <IntContext.Provider
      value={{
        dictionary,
        setDictionary,
      }}
    >
      <AuthContext.Provider
        value={{
          currentSession,
          setCurrentSession,
        }}
      >
        {children}
      </AuthContext.Provider>
    </IntContext.Provider>
  );
}

"use client";

import {
  createContext,
  Dispatch,
  PropsWithChildren,
  SetStateAction,
  useState,
} from "react";
import { AlertLevel, Session } from "./definitions";
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

export type FlashMessage = { message: string; level: AlertLevel };
export const FlashMessageContext = createContext<{
  flashMessage: FlashMessage | null;
  setFlashMessage: Dispatch<SetStateAction<FlashMessage | null>>;
}>({
  flashMessage: null,
  setFlashMessage: () => null,
});

export function AppContextProvider({
  session: initialSession,
  dictionary: initialDictionary,
  flashMessage: initialFlashMessage,
  children,
}: PropsWithChildren<{
  session: Session;
  dictionary: Dictionary;
  flashMessage: FlashMessage;
}>) {
  const [dictionary, setDictionary] = useState(initialDictionary);
  const [currentSession, setCurrentSession] = useState(initialSession);
  const [flashMessage, setFlashMessage] = useState(initialFlashMessage);

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
        <FlashMessageContext.Provider
          value={{
            flashMessage,
            setFlashMessage,
          }}
        >
          {children}
        </FlashMessageContext.Provider>
      </AuthContext.Provider>
    </IntContext.Provider>
  );
}

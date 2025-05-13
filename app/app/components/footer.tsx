"use client";

import Image from "next/image";
import { PropsWithChildren } from "react";

export default function Footer({
  className,
}: PropsWithChildren<{ className?: string }>) {
  const classNames = [className];
  return (
    <div className={classNames.join(" ")}>
      <div className="content flex items-start justify-between">
        <div className="flex items-center">
          <Image
            src="/assets/logo-white.png"
            alt="Logo de Chef Yum"
            width="100"
            height="100"
          />
          <p className="font-semibold">
            Le bon repas, pour les bonnes personnes, au bon moment.
          </p>
        </div>
        <div className="flex gap-10">
          <div className="flex flex-col">
            <p className="text-xl mb-2">À propos</p>
            <a href="#" className="font-light text-white">
              Notre mission
            </a>
            <a href="#" className="font-light text-white">
              Plan de site
            </a>
          </div>
          <div className="flex flex-col">
            <p className="text-xl mb-2">Informations légales</p>
            <a href="#" className="font-light text-white">
              Conditions Générales d&apos;Utilisation
            </a>
            <a href="#" className="font-light text-white">
              Politique de confidentialité
            </a>
            <a href="#" className="font-light text-white">
              Mentions légales
            </a>
            <a href="#" className="font-light text-white">
              Charte cookies
            </a>
            <a href="#" className="font-light text-white">
              Gestion des cookies
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}

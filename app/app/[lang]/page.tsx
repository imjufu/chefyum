"use client";

import Image from "next/image";
import { t } from "@/app/lib/i18n";
import { useContext } from "react";
import { IntContext } from "@/app/lib/providers";
import Link from "next/link";
import {
  BoltIcon,
  CakeIcon,
  FireIcon,
  GlobeEuropeAfricaIcon,
} from "@heroicons/react/24/outline";

export default function Page() {
  const { dictionary } = useContext(IntContext);

  return (
    <>
      <div className="bg-power-orange rounded-lg mb-3">
        <div className="flex gap-x-20 items-center content">
          <div>
            <div className="mb-8">
              <h1 className="text-5xl font-semibold">
                {t(dictionary, "home.pitch_title")}
              </h1>
              <p className="mt-5">{t(dictionary, "home.pitch_description")}</p>
            </div>
            <Link
              href="/signin"
              className="text-white bg-leaf-green px-4 py-2 rounded-full"
            >
              {t(dictionary, "navbar.get_started")}
            </Link>
          </div>
          <Image
            src="/assets/plate-with-healthy-food.png"
            alt="Assiette remplie avec de la nourriture saine"
            width="400"
            height="400"
          />
        </div>
      </div>
      <div className="content">
        <h2 className="text-2xl font-semibold">Parcourir par catégorie</h2>
        <div className="mt-5 flex gap-5">
          <Link
            href="/signin"
            className="bg-red-400 p-4 text-white rounded-lg flex items-center gap-1"
          >
            <FireIcon aria-hidden="true" className="block size-6" />
            Protéinée
          </Link>
          <Link
            href="/signin"
            className="bg-orange-400 p-4 text-white rounded-lg flex items-center gap-1"
          >
            <BoltIcon aria-hidden="true" className="block size-6" />
            Rapide et facile
          </Link>
          <Link
            href="/signin"
            className="bg-emerald-400 p-4 text-white rounded-lg flex items-center gap-1"
          >
            <GlobeEuropeAfricaIcon
              aria-hidden="true"
              className="block size-6"
            />
            Végétarienne
          </Link>
          <Link
            href="/signin"
            className="bg-blue-400 p-4 text-white rounded-lg flex items-center gap-1"
          >
            <CakeIcon aria-hidden="true" className="block size-6" />
            Sucrée
          </Link>
        </div>
      </div>
      <div className="content">
        <div className="rounded-lg bg-light-blue p-5 text-white flex items-center gap-5">
          <Image
            className="rounded-full"
            src="/assets/julien-f.webp"
            alt="Une photo de Julien F."
            width="100"
            height="100"
          />
          <div>
            <blockquote className="text-2xl font-semi-bold">
              <p>
                “ Chef Yum m&apos;a vraiment aidé à améliorer mes performances
                au CrossFit en prenant en compte mes besoins alimentaires et
                ceux de ma famille ! ”
              </p>
            </blockquote>
            <p className="mt-2">
              Julien F., <cite>- CrossFiteur & père de famille</cite>
            </p>
          </div>
        </div>
      </div>
    </>
  );
}

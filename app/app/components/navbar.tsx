"use client";

import {
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  Menu,
  MenuButton,
  MenuItem,
  MenuItems,
  Button,
} from "@headlessui/react";
import {
  Bars3Icon,
  XMarkIcon,
  ArrowLongRightIcon,
} from "@heroicons/react/24/outline";
import { useContext } from "react";
import { AuthContext, IntContext } from "@/app/lib/providers";
import Link from "next/link";
import { deleteSession } from "@/app/lib/session";
import { t } from "@/app/lib/i18n";

function inlineClassNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

function userNavigationItem(
  item: { name: string; href?: string; onClick?: () => void },
  classNames: string,
) {
  let content = null;
  if (item.href) {
    content = (
      <Link href={item.href} className={classNames}>
        {item.name}
      </Link>
    );
  } else {
    content = (
      <Button onClick={item.onClick} className={classNames}>
        {item.name}
      </Button>
    );
  }
  return content;
}

export default function Navbar() {
  const { currentSession, setCurrentSession } = useContext(AuthContext);
  const { dictionary: dict } = useContext(IntContext);

  const navigation = [
    { name: t(dict, "navbar.homepage"), href: "#", current: true },
    { name: t(dict, "navbar.pricing"), href: "#", current: false },
    { name: t(dict, "navbar.about"), href: "#", current: false },
  ];
  const userNavigation = [
    { name: t(dict, "navbar.profile"), href: "#" },
    {
      name: t(dict, "navbar.signout"),
      onClick: () => {
        deleteSession();
        setCurrentSession({ isAuth: false });
      },
    },
  ];

  let profilePartContent = null;
  let profilePartMobileContent = null;
  if (currentSession?.isAuth) {
    profilePartContent = (
      <Menu as="div" className="relative ml-3">
        <MenuButton className="cursor-pointer relative flex max-w-xs bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium">
          Welcome, {currentSession.user?.name}
        </MenuButton>
        <MenuItems
          transition
          className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 ring-1 shadow-lg ring-black/5 transition focus:outline-hidden data-closed:scale-95 data-closed:transform data-closed:opacity-0 data-enter:duration-100 data-enter:ease-out data-leave:duration-75 data-leave:ease-in"
        >
          {userNavigation.map((item) => {
            const content = userNavigationItem(
              item,
              "cursor-pointer block px-4 py-2 text-sm text-gray-700",
            );
            return <MenuItem key={item.name}>{content}</MenuItem>;
          })}
        </MenuItems>
      </Menu>
    );
    profilePartMobileContent = (
      <>
        <div className="flex items-center px-5">
          <div className="ml-3">
            <div className="text-base/5 font-medium text-white">
              {currentSession.user?.name}
            </div>
            <div className="text-sm font-medium text-gray-400">
              {currentSession.user?.email}
            </div>
          </div>
        </div>
        <div className="mt-3 space-y-1 px-2">
          {userNavigation.map((item) => {
            return userNavigationItem(
              item,
              "block px-3 py-2 text-base font-medium text-gray-400",
            );
          })}
        </div>
      </>
    );
  } else {
    profilePartContent = (
      <Link href="/signin" className="text-gray-300">
        {t(dict, "navbar.signin")}
        <ArrowLongRightIcon aria-hidden="true" className="ml-2 inline size-6" />
      </Link>
    );
    profilePartMobileContent = <div className="px-5">{profilePartContent}</div>;
  }

  return (
    <>
      <Disclosure as="nav" className="bg-gray-800">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex h-16 items-center justify-between">
            <div className="flex items-center">
              <div className="shrink-0">
                <Link href="/" className="text-gray-300">
                  Chef Yum
                </Link>
              </div>
              <div className="hidden md:block">
                <div className="ml-10 flex items-baseline space-x-4">
                  {navigation.map((item) => (
                    <a
                      key={item.name}
                      href={item.href}
                      aria-current={item.current ? "page" : undefined}
                      className={inlineClassNames(
                        item.current
                          ? "bg-gray-900 text-white"
                          : "text-gray-300 hover:bg-gray-700 hover:text-white",
                        "rounded-md px-3 py-2 text-sm font-medium",
                      )}
                    >
                      {item.name}
                    </a>
                  ))}
                </div>
              </div>
            </div>
            <div className="hidden md:block">
              <div className="ml-4 flex items-center md:ml-6">
                {profilePartContent}
              </div>
            </div>
            <div className="-mr-2 flex md:hidden">
              {/* Mobile menu button */}
              <DisclosureButton className="group relative inline-flex items-center justify-center rounded-md bg-gray-800 p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800 focus:outline-hidden">
                <span className="absolute -inset-0.5" />
                <span className="sr-only">Open main menu</span>
                <Bars3Icon
                  aria-hidden="true"
                  className="block size-6 group-data-open:hidden"
                />
                <XMarkIcon
                  aria-hidden="true"
                  className="hidden size-6 group-data-open:block"
                />
              </DisclosureButton>
            </div>
          </div>
        </div>

        <DisclosurePanel className="md:hidden">
          <div className="space-y-1 px-2 pt-2 pb-3 sm:px-3">
            {navigation.map((item) => (
              <Button
                key={item.name}
                as="a"
                href={item.href}
                aria-current={item.current ? "page" : undefined}
                className={inlineClassNames(
                  item.current
                    ? "bg-gray-900 text-white"
                    : "text-gray-300 hover:bg-gray-700 hover:text-white",
                  "block rounded-md px-3 py-2 text-base font-medium",
                )}
              >
                {item.name}
              </Button>
            ))}
          </div>
          <div className="border-t border-gray-700 pt-4 pb-3">
            {profilePartMobileContent}
          </div>
        </DisclosurePanel>
      </Disclosure>
    </>
  );
}

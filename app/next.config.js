// @ts-check

/** @type {import('next').NextConfig} */
const nextConfig = {
  sassOptions: {},
  images: {
    remotePatterns: [
      {
        protocol: "http",
        hostname: "localhost",
        port: "3000",
        pathname: "/rails/active_storage/**",
      },
    ],
  },
};

module.exports = nextConfig;

const users = require('./showcase.json');
const versions = require('./versions.json');

const lastVersion = versions[0];
const copyright = `Copyright © ${new Date().getFullYear()} AiCure, Inc.`;

const commonDocsOptions = {
  breadcrumbs: false,
  showLastUpdateAuthor: false,
  showLastUpdateTime: true,
  editUrl: 'https://github.com/AiCure/open_dbm/blob/master/docs/docs',
  remarkPlugins: [require('@react-native-website/remark-snackplayer')],
};

/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
  title: 'OpenDBM',
  tagline: 'AiCure Digital Biomaker Tools',
  organizationName: 'AiCure',
  projectName: 'open_dbm',
  url: 'https://aicure.github.io',
  baseUrl: '/open_dbm/',
  clientModules: [require.resolve('./snackPlayerInitializer.js')],
  trailingSlash: false, // because trailing slashes can break some existing relative links
  scripts: [
    {
      src: 'https://cdn.jsdelivr.net/npm/focus-visible@5.2.0/dist/focus-visible.min.js',
      defer: true,
    },
    {
      src: 'https://widget.surveymonkey.com/collect/website/js/FILLWITHSOMETHING.js',
      defer: true,
    },
    {src: 'https://snack.expo.dev/embed.js', defer: true},
  ],
  favicon: 'img/favicon.ico',
  titleDelimiter: '·',
  customFields: {
    users,
  },
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },
  onBrokenLinks: 'throw',
  webpack: {
    jsLoader: isServer => ({
      loader: require.resolve('esbuild-loader'),
      options: {
        loader: 'tsx',
        format: isServer ? 'cjs' : undefined,
        target: isServer ? 'node12' : 'es2017',
      },
    }),
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: '../docs',
          sidebarPath: require.resolve('./sidebars.json'),
          editCurrentVersion: true,
          onlyIncludeVersions:
            process.env.PREVIEW_DEPLOY === 'true'
              ? ['current', ...versions.slice(0, 2)]
              : undefined,
          versions: {
            [lastVersion]: {
              badge: false, // Do not show version badge for last RN version
            },
          },
          ...commonDocsOptions,
        },
        blog: {
          path: 'blog',
          blogSidebarCount: 'ALL',
          blogSidebarTitle: 'All Blog Posts',
          feedOptions: {
            type: 'all',
            copyright,
          },
        },
        theme: {
          customCss: [
            require.resolve('./src/css/customTheme.scss'),
            require.resolve('./src/css/index.scss'),
            require.resolve('./src/css/showcase.scss'),
            require.resolve('./src/css/versions.scss'),
          ],
        },
        googleAnalytics: {
          trackingID: 'UA-41298772-2',
        },
        gtag: {
          trackingID: 'UA-41298772-2',
        },
      }),
    ],
  ],
  plugins: [
    'docusaurus-plugin-sass',
    [
      'content-docs',
      /** @type {import('@docusaurus/plugin-content-docs').Options} */
      ({
        id: 'extras',
        path: 'extras',
        routeBasePath: '/extras',
        sidebarPath: require.resolve('./sidebarsExtras.json'),
        ...commonDocsOptions,
      }),
    ],
    [
      'content-docs',
      /** @type {import('@docusaurus/plugin-content-docs').Options} */
      ({
        id: 'contributing',
        path: 'contributing',
        routeBasePath: '/contributing',
        sidebarPath: require.resolve('./sidebarsContributing.json'),
        ...commonDocsOptions,
      }),
    ],
    [
      'content-docs',
      /** @type {import('@docusaurus/plugin-content-docs').Options} */
      ({
        id: 'api',
        path: 'api',
        routeBasePath: '/api',
        sidebarPath: require.resolve('./sidebarsAPI.json'),
        ...commonDocsOptions,
      }),
    ],
    [
      '@docusaurus/plugin-pwa',
      {
        debug: true,
        offlineModeActivationStrategies: ['appInstalled', 'queryString'],
        pwaHead: [
          {
            tagName: 'link',
            rel: 'icon',
            href: '/img/pwa/manifest-icon-512.png',
          },
          {
            tagName: 'link',
            rel: 'manifest',
            href: '/manifest.json',
          },
          {
            tagName: 'meta',
            name: 'theme-color',
            content: '#20232a',
          },
          {
            tagName: 'meta',
            name: 'apple-mobile-web-app-capable',
            content: 'yes',
          },
          {
            tagName: 'meta',
            name: 'apple-mobile-web-app-status-bar-style',
            content: '#20232a',
          },
          {
            tagName: 'link',
            rel: 'apple-touch-icon',
            href: '/img/pwa/manifest-icon-512.png',
          },
          {
            tagName: 'link',
            rel: 'mask-icon',
            href: '/img/pwa/manifest-icon-512.png',
            color: '#06bcee',
          },
          {
            tagName: 'meta',
            name: 'msapplication-TileImage',
            href: '/img/pwa/manifest-icon-512.png',
          },
          {
            tagName: 'meta',
            name: 'msapplication-TileColor',
            content: '#20232a',
          },
        ],
      },
    ],
  ],
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      prism: {
        defaultLanguage: 'jsx',
        theme: require('./core/PrismTheme'),
        additionalLanguages: [
          'java',
          'kotlin',
          'objectivec',
          'swift',
          'groovy',
          'ruby',
          'flow',
        ],
      },
      navbar: {
        title: 'OpenDBM',
        logo: {
          src: 'img/header_logo.png',
          alt: 'OpenDBM',
        },
        style: 'dark',
        items: [
          {
            label: 'Getting Started',
            type: 'doc',
            docId: 'getting-started',
            position: 'right',
          },
          {
            label: 'Variables',
            type: 'doc',
            docId: 'biomaker-variables',
            position: 'right',
          },
          {
            label: 'API',
            type: 'doc',
            docId: 'api-doc',
            position: 'right',
            docsPluginId: 'api',
          },
          {
            label: 'Resources',
            type: 'doc',
            docId: 'extras',
            position: 'right',
            docsPluginId: 'extras',
          },

          {
            to: '/blog',
            label: 'Blog',
            position: 'right',
          },
          {
            type: 'docsVersionDropdown',
            position: 'left',
            dropdownActiveClassDisabled: true,
            dropdownItemsAfter: [
              {
                to: '/versions',
                label: 'All versions',
              },
            ],
          },
          {
            href: 'https://github.com/AiCure/open_dbm',
            'aria-label': 'GitHub repository',
            position: 'right',
            className: 'navbar-github-link',
          },
        ],
      },
      image: 'img/logo-og.png',
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Getting Started',
                to: 'docs/getting-started',
              },
              {
                label: 'Tutorial',
                to: 'docs/tutorial',
              },
              {
                label: 'OpenDBM Biomaker Variables',
                to: 'docs/biomaker-variables',
              },
              {
                label: 'More Resources',
                to: 'docs/more-resources',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'The OpenDBM Community',
                to: 'help',
              },
              {
                label: "Who's using OpenDBM?",
                to: 'showcase',
              },
              {
                label: 'Ask Questions on Stack Overflow',
                href: 'https://stackoverflow.com/questions/tagged/opendbm',
              },
            ],
          },
          {
            title: 'Find us',
            items: [
              {
                label: 'Blog',
                to: 'blog',
              },
              {
                label: 'GitHub',
                href: 'https://github.com/AiCure/open_dbm',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'AiCure',
                href: 'https://aicure.com/',
              },
              {
                label: 'AiCure OpenDBM',
                href: 'https://aicure.com/opendbm/',
              },
              {
                label: 'Docs (Word version)',
                href: 'https://docs.google.com/document/d/1O6OUSY9FHFCZfpIWu3Kgg0Q_dyp073xjjQ2K3viEffU/edit#heading=h.rxr2y5t62mwa',
              },
            ],
          },
        ],
        logo: {
          alt: 'OpenDBM Open Source Logo',
          src: 'img/oss_logo.png',
          href: 'https://aicure.com/opendbm',
        },
        copyright,
      },
      algolia: {
        appId: '8TDSE0OHGQ',
        apiKey: '83cd239c72f9f8b0ed270a04b1185288',
        indexName: 'react-native-v2',
        contextualSearch: true,
      },
      metadata: [
        {
          property: 'og:image',
          content:
            'https://raw.githubusercontent.com/AiCure/open_dbm/master/docs/website/static/img/header_logo.png',
        },
        {name: 'twitter:card', content: 'summary_large_image'},
        {
          name: 'twitter:image',
          content:
            'https://raw.githubusercontent.com/AiCure/open_dbm/master/docs/website/static/img/header_logo.png',
        },
        {name: 'twitter:site', content: '@aicure'},
      ],
    }),
};

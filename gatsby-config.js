module.exports = {
  siteMetadata: {
    title: `Alexey Shmalko’s blog`,
    author: `Alexey Shmalko`,
    description: `A blog about programming, technology, and self-development`,
    siteUrl: `https://www.alexeyshmalko.com`,
    disqusUrlPrefix: `https://www.alexeyshmalko.com`,
    social: {
      email: 'rasen.dubi@gmail.com',
      github: 'rasendubi',
      linkedin: 'alexeyshmalko',
    },
  },
  plugins: [
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/content/blog`,
        name: `blog`,
        ignore: process.env.NODE_ENV === 'production' && ['**/_*'],
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        path: `${__dirname}/content/assets`,
        name: `assets`,
      },
    },
    {
      resolve: `gatsby-transformer-remark`,
      options: {
        excerpt_separator: '<!--more-->',
        plugins: [
          {
            resolve: `gatsby-remark-images`,
            options: {
              maxWidth: 590,
            },
          },
          {
            resolve: `gatsby-remark-responsive-iframe`,
            options: {
              wrapperStyle: `margin-bottom: 1.0725rem`,
            },
          },
          {
            resolve: `gatsby-remark-prismjs`,
            options: {
              languageExtensions: [
                {
                  language: 'org',
                  definition: {
                    'code-block': {
                      pattern: /#\+begin_src( .*)\n(.|\n)*?\n#\+end_src/,
                      inside: {
                        'org-block-begin-line': /#\+begin_src.*/i,
                        'org-block-end-line': /#\+end_src/i,
                      },
                    },

                    'title important': {
                      pattern: /\*+ .*/,
                      inside: {
                        punctuation: /\*+/,
                      },
                    },

                    comment: /(#+.*)/,

                    'org-code': /~.*?~/,
                  },
                },
              ],
            },
          },
          `gatsby-remark-copy-linked-files`,
          {
            resolve: `gatsby-remark-smartypants`,
            options: {
              dashes: 'oldschool',
            },
          },
        ],
      },
    },
    {
      resolve: `gatsby-plugin-disqus`,
      options: {
        shortname: `alexeyshmalko`,
      },
    },
    `gatsby-transformer-sharp`,
    `gatsby-plugin-sharp`,
    // {
    //   resolve: `gatsby-plugin-google-analytics`,
    //   options: {
    //     trackingId: `UA-49556972-1`,
    //   },
    // },
    `gatsby-plugin-feed`,
    // TODO: fix icon
    // {
    //   resolve: `gatsby-plugin-manifest`,
    //   options: {
    //     name: `Alexey Shmalko’s blog`,
    //     short_name: `alexeyshmalko`,
    //     start_url: `/`,
    //     background_color: `#ffffff`,
    //     theme_color: `#663399`,
    //     display: `minimal-ui`,
    //     icon: `content/assets/gatsby-icon.png`,
    //   },
    // },
    // `gatsby-plugin-offline`,
    `gatsby-plugin-react-helmet`,
    {
      resolve: `gatsby-plugin-typography`,
      options: {
        pathToConfigModule: `src/utils/typography`,
      },
    },
    {
      resolve: `gatsby-plugin-canonical-urls`,
      options: {
        siteUrl: 'https://www.alexeyshmalko.com',
        stripQueryString: true,
      },
    },
    `gatsby-plugin-sitemap`,
    {
      resolve: `gatsby-plugin-nprogress`,
      options: {
        showSpinner: false,
      },
    },
    `gatsby-plugin-sass`,
    `gatsby-plugin-no-sourcemaps`,
    {
      resolve: `gatsby-plugin-webpack-bundle-analyzer`,
      options: {
        production: true,

        analyzerMode: 'static',
        reportFilename: './report.html',
        defaultSizes: 'gzip',
        openAnalyzer: false,
      },
    },
    {
      resolve: `gatsby-plugin-s3`,
      options: {
        bucketName: 'www.alexeyshmalko.com',
        protocol: 'https',
        hostname: 'www.alexeyshmalko.com',

        removeNonexistentObjects: false,
      },
    },
  ],
};

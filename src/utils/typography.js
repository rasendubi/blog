import Typography from 'typography';
import StowLake from 'typography-theme-stow-lake';

StowLake.overrideThemeStyles = ({ rhythm, scale }) => {
  return {
    'a.gatsby-resp-image-link': {
      boxShadow: `none`,
    },

    'a, a:visited': {
      color: '#1abc9c',
      textDecoration: 'none',
    },
    'a:hover, a:focus': {
      color: '#117964',
    },

    h2: {
      ...scale(0.2),
      fontWeight: 700,
    },
    h3: {
      ...scale(0),
      fontWeight: 700,
    },

    p: {
      marginBottom: rhythm(3 / 4),
    },
  };
};
StowLake.overrideStyles = ({ rhythm, scale }) => {
  return {
    h2: {
      marginTop: rhythm(2),
      marginBottom: rhythm(1 / 4),
    },
    h3: {
      marginTop: rhythm(0.5),
      marginBottom: 0,
    },
  };
};

StowLake.headerFontFamily = ['Lora', 'serif'];
StowLake.headerWeight = 'normal';
StowLake.scaleRatio = 1.5;

delete StowLake.googleFonts;

const typography = new Typography(StowLake);

// Hot reload typography in development.
if (process.env.NODE_ENV !== `production`) {
  typography.injectStyles();
}

export default typography;
export const rhythm = typography.rhythm;
export const scale = typography.scale;

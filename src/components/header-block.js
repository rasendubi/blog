import React from 'react';
import { Link } from 'gatsby';

import { rhythm } from '../utils/typography';

const HeaderBlock = ({ title, url, date }) => {
  const titleBlock = url ? (
    <Link style={{ boxShadow: `none` }} to={url}>
      {title}
    </Link>
  ) : (
    title
  );
  return (
    <header style={{ marginBottom: rhythm(1 / 4) }}>
      <h1
        style={{
          marginTop: rhythm(1),
          marginBottom: 0,
        }}
      >
        {titleBlock}
      </h1>
      <small>{date}</small>
    </header>
  );
};

export default HeaderBlock;

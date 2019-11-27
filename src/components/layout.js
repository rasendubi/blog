import React from 'react';
import { Link } from 'gatsby';

import { rhythm } from '../utils/typography';

class Layout extends React.Component {
  render() {
    const { title, children } = this.props;

    return (
      <>
        <header>
          <h4
            style={{
              // fontFamily: `Montserrat, sans-serif`,
              margin: `${rhythm(0.5)} ${rhythm(3 / 4)}`,
            }}
          >
            <Link
              style={{
                boxShadow: `none`,
                textDecoration: `none`,
                color: `inherit`,
              }}
              to={`/`}
            >
              {title}
            </Link>
          </h4>
        </header>
        <div
          style={{
            marginLeft: `auto`,
            marginRight: `auto`,
            maxWidth: rhythm(24),
            padding: `${rhythm(1 / 4)} ${rhythm(3 / 4)} ${rhythm(1.5)}`,
          }}
        >
          <main>{children}</main>
          {/* <footer> */}
          {/*   © {new Date().getFullYear()}, Built with */}
          {/*   {` `} */}
          {/*   <a href="https://www.gatsbyjs.org">Gatsby</a> */}
          {/* </footer> */}
        </div>
      </>
    );
  }
}

export default Layout;

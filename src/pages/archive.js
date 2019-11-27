import React from 'react';
import { Link, graphql } from 'gatsby';

import Layout from '../components/layout';
import SEO from '../components/seo';

class BlogArchive extends React.Component {
  render() {
    const { data } = this.props;
    const siteTitle = data.site.siteMetadata.title;
    const posts = data.allMarkdownRemark.edges;

    return (
      <Layout location={this.props.location} title={siteTitle}>
        <SEO title="Archives" />
        <ul>
          {posts.map(({ node }) => {
            const title = node.frontmatter.title || node.fields.slug;
            return (
              <li key={node.fields.slug}>
                <Link style={{ boxShadow: 'none' }} to={node.fields.slug}>
                  {title}
                </Link>{' '}
                — {node.frontmatter.date}
              </li>
            );
          })}
        </ul>
      </Layout>
    );
  }
}

export default BlogArchive;

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allMarkdownRemark(sort: { fields: [frontmatter___date], order: DESC }) {
      edges {
        node {
          fields {
            slug
          }
          frontmatter {
            date(formatString: "MMMM DD, YYYY")
            title
          }
        }
      }
    }
  }
`;

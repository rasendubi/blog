{-# LANGUAGE OverloadedStrings #-}
module Main (main) where
import           Data.Monoid (mappend)
import           Hakyll hiding (defaultContext)
import qualified Hakyll as H (defaultContext)

import Data.List (isInfixOf, isPrefixOf, isSuffixOf)
import System.FilePath.Posix (takeBaseName, takeDirectory, (</>), splitFileName)
import Data.Monoid

import Debug.Trace

import qualified Data.Map as M

import Sitemap

import qualified GHC.IO.Encoding as E

sitemapConfig :: SitemapConfiguration
sitemapConfig = def
    { sitemapBase = "http://www.alexeyshmalko.com/"
    , sitemapRewriter = rewriteSitemap
    , sitemapPriority = priority
    , sitemapChangeFreq = changeFrequency
    , sitemapFilter = sitemapFilter'
    }

rewriteSitemap :: String -> String
rewriteSitemap x
    | "index.html" `isSuffixOf` x = ('/' :) $ reverse $ drop 10 $ reverse x
    | otherwise = '/' : x

changeFrequency :: String -> ChangeFrequency
changeFrequency "index.html" = Daily
changeFrequency "reviews/index.html" = Weekly
changeFrequency "archive/index.html" = Daily
changeFrequency "about-me/index.html" = Yearly
changeFrequency "contact/index.html" = Yearly
changeFrequency x = Monthly

priority :: String -> Double
priority "index.html" = 1
priority "reviews/index.html" = 0.7
priority "archive/index.html" = 0.2
priority "about-me/index.html" = 0.3
priority "contact/index.html" = 0.3
priority _ = 1

sitemapFilter' :: String -> Bool
sitemapFilter' "404.html" = False
sitemapFilter' x | "tags" `isPrefixOf` x = False
sitemapFilter' _ = True

--------------------------------------------------------------------------------
main :: IO ()
main = (E.setLocaleEncoding E.utf8 >>) $ hakyll $ do

    match ("images/**" .||. "files/**" .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/**" $ do
        route   idRoute
        compile compressCssCompiler

    match "about-me.md" $ do
        route   $ constRoute "about-me/index.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
            >>= removeIndexHtml

    match "contact.md" $ do
        route   $ constRoute "contact/index.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
            >>= removeIndexHtml

    match "404.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= removeIndexHtml

    tags <- buildTags ("posts/*" .||. "reviews/*") (fromCapture "tags/*/index.html")
    let postCtx = mconcat
          [ dateField "date" "%B %e, %Y"
          , teaserField "teaser" "content"
          , tagsField "tags" tags
          , postTitleCtx
          , defaultContext
          ]

    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title
                    `mappend` listField "posts" postCtx (return posts)
                    `mappend` defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/add-title.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls
                >>= removeIndexHtml

    match "posts/*.md" $ do
        route $ removePrefix "posts/" `composeRoutes` niceRoute `composeRoutes` groupByYear
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            >>= removeIndexHtml

    match "reviews/*.md" $ do
        route $ niceRoute `composeRoutes` groupByYear
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            >>= removeIndexHtml

    create ["archive/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll ("posts/*" .||. "reviews/*.md")
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/add-title.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
                >>= removeIndexHtml

    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = bodyField "description" `mappend` postCtx
            posts <- recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderAtom feedConfiguration feedCtx posts
                >>= removeIndexHtml

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = bodyField "description" `mappend` postCtx
            posts <- recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderRss feedConfiguration feedCtx posts
                >>= removeIndexHtml

    create ["reviews/atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = bodyField "description" `mappend` postCtx
            posts <- recentFirst =<<
                loadAllSnapshots ("reviews/*" .&&. complement "reviews/*.xml" .&&. complement "reviews/index.html") "content"
            renderAtom feedConfiguration feedCtx posts
                >>= removeIndexHtml

    create ["reviews/rss.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = bodyField "description" `mappend` postCtx
            posts <- recentFirst =<<
                loadAllSnapshots ("reviews/*" .&&. complement "reviews/*.xml" .&&. complement "reviews/index.html") "content"
            renderRss feedConfiguration feedCtx posts
                >>= removeIndexHtml

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls
                >>= removeIndexHtml

    match "reviews.html" $ do
        route $ constRoute "reviews/index.html"
        compile $ do
            posts <- recentFirst =<< loadAll "reviews/*.md"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls
                >>= removeIndexHtml

    create ["sitemap.xml"] $ do
        route idRoute
        compile $ generateSitemap sitemapConfig

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------

postTitleCtx :: Context String
postTitleCtx = field "page_title" $ \item -> do
    metadata <- getMetadata (itemIdentifier item)
    return $ maybe "" (++ " | Alexey Shmalko's Personal Blog") $ M.lookup "title" metadata

defaultContext :: Context String
defaultContext = fullUrlCtx `mappend` H.defaultContext

fullUrlCtx :: Context String
fullUrlCtx = mapContext fullUrlCtx' (urlField "url")
    where
        fullUrlCtx' :: String -> String
        fullUrlCtx' x
            | "index.html" `isSuffixOf` x = reverse $ drop 10 $ reverse x
            | otherwise = x

removePrefix :: String -> Routes
removePrefix prefix = gsubRoute ('^' : prefix) (const "")

groupByYear :: Routes
groupByYear = gsubRoute "[0-9]{4}-[0-9]{2}-[0-9]{2}-" (\x -> takeWhile (/= '-') x ++ "/")

niceRoute :: Routes
niceRoute = customRoute createIndexRoute
    where
        createIndexRoute ident = normalize $ takeDirectory p </> takeBaseName p </> "index.html"
            where
                p = toFilePath ident
                normalize :: String -> String
                normalize p' = if "./" `isPrefixOf` p' then drop 2 p' else p'

removeIndexHtml :: Item String -> Compiler (Item String)
removeIndexHtml = return . fmap (withUrls removeIndexStr)
    where
        removeIndexStr :: String -> String
        removeIndexStr url = case splitFileName url of
            (dir, "index.html") | isLocal dir -> dir
            _                                 -> url
            where isLocal = not . isInfixOf "://"

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = "Alexey Shmalko's Personal Blog"
    , feedDescription = "Yet another programmer's blog"
    , feedAuthorName = "Alexey Shmalko"
    , feedAuthorEmail = "rasen.dubi@gmail.com"
    , feedRoot = "http://www.alexeyshmalko.com"
    }

sitemapCtx :: FeedConfiguration -> Context String
sitemapCtx conf = mconcat
    [ constField "root" (feedRoot conf)
    , defaultContext
    ]

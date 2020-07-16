{- stack script
    --resolver lts-16.5
    --install-ghc
    --ghc-options -Wall
    --package blaze-html
    --package shakespeare
    --package yaml
-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE RecordWildCards     #-}

import           Data.Yaml (FromJSON (..))
import qualified Data.Yaml as Y
import           GHC.Generics (Generic)
import           Text.Blaze.Html
import           Text.Blaze.Html.Renderer.Pretty
import           Text.Hamlet

data SectionHeader =
  SectionHeader
    { title          :: String
    , subtitle       :: String
    , extraHeader    :: Maybe String
    , extraSubheader :: Maybe String
    }
  deriving (Show, Generic)

newtype SectionBody =
  SectionBody [String]
  deriving (Show, Generic)

data SectionItem =
  SectionItem
    { header :: SectionHeader
    , body   :: Maybe SectionBody
    }
  deriving (Show, Generic)

data Section =
  Section
    { name     :: String
    , children :: [SectionItem]
    }
  deriving (Show, Generic)

data Resume =
  Resume
    { name    :: String
    , contact :: [String]
    , sections :: [Section]
    }
  deriving (Show, Generic)

instance FromJSON SectionHeader
instance FromJSON SectionBody
instance FromJSON SectionItem
instance FromJSON Section
instance FromJSON Resume

sectionTemplate :: Section -> Html
sectionTemplate (Section {..}) = [shamlet|
<section>
  <h2>#{name}
  $forall (SectionItem header body) <- children
    <div .section-object>
      <div .section-header>
        <div .flex>
          <h3 .section-title>#{preEscapedToHtml $ title header}
          $maybe extraHeader' <- extraHeader header
            <p .section-extra-header>#{extraHeader'}
        
        <div .flex>
          <p .section-subtitle>#{subtitle header}
          $maybe extraSubheader' <- extraSubheader header
            <p .section-extra-subheader>#{extraSubheader'}
        
      $maybe SectionBody body' <- body
        <ul .section-body>
          $forall b <- body'
            <li .section-body-list>#{preEscapedToHtml b}
|]

template :: String -> Resume -> Html
template css (Resume {..}) = [shamlet|
$doctype 5
<html>
  <head>
    <title>Cheah Jer Fei
    <meta charset="utf-8">
    <style>#{preEscapedToHtml css}

  <body>
    <div .wrapper>
      <div .top>
        <h1>#{name}
        <ul .contact-details>
          $forall c <- contact
            <li>#{preEscapedToHtml c}
      $forall section <- sections
        #{preEscapedToHtml $ sectionTemplate section}
|]

inputFile :: String
inputFile = "input.yaml"

cssFile :: String
cssFile = "style.css"

main :: IO ()
main = do
  css <- readFile cssFile
  config <- Y.decodeFileThrow inputFile
  
  putStrLn $ renderHtml $ template css config

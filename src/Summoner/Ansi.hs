-- | This module contains functions for colorful printing into terminal.

module Summoner.Ansi
       ( putStrFlush
       , bold
       , boldText
       , boldDefault
       , reset
       , prompt
       , successMessage
       , warningMessage
       , errorMessage
       ) where

import Data.Semigroup (Semigroup (..))
import Data.Text (Text)
import System.Console.ANSI (Color (Blue, Green, Red, Yellow), ColorIntensity (Vivid),
                            ConsoleIntensity (BoldIntensity), ConsoleLayer (Foreground),
                            SGR (Reset, SetColor, SetConsoleIntensity), setSGR)
import System.IO (hFlush, stdout)

import qualified Data.Text.IO as T

----------------------------------------------------------------------------
-- Ansi-terminal
----------------------------------------------------------------------------

-- Explicit flush ensures prompt messages are in the correct order on all systems.
putStrFlush :: Text -> IO ()
putStrFlush msg = do
    T.putStr msg
    hFlush stdout

setColor :: Color -> IO ()
setColor color = setSGR [SetColor Foreground Vivid color]

-- | Starts bold printing.
bold :: IO ()
bold = setSGR [SetConsoleIntensity BoldIntensity]

-- | Resets all previous settings.
reset :: IO ()
reset = do
    setSGR [Reset]
    hFlush stdout

prompt :: IO Text
prompt = do
    setColor Blue
    putStrFlush "  ->   "
    reset
    T.getLine

boldText :: Text -> IO ()
boldText message = bold >> putStrFlush message >> reset

boldDefault :: Text -> IO ()
boldDefault message = boldText (" [" <> message <> "]")

colorMessage :: Color -> Text -> IO ()
colorMessage color message = do
    setColor color
    T.putStrLn $ "  " <> message
    reset

errorMessage, warningMessage, successMessage :: Text -> IO ()
errorMessage   = colorMessage Red
warningMessage = colorMessage Yellow
successMessage = colorMessage Green
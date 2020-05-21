-- | my xmonad.hs

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spacing
import qualified Data.Map as M
import XMonad.Util.EZConfig
import Data.List
-- import qualified DBus as D
-- import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main = do -- dbus <- D.connectSession
          -- -\- Request access to the DBus name
          -- D.requestName dbus (D.busName_ "org.xmonad.Log")
          --   [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]-- 
          xmonad =<< statusBar mybar mypp togglestrutskey myconfig

-- Command to launch the bar.
mybar = "xmobar"
-- Custom PP, configure it as you like. It determines what is being written to the bar
mypp = def { ppCurrent = const "<fc=#fe8019>\x25cf</fc>"
           , ppHidden = const "<fc=#3c3836>\x25cf</fc>" -- "<fc=#fe8019>\x25cb</fc>"
           , ppHiddenNoWindows = const "<fc=#3c3836>\x25cf</fc>"
           , ppTitle = const ""
           , ppOrder = return . head
           , ppWsSep = "   " }
-- Key binding to toggle the gap for the bar.
togglestrutskey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myconfig = def
  { borderWidth        = myborderwidth
  , terminal           = myterminal
  , normalBorderColor  = mynormalbordercolor
  , focusedBorderColor = myfocusedbordercolor
  , layoutHook         = mylayout
  , startupHook        = mystartup
  , keys               = \c -> mykeys c `M.union` keys def c }

myborderwidth = 0
myterminal = "alacritty"
mynormalbordercolor = "purple"
myfocusedbordercolor = "cyan"
mylayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = spacingRaw False
                         (Border 0 0 0 0) False
                         (Border 25 25 25 25) True $
                         Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
mystartup = do
  spawn $ "gpg -q --for-your-eyes-only --no-tty -d ~/.gmailpass.gpg"
mykeys c = mkKeymap c $
  [ ("M-S-e", spawn "emacsclient -c --eval \'(dired \"~/Documents\")\'")
  , ("M-S-f", spawn "firefox")
  , ("M-S-g", spawn "google-chrome-stable")
  , ("M-S-l", spawn $ "i3lock-fancy-rapid 40 10 -n"
                   ++ " --insidecolor=1d202180"
                   ++ " --ringcolor=b8bb2680"
                   ++ " --keyhlcolor=fabd2f80"
                   ++ " --bshlcolor=cc241dff" 
                   ++ " --linecolor=282828ff"
                   ++ " --insidevercolor=83a5984d"
                   ++ " --ringvercolor=45858880"
                   ++ " --insidewrongcolor=cc241d80"
                   ++ " --ringwrongcolor=fb493480")
  , ("M-S-i", spawn "escrotum -s")
  , ("M-S-s", spawn "spotify") ]

-- -\- Override the PP values as you would otherwise, adding colors etc depending
-- -\- on  the statusbar used
-- myloghook :: D.Client -> PP
-- myloghook dbus = def { ppOutput = dbusoutput dbus }
-- -\- Emit a DBus signal on log updates
-- dbusoutput :: D.Client -> String -> IO ()
-- dbusoutput dbus str = do
--   let signal = (D.signal objectPath interfaceName memberName)
--                  { D.signalBody = [D.toVariant $ UTF8.decodeString str] }
--   D.emit dbus signal
--   where objectPath = D.objectPath_ "/org/xmonad/Log"
--         interfaceName = D.interfaceName_ "org.xmonad.Log"
--         memberName = D.memberName_ "Update"

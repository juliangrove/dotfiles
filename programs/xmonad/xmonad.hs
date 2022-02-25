-- | my xmonad.hs

import XMonad
import XMonad.Hooks.EwmhDesktops
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
          x <- statusBar mybar mypp togglestrutskey myconfig
          xmonad (ewmh x)

-- Command to launch the bar.
mybar = "xmobar"
-- Custom PP, configure it as you like. It determines what is being written to the bar
mypp = def { ppCurrent = const "<fc=#fe8019>\x25cf</fc>"
           , ppHidden = const "<fc=#3c3836>\x25cf</fc>" -- "<fc=#fe8019>\x25cb</fc>"
           , ppHiddenNoWindows = const "<fc=#3c3836>\x25cf</fc>"
           , ppVisible = const "<fc=#8ec07c>\x25cf</fc>"
           , ppVisibleNoWindows = Just $ const "<fc=#8ec07c>\x25cf</fc>"
           , ppTitle = const ""
           , ppOrder = return . head
           , ppWsSep = "   " }
-- Key binding to toggle the gap for the bar.
togglestrutskey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

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
  spawn $ "gpg2 -q --for-your-eyes-only --no-tty -d ~/.gmailpass.gpg" ++
    " && gpg2 -q --for-your-eyes-only --no-tty -d ~/.gupass.gpg" ++
    " && arbtt-capture"
    
mykeys c = mkKeymap c $
  [ -- ("M-S-d", spawn $ "dmenu_run -b -fn 'Courier-12' -nb '#282828'"
    -- ++ " -nf '#ebdbb2' -sb '#98971a' -sf '#1d2021'")
    ("M-S-e", spawn "emacsclient -c --eval \'(dired \"~/Documents\")\'")
  , ("M-S-f", spawn "firefox")
  , ("M-S-g", spawn "google-chrome-stable")
  , ("M-S-l", spawn $ "i3lock-fancy-rapid 40 10 -n"
                   ++ " --inside-color=1d202180"
                   ++ " --ring-color=b8bb2680"
                   ++ " --keyhl-color=fabd2f80"
                   ++ " --bshl-color=cc241dff" 
                   ++ " --line-color=282828ff"
                   ++ " --insidever-color=83a5984d"
                   ++ " --ringver-color=45858880"
                   ++ " --insidewrong-color=cc241d80"
                   ++ " --ringwrong-color=fb493480")
  , ("M-S-i", spawn "escrotum -s")
  , ("M-S-u", spawn "escrotum")
  , ("M-S-r", spawn "rofi -theme gruvbox-dark -font 'Courier New 16' -show run")
  , ("M-S-s", spawn "spotify")
  , ("M-S-z", spawn "zoom-us") ]

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

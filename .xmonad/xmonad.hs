--------------------------------------------------------------------------------
-- IMPORTS
--------------------------------------------------------------------------------
-- {{{
import Data.List
import Data.Map                     ((!))
import Data.Monoid                  (Endo)
import qualified Data.Map           as M
import Data.String                  (words, unwords)

import System.IO                    (Handle, hPutStrLn)
import System.Exit                  (exitSuccess)
import XMonad
import qualified XMonad.StackSet    as W

import XMonad.Actions.CycleWS       (toggleWS)
import XMonad.Actions.MouseResize   (mouseResize)
import XMonad.Actions.Promote       ()
import XMonad.Actions.SpawnOn       (spawnHere)
import XMonad.Actions.WithAll       (killAll, sinkAll)

import XMonad.Hooks.DynamicLog      (dynamicLogWithPP, shorten, PP(..), wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.EwmhDesktops    (ewmh, fullscreenEventHook)
import XMonad.Hooks.InsertPosition  (insertPosition, Position(..), Focus(..))
import XMonad.Hooks.ManageDocks     (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers   (doCenterFloat, doFullFloat, isFullscreen)
import XMonad.Hooks.SetWMName       (setWMName)

import XMonad.Layout.Grid           (Grid(..))
import XMonad.Layout.SimpleFloat    (simpleFloat)
import XMonad.Layout.Spacing        (spacing)
import XMonad.Layout.ThreeColumns   ( ThreeCol(ThreeColMid) )
import XMonad.Layout.ToggleLayouts  (toggleLayouts, ToggleLayout(..))

import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(..))

import XMonad.Util.EZConfig         (additionalKeysP)
import XMonad.Util.Run              (spawnPipe)
import XMonad.Util.SpawnOnce        (spawnOnce)
-- }}}

--------------------------------------------------------------------------------
-- DEFAULTS
--------------------------------------------------------------------------------
-- {{{
myFont :: String
myFont = "xft:UbuntuMono Nerd Font Mono:regular:antialias=true:hinting=true:size="

myFontSize :: Int
myFontSize = 10

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "firefox"

myFileBrowser :: String
myFileBrowser = "pcmanfm"

myEditor :: String
myEditor = myTerminal ++ " -e vim"

myDmenu :: String
myDmenu = "dmenu_run -h 28 -p \"> \""

myDmenuScript :: String
myDmenuScript = "dmenu -h 28"

myWorkspaces :: [String]
myWorkspaces = ["dev", "web", "pdf", "mus", "misc", "com"]

myWorkspaceKeys :: [String]
myWorkspaceKeys = ["y", "u", "i", "o", "p", "["]

myBorderWidth :: Dimension
myBorderWidth = 2

mySpacing :: Int
mySpacing = 8

transparencyOffset :: Int
transparencyOffset = 5

myColors = M.fromList
  [ ("background" , "#282828")
  , ("foreground" , "#ebdbb2")
  , ("black"      , "#282828")
  , ("white"      , "#ebdbb2")
  , ("red"        , "#cc241d")
  , ("yellow"     , "#d79921")
  , ("green"      , "#98971a")
  , ("blue"       , "#458588")
  , ("purple"     , "#b16286")
  , ("aqua"       , "#689d6a")
  , ("grey"       , "#a89984")
  ]
-- }}}

--------------------------------------------------------------------------------
-- KEY BINDINGS
--------------------------------------------------------------------------------
-- {{{
myKeys :: [( String, X () )]
myKeys =
  -- Basic xmonad functionality
  [ ("M-C-r", spawn "xmonad --recompile")
  , ("M-S-r", spawn "xmonad --restart")
  , ("M-S-q", io exitSuccess)
  , ("M-q", spawn "echo \"removed default xmonad restart\"")

  -- Dmenu
  , ("M-S-<Return>", spawn $ myDmenu)

  -- Dmenu scripts
  , ("M-r r", spawn $ myDmenu)
  , ("M-r l", spawn $ "dm-logout \"" ++ myDmenuScript ++ "\"")
  , ("M-r d", spawn $ "dm-dotfiles \"" ++ myDmenuScript ++ "\" \"" ++ myEditor ++ "\"")
  , ("M-r w", spawn $ "dm-windows \"" ++ myDmenuScript ++ "\"")

  -- Useful applications
  , ("M-<Return>", spawn myTerminal)
  , ("M-b", spawn myBrowser)
  , ("M-f", spawn myFileBrowser)

  -- Window killing
  , ("M-S-c", kill)
  , ("M-S-a", killAll)

  -- Floating windows
  , ("M-t", withFocused $ windows . W.sink)
  , ("M-S-t", sinkAll)

  -- Window navigation
  , ("M-m", windows W.focusMaster)
  , ("M-j", windows W.focusDown)
  , ("M-k", windows W.focusUp)
  , ("M-S-m", windows W.swapMaster)
  , ("M-S-j", windows W.swapDown)
  , ("M-S-k", windows W.swapUp)

  -- Window resizing
  , ("M-h", sendMessage Shrink)
  , ("M-l", sendMessage Expand)

  -- Opacity
  , ("M-,", spawnHere $ "picom-trans -c -" ++ (show transparencyOffset))
  , ("M-.", spawnHere $ "picom-trans -c +" ++ (show transparencyOffset))

  -- Layouts - Borders
  , ("C-<Space>", sendMessage NextLayout)
  , ("C-S-<Space>", sendMessage FirstLayout)
  , ("M-<Space>", spawn "echo 'keyboard layout change'")

  -- Multimedia keys
  , ("<XF86AudioPlay>", spawn "playerctl play-pause")
  , ("<XF86AudioPrev>", spawn "playerctl previous")
  , ("<XF86AudioNext>", spawn "playerctl next")
  , ("<XF86AudioMute>", spawn "amixer set Master toggle")
  , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
  , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
  , ("<Print>", spawn "flameshot screen")
  , ("C-<Print>", spawn "flameshot gui")
  ]
  -- Workspace moving
  ++ [( "M-<Tab>", toggleWS )]
  ++ map switchTo myWorkspaceMap
  ++ map moveTo myWorkspaceMap
  ++ map moveAndSwitchTo myWorkspaceMap
  where
    myWorkspaceMap              = zip myWorkspaces myWorkspaceKeys
    switchTo        (ws, key)   = ("M-" ++ key, windows $ W.greedyView ws)
    moveTo          (ws, key)   = ("M-C-" ++ key, windows $ W.shift ws)
    moveAndSwitchTo (ws, key)   = ("M-S-" ++ key, windows $ W.greedyView ws . W.shift ws)
-- }}}

--------------------------------------------------------------------------------
-- HOOKS
--------------------------------------------------------------------------------
-- {{{
myStartupHook :: X ()
myStartupHook = do
  spawn "killall trayer"

  spawnOnce "monitors"
  spawnOnce "lxsession"
  spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOnce "lxsession"
  spawnOnce "nitrogen --restore &"

  spawn $ "sleep 2 && trayer --edge top --align right --widthtype request "
    ++ "--SetDockType true --SetPartialStrut true --expand true " 
    ++ "--transparent true --alpha 0 --height 28 --tint 0x"
    ++ (tail $ myColors ! "background")

  setWMName "LG3D"

myManageHook :: Query(Endo WindowSet)
myManageHook = insertPosition Below Newer <+> composeAll
  [ className =? "confirm"              --> doFloat
  , className =? "file_progress"        --> doFloat
  , className =? "dialog"               --> doFloat
  , className =? "download"             --> doFloat
  , className =? "error"                --> doFloat
  , className =? "notification"         --> doFloat
  , className =? "toolbar"              --> doFloat

  , className =? "Blueberry.py"         --> doCenterFloat
  , className =? "Nm-connection-editor" --> doCenterFloat
  , className =? "Pavucontrol"          --> doCenterFloat
  , className =? "Galculator"           --> doCenterFloat

  , isFullscreen                        --> doFullFloat

  , className =? "Alacritty"            --> setTransparency 95
  ]
  where
    setTransparency num = liftX (spawnHere $ "picom-trans -c " ++ (show num))
      >> idHook
-- }}}

--------------------------------------------------------------------------------
--  LAYOUTS
--------------------------------------------------------------------------------
-- {{{
-- myLayoutHook :: !(l Window)
myLayoutHook = spacing mySpacing $ avoidStruts (tiled ||| Full ||| simpleFloat ||| colMid ||| Grid)
  where
    tiled = Tall 1  (3/100) (3/5)
    colMid = ThreeColMid 1 (3/100) (1/2)
-- }}}

--------------------------------------------------------------------------------
-- XMOBAR CONFIG
--------------------------------------------------------------------------------
-- {{{
myXmobarHook :: (Handle, Handle) -> PP
myXmobarHook (xmproc0, xmproc1) = xmobarPP
  { ppOutput = \x -> hPutStrLn xmproc0 x
                  >> hPutStrLn xmproc1 x
  , ppCurrent          = xmobarColor (myColors ! "red") "" . wrap "[" "]" . clickable
  , ppVisible          = xmobarColor (myColors ! "yellow") "" . wrap "[" "]" . clickable
  , ppHidden           = xmobarColor (myColors ! "white") "" . wrap "[" "]" . clickable
  , ppHiddenNoWindows  = xmobarColor (myColors ! "white") "" . wrap "(" ")" . clickable
  , ppUrgent           = xmobarColor (myColors ! "red") "" . wrap "!" "!" . clickable

  , ppTitle            = xmobarColor (myColors ! "foreground") "" . windowAction . shorten 40 
  , ppLayout           = formatLayout

  , ppSep              = xmobarColor (myColors ! "yellow") "" " | "
  , ppWsSep            = ""
  }
  where
    formatLayout l   = unwords $ filter (`notElem` removeFromLayout) $ words l
    removeFromLayout = ["Spacing", "Simple"]
    clickable ws     = "<action=xdotool key super+" ++ (key ws) ++ ">" ++ ws ++ "</action>"
    key ws           = fixSymbols $ myWorkspaceMap ! ws
    myWorkspaceMap   = M.fromList $ zip myWorkspaces myWorkspaceKeys
    fixSymbols key   = if (key == "[") then "bracketleft" else key
    windowAction win = if (win == "") then ""
                       else "<action=xdotool key super+shift+c><fc=" ++ (myColors ! "red")
                            ++ ">[X] </fc></action>" ++ win
-- }}}

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------
-- {{{
main :: IO ()
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.xmonad/xmobarrc.primary"
  xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.xmonad/xmobarrc.secondary"
  xmonad $ ewmh def
    { modMask            = myModMask
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myColors ! "black"
    , focusedBorderColor = myColors ! "red"
    , workspaces         = myWorkspaces

    , handleEventHook    = docksEventHook <+> fullscreenEventHook
    , startupHook        = myStartupHook
    , manageHook         = myManageHook <+> manageDocks
    , layoutHook         = myLayoutHook
    , logHook            = dynamicLogWithPP $ myXmobarHook (xmproc0, xmproc1)
    } `additionalKeysP`  myKeys
-- }}}

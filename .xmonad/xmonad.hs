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
import XMonad.Actions.GridSelect    
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
import XMonad.Layout.Maximize       (maximize, maximizeRestore)
import XMonad.Layout.SimplestFloat  (simplestFloat)
import XMonad.Layout.Spacing        (spacing)
import XMonad.Layout.ThreeColumns   ( ThreeCol(ThreeColMid) )
import XMonad.Layout.ToggleLayouts  (toggleLayouts, ToggleLayout(..))

import qualified XMonad.Layout.MultiToggle as MT (mkToggle, Toggle(..), EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(..))

import XMonad.Util.Cursor           (setDefaultCursor)
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

myShell :: String
myShell = "bash"

myEditor :: String
myEditor = "edit"

myDmenu :: String
myDmenu = "dmenu_run -h 28 -p \"> \""

myDmenuScript :: String
myDmenuScript = "dmenu -h 28"

myWorkspaces :: [String]
myWorkspaces = ["dev", "web", "pdf", "mus", "misc", "com", "ntua"]

myWorkspaceKeys :: [String]
myWorkspaceKeys = ["y", "u", "i", "o", "p", "[", "n"]

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

myApplications :: [( String, X() )]
myApplications = [
    ("Terminal", spawn myTerminal)
  , ("Browser", spawn myBrowser)
  , ("File Manager", spawn myFileBrowser)
  , ("Editor", spawn myEditor)
  , ("Eclipse", spawn "eclipse")
  , ("Geany", spawn "geany")
  , ("Discord", spawn "discord")
  , ("Spotify", spawn "spotify")
  , ("PDF Viewer", spawn "evince")
  , ("Calculator", spawn "galculator")
  , ("Musescore", spawn "musescore")
  , ("Scanner", spawn "simple-scan")
  , ("OBS", spawn "obs-studio")
  , ("VLC", spawn "vlc")
  , ("Quit", spawn "echo AppSelector killed")
  ]

myGridConfig :: GSConfig (X ())
myGridConfig = (buildDefaultGSConfig myColorizer) {
    gs_cellheight = 40
  , gs_cellwidth = 200
  , gs_cellpadding = 6
  , gs_font = myFont ++ ( show $ myFontSize + 2 )
  , gs_navigate = navNSearch
  , gs_originFractX = 0.5
  , gs_originFractY = 0.5
  }
  where
    myColorizer s active =
      if active
        then return (myColors ! "red", myColors ! "foreground")
        else return (myColors ! "background", myColors ! "foreground")
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
  , ("M-r a", runSelectedAction myGridConfig myApplications)

  -- Useful applications
  , ("M-<Return>", spawn myTerminal)
  , ("M-b", spawn myBrowser)
  , ("M-f", spawn myFileBrowser)
  , ("M-v", spawn $ myEditor)

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
  , ("M-S-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)

  -- Opacity
  , ("M--", spawnHere $ "picom-trans -c -" ++ (show transparencyOffset))
  , ("M-=", spawnHere $ "picom-trans -c +" ++ (show transparencyOffset))

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
  , ("C-<Print>", spawn "flameshot screen -p $HOME/Pictures/")
  , ("<Print>", spawn "flameshot screen -c")
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

  -- spawnOnce "monitors"
  spawnOnce "lxsession"
  spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOnce "lxsession"
  spawnOnce "caffeine-indicator"
  spawnOnce "nitrogen --restore &"
  spawn "setxkbmap -model pc104 -layout us,gr -option 'grp:win_space_toggle'"

  -- spawnOnce "discord"
  -- spawnOnce "spotify"

  spawn $ "monitors"
  spawn $ "sleep 1.5 && trayer --edge top --align right --widthtype request "
    ++ "--SetDockType true --SetPartialStrut true --expand true " 
    ++ "--transparent true --alpha 0 --height 28 --tint 0x"
    ++ (tail $ myColors ! "background")

  setWMName "LG3D"

myManageHook :: Query(Endo WindowSet)
myManageHook = insertPosition Below Newer <+> composeAll
  [ className =? "confirm"                   --> doFloat
  , className =? "file_progress"             --> doFloat
  , className =? "dialog"                    --> doFloat
  , className =? "download"                  --> doFloat
  , className =? "error"                     --> doFloat
  , className =? "notification"              --> doFloat
  , className =? "toolbar"                   --> doFloat

  , className =? "Blueberry.py"              --> doCenterFloat
  , className =? "Nm-connection-editor"      --> doCenterFloat
  , className =? "nm-applet"                 --> doCenterFloat
  , className =? "Pavucontrol"               --> doCenterFloat
  , className =? "Galculator"                --> doCenterFloat
  , className =? "vncviewer"                 --> doCenterFloat
  , title     =? "progtech"                  --> doCenterFloat
  , title     =? "Eclipse"                   --> doCenterFloat

  , isFullscreen                             --> doFullFloat

  , className =? "discord"                   --> doShift "com"
  -- , className =? "Spotify"                  --> doShift "mus"

  , className =? "Alacritty"                 --> setTransparency 95
  , className =? "microsoft teams - preview" --> setTransparency 100
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
myLayoutHook = avoidStruts $ MT.mkToggle (NBFULL MT.?? NOBORDERS MT.?? MT.EOT) $ spacing mySpacing $
-- myLayoutHook = spacing mySpacing $ avoidStruts $ maximize $ MT.mkToggle (NBFULL)
  (tiled ||| Full ||| simplestFloat ||| colMid ||| Grid)
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
  , ppLayout           = layoutAction . formatLayout

  , ppSep              = xmobarColor (myColors ! "yellow") "" " | "
  , ppWsSep            = ""
  }
  where
    formatLayout l   = unwords $ map replaceLayout $ filter (`notElem` removeFromLayout) $ words l
    removeFromLayout = ["Maximize", "Spacing", "Simple"]
    replaceLayout x  = if (x == "SimplestFloat") then "Float"
                       else x
    clickable ws     = "<action=`xdotool key super+" ++ (key ws) ++ "` button=1>" 
                       ++ "<action=`xdotool key super+control+" ++ (key ws) ++ "` button=3>"
                       ++ ws ++ "</action></action>"
    key ws           = fixSymbols $ myWorkspaceMap ! ws
    myWorkspaceMap   = M.fromList $ zip myWorkspaces myWorkspaceKeys
    fixSymbols key   = if (key == "[") then "bracketleft"
                       else if (key == "]") then "bracketright"
                       else key
    windowAction win = if (win == "") then ""
                       else "<action=xdotool key super+shift+c><fc=" ++ (myColors ! "red")
                            ++ ">[X] </fc></action>" ++ win
    layoutAction     = wrap "<action=xdotool key control+space>" "</action>"
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

    , handleEventHook    = docksEventHook
    , startupHook        = setDefaultCursor xC_left_ptr <+> myStartupHook
    , manageHook         = myManageHook <+> manageDocks
    , layoutHook         = myLayoutHook
    , logHook            = dynamicLogWithPP $ myXmobarHook (xmproc0, xmproc1)
    } `additionalKeysP`  myKeys
-- }}}

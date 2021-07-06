import XMonad
import XMonad.Hooks.SetWMName

import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageHelpers

-- XMobar hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.WorkspaceNames
import XMonad.Util.Run(spawnPipe, hPutStrLn)

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ docks def
        { modMask            = mod4Mask         -- superkey (WIN key)
        , workspaces         = ["1:main", "2:side", "3:media", "4", "5", "6"]
        , manageHook         = manageDocks <+> manageHook def <+> composeAll
            [ title     =? "demo" --> doCenterFloat
            -- , title     =? "demo" --> doShift "2:side"
            , className =? "demo" --> doCenterFloat
            ]
        , layoutHook         = avoidStruts  $  layoutHook def

        , handleEventHook    = handleEventHook def <+> docksEventHook

        , terminal           = "alacritty"
        , normalBorderColor  = "#000000"
        , focusedBorderColor = "#3979C6"
        , borderWidth        = 2
        , startupHook        = do
            setWMName "LG3D" -- for java applications
            spawnOnce "xfce4-power-manager --daemon"
        , logHook            = workspaceNamesPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = id
            }
            >>= dynamicLogWithPP
        }

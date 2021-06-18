import XMonad
import XMonad.Hooks.SetWMName

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
        , manageHook         = manageDocks <+> manageHook def <+> composeAll
            [ className =? "demo" --> doFloat
            , title     =? "demo" --> doFloat
            ]
        , layoutHook         = avoidStruts  $  layoutHook def

        , handleEventHook    = handleEventHook def <+> docksEventHook

        , terminal           = "alacritty"
        , normalBorderColor  = "#000000"
        , focusedBorderColor = "#3979C6"
        , borderWidth        = 2
        , startupHook        = setWMName "LG3D" -- for java applications
        , logHook            = workspaceNamesPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = id
            }
            >>= dynamicLogWithPP
        }

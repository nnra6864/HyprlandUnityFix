-- TODO: Replace all window rules with a for loop

-- Opaque
hl.window_rule({ match = { class = "Unity", title = "Font Asset Creator" },    tag = "+unity_opaque" })
hl.window_rule({ match = { class = "Unity", title = "UI Builder" },            tag = "+unity_opaque" })
hl.window_rule({ match = { class = "Unity", title = "Color" },                 tag = "+unity_opaque" })
hl.window_rule({ match = { class = "Unity", title = "HDR Color" },             tag = "+unity_opaque" })
hl.window_rule({ match = { class = "Unity", title = "Gradient Editor.*" },     tag = "+unity_opaque" })
hl.window_rule({ match = { class = "Unity", title = "HDR Gradient Editor.*" }, tag = "+unity_opaque" })

hl.window_rule({
    name   = "unity_opaque",
    match  = { tag = "unity_opaque" },
    opaque = true
})

-- Selectors
local selector_pos = { "cursor_x - (window_w * 0.5)", "cursor_y - (window_h * 0.5)" }

hl.window_rule({ match = { class = "Unity", title = "" },                                                         tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Select.*" },                                                 tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.AddComponent.AddComponentWindow" },              tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.Rendering.FilterWindow.*" },                     tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.IconSelector" },                                 tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.IMGUI.Controls.AdvancedDropdownWindow" },        tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.Searcher.SearcherWindow" },                      tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.VFX.UI.VFXFilterWindow" },                       tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Tile Palette" },                                             tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.Rendering.FilterWindow" },                       tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.IMGUI.Controls.AdvancedDropdownWindow" },        tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditorInternal.AddCurvesPopup" },                       tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEngine.InputSystem.Editor.AdvancedDropdownWindow" },    tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Save Layout" },                                              tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "UnityEditor.PackageManager.UI.Internal.DropdownContainer" }, tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Color" },                                                    tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "HDR Color" },                                                tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Gradient Editor.*" },                                        tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "HDR Gradient Editor.*" },                                    tag = "+unity_selector" })
hl.window_rule({ match = { class = "Unity", title = "Curve.*" },                                                  tag = "+unity_selector" })

hl.window_rule({
    name  = "unity_selector",
    match = { tag = "unity_selector" },
    move  = selector_pos
})

-- Makes new windows immediately accept input and fixes other X related issues
-- Can introduce some unexpected behavior
hl.window_rule({
    name         = "unity_x_fix",
    match        = { class = "Unity" },
    allows_input = true
})

-- Tooltips Stealing Focus
-- Discussions: https://discussions.unity.com/t/unset-tooltip-titles/1522964
-- Support: https://unity3d.atlassian.net/servicedesk/customer/portal/2/IN-85635
-- Issue Tracker: https://issuetracker.unity3d.com/issues/linux-tooltips-have-an-unset-title-which-causes-the-inability-to-modify-tooltip-behavior-on-window-managers
-- Thanks Unity devs <3
hl.window_rule({
    name  = "unity_tooltips",
    match = {
        class         = "Unity",
        initial_title = "UnityTooltipWindow"
    },

    allows_input      = false,
    no_focus          = true,
    no_initial_focus  = true,
    focus_on_activate = false
})

-- Fix for https://github.com/yasirkula/UnityAssetUsageDetector tooltips
hl.window_rule({
    name  = "asset_usage_detector_tooltips",
    match = {
        class = "Unity",
        title = "AssetUsageDetectorNamespace.SearchResultTooltip"
    },

    allows_input      = false,
    no_focus          = true,
    no_initial_focus  = true,
    focus_on_activate = false,
    min_size          = { 25, 25 }
})

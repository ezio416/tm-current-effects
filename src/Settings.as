[Setting category="General" hidden] bool  S_Enabled        = true;
[Setting category="General" hidden] bool  S_HideWithGame   = true;
[Setting category="General" hidden] bool  S_HideWithOP     = false;
[Setting category="General" hidden] bool  S_HideInactive   = false;
[Setting category="General" hidden] Style S_Style          = Style::Legacy;
[Setting category="General" hidden] bool  S_OverrideSafety = false;


[Setting category="Toggles" hidden] bool S_NoEngine  = true;
[Setting category="Toggles" hidden] bool S_Turbo     = true;
[Setting category="Toggles" hidden] bool S_Vehicle   = true;
#if TMNEXT
[Setting category="Toggles" hidden] bool S_ActionKey = false;
[Setting category="Toggles" hidden] bool S_Cruise    = true;
[Setting category="Toggles" hidden] bool S_Fragile   = true;
[Setting category="Toggles" hidden] bool S_Reactor   = true;
[Setting category="Toggles" hidden] bool S_SlowMo    = true;
[Setting category="Toggles" hidden] bool S_Water     = false;
#endif
#if TMNEXT || MP4
[Setting category="Toggles" hidden] bool S_Forced    = true;
[Setting category="Toggles" hidden] bool S_NoBrakes  = true;
[Setting category="Toggles" hidden] bool S_NoGrip    = true;
[Setting category="Toggles" hidden] bool S_NoSteer   = true;
#endif


[Setting category="Colors" hidden]
vec3 S_OffColor = vec3(0.5f, 0.5f, 0.5f);
string g_offColor;

[Setting category="Colors" hidden]
vec3 S_NoEngineColor = vec3(1.0f, 0.0f, 0.0f);
string g_noEngineColor;

#if TMNEXT

[Setting category="Colors" hidden]
vec3 S_AK1Color = vec3(1.0f, 0.0f, 0.0f);
string g_AK1Color;

[Setting category="Colors" hidden]
vec3 S_AK2Color = vec3(1.0f, 1.0f, 0.0f);
string g_AK2Color;

[Setting category="Colors" hidden]
vec3 S_AK3Color = vec3(0.0f, 1.0f, 0.0f);
string g_AK3Color;

[Setting category="Colors" hidden]
vec3 S_AK4Color = vec3(0.0f, 1.0f, 1.0f);
string g_AK4Color;

[Setting category="Colors" hidden]
vec3 S_CruiseColor = vec3(0.226f, 0.564f, 1.0f);
string g_cruiseColor;

[Setting category="Colors" hidden]
vec3 S_FragileColor = vec3(1.0f, 0.648f, 0.0f);
string g_fragileColor;

[Setting category="Colors" hidden]
vec3 S_Reactor1Color = vec3(0.766f, 1.0f, 0.0f);
string g_reactor1Color;

[Setting category="Colors" hidden]
vec3 S_Reactor2Color = vec3(1.0f, 0.463f, 0.0f);
string g_reactor2Color;

[Setting category="Colors" hidden]
vec3 S_SlowMo1Color = vec3(0.0f, 1.0f, 0.0f);
string g_slowMo1Color;

[Setting category="Colors" hidden]
vec3 S_SlowMo2Color = vec3(1.0f, 1.0f, 0.0f);
string g_slowMo2Color;

[Setting category="Colors" hidden]
vec3 S_SlowMo3Color = vec3(1.0f, 0.663f, 0.0f);
string g_slowMo3Color;

[Setting category="Colors" hidden]
vec3 S_SlowMo4Color = vec3(1.0f, 0.0f, 0.0f);
string g_slowMo4Color;

[Setting category="Colors" hidden]
vec3 S_Turbo1Color = vec3(1.0f, 1.0f, 0.0f);
string g_turbo1Color;

[Setting category="Colors" hidden]
vec3 S_Turbo2Color = vec3(1.0f, 0.0f, 0.0f);
string g_turbo2Color;

[Setting category="Colors" hidden]
vec3 S_Turbo3Color = vec3(1.0f, 1.0f, 0.0f);
string g_turbo3Color;

[Setting category="Colors" hidden]
vec3 S_Turbo4Color = vec3(0.0f, 1.0f, 1.0f);
string g_turbo4Color;

[Setting category="Colors" hidden]
vec3 S_Turbo5Color = vec3(1.0f, 0.0f, 1.0f);
string g_turbo5Color;

[Setting category="Colors" hidden]
vec3 S_WaterColor = vec3(0.0f, 0.85f, 1.0f);
string g_waterColor;

#else

[Setting category="Colors" hidden]
vec3 S_TurboColor = vec3(0.0f, 1.0f, 0.0f);
string g_turboColor;

#endif
#if TMNEXT || MP4

[Setting category="Colors" hidden]
vec3 S_ForcedColor = vec3(0.0f, 1.0f, 0.0f);
string g_forcedColor;

[Setting category="Colors" hidden]
vec3 S_NoBrakesColor = vec3(1.0f, 0.848f, 0.0f);
string g_noBrakesColor;

[Setting category="Colors" hidden]
vec3 S_NoGripColor = vec3(0.049f, 0.861f, 1.0f);
string g_noGripColor;

[Setting category="Colors" hidden]
vec3 S_NoSteerColor = vec3(0.951f, 0.0f, 1.0f);
string g_noSteerColor;

[Setting category="Colors" hidden]
vec3 S_SnowColor = vec3(0.0f, 1.0f, 1.0f);
string g_snowColor;

[Setting category="Colors" hidden]
vec3 S_DesertColor = vec3(1.0f, 0.5f, 0.1f);
string g_desertColor;

[Setting category="Colors" hidden]
vec3 S_RallyColor = vec3(0.1f, 0.8f, 0.1f);
string g_rallyColor;

#endif
#if MP4

// [Setting category="Colors" hidden]
// vec3 S_IslandColor = vec3();
// string g_islandColor;

[Setting category="Colors" hidden]
vec3 S_BayColor = vec3(0.0f, 0.2f, 1.0f);
string g_bayColor;

// [Setting category="Colors" hidden]
// vec3 S_CoastColor = vec3();
// string g_coastColor;

#endif
#if MP4 || TURBO

[Setting category="Colors" hidden]
vec3 S_CanyonColor = vec3(1.0f, 0.5f, 0.2f);
string g_canyonColor;

[Setting category="Colors" hidden]
vec3 S_ValleyColor = vec3(0.1f, 0.8f, 0.1f);
string g_valleyColor;

[Setting category="Colors" hidden]
vec3 S_LagoonColor = vec3(0.0f, 0.2f, 1.0f);
string g_lagoonColor;

#endif


[Setting category="Font" hidden] Font   S_Font     = Font::DroidSans;
[Setting category="Font" hidden] string S_SystemFont;
[Setting category="Font" hidden] int    S_FontSize = 16;


[SettingsTab name="Settings" icon="Cog" order=0]
void SettingsTab_Statuses() {
    if (UI::TreeNode("General", UI::TreeNodeFlags::Framed)) {
        if (UI::Button("Reset general to default")) {
            Meta::PluginSetting@[]@ settings = PLUGIN_META.GetSettings();
            for (uint i = 0; i < settings.Length; i++) {
                if (settings[i].Category == "General") {
                    settings[i].Reset();
                }
            }

            OnSettingsChanged();
        }

        S_Enabled      = UI::Checkbox("Show window", S_Enabled);
        S_HideWithGame = UI::Checkbox("Show/hide with game UI", S_HideWithGame);
        S_HideWithOP   = UI::Checkbox("Show/hide with Openplanet UI", S_HideWithOP);
        S_HideInactive = UI::Checkbox("Only show active statuses", S_HideInactive);

#if TMNEXT
        if (!Safety::safe) {
            S_OverrideSafety = UI::Checkbox(
                "\\$fa0" + Icons::ExclamationCircle + " Override safety and run plugin " + Icons::ExclamationCircle,
                S_OverrideSafety
            );
        }
#endif

        UI::TreePop();
    }

    if (UI::TreeNode("Font", UI::TreeNodeFlags::Framed)) {
        if (UI::Button("Reset font to default")) {
            PLUGIN_META.GetSetting("S_Font").Reset();
            PLUGIN_META.GetSetting("S_FontSize").Reset();
        }

        RenderFontSettings();

        UI::TreePop();
    }

    if (UI::TreeNode("Toggles and Colors", UI::TreeNodeFlags::Framed)) {
        if (UI::Button("Reset toggles to default")) {
            Meta::PluginSetting@[]@ settings = PLUGIN_META.GetSettings();
            for (uint i = 0; i < settings.Length; i++) {
                if (settings[i].Category == "Toggles") {
                    settings[i].Reset();
                }
            }

            OnSettingsChanged();
        }

        UI::SameLine();
        if (UI::Button("Reset colors to default")) {
            Meta::PluginSetting@[]@ settings = PLUGIN_META.GetSettings();
            for (uint i = 0; i < settings.Length; i++) {
                if (settings[i].Category == "Colors") {
                    settings[i].Reset();
                }
            }

            OnSettingsChanged();
        }

        S_OffColor = UI::InputColor3("Status Inactive/Invalid", S_OffColor);
        g_offColor = Text::FormatOpenplanetColor(S_OffColor);

        for (uint i = 0; i < g_statuses.Length; i++) {
            g_statuses[i].RenderSettings();
        }

        UI::TreePop();
    }
}


#if SIG_DEVELOPER

[SettingsTab name="Debug" icon="Bug" order=66]
void SettingsTab_Debug() {
    if (UI::BeginTable("##table-debug", 2, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(), 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("name");
        UI::TableSetupColumn("value", UI::TableColumnFlags::WidthStretch);
        UI::TableHeadersRow();

        g_state.RenderDebugRows();

        UI::PopStyleColor();
        UI::EndTable();
    }
}

#endif

[Setting category="General" hidden] bool   S_Enabled      = true;
[Setting category="General" hidden] bool   S_HideInactive = false;
[Setting category="General" hidden] bool   S_HideWithGame = true;
[Setting category="General" hidden] bool   S_HideWithOP   = false;
[Setting category="General" hidden] bool   S_Icons        = true;
[Setting category="General" hidden] float  S_Opacity      = 1.0f;
[Setting category="General" hidden] string S_OverrideVersion;
[Setting category="General" hidden] Style  S_Style        = Style::Legacy;


[Setting category="Toggles" hidden] bool S_Checkpoints    = false;
[Setting category="Toggles" hidden] bool S_CheckpointsBar = true;
[Setting category="Toggles" hidden] bool S_CheckpointTime = false;
[Setting category="Toggles" hidden] bool S_Clock1         = false;
[Setting category="Toggles" hidden] bool S_Clock2         = false;
[Setting category="Toggles" hidden] bool S_Clock3         = false;
[Setting category="Toggles" hidden] bool S_ExeVersion     = false;
[Setting category="Toggles" hidden] bool S_Fps            = false;
[Setting category="Toggles" hidden] bool S_FpsBar         = true;
[Setting category="Toggles" hidden] bool S_GameMode       = false;
[Setting category="Toggles" hidden] bool S_Ghosts         = false;
[Setting category="Toggles" hidden] bool S_Laps           = false;
[Setting category="Toggles" hidden] bool S_LapsBar        = true;
[Setting category="Toggles" hidden] bool S_LapTime        = false;
[Setting category="Toggles" hidden] bool S_MapType        = false;
[Setting category="Toggles" hidden] bool S_MapUid         = false;
[Setting category="Toggles" hidden] bool S_NoEngine       = true;
[Setting category="Toggles" hidden] bool S_RaceTime       = false;
[Setting category="Toggles" hidden] bool S_Sequence       = false;
[Setting category="Toggles" hidden] bool S_Turbo          = true;
[Setting category="Toggles" hidden] bool S_TurboBar       = true;
[Setting category="Toggles" hidden] bool S_Vehicle        = true;
#if TMNEXT
[Setting category="Toggles" hidden] bool S_ActionKey     = false;
[Setting category="Toggles" hidden] bool S_ActionKeyBar  = true;
[Setting category="Toggles" hidden] bool S_Cruise        = true;
[Setting category="Toggles" hidden] bool S_CruiseBar     = true;
[Setting category="Toggles" hidden] bool S_Fragile       = true;
[Setting category="Toggles" hidden] bool S_FragileBar    = true;
[Setting category="Toggles" hidden] bool S_Reactor       = true;
[Setting category="Toggles" hidden] bool S_ReactorBar    = true;
[Setting category="Toggles" hidden] bool S_Respawning    = false;
[Setting category="Toggles" hidden] bool S_RespawningBar = true;
[Setting category="Toggles" hidden] bool S_SlowMo        = true;
[Setting category="Toggles" hidden] bool S_SlowMoBar     = true;
[Setting category="Toggles" hidden] bool S_Water         = false;
[Setting category="Toggles" hidden] bool S_WaterBar      = true;
#endif
#if TMNEXT || MP4
[Setting category="Toggles" hidden] bool S_Forced    = true;
[Setting category="Toggles" hidden] bool S_Nametags  = false;
[Setting category="Toggles" hidden] bool S_NoBrakes  = true;
[Setting category="Toggles" hidden] bool S_NoGrip    = true;
[Setting category="Toggles" hidden] bool S_NoSteer   = true;
[Setting category="Toggles" hidden] bool S_Opponents = false;
#endif


[Setting category="Colors" hidden]
vec3 S_OffColor = vec3(0.35f, 0.35f, 0.35f);
string g_offColor;

[Setting category="Colors" hidden]
vec3 S_CheckpointsColor = vec3(0.1f, 0.6f, 1.0f);
string g_checkpointsColor;

[Setting category="Colors" hidden]
vec3 S_CheckpointTimeColor = vec3(0.1f, 0.6f, 1.0f);
string g_checkpointTimeColor;

[Setting category="Colors" hidden]
vec3 S_Clock1Color = vec3(1.0f, 0.5f, 0.1f);
string g_clock1Color;

[Setting category="Colors" hidden]
vec3 S_Clock2Color = vec3(1.0f, 0.9f, 0.1f);
string g_clock2Color;

[Setting category="Colors" hidden]
vec3 S_Clock3Color = vec3(0.7f, 1.0f, 0.1f);
string g_clock3Color;

[Setting category="Colors" hidden]
vec3 S_ExeVersionColor = vec3(1.0f, 1.0f, 1.0f);
string g_exeVersionColor;

[Setting category="Colors" hidden]
vec3 S_FpsColor = vec3(1.0f, 1.0f, 1.0f);
string g_fpsColor;

[Setting category="Colors" hidden]
vec3 S_GameModeColor = vec3(1.0f, 1.0f, 1.0f);
string g_gameModeColor;

[Setting category="Colors" hidden]
vec3 S_GhostsColor = vec3(1.0f, 1.0f, 1.0f);
string g_ghostsColor;

[Setting category="Colors" hidden]
vec3 S_LapsColor = vec3(0.9f, 0.8f, 0.1f);
string g_lapsColor;

[Setting category="Colors" hidden]
vec3 S_LapTimeColor = vec3(0.9f, 0.8f, 0.1f);
string g_lapTimeColor;

[Setting category="Colors" hidden]
vec3 S_MapTypeColor = vec3(1.0f, 1.0f, 1.0f);
string g_mapTypeColor;

[Setting category="Colors" hidden]
vec3 S_MapUidColor = vec3(1.0f, 1.0f, 1.0f);
string g_mapUidColor;

[Setting category="Colors" hidden]
vec3 S_NoEngineColor = vec3(1.0f, 0.0f, 0.0f);
string g_noEngineColor;

[Setting category="Colors" hidden]
vec3 S_RaceTimeColor = vec3(1.0f, 0.3f, 0.3f);
string g_raceTimeColor;

[Setting category="Colors" hidden]
vec3 S_SequenceColor = vec3(1.0f, 1.0f, 1.0f);
string g_sequenceColor;

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
vec3 S_LaunchRespawnColor = vec3(0.0f, 1.0f, 0.0f);
string g_launchRespawnColor;

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
vec3 S_StandRespawnColor = vec3(1.0f, 0.0f, 0.0f);
string g_standRespawnColor;

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
vec3 S_NametagsColor = vec3(1.0f, 1.0f, 1.0f);
string g_nametagsColor;

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
vec3 S_OpponentsOpaqueColor = vec3(1.0f, 1.0f, 1.0f);
string g_opponentsOpaqueColor;

[Setting category="Colors" hidden]
vec3 S_OpponentsTransColor = vec3(0.6f, 0.6f, 0.6f);
string g_opponentsTransColor;

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

[Setting category="Colors" hidden]
vec3 S_IslandColor = vec3(0.2f, 1.0f, 0.6f);
string g_islandColor;

[Setting category="Colors" hidden]
vec3 S_BayColor = vec3(0.0f, 0.4f, 1.0f);
string g_bayColor;

[Setting category="Colors" hidden]
vec3 S_CoastColor = vec3(1.0f, 0.86f, 0.53f);
string g_coastColor;

[Setting category="Colors" hidden]
vec3 S_TrafficColor = vec3(1.0f, 0.9f, 0.2f);
string g_trafficColor;

#endif
#if MP4 || TURBO

[Setting category="Colors" hidden]
vec3 S_CanyonColor = vec3(1.0f, 0.5f, 0.2f);
string g_canyonColor;

[Setting category="Colors" hidden]
vec3 S_ValleyColor = vec3(0.1f, 0.8f, 0.1f);
string g_valleyColor;

[Setting category="Colors" hidden]
vec3 S_LagoonColor = vec3(0.0f, 0.4f, 1.0f);
string g_lagoonColor;

#endif


[Setting category="Font" hidden] Font   S_Font     = Font::DroidSans;
[Setting category="Font" hidden] string S_SystemFont;
[Setting category="Font" hidden] int    S_FontSize = 16;


[Setting hidden]
string S_Clock1Format = "%A";
bool g_clock1FormatValid = false;

[Setting hidden]
string S_Clock2Format = "%F";
bool g_clock2FormatValid = false;

[Setting hidden]
string S_Clock3Format = "%X";
bool g_clock3FormatValid = false;


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
        S_Icons        = UI::Checkbox("Show icons", S_Icons);
        S_Opacity      = UI::SliderFloat("Window opacity", S_Opacity, 0.05f, 1.0f, "%.2f", UI::SliderFlags::NoInput);

#if TMNEXT

        if (!Safety::safe) {
            Safety::runAnyway = UI::Checkbox(
                "\\$fa0Override safety and run plugin anyway",
                Safety::runAnyway
            );

            if (Safety::runAnyway) {
                UI::Indent(30.0f);

                S_OverrideVersion = UI::Checkbox(
                    "\\$fa0Remember this game version (" + Safety::gameVersion + ")",
                    S_OverrideVersion.Length > 0
                )
                    ? Safety::gameVersion
                    : ""
                ;

                UI::Indent(-30.0f);

            } else {
                S_OverrideVersion = "";
            }
        }

#endif

        UI::TreePop();
    }

    if (UI::TreeNode("Font", UI::TreeNodeFlags::Framed)) {
        if (UI::Button("Reset font to default")) {
            PLUGIN_META.GetSetting("S_Font").Reset();
            PLUGIN_META.GetSetting("S_FontSize").Reset();
            ChangeFont();
        }

        RenderFontSettings();

        UI::TreePop();
    }

    if (UI::TreeNode("Statuses", UI::TreeNodeFlags::Framed)) {
        UI::BeginChild("##child-statuses");

        if (UI::Button("Turn everything on")) {
            Meta::PluginSetting@[]@ settings = PLUGIN_META.GetSettings();
            for (uint i = 0; i < settings.Length; i++) {
                if (settings[i].Category == "Toggles") {
                    settings[i].WriteBool(true);
                }
            }

            OnSettingsChanged();
        }

        UI::SameLine();
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

        UI::EndChild();
        UI::TreePop();
    }
}


#if SIG_DEVELOPER

[SettingsTab name="Debug" icon="Bug" order=66]
void SettingsTab_Debug() {
    if (UI::BeginTable("##table-debug", 2, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(), 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("name",  UI::TableColumnFlags::WidthFixed, UI::GetScale() * 150.0f);
        UI::TableSetupColumn("value", UI::TableColumnFlags::WidthStretch);
        UI::TableHeadersRow();

        g_state.RenderDebugRows();

        UI::PopStyleColor();
        UI::EndTable();
    }
}

#endif

const string COLOR_DEBUG_OFF = "\\$f00";
const string COLOR_DEBUG_ON  = "\\$0f0";

string ColorDebugBool(const bool b) {
    return (b ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + b;
}

string ColorDebugCamera(const CurrentEffects::Camera c) {
    return (c != CurrentEffects::Camera::Unknown ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(c);
}

string ColorDebugFloat(const double f) {
    return Text::Format((f != 0.0f ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + "%.3f", f);
}

string ColorDebugFormattedString(const string&in s) {
    return COLOR_DEBUG_ON + Text::StripFormatCodes(s);
}

string ColorDebugInt(const int64 i) {  // unlikely to get a uint64 that exceeds int64 max without being a pointer
    return (i != 0 ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + i;
}

string ColorDebugOpponentVis(const CurrentEffects::OpponentVis o) {
    return (o > CurrentEffects::OpponentVis::Off ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(o);
}

string ColorDebugPointer(const uint64 p) {
    return (p != 0x0 ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + Text::FormatPointer(p);
}

string ColorDebugSequence(const CGamePlaygroundUIConfig::EUISequence s) {
    return (s != CGamePlaygroundUIConfig::EUISequence::None ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(s);
}

string ColorDebugString(const string&in s) {
    return COLOR_DEBUG_ON + s;
}

string ColorDebugVehicleType(const CurrentEffects::VehicleType v) {
    return (v != CurrentEffects::VehicleType::Unknown ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(v);
}

string ColorDebugViewMode(const CurrentEffects::ViewMode v) {
    return (v != CurrentEffects::ViewMode::Unknown ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(v);
}

string ColorGhosts() {
    return g_state.ghostVis ? g_ghostsColor : g_offColor;
}

string ColorNoEngine() {
    return g_state.noEngine ? g_noEngineColor : g_offColor;
}

string ColorTurbo() {
#if TMNEXT

    switch (g_state.turboLevel) {
        case 1:  return g_turbo1Color;
        case 2:  return g_turbo2Color;
        case 3:  return g_turbo3Color;
        case 4:  return g_turbo4Color;
        case 5:  return g_turbo5Color;
        default: return g_offColor;
    }

#else

    return g_state.turbo ? g_turboColor : g_offColor;

#endif
}

#if TMNEXT

string ColorActionKey() {
    switch (g_state.actionKey) {
        case 1:  return g_AK1Color;
        case 2:  return g_AK2Color;
        case 3:  return g_AK3Color;
        case 4:  return g_AK4Color;
        default: return g_offColor;
    }
}

string ColorCruise() {
    return g_state.cruiseControl ? g_cruiseColor : g_offColor;
}

string ColorDebugReactorLevel(const ESceneVehicleVisReactorBoostLvl l) {
    return (l != ESceneVehicleVisReactorBoostLvl::None ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(l);
}

string ColorDebugReactorType(const ESceneVehicleVisReactorBoostType t) {
    return (t != ESceneVehicleVisReactorBoostType::None ? COLOR_DEBUG_ON : COLOR_DEBUG_OFF) + tostring(t);
}

string ColorFragile() {
    return g_state.fragile ? g_fragileColor : g_offColor;
}

string ColorReactor() {
    switch (g_state.reactorLevel) {
        case ESceneVehicleVisReactorBoostLvl::Lvl1: return g_reactor1Color;
        case ESceneVehicleVisReactorBoostLvl::Lvl2: return g_reactor2Color;
        default:                                    return g_offColor;
    }
}

string ColorRespawning() {
    if (g_state.launchRespawning) return g_launchRespawnColor;
    if (g_state.standRespawning)  return g_standRespawnColor;
                                  return g_offColor;
}

string ColorSlowMo() {
    switch (g_state.slowMoLevel) {
        case 1:  return g_slowMo1Color;
        case 2:  return g_slowMo2Color;
        case 3:  return g_slowMo3Color;
        case 4:  return g_slowMo4Color;
        default: return g_offColor;
    }
}

string ColorWater() {
    return g_state.water > 0.0f ? g_waterColor : g_offColor;
}

#endif
#if TMNEXT || MP4

string ColorForced() {
    return g_state.forcedAccel ? g_forcedColor : g_offColor;
}

string ColorNametags() {
    return g_state.nametagVis ? g_nametagsColor : g_offColor;
}

string ColorNoBrakes() {
    return g_state.noBrakes ? g_noBrakesColor : g_offColor;
}

string ColorNoGrip() {
    return g_state.noGrip ? g_noGripColor : g_offColor;
}

string ColorNoSteer() {
    return g_state.noSteer ? g_noSteerColor : g_offColor;
}

string ColorOpponents() {
    switch (g_state.opponentVis) {
        case CurrentEffects::OpponentVis::Opaque:      return g_opponentsOpaqueColor;
        case CurrentEffects::OpponentVis::Transparent: return g_opponentsTransColor;
        default:                                       return g_offColor;
    }
}

#endif

void SetColorStrings() {
    g_ghostsColor   = Text::FormatOpenplanetColor(S_GhostsColor);
    g_offColor      = Text::FormatOpenplanetColor(S_OffColor);
    g_noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);

#if TMNEXT

    g_AK1Color           = Text::FormatOpenplanetColor(S_AK1Color);
    g_AK2Color           = Text::FormatOpenplanetColor(S_AK2Color);
    g_AK3Color           = Text::FormatOpenplanetColor(S_AK3Color);
    g_AK4Color           = Text::FormatOpenplanetColor(S_AK4Color);
    g_cruiseColor        = Text::FormatOpenplanetColor(S_CruiseColor);
    g_fragileColor       = Text::FormatOpenplanetColor(S_FragileColor);
    g_launchRespawnColor = Text::FormatOpenplanetColor(S_LaunchRespawnColor);
    g_reactor1Color      = Text::FormatOpenplanetColor(S_Reactor1Color);
    g_reactor2Color      = Text::FormatOpenplanetColor(S_Reactor2Color);
    g_slowMo1Color       = Text::FormatOpenplanetColor(S_SlowMo1Color);
    g_slowMo2Color       = Text::FormatOpenplanetColor(S_SlowMo2Color);
    g_slowMo3Color       = Text::FormatOpenplanetColor(S_SlowMo3Color);
    g_slowMo4Color       = Text::FormatOpenplanetColor(S_SlowMo4Color);
    g_standRespawnColor  = Text::FormatOpenplanetColor(S_StandRespawnColor);
    g_turbo1Color        = Text::FormatOpenplanetColor(S_Turbo1Color);
    g_turbo2Color        = Text::FormatOpenplanetColor(S_Turbo2Color);
    g_turbo3Color        = Text::FormatOpenplanetColor(S_Turbo3Color);
    g_turbo4Color        = Text::FormatOpenplanetColor(S_Turbo4Color);
    g_turbo5Color        = Text::FormatOpenplanetColor(S_Turbo5Color);
    g_waterColor         = Text::FormatOpenplanetColor(S_WaterColor);

#endif
#if TMNEXT || MP4

    g_checkpointsColor     = Text::FormatOpenplanetColor(S_CheckpointsColor);
    g_desertColor          = Text::FormatOpenplanetColor(S_DesertColor);
    g_forcedColor          = Text::FormatOpenplanetColor(S_ForcedColor);
    g_lapsColor            = Text::FormatOpenplanetColor(S_LapsColor);
    g_nametagsColor        = Text::FormatOpenplanetColor(S_NametagsColor);
    g_noBrakesColor        = Text::FormatOpenplanetColor(S_NoBrakesColor);
    g_noGripColor          = Text::FormatOpenplanetColor(S_NoGripColor);
    g_noSteerColor         = Text::FormatOpenplanetColor(S_NoSteerColor);
    g_opponentsOpaqueColor = Text::FormatOpenplanetColor(S_OpponentsOpaqueColor);
    g_opponentsTransColor  = Text::FormatOpenplanetColor(S_OpponentsTransColor);
    g_rallyColor           = Text::FormatOpenplanetColor(S_RallyColor);
    g_snowColor            = Text::FormatOpenplanetColor(S_SnowColor);

#endif
#if MP4

    // g_islandColor = Text::FormatOpenplanetColor(S_IslandColor);
    g_bayColor    = Text::FormatOpenplanetColor(S_BayColor);
    // g_coastColor  = Text::FormatOpenplanetColor(S_CoastColor);

#endif
#if MP4 || TURBO

    g_canyonColor = Text::FormatOpenplanetColor(S_CanyonColor);
    g_lagoonColor = Text::FormatOpenplanetColor(S_LagoonColor);
    g_turboColor  = Text::FormatOpenplanetColor(S_TurboColor);
    g_valleyColor = Text::FormatOpenplanetColor(S_ValleyColor);

#endif
}

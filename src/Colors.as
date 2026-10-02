namespace Color {
    const string DEBUG_OFF = "\\$f00";
    const string DEBUG_ON  = "\\$0f0";

#if TMNEXT
    string CruiseControl() {
        return g_state.cruiseControl ? g_cruiseColor : g_offColor;
    }
#endif

    string DebugBool(const bool b) {
        return (b ? DEBUG_ON : DEBUG_OFF) + b;
    }

    string DebugCamera(const CE::Camera c) {
        return (c != CE::Camera::Unknown ? DEBUG_ON : DEBUG_OFF) + tostring(c);
    }

    string DebugFloat(const double f) {
        return Text::Format((f != 0.0f ? DEBUG_ON : DEBUG_OFF) + "%.3f", f);
    }

    string DebugFormattedString(const string&in s) {
        return DEBUG_ON + Text::StripFormatCodes(s);
    }

    string DebugInt(const int64 i) {  // unlikely to get a uint64 that exceeds int64 max without being a pointer
        return (i != 0 ? DEBUG_ON : DEBUG_OFF) + i;
    }

    string DebugOpponentVis(const CE::OpponentVis o) {
        return (o > CE::OpponentVis::Off ? DEBUG_ON : DEBUG_OFF) + tostring(o);
    }

    string DebugPointer(const uint64 p) {
        return (p != 0x0 ? DEBUG_ON : DEBUG_OFF) + Text::FormatPointer(p);
    }

#if TMNEXT

    string DebugReactorLevel(const ESceneVehicleVisReactorBoostLvl l) {
        return (l != ESceneVehicleVisReactorBoostLvl::None ? DEBUG_ON : DEBUG_OFF) + tostring(l);
    }

    string DebugReactorType(const ESceneVehicleVisReactorBoostType t) {
        return (t != ESceneVehicleVisReactorBoostType::None ? DEBUG_ON : DEBUG_OFF) + tostring(t);
    }

#endif

    string DebugSequence(const CGamePlaygroundUIConfig::EUISequence s) {
        return (s != CGamePlaygroundUIConfig::EUISequence::None ? DEBUG_ON : DEBUG_OFF) + tostring(s);
    }

    string DebugString(const string&in s) {
        return DEBUG_ON + s;
    }

    string DebugVehicleType(const CE::VehicleType v) {
        return (v != CE::VehicleType::Unknown ? DEBUG_ON : DEBUG_OFF) + tostring(v);
    }

    string DebugViewMode(const CE::ViewMode v) {
        return (v != CE::ViewMode::Unknown ? DEBUG_ON : DEBUG_OFF) + tostring(v);
    }

#if TMNEXT || MP4
    string ForcedAccel() {
        return g_state.forcedAccel ? g_forcedColor : g_offColor;
    }
#endif

#if TMNEXT
    string Fragile() {
        return g_state.fragile ? g_fragileColor : g_offColor;
    }
#endif

#if TMNEXT || MP4
    string NoBrake() {
        return g_state.noBrake ? g_noBrakeColor : g_offColor;
    }
#endif

    string NoEngine() {
        return g_state.noEngine ? g_noEngineColor : g_offColor;
    }

#if TMNEXT || MP4
    string NoGrip() {
        return g_state.noGrip ? g_noGripColor : g_offColor;
    }
#endif

#if TMNEXT || MP4
    string NoSteer() {
        return g_state.noSteer ? g_noSteerColor : g_offColor;
    }
#endif

#if TMNEXT
    string Reactor() {
        switch (g_state.reactorLevel) {
            case ESceneVehicleVisReactorBoostLvl::Lvl1: return g_reactor1Color;
            case ESceneVehicleVisReactorBoostLvl::Lvl2: return g_reactor2Color;
            default:                                    return g_offColor;
        }
    }
#endif

    void SetStrings() {
        g_offColor      = Text::FormatOpenplanetColor(S_OffColor);
        g_noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);
#if TMNEXT
        g_cruiseColor   = Text::FormatOpenplanetColor(S_CruiseColor);
        g_fragileColor  = Text::FormatOpenplanetColor(S_FragileColor);
        g_reactor1Color = Text::FormatOpenplanetColor(S_Reactor1Color);
        g_reactor2Color = Text::FormatOpenplanetColor(S_Reactor2Color);
        g_slowMo1Color  = Text::FormatOpenplanetColor(S_SlowMo1Color);
        g_slowMo2Color  = Text::FormatOpenplanetColor(S_SlowMo2Color);
        g_slowMo3Color  = Text::FormatOpenplanetColor(S_SlowMo3Color);
        g_slowMo4Color  = Text::FormatOpenplanetColor(S_SlowMo4Color);
        g_turbo1Color   = Text::FormatOpenplanetColor(S_Turbo1Color);
        g_turbo2Color   = Text::FormatOpenplanetColor(S_Turbo2Color);
        g_turbo3Color   = Text::FormatOpenplanetColor(S_Turbo3Color);
        g_turbo4Color   = Text::FormatOpenplanetColor(S_Turbo4Color);
        g_turbo5Color   = Text::FormatOpenplanetColor(S_Turbo5Color);
#endif
#if TMNEXT || MP4
        g_desertColor   = Text::FormatOpenplanetColor(S_DesertColor);
        g_forcedColor   = Text::FormatOpenplanetColor(S_ForcedColor);
        g_noBrakeColor  = Text::FormatOpenplanetColor(S_NoBrakesColor);
        g_noGripColor   = Text::FormatOpenplanetColor(S_NoGripColor);
        g_noSteerColor  = Text::FormatOpenplanetColor(S_NoSteerColor);
        g_rallyColor    = Text::FormatOpenplanetColor(S_RallyColor);
        g_snowColor     = Text::FormatOpenplanetColor(S_SnowColor);
#endif
#if MP4
        // g_islandColor   = Text::FormatOpenplanetColor(S_IslandColor);
        g_bayColor      = Text::FormatOpenplanetColor(S_BayColor);
        // g_coastColor    = Text::FormatOpenplanetColor(S_CoastColor);
#endif
#if MP4 || TURBO
        g_canyonColor    = Text::FormatOpenplanetColor(S_CanyonColor);
        g_lagoonColor    = Text::FormatOpenplanetColor(S_LagoonColor);
        g_turboColor     = Text::FormatOpenplanetColor(S_TurboColor);
        g_valleyColor    = Text::FormatOpenplanetColor(S_ValleyColor);
#endif
    }

#if TMNEXT
    string SlowMo() {
        switch (g_state.slowMoLevel) {
            case 1:  return g_slowMo1Color;
            case 2:  return g_slowMo2Color;
            case 3:  return g_slowMo3Color;
            case 4:  return g_slowMo4Color;
            default: return g_offColor;
        }
    }
#endif

    string Turbo() {
        if (!g_state.turbo) {
            return g_offColor;
        }

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
        return g_turboColor;
#endif
    }
}

// c 2023-10-21
// m 2024-05-21

int64 lastAllColorsSwap = 0;

#if TMNEXT
string GetCruiseColor() {
    switch (state.CruiseControl) {
        case -1: return disabledColor;
        case  1: return cruiseColor;
        default: return offColor;
    }
}
#endif

#if TMNEXT || MP4
string GetForcedColor() {
    switch (state.ForcedAccel) {
        case -1: return disabledColor;
        case  1: return forcedColor;
        default: return offColor;
    }
}
#endif

#if TMNEXT
string GetFragileColor() {
    switch (state.Fragile) {
        case -1: return disabledColor;
        case  1: return fragileColor;
        default: return offColor;
    }
}
#endif
#if TMNEXT || MP4
string GetNoBrakesColor() {
    switch (state.NoBrakes) {
        case -1: return disabledColor;
        case  1: return noBrakesColor;
        default: return offColor;
    }
}
#endif

string GetNoEngineColor() {
    switch (state.NoEngine) {
        case -1: return disabledColor;
        case  1: return noEngineColor;
        default: return offColor;
    }
}

#if TMNEXT || MP4
string GetNoGripColor() {
    switch (state.NoGrip) {
        case -1: return disabledColor;
        case  1: return noGripColor;
        default: return offColor;
    }
}

string GetNoSteerColor() {
    switch (state.NoSteer) {
        case -1: return disabledColor;
        case  1: return noSteerColor;
        default: return offColor;
    }
}
#endif
#if TMNEXT
string GetPenaltyColor() {
    switch (state.AccelPenalty) {
        case -1: return disabledColor;
        case  1: return penaltyColor;
        default: return offColor;
    }
}

string GetReactorColor() {
    switch (state.ReactorBoostLevel) {
        case -1: return disabledColor;
        case  1: return reactor1Color;
        case  2: return reactor2Color;
        default: return offColor;
    }
}

string GetSlowMoColor() {
    switch (state.SlowMoLevel) {
        case -1: return disabledColor;
        case  1: return slowMo1Color;
        case  2: return slowMo2Color;
        case  3: return slowMo3Color;
        case  4: return slowMo4Color;
        default: return offColor;
    }
}

string GetTurboColor() {
    switch (state.TurboLevel) {
        case -1: return disabledColor;
        case  1: return turbo1Color;
        case  2: return turbo2Color;
        case  3: return turbo3Color;
        case  4: return turbo4Color;
        case  5: return turbo5Color;
        default: return offColor;
    }
}

string GetVehicleColor() {
    switch (state.Vehicle) {
        case -1: return disabledColor;
        case  1: return snowColor;
        case  2: return rallyColor;
        case  3: return desertColor;
        default: return offColor;
    }
}

#else
string GetTurboColor() {
    switch (state.TurboLevel) {
        case  1: return turboColor;
        default: return offColor;
    }
}
#endif

void SetColors() {
    offColor      = Text::FormatOpenplanetColor(S_OffColor);
#if TMNEXT || MP4
    forcedColor   = Text::FormatOpenplanetColor(S_ForcedColor);
    noBrakesColor = Text::FormatOpenplanetColor(S_NoBrakesColor);
#endif
    noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);
#if TMNEXT || MP4
    noGripColor   = Text::FormatOpenplanetColor(S_NoGripColor);
    noSteerColor  = Text::FormatOpenplanetColor(S_NoSteerColor);
#endif
#if TMNEXT
    // desertColor   = Text::FormatOpenplanetColor(S_DesertColor);
    disabledColor = Text::FormatOpenplanetColor(S_DisabledColor);
    cruiseColor   = Text::FormatOpenplanetColor(S_CruiseColor);
    fragileColor  = Text::FormatOpenplanetColor(S_FragileColor);
    penaltyColor  = Text::FormatOpenplanetColor(S_PenaltyColor);
    rallyColor    = Text::FormatOpenplanetColor(S_RallyColor);
    reactor1Color = Text::FormatOpenplanetColor(S_Reactor1Color);
    reactor2Color = Text::FormatOpenplanetColor(S_Reactor2Color);
    slowMo1Color  = Text::FormatOpenplanetColor(S_SlowMo1Color);
    slowMo2Color  = Text::FormatOpenplanetColor(S_SlowMo2Color);
    slowMo3Color  = Text::FormatOpenplanetColor(S_SlowMo3Color);
    slowMo4Color  = Text::FormatOpenplanetColor(S_SlowMo4Color);
    snowColor     = Text::FormatOpenplanetColor(S_SnowColor);
    turbo1Color   = Text::FormatOpenplanetColor(S_Turbo1Color);
    turbo2Color   = Text::FormatOpenplanetColor(S_Turbo2Color);
    turbo3Color   = Text::FormatOpenplanetColor(S_Turbo3Color);
    turbo4Color   = Text::FormatOpenplanetColor(S_Turbo4Color);
    turbo5Color   = Text::FormatOpenplanetColor(S_Turbo5Color);

#else
    turboColor = Text::FormatOpenplanetColor(S_TurboColor);
#endif

}

void ShowAllColors(const bool shouldHide) {
    if (shouldHide)
        return;

    state.AccelPenalty = CurrentEffects::ActiveState::Active;
    state.ForcedAccel  = CurrentEffects::ActiveState::Active;
    state.NoBrakes     = CurrentEffects::ActiveState::Active;
    state.NoEngine     = CurrentEffects::ActiveState::Active;
    state.NoGrip       = CurrentEffects::ActiveState::Active;
    state.NoSteer      = CurrentEffects::ActiveState::Active;

#if TMNEXT
    state.CruiseControl = CurrentEffects::ActiveState::Active;
    state.Fragile       = CurrentEffects::ActiveState::Active;

    int64 now = Time::Stamp;

    if (now - lastAllColorsSwap >= 2) {
        lastAllColorsSwap = now;

        switch (state.ReactorBoostLevel) {
            case 0:
            case 2:  state.ReactorBoostLevel = ESceneVehicleVisReactorBoostLvl::Lvl1; break;
            default: state.ReactorBoostLevel = ESceneVehicleVisReactorBoostLvl::Lvl2;
        }

        reactorIcon = (reactorIcon == Icons::ChevronDown) ? Icons::ChevronUp : Icons::ChevronDown;

        switch (state.SlowMoLevel) {
            case 0:
            case 4:  state.SlowMoLevel = 1; break;
            case 1:  state.SlowMoLevel = 2; break;
            case 2:  state.SlowMoLevel = 3; break;
            default: state.SlowMoLevel = 4;
        }

        switch (state.TurboLevel) {
            case 0:
            case 5:  state.TurboLevel = 1; break;
            case 1:  state.TurboLevel = 2; break;
            case 2:  state.TurboLevel = 3; break;
            case 3:  state.TurboLevel = 4; break;
            default: state.TurboLevel = 5;
        }

        switch (state.Vehicle) {
            case 0:
            case 2:  state.Vehicle = 1; break;
            case 1:  state.Vehicle = 2; break;
            default: state.Vehicle = 0;
        }
    }

#else
    state.TurboLevel = 1;
#endif
}

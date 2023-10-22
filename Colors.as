/*
c 2023-10-21
m 2023-10-22
*/

int64 lastAllColorsSwap = 0;

string GetCruiseColor() {
    switch (cruise) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return cruiseColor;
    }
}

string GetForcedColor() {
    switch (forced) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return forcedColor;
    }
}

string GetFragileColor() {
    switch (fragile) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return fragileColor;
    }
}

string GetNoBrakesColor() {
    switch (noBrakes) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return noBrakesColor;
    }
}

string GetNoEngineColor() {
    switch (noEngine) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return noEngineColor;
    }
}

string GetNoGripColor() {
    switch (noGrip) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return noGripColor;
    }
}

string GetNoSteerColor() {
    switch (noSteer) {
        case -1: return disabledColor;
        case  0: return offColor;
        default: return noSteerColor;
    }
}

string GetReactorColor() {
    switch (reactor) {
        case -1: return disabledColor;
        case  0: return offColor;
        case  1: return reactor1Color;
        default: return reactor2Color;
    }
}

string GetSlowMoColor() {
    switch (slowmo) {
        case -1: return disabledColor;
        case  0: return offColor;
        case  1: return slowMo1Color;
        case  2: return slowMo2Color;
        case  3: return slowMo3Color;
        default: return slowMo4Color;
    }
}

string GetTurboColor() {
    switch (turbo) {
        case -1: return disabledColor;
        case  0: return offColor;

#if TMNEXT

        case  1: return turbo1Color;
        case  2: return turbo2Color;
        case  3: return turbo3Color;
        case  4: return turbo4Color;
        default: return turbo5Color;

#elif MP4

        default: return turboColor;

#endif
    }
}

void SetColors() {
    disabledColor = Text::FormatOpenplanetColor(S_DisabledColor);
    offColor      = Text::FormatOpenplanetColor(S_OffColor);

    forcedColor   = Text::FormatOpenplanetColor(S_ForcedColor);
    noBrakesColor = Text::FormatOpenplanetColor(S_NoBrakesColor);
    noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);
    noGripColor   = Text::FormatOpenplanetColor(S_NoGripColor);
    noSteerColor  = Text::FormatOpenplanetColor(S_NoSteerColor);

#if TMNEXT

    cruiseColor   = Text::FormatOpenplanetColor(S_CruiseColor);
    fragileColor  = Text::FormatOpenplanetColor(S_FragileColor);
    reactor1Color = Text::FormatOpenplanetColor(S_Reactor1Color);
    reactor2Color = Text::FormatOpenplanetColor(S_Reactor2Color);
    slowMo1Color  = Text::FormatOpenplanetColor(S_SlowMo1Color);
    slowMo2Color  = Text::FormatOpenplanetColor(S_SlowMo2Color);
    slowMo3Color  = Text::FormatOpenplanetColor(S_SlowMo3Color);
    slowMo4Color  = Text::FormatOpenplanetColor(S_SlowMo4Color);
    turbo1Color   = Text::FormatOpenplanetColor(S_Turbo1Color);
    turbo2Color   = Text::FormatOpenplanetColor(S_Turbo2Color);
    turbo3Color   = Text::FormatOpenplanetColor(S_Turbo3Color);
    turbo4Color   = Text::FormatOpenplanetColor(S_Turbo4Color);
    turbo5Color   = Text::FormatOpenplanetColor(S_Turbo5Color);

#elif MP4

    turboColor = Text::FormatOpenplanetColor(S_TurboColor);

#endif
}

void ShowAllColors() {
    forced   = 1;
    noBrakes = 1;
    noEngine = 1;
    noGrip   = 1;
    noSteer  = 1;

#if TMNEXT

    cruise = 1;
    fragile = 1;

    int64 now = Time::Stamp;

    if (now - lastAllColorsSwap >= 2) {
        lastAllColorsSwap = now;

        switch (reactor) {
            case 0:
            case 2:  reactor = 1; break;
            default: reactor = 2;
        }

        reactorIcon = (reactorIcon == Icons::ChevronDown) ? Icons::ChevronUp : Icons::ChevronDown;

        switch (slowmo) {
            case 0:
            case 4:  slowmo = 1; break;
            case 1:  slowmo = 2; break;
            case 2:  slowmo = 3; break;
            default: slowmo = 4;
        }

        switch (turbo) {
            case 0:
            case 5:  turbo = 1; break;
            case 1:  turbo = 2; break;
            case 2:  turbo = 3; break;
            case 3:  turbo = 4; break;
            default: turbo = 5;
        }
    }

#elif MP4

    turbo = 1;

#endif
}
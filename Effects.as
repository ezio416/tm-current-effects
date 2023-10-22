/*
c 2023-08-17
m 2023-10-22
*/

int    cruise   = 0;
int    forced   = 0;
int    fragile  = 0;
int    noBrakes = 0;
int    noEngine = 0;
int    noGrip   = 0;
int    noSteer  = 0;
int    reactor  = 0;
string reactorIcon;
int    slowmo   = 0;
int    turbo    = 0;

void RenderEffects(CSceneVehicleVisState@ state) {
    if (!S_ShowAll) {
        if (S_Reset) {
            ResetEventEffects();
            S_Reset = false;
        }

        SetHandicaps(GetHandicapSum(state));

#if TMNEXT

        reactor = int(state.ReactorBoostLvl);

        switch (int(state.ReactorBoostType)) {
            case 1:  reactorIcon = Icons::ChevronUp;   break;
            case 2:  reactorIcon = Icons::ChevronDown; break;
            default: reactorIcon = Icons::Rocket;
        }

        switch (int(state.SimulationTimeCoef * 100)) {
            case 100: slowmo = 0; break;
            case 56:
            case 57:  slowmo = 1; break;
            case 32:  slowmo = 2; break;
            case 18:  slowmo = 3; break;
            default:  slowmo = 4;
        }

        turbo = 0;
        if (state.IsTurbo)
            turbo = int(VehicleState::GetLastTurboLevel(state));

        if (replay) {
            cruise   = -1;
            forced   = -1;
            fragile  = -1;
            noBrakes = -1;
            noEngine = -1;
            noGrip   = -1;
            noSteer  = -1;
        } else if (spectating) {
            cruise   = -1;
            fragile  = -1;
            turbo    = -1;
        } else if (!S_Experimental) {
            cruise   = -1;
            fragile  = -1;
        }

#elif MP4

        turbo = state.TurboActive ? 1 : 0;

#endif

    } else
        ShowAllColors();

    int flags = UI::WindowFlags::AlwaysAutoResize |
                UI::WindowFlags::NoCollapse |
                UI::WindowFlags::NoTitleBar;

    if (!UI::IsOverlayShown())
        flags |= UI::WindowFlags::NoInputs;

    UI::PushFont(font);
    UI::Begin("Current Effects", flags);

#if TMNEXT

        if (S_Cruise)   UI::Text(GetCruiseColor() + Icons::Tachometer + iconPadding + "Cruise Control");
        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff + iconPadding + "Engine Off");
        if (S_Forced)   UI::Text(GetForcedColor() + Icons::Forward + iconPadding + "Forced Accel");
        if (S_Fragile)  UI::Text(GetFragileColor() + Icons::ChainBroken + iconPadding + "Fragile");

#elif MP4

        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff + iconPadding + "Free Wheeling");
        if (S_Forced)   UI::Text(GetForcedColor() + Icons::Forward + iconPadding + "Fullspeed Ahead");

#endif

        if (S_NoBrakes) UI::Text(GetNoBrakesColor() + Icons::ExclamationTriangle + iconPadding + "No Brakes");
        if (S_NoGrip)   UI::Text(GetNoGripColor() + Icons::SnowflakeO + iconPadding + "No Grip");
        if (S_NoSteer)  UI::Text(GetNoSteerColor() + Icons::ArrowsH + iconPadding + "No Steering");

#if TMNEXT

        if (S_Reactor)  UI::Text(GetReactorText(VehicleState::GetReactorFinalTimer(state)));
        if (S_SlowMo)   UI::Text(GetSlowMoColor() + Icons::ClockO + iconPadding + "Slow-Mo");
        if (S_Turbo)    UI::Text(GetTurboText(state.TurboTime));

#elif MP4

        if (S_Turbo)    UI::Text(GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo");

#endif

    UI::End();
    UI::PopFont();
}

string GetReactorText(float f) {
    if (f == 0)   return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boost";
    if (f < 0.09) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boos" + offColor + "t";
    if (f < 0.17) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boo" + offColor + "st";
    if (f < 0.25) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Bo" + offColor + "ost";
    if (f < 0.33) return GetReactorColor() + reactorIcon + iconPadding + "Reactor B" + offColor + "oost";
    if (f < 0.41) return GetReactorColor() + reactorIcon + iconPadding + "Reactor " + offColor + "Boost";
    if (f < 0.49) return GetReactorColor() + reactorIcon + iconPadding + "Reacto" + offColor + "r Boost";
    if (f < 0.57) return GetReactorColor() + reactorIcon + iconPadding + "React" + offColor + "or Boost";
    if (f < 0.65) return GetReactorColor() + reactorIcon + iconPadding + "Reac" + offColor + "tor Boost";
    if (f < 0.73) return GetReactorColor() + reactorIcon + iconPadding + "Rea" + offColor + "ctor Boost";
    if (f < 0.81) return GetReactorColor() + reactorIcon + iconPadding + "Re" + offColor + "actor Boost";
    if (f < 0.89) return GetReactorColor() + reactorIcon + iconPadding + "R" + offColor + "eactor Boost";
    return GetReactorColor() + reactorIcon + offColor + iconPadding + "Reactor Boost";
}

string GetTurboText(float f) {
    if (f == 0)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo";
    if (f < 0.2) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turb" + offColor + "o";
    if (f < 0.4) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tur" + offColor + "bo";
    if (f < 0.6) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tu" + offColor + "rbo";
    if (f < 0.8) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "T" + offColor + "urbo";
    return GetTurboColor() + Icons::ArrowCircleUp + offColor + iconPadding + "Turbo";
}
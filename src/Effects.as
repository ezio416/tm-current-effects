// c 2023-08-17
// m 2024-02-26

int    cruise       = 0;
int    forced       = 0;
int    fragile      = 0;
int    noBrakes     = 0;
int    noEngine     = 0;
int    noGrip       = 0;
int    noSteer      = 0;
int    penalty      = 0;
int    reactor      = 0;
string reactorIcon;
int    reactorLevel = 0;
float  reactorTimer = 0.0f;
int    reactorType  = 0;
int    slowmo       = 0;
int    turbo        = 0;
int    vehicle      = 0;

void RenderEffects(CSceneVehicleVisState@ State) {
    if (!S_ShowAll) {
        SetHandicaps(GetHandicapFlags(State));

#if TMNEXT
        if (S_Reset) {
            S_Reset = false;
            ResetEventEffects();
        }

        cruise = GetCruiseSpeed(State) != 0 ? 1 : 0;

        penalty = S_Experimental && (GetSparks1(State) > 0 || GetSparks2(State) > 0 || GetSparks3(State) > 0) ? 1 : 0;

        reactorLevel = State.ReactorBoostLvl;
        reactor = int(reactorLevel);

        reactorType = State.ReactorBoostType;
        switch (int(reactorType)) {
            case 1:  reactorIcon = Icons::ChevronUp;   break;
            case 2:  reactorIcon = Icons::ChevronDown; break;
            default: reactorIcon = Icons::Rocket;
        }

        reactorTimer = VehicleState::GetReactorFinalTimer(State);

        switch (int(State.SimulationTimeCoef * 100.0f)) {
            case 100: slowmo = 0; break;
            case 56:
            case 57:  slowmo = 1; break;
            case 32:  slowmo = 2; break;
            case 18:  slowmo = 3; break;
            default:  slowmo = 4;
        }

        vehicle = GetVehicleType(State);

        turbo = 0;
        if (State.IsTurbo)
            turbo = int(VehicleState::GetLastTurboLevel(State));

        if (replay) {
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
            fragile  = -1;
            penalty  = -1;
        }

#elif MP4
        turbo = State.TurboActive ? 1 : 0;
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
        if (S_Penalty)  UI::Text(GetPenaltyColor()  + Icons::Times       + iconPadding + "Accel Penalty");
        if (S_Cruise)   UI::Text(GetCruiseColor()   + Icons::Tachometer  + iconPadding + "Cruise Control");
        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff    + iconPadding + "Engine Off");
        if (S_Forced)   UI::Text(GetForcedColor()   + Icons::Forward     + iconPadding + "Forced Accel");
        if (S_Fragile)  UI::Text(GetFragileColor()  + Icons::ChainBroken + iconPadding + "Fragile");

#elif MP4
        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff + iconPadding + "Free Wheeling");
        if (S_Forced)   UI::Text(GetForcedColor()   + Icons::Forward  + iconPadding + "Fullspeed Ahead");
#endif

        if (S_NoBrakes) UI::Text(GetNoBrakesColor() + Icons::ExclamationTriangle + iconPadding + "No Brakes");
        if (S_NoGrip)   UI::Text(GetNoGripColor()   + Icons::SnowflakeO          + iconPadding + "No Grip");
        if (S_NoSteer)  UI::Text(GetNoSteerColor()  + Icons::ArrowsH             + iconPadding + "No Steering");

#if TMNEXT
        if (S_Reactor)  UI::Text(GetReactorText(reactorTimer));
        if (S_SlowMo)   UI::Text(GetSlowMoColor() + Icons::ClockO + iconPadding + "Slow-Mo");
        if (S_Turbo)    UI::Text(GetTurboText(State.TurboTime));
        if (S_Vehicle)  UI::Text(GetVehicleText());

#elif MP4
        if (S_Turbo)    UI::Text(GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo");
#endif

    UI::End();
    UI::PopFont();
}

#if TMNEXT

string GetReactorText(float f) {
    if (f == 0.0f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boost";
    if (f < 0.09f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boos" + offColor + "t";
    if (f < 0.17f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Boo" + offColor + "st";
    if (f < 0.25f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor Bo" + offColor + "ost";
    if (f < 0.33f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor B" + offColor + "oost";
    if (f < 0.41f) return GetReactorColor() + reactorIcon + iconPadding + "Reactor " + offColor + "Boost";
    if (f < 0.49f) return GetReactorColor() + reactorIcon + iconPadding + "Reacto" + offColor + "r Boost";
    if (f < 0.57f) return GetReactorColor() + reactorIcon + iconPadding + "React" + offColor + "or Boost";
    if (f < 0.65f) return GetReactorColor() + reactorIcon + iconPadding + "Reac" + offColor + "tor Boost";
    if (f < 0.73f) return GetReactorColor() + reactorIcon + iconPadding + "Rea" + offColor + "ctor Boost";
    if (f < 0.81f) return GetReactorColor() + reactorIcon + iconPadding + "Re" + offColor + "actor Boost";
    if (f < 0.89f) return GetReactorColor() + reactorIcon + iconPadding + "R" + offColor + "eactor Boost";
    return GetReactorColor() + reactorIcon + offColor + iconPadding + "Reactor Boost";
}

string GetTurboText(float f) {
    if (f == 0.0f) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo";
    if (f < 0.2f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turb" + offColor + "o";
    if (f < 0.4f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tur" + offColor + "bo";
    if (f < 0.6f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tu" + offColor + "rbo";
    if (f < 0.8f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "T" + offColor + "urbo";
    return GetTurboColor() + Icons::ArrowCircleUp + offColor + iconPadding + "Turbo";
}

string GetVehicleText() {
    switch (vehicle) {
        case 1:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Snow Car";
        case 2:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Rally Car";
        // case 3:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Desert Car";
        default: return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Stadium Car";
    }
}

#elif MP4

int GetHandicapFlags(CSceneVehicleVisState@ State) {
    return int(State.ActiveEffects);
}

#endif

void ResetAllEffects() {
    cruise       = 0;
    forced       = 0;
    fragile      = 0;
    noBrakes     = 0;
    noEngine     = 0;
    noGrip       = 0;
    noSteer      = 0;
    penalty      = 0;
    reactor      = 0;
    reactorLevel = 0;
    reactorTimer = 0.0f;
    reactorType  = 0;
    slowmo       = 0;
    turbo        = 0;
    vehicle      = 0;
}

void SetHandicaps(int flags) {

#if TMNEXT
    noEngine = (flags & 0x100  == 0x100)  ? 1 : 0;
    forced   = (flags & 0x200  == 0x200)  ? 1 : 0;
    noBrakes = (flags & 0x400  == 0x400)  ? 1 : 0;
    noSteer  = (flags & 0x800  == 0x800)  ? 1 : 0;
    noGrip   = (flags & 0x1000 == 0x1000) ? 1 : 0;

#elif MP4
    noEngine = (flags & 0x1  == 0x1)  ? 1 : 0;
    forced   = (flags & 0x2  == 0x2)  ? 1 : 0;
    noBrakes = (flags & 0x4  == 0x4)  ? 1 : 0;
    noSteer  = (flags & 0x8  == 0x8)  ? 1 : 0;
    noGrip   = (flags & 0x10 == 0x10) ? 1 : 0;
#endif
}
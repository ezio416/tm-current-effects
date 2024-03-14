// c 2023-08-17
// m 2024-03-13

string reactorIcon;

void RenderEffects(CSceneVehicleVisState@ VisState, const bool shouldHide) {
    if (!S_ShowAll) {
#if TURBO
        if (VisState.m_vis is null)
            return;

        state.NoEngine = CurrentEffects::ActiveState(Dev::GetOffsetUint8(VisState.m_vis, 440));
        state.TurboLevel = Dev::GetOffsetUint8(VisState.m_vis, 416);
#else
        SetHandicaps(GetHandicapFlags(VisState));

#if TMNEXT
        if (S_Reset) {
            S_Reset = false;
            ResetEventEffects();
        }

        state.CruiseControl = CurrentEffects::ActiveState(GetCruiseSpeed(VisState) != 0 ? 1 : 0);

        state.AccelPenalty = CurrentEffects::ActiveState(S_Experimental && (GetSparks1(VisState) > 0 || GetSparks2(VisState) > 0 || GetSparks3(VisState) > 0) ? 1 : 0);

        state.ReactorBoostLevel = VisState.ReactorBoostLvl;

        state.ReactorBoostType = VisState.ReactorBoostType;
        switch (state.ReactorBoostType) {
            case 1:  reactorIcon = Icons::ChevronUp;   break;
            case 2:  reactorIcon = Icons::ChevronDown; break;
            default: reactorIcon = Icons::Rocket;
        }

        state.ReactorBoostFinalTimer = VehicleState::GetReactorFinalTimer(VisState);

        switch (int(VisState.SimulationTimeCoef * 100.0f)) {
            case 100: state.SlowMoLevel = 0; break;
            case 56:
            case 57:  state.SlowMoLevel = 1; break;
            case 32:  state.SlowMoLevel = 2; break;
            case 18:  state.SlowMoLevel = 3; break;
            default:  state.SlowMoLevel = 4;
        }

        state.Vehicle = GetVehicleType(VisState);

        state.TurboLevel = 0;
        if (VisState.IsTurbo)
            state.TurboLevel = int(VehicleState::GetLastTurboLevel(VisState));

        if (state.WatchingReplay) {
            state.AccelPenalty = CurrentEffects::ActiveState::Disabled;
            state.ForcedAccel  = CurrentEffects::ActiveState::Disabled;
            state.Fragile      = CurrentEffects::ActiveState::Disabled;
            state.NoBrakes     = CurrentEffects::ActiveState::Disabled;
            state.NoEngine     = CurrentEffects::ActiveState::Disabled;
            state.NoGrip       = CurrentEffects::ActiveState::Disabled;
            state.NoSteer      = CurrentEffects::ActiveState::Disabled;
        } else if (state.Spectating) {
            state.AccelPenalty  = CurrentEffects::ActiveState::Disabled;
            state.CruiseControl = CurrentEffects::ActiveState::Disabled;
            state.Fragile       = CurrentEffects::ActiveState::Disabled;
            state.TurboLevel    = CurrentEffects::ActiveState::Disabled;
        } else if (!S_Experimental) {
            state.AccelPenalty = CurrentEffects::ActiveState::Disabled;
            state.Fragile      = CurrentEffects::ActiveState::Disabled;
        }

        state.TurboTime = VisState.TurboTime;

#elif MP4
        state.TurboLevel = VisState.TurboActive ? 1 : 0;
#endif
#endif

    } else
        ShowAllColors(shouldHide);

    if (shouldHide)
        return;

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
#endif
#if TMNEXT || TURBO
        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff    + iconPadding + "Engine Off");
#endif
#if TMNEXT
        if (S_Forced)   UI::Text(GetForcedColor()   + Icons::Forward     + iconPadding + "Forced Accel");
        if (S_Fragile)  UI::Text(GetFragileColor()  + Icons::ChainBroken + iconPadding + "Fragile");
#elif MP4
        if (S_NoEngine) UI::Text(GetNoEngineColor() + Icons::PowerOff + iconPadding + "Free Wheeling");
        if (S_Forced)   UI::Text(GetForcedColor()   + Icons::Forward  + iconPadding + "Fullspeed Ahead");
#endif
#if TMNEXT || MP4
        if (S_NoBrakes) UI::Text(GetNoBrakesColor() + Icons::ExclamationTriangle + iconPadding + "No Brakes");
        if (S_NoGrip)   UI::Text(GetNoGripColor()   + Icons::SnowflakeO          + iconPadding + "No Grip");
        if (S_NoSteer)  UI::Text(GetNoSteerColor()  + Icons::ArrowsH             + iconPadding + "No Steering");
#endif
#if TMNEXT
        if (S_Reactor)  UI::Text(GetReactorText(state.ReactorBoostFinalTimer));
        if (S_SlowMo)   UI::Text(GetSlowMoColor() + Icons::ClockO + iconPadding + "Slow-Mo");
        if (S_Turbo)    UI::Text(GetTurboText(state.TurboTime));
        if (S_Vehicle)  UI::Text(GetVehicleText());
#else
        if (S_Turbo)    UI::Text(GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo");
#endif

    UI::End();
    UI::PopFont();
}

#if TMNEXT

string GetReactorText(const float f) {
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

string GetTurboText(const float f) {
    if (f == 0.0f) return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turbo";
    if (f < 0.2f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Turb" + offColor + "o";
    if (f < 0.4f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tur" + offColor + "bo";
    if (f < 0.6f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "Tu" + offColor + "rbo";
    if (f < 0.8f)  return GetTurboColor() + Icons::ArrowCircleUp + iconPadding + "T" + offColor + "urbo";
    return GetTurboColor() + Icons::ArrowCircleUp + offColor + iconPadding + "Turbo";
}

string GetVehicleText() {
    switch (state.Vehicle) {
        case 1:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Snow Car";
        case 2:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Rally Car";
        // case 3:  return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Desert Car";
        default: return GetVehicleColor() + Icons::Kenney::Car + iconPadding + "Stadium Car";
    }
}

#elif MP4

int GetHandicapFlags(CSceneVehicleVisState@ VisState) {
    return int(VisState.ActiveEffects);
}

#endif

void ResetAllEffects() {
    state.AccelPenalty           = CurrentEffects::ActiveState::NotActive;
    state.CruiseControl          = CurrentEffects::ActiveState::NotActive;
    state.ForcedAccel            = CurrentEffects::ActiveState::NotActive;
    state.Fragile                = CurrentEffects::ActiveState::NotActive;
    state.NoBrakes               = CurrentEffects::ActiveState::NotActive;
    state.NoEngine               = CurrentEffects::ActiveState::NotActive;
    state.NoGrip                 = CurrentEffects::ActiveState::NotActive;
    state.NoSteer                = CurrentEffects::ActiveState::NotActive;

#if TMNEXT
    state.ReactorBoostLevel      = ESceneVehicleVisReactorBoostLvl::None;
    state.ReactorBoostFinalTimer = 0.0f;
    state.ReactorBoostType       = ESceneVehicleVisReactorBoostType::None;
    state.SlowMoLevel            = 0;
#endif

    state.Spectating             = false;
    state.TurboLevel             = 0;
    state.TurboTime              = 0.0f;
    state.Vehicle                = 0;
    state.WatchingReplay         = false;
}

void SetHandicaps(const int flags) {

#if TMNEXT
    state.NoEngine    = CurrentEffects::ActiveState((flags & 0x100  == 0x100)  ? 1 : 0);
    state.ForcedAccel = CurrentEffects::ActiveState((flags & 0x200  == 0x200)  ? 1 : 0);
    state.NoBrakes    = CurrentEffects::ActiveState((flags & 0x400  == 0x400)  ? 1 : 0);
    state.NoSteer     = CurrentEffects::ActiveState((flags & 0x800  == 0x800)  ? 1 : 0);
    state.NoGrip      = CurrentEffects::ActiveState((flags & 0x1000 == 0x1000) ? 1 : 0);

#elif MP4
    state.NoEngine    = CurrentEffects::ActiveState((flags & 0x1  == 0x1)  ? 1 : 0);
    state.ForcedAccel = CurrentEffects::ActiveState((flags & 0x2  == 0x2)  ? 1 : 0);
    state.NoBrakes    = CurrentEffects::ActiveState((flags & 0x4  == 0x4)  ? 1 : 0);
    state.NoSteer     = CurrentEffects::ActiveState((flags & 0x8  == 0x8)  ? 1 : 0);
    state.NoGrip      = CurrentEffects::ActiveState((flags & 0x10 == 0x10) ? 1 : 0);
#endif
}
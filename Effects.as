/*
c 2023-08-17
m 2023-10-02
*/

const string BLUE    = "\\$09D";
const string CYAN    = "\\$2FF";
const string DGRAY   = "\\$444";
const string GRAY    = "\\$888";
const string GREEN   = "\\$0D2";
const string ORANGE  = "\\$F90";
const string PURPLE  = "\\$F0F";
const string RED     = "\\$F00";
const string WHITE   = "\\$FFF";
const string YELLOW  = "\\$FF0";
string DefaultColor  = GRAY;
string DisabledColor = DGRAY;

string PenaltyColor = DefaultColor;
string CruiseColor = DefaultColor;
string NoEngineColor;
string ForcedColor;
string FragileColor = DefaultColor;
string NoBrakesColor;
string NoGripColor;
string NoSteerColor;
string ReactorColor;
string ReactorIcon;
string SlowMoColor;
string TurboColor;

void RenderEffects(CSceneVehicleVisState@ state) {
    SetHandicaps(GetHandicapSum(state));

    switch (uint(state.ReactorBoostLvl)) {
        case 1:  ReactorColor = YELLOW; break;
        case 2:  ReactorColor = RED;    break;
        default: ReactorColor = DefaultColor;
    }
    switch (uint(state.ReactorBoostType)) {
        case 1:  ReactorIcon = Icons::ChevronUp;   break;
        case 2:  ReactorIcon = Icons::ChevronDown; break;
        default: ReactorIcon = Icons::Rocket;
    }

    switch (uint(state.SimulationTimeCoef * 100)) {
        case 100:         SlowMoColor = DefaultColor; break;
        case 56: case 57: SlowMoColor = GREEN;        break;
        case 32:          SlowMoColor = YELLOW;       break;
        case 18:          SlowMoColor = ORANGE;       break;
        default:          SlowMoColor = RED;
    }

    TurboColor = DefaultColor;
    if (state.IsTurbo) {
        switch (VehicleState::GetLastTurboLevel(state)) {
            case 1: TurboColor = YELLOW; break;
            case 2: TurboColor = RED;    break;
            case 3: TurboColor = YELLOW; break;  // roulette 1
            case 4: TurboColor = CYAN;   break;  // roulette 2
            case 5: TurboColor = PURPLE; break;  // roulette 3
            default:                     break;
        }
    }

    if (replay) {
        CruiseColor   = DisabledColor;
        NoEngineColor = DisabledColor;
        ForcedColor   = DisabledColor;
        FragileColor  = DisabledColor;
        NoBrakesColor = DisabledColor;
        NoGripColor   = DisabledColor;
        NoSteerColor  = DisabledColor;
    }

    if (spectating) {
        CruiseColor  = DisabledColor;
        FragileColor = DisabledColor;
        TurboColor   = DisabledColor;
    }

    int flags = UI::WindowFlags::AlwaysAutoResize |
                UI::WindowFlags::NoCollapse |
                UI::WindowFlags::NoTitleBar;

    if (!UI::IsOverlayShown())
        flags |= UI::WindowFlags::NoInputs;

    UI::PushFont(font);
    UI::Begin("Current Effects", flags);
        if (S_Penalty)  UI::Text(PenaltyColor  + Icons::Times               + iconPadding + "Accel Penalty");
        if (S_Cruise)   UI::Text(CruiseColor   + Icons::Tachometer          + iconPadding + "Cruise Control");
        if (S_NoEngine) UI::Text(NoEngineColor + Icons::PowerOff            + iconPadding + "Engine Off");
        if (S_Forced)   UI::Text(ForcedColor   + Icons::Forward             + iconPadding + "Forced Accel");
        if (S_Fragile)  UI::Text(FragileColor  + Icons::ChainBroken         + iconPadding + "Fragile");
        if (S_NoBrakes) UI::Text(NoBrakesColor + Icons::ExclamationTriangle + iconPadding + "No Brakes");
        if (S_NoGrip)   UI::Text(NoGripColor   + Icons::SnowflakeO          + iconPadding + "No Grip");
        if (S_NoSteer)  UI::Text(NoSteerColor  + Icons::ArrowsH             + iconPadding + "No Steering");
        if (S_Reactor)  UI::Text(ReactorText(VehicleState::GetReactorFinalTimer(state)));
        if (S_SlowMo)   UI::Text(SlowMoColor   + Icons::ClockO              + iconPadding + "Slow-Mo");
        if (S_Turbo)    UI::Text(TurboText(state.TurboTime));
    UI::End();
    UI::PopFont();
}

string ReactorText(float f) {
    if (f == 0)   return ReactorColor + ReactorIcon + iconPadding + "Reactor Boost";
    if (f < 0.09) return ReactorColor + ReactorIcon + iconPadding + "Reactor Boos" + DefaultColor + "t";
    if (f < 0.17) return ReactorColor + ReactorIcon + iconPadding + "Reactor Boo" + DefaultColor + "st";
    if (f < 0.25) return ReactorColor + ReactorIcon + iconPadding + "Reactor Bo" + DefaultColor + "ost";
    if (f < 0.33) return ReactorColor + ReactorIcon + iconPadding + "Reactor B" + DefaultColor + "oost";
    if (f < 0.41) return ReactorColor + ReactorIcon + iconPadding + "Reactor " + DefaultColor + "Boost";
    if (f < 0.49) return ReactorColor + ReactorIcon + iconPadding + "Reacto" + DefaultColor + "r Boost";
    if (f < 0.57) return ReactorColor + ReactorIcon + iconPadding + "React" + DefaultColor + "or Boost";
    if (f < 0.65) return ReactorColor + ReactorIcon + iconPadding + "Reac" + DefaultColor + "tor Boost";
    if (f < 0.73) return ReactorColor + ReactorIcon + iconPadding + "Rea" + DefaultColor + "ctor Boost";
    if (f < 0.81) return ReactorColor + ReactorIcon + iconPadding + "Re" + DefaultColor + "actor Boost";
    if (f < 0.89) return ReactorColor + ReactorIcon + iconPadding + "R" + DefaultColor + "eactor Boost";
    return ReactorColor + ReactorIcon + DefaultColor + iconPadding + "Reactor Boost";
}

string TurboText(float f) {
    if (f == 0)  return TurboColor + Icons::ArrowCircleUp + iconPadding + "Turbo";
    if (f < 0.2) return TurboColor + Icons::ArrowCircleUp + iconPadding + "Turb" + DefaultColor + "o";
    if (f < 0.4) return TurboColor + Icons::ArrowCircleUp + iconPadding + "Tur" + DefaultColor + "bo";
    if (f < 0.6) return TurboColor + Icons::ArrowCircleUp + iconPadding + "Tu" + DefaultColor + "rbo";
    if (f < 0.8) return TurboColor + Icons::ArrowCircleUp + iconPadding + "T" + DefaultColor + "urbo";
    return TurboColor + Icons::ArrowCircleUp + DefaultColor + iconPadding + "Turbo";
}
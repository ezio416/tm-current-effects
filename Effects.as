/*
c 2023-08-17
m 2023-08-18
*/

const string BLUE   = "\\$09D";
const string CYAN   = "\\$2FF";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";
string DefaultColor = GRAY;

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
    auto type = Reflection::GetType("CSceneVehicleVisState");
    int handicapSum = Dev::GetOffsetInt32(state, type.GetMember("TurboTime").Offset + 12);
    SetHandicaps(handicapSum);

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

    if      (state.SimulationTimeCoef == 1)        SlowMoColor = DefaultColor;
    else if (state.SimulationTimeCoef == 0.57)     SlowMoColor = GREEN;
    else if (state.SimulationTimeCoef == 0.3249)   SlowMoColor = YELLOW;
    else if (state.SimulationTimeCoef == 0.185193) SlowMoColor = ORANGE;
    else                                           SlowMoColor = RED;

    TurboColor = DefaultColor;
    if (state.IsTurbo) {
        switch (Dev::GetOffsetUint32(state, 368)) {
            case 1: TurboColor = YELLOW; break;
            case 2: TurboColor = RED;    break;
            case 3: TurboColor = YELLOW; break;  // roulette 1
            case 4: TurboColor = CYAN;   break;  // roulette 2
            case 5: TurboColor = PURPLE; break;  // roulette 3
            default:                     break;
        }
    }

    int flags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoTitleBar;

    if (!UI::IsOverlayShown())
        flags |= UI::WindowFlags::NoInputs;

    UI::PushFont(font);
    UI::Begin("Current Effects", flags);
        if (S_Penalty)  UI::Text(PenaltyColor  + Icons::Times               + iconPadding + "Accel Penalty");
        if (S_Cruise)   UI::Text(CruiseColor   + Icons::Road                + iconPadding + "Cruise Control");
        if (S_NoEngine) UI::Text(NoEngineColor + Icons::PowerOff            + iconPadding + "Engine Off");
        if (S_Forced)   UI::Text(ForcedColor   + Icons::Forward             + iconPadding + "Forced Accel");
        if (S_Fragile)  UI::Text(FragileColor  + Icons::ChainBroken         + iconPadding + "Fragile");
        if (S_NoBrakes) UI::Text(NoBrakesColor + Icons::ExclamationTriangle + iconPadding + "No Brakes");
        if (S_NoGrip)   UI::Text(NoGripColor   + Icons::SnowflakeO          + iconPadding + "No Grip");
        if (S_NoSteer)  UI::Text(NoSteerColor  + Icons::ArrowsH             + iconPadding + "No Steering");
        if (S_Reactor)  UI::Text(ReactorText(Dev::GetOffsetFloat(state, 380)));
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

void SetHandicaps(int sum) {
    switch (sum) {
        case 256: case 257: case 258:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1024: case 1025: case 1026:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1280: case 1281: case 1282:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1536: case 1537: case 1538:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 2048: case 2049: case 2050:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 2304: case 2305: case 2306:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3072: case 3073: case 3074:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3328: case 3329: case 3330:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3584: case 3585: case 3586:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 4096: case 4097: case 4098:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 4352: case 4353: case 4354:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5120: case 5121: case 5122:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5376: case 5377: case 5378:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5632: case 5633: case 5634:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5888: case 5889: case 5890:
            NoEngineColor = RED;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 6144: case 6145: case 6146:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        case 6400: case 6401: case 6402:
            NoEngineColor = RED;
            ForcedColor = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor = PURPLE;
            NoGripColor = BLUE;
            break;
        case 7424: case 7425: case 7426:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        case 7680: case 7681: case 7682:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        default:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoGripColor   = DefaultColor;
            NoSteerColor  = DefaultColor;
    }
}
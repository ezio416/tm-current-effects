/*
c 2023-05-04
m 2023-08-04
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

bool replay;

void Main() {
    ChangeFont();
}

void OnSettingsChanged() {
    if (currentFont != S_Font) {
        ChangeFont();
    }
}

void RenderMenu() {
    if (UI::MenuItem("\\$F00" + Icons::React + "\\$G Current Effects", "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Render() {
    if (
        !S_Enabled ||
        (S_hideWithGame && !UI::IsGameUIVisible()) ||
        (S_hideWithOP && !UI::IsOverlayShown()) ||
        font is null
    ) return;

    auto app = cast<CTrackMania@>(GetApp());

    auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
    if (playground is null) return;

    if (
        playground.GameTerminals.Length != 1 ||
        playground.UIConfigs.Length == 0
    ) return;

    auto scene = cast<ISceneVis@>(app.GameScene);
    if (scene is null) return;

    CSceneVehicleVis@ vis;
    auto player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
    if (player !is null) {
        @vis = VehicleState::GetVis(scene, player);
        replay = false;
    } else {
        @vis = VehicleState::GetSingularVis(scene);
        replay = true;
    }
    if (vis is null) return;

    auto state = vis.AsyncState;

    auto script = cast<CSmScriptPlayer@>(playground.Arena.Players[0].ScriptAPI);
    if (script is null) return;

    auto sequence = playground.UIConfigs[0].UISequence;
    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::UIInteraction && replay)
    ) return;

////////////////////////////////////////////////////////////////////////////////////////////////////

    NoEngineColor = script.HandicapNoGasDuration > 0 ? RED : DefaultColor;

    ForcedColor = script.HandicapForceGasDuration > 0 ? GREEN : DefaultColor;

    NoBrakesColor = script.HandicapNoBrakesDuration > 0 ? ORANGE : DefaultColor;

    NoGripColor = script.HandicapNoGripDuration > 0 ? BLUE : DefaultColor;

    NoSteerColor = script.HandicapNoSteeringDuration > 0 ? PURPLE : DefaultColor;

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

////////////////////////////////////////////////////////////////////////////////////////////////////

    int windowFlags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoTitleBar;

    UI::PushFont(font);
    UI::Begin("Current Effects", windowFlags);
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
/*
c 2023-05-04
m 2023-05-05
*/

void Render() {
    auto app = cast<CTrackMania>(GetApp());
    if (
        !UI::IsGameUIVisible() ||
        app.RootMap is null ||
        app.RootMap.MapInfo.MapUid == "" ||
        app.Editor !is null
    ) return;

    int windowFlags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoDocking |
                      UI::WindowFlags::NoTitleBar;
    if (!UI::IsOverlayShown()) windowFlags |= UI::WindowFlags::NoInputs;

    string endl = DefaultColor + "\n";
    string text;
    if (CruiseShow)      text += CruiseColor      + Icons::Road                + " Cruise Control" + endl;
    if (NoEngineShow)    text += NoEngineColor    + Icons::PowerOff            + " Engine Off"     + endl;
    if (ForcedAccelShow) text += ForcedAccelColor + Icons::Forward             + " Forced Accel"   + endl;
    if (FragileShow)     text += FragileColor     + Icons::ChainBroken         + " Fragile"        + endl;
    if (NoBrakesShow)    text += NoBrakesColor    + Icons::ExclamationTriangle + " No Brakes"      + endl;
    if (NoGripShow)      text += NoGripColor      + Icons::SnowflakeO          + " No Grip"        + endl;
    if (NoSteerShow)     text += NoSteerColor     + Icons::ArrowsH             + " No Steering"    + endl;
    if (ReactorShow)     text += ReactorColor     + ReactorIcon                + " Reactor Boost"  + endl;
    if (SlowMoShow)      text += SlowMoColor      + Icons::ClockO              + " Slow-Mo"        + endl;
    if (TurboShow)       text += TurboColor       + Icons::ArrowCircleUp       + " Turbo";

    if (Show) {
        UI::Begin("Current Effects", windowFlags);
        UI::Text(text);
        UI::End();
    }
}

bool Truthy(uint num) {
    if (num > 0)
        return true;
    return false;
}

const string BLUE   = "\\$09D";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$B90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";
string DefaultColor = WHITE;

// bool   Cruise;
string CruiseColor = "\\$888";
bool   ForcedAccel;
string ForcedAccelColor;
// bool   Fragile;
string FragileColor = "\\$888";
bool   NoBrakes;
string NoBrakesColor;
bool   NoEngine;
string NoEngineColor;
bool   NoGrip;
string NoGripColor;
bool   NoSteer;
string NoSteerColor;
string ReactorColor;
string ReactorIcon = Icons::Rocket;
uint   ReactorLevel;
uint   ReactorType;
float  SlowMo;
string SlowMoColor;
bool   Turbo;
string TurboColor;

[Setting name="Show Window" category="General"]
bool Show = true;
[Setting name="Cruise Control" category="Toggle Options" description="not working yet"]
bool CruiseShow = false;
[Setting name="Engine Off" category="Toggle Options"]
bool NoEngineShow = true;
[Setting name="Forced Acceleration" category="Toggle Options"]
bool ForcedAccelShow = true;
[Setting name="Fragile" category="Toggle Options" description="not working yet"]
bool FragileShow = false;
[Setting name="No Brakes" category="Toggle Options"]
bool NoBrakesShow = true;
[Setting name="No Grip" category="Toggle Options"]
bool NoGripShow = true;
[Setting name="No Steering" category="Toggle Options"]
bool NoSteerShow = true;
[Setting name="Reactor Boost" category="Toggle Options"]
bool ReactorShow= true;
[Setting name="Slow-Mo" category="Toggle Options"]
bool SlowMoShow = true;
[Setting name="Turbo" category="Toggle Options"]
bool TurboShow = true;

void Main() {
    while (true) {
        try {
            if (VehicleState::GetViewingPlayer() is null) { yield(); continue; }
        } catch { yield(); continue; }

        auto car     = cast<CSceneVehicleVisState>(VehicleState::ViewingPlayerState());
        ReactorLevel = uint(car.ReactorBoostLvl);
        ReactorType  = uint(car.ReactorBoostType);
        SlowMo       = car.BulletTimeNormed;
        Turbo        = car.IsTurbo;

        if      (ReactorLevel == 0) ReactorColor = DefaultColor;
        else if (ReactorLevel == 1) ReactorColor = YELLOW;
        else                        ReactorColor = RED;

        if      (ReactorType == 0) ReactorIcon = Icons::Rocket;
        else if (ReactorType == 1) ReactorIcon = Icons::ChevronUp;
        else                       ReactorIcon = Icons::ChevronDown;

        if      (SlowMo == 0)  SlowMoColor = DefaultColor;
        else if (SlowMo > 0.5) SlowMoColor = RED;
        else                   SlowMoColor = YELLOW;

        TurboColor = Turbo ? GREEN : DefaultColor;

        auto app        = cast<CTrackMania>(GetApp());
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
        auto script     = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
        ForcedAccel     = Truthy(script.HandicapForceGasDuration);
        NoBrakes        = Truthy(script.HandicapNoBrakesDuration);
        NoEngine        = Truthy(script.HandicapNoGasDuration);
        NoGrip          = Truthy(script.HandicapNoGripDuration);
        NoSteer         = Truthy(script.HandicapNoSteeringDuration);

        ForcedAccelColor = ForcedAccel ? GREEN  : DefaultColor;
        NoBrakesColor    = NoBrakes    ? ORANGE : DefaultColor;
        NoEngineColor    = NoEngine    ? RED    : DefaultColor;
        NoGripColor      = NoGrip      ? BLUE   : DefaultColor;
        NoSteerColor     = NoSteer     ? PURPLE : DefaultColor;

        yield();
    }
}
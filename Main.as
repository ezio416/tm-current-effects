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

    UI::Begin("CurrentEffects", windowFlags);
    UI::Text(  ForcedAccelColor + Icons::Forward             + " Forced Accel"  + WHITE +
        "\n" + NoBrakesColor    + Icons::ExclamationTriangle + " No Brakes"     + WHITE +
        "\n" + NoEngineColor    + Icons::PowerOff            + " No Engine"     + WHITE +
        "\n" + NoGripColor      + Icons::SnowflakeO          + " No Grip"       + WHITE +
        "\n" + NoSteerColor     + Icons::ArrowsH             + " No Steering"   + WHITE +
        "\n" + ReactorColor     + ReactorIcon                + " Reactor Boost" + WHITE +
        "\n" + SlowMoColor      + Icons::ClockO              + " Slow-Mo"       + WHITE +
        "\n" + TurboColor       + Icons::ArrowCircleUp       + " Turbo"         + WHITE
    );
    UI::End();
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

bool   ForcedAccel;
string ForcedAccelColor;
bool   NoBrakes;
string NoBrakesColor;
bool   NoEngine;
string NoEngineColor;
bool   NoGrip;
string NoGripColor;
bool   NoSteer;
string NoSteerColor;
uint   ReactorLevel;
uint   ReactorType;
string ReactorColor;
string ReactorIcon;
float  SlowMo;
string SlowMoColor;
bool   Turbo;
string TurboColor;

void Main() {
    while (true) {
        try {
            if (VehicleState::GetViewingPlayer() is null) {
                yield();
                continue;
            }
        } catch {
            yield();
            continue;
        }
        auto car     = cast<CSceneVehicleVisState>(VehicleState::ViewingPlayerState());
        ReactorLevel = uint(car.ReactorBoostLvl);
        ReactorType  = uint(car.ReactorBoostType);
        SlowMo       = car.BulletTimeNormed;
        Turbo        = car.IsTurbo;

        if      (ReactorLevel == 0) ReactorColor = WHITE;
        else if (ReactorLevel == 1) ReactorColor = YELLOW;
        else                        ReactorColor = RED;

        if      (ReactorType == 0)  ReactorIcon  = Icons::Rocket;
        else if (ReactorType == 1)  ReactorIcon  = Icons::ChevronUp;
        else                        ReactorIcon  = Icons::ChevronDown;

        if      (SlowMo == 0)       SlowMoColor  = WHITE;
        else if (SlowMo > 0.5)      SlowMoColor  = RED;
        else                        SlowMoColor  = YELLOW;

        if      (Turbo)             TurboColor   = GREEN;
        else                        TurboColor   = WHITE;

        auto app        = cast<CTrackMania>(GetApp());
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
        auto script     = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
        ForcedAccel     = Truthy(script.HandicapForceGasDuration);
        NoBrakes        = Truthy(script.HandicapNoBrakesDuration);
        NoEngine        = Truthy(script.HandicapNoGasDuration);
        NoGrip          = Truthy(script.HandicapNoGripDuration);
        NoSteer         = Truthy(script.HandicapNoSteeringDuration);

        if (ForcedAccel) ForcedAccelColor = GREEN;
        else             ForcedAccelColor = WHITE;

        if (NoBrakes)    NoBrakesColor    = ORANGE;
        else             NoBrakesColor    = WHITE;

        if (NoEngine)    NoEngineColor    = RED;
        else             NoEngineColor    = WHITE;

        if (NoGrip)      NoGripColor      = BLUE;
        else             NoGripColor      = WHITE;

        if (NoSteer)     NoSteerColor     = PURPLE;
        else             NoSteerColor     = WHITE;

        yield();
    }
}
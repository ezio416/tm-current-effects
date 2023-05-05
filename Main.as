/*
c 2023-05-04
m 2023-05-04
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
    UI::Text(  Icons::Forward             + " ForceAccel:  "    + ForceAccel +
        "\n" + Icons::ExclamationTriangle + " NoBrake:     "    + NoBrake +
        "\n" + Icons::PowerOff            + " NoEngine:   "     + NoEngine +
        "\n" + Icons::SnowflakeO          + " NoGrip:       "   + NoGrip +
        "\n" + Icons::ArrowsH             + " NoSteer:      "   + NoSteer +
        "\n" + Icons::Signal              + " ReactLevel: "     + ReactLevelText +
        "\n" + Icons::ArrowsV             + " ReactType:  "     + ReactTypeText +
        "\n" + Icons::ClockO              + " SlowMo:      "    + SlowMoText +
        "\n" + Icons::ArrowCircleUp       + " Turbo:          " + Turbo
    );
    UI::End();
}

bool Truthy(uint num) {
    if (num > 0)
        return true;
    return false;
}

bool   ForceAccel;
bool   NoBrake;
bool   NoEngine;
bool   NoGrip;
bool   NoSteer;
uint   ReactLevel;
string ReactLevelText;
uint   ReactType;
string ReactTypeText;
float  SlowMo;
string SlowMoText;
bool   Turbo;

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
        auto car   = cast<CSceneVehicleVisState>(VehicleState::ViewingPlayerState());
        ReactLevel = uint(car.ReactorBoostLvl);
        ReactType  = uint(car.ReactorBoostType);
        SlowMo     = car.BulletTimeNormed;
        Turbo      = car.IsTurbo;

        if      (ReactLevel == 0) ReactLevelText = "none";
        else if (ReactLevel == 1) ReactLevelText = "yellow";
        else                      ReactLevelText = "red";

        if      (ReactType == 0)  ReactTypeText  = "none";
        else if (ReactType == 1)  ReactTypeText  = "up";
        else                      ReactTypeText  = "down";

        if      (SlowMo == 0)     SlowMoText     = "none";
        else if (SlowMo > 0.5)    SlowMoText     = "level 2+";
        else                      SlowMoText     = "level 1";

        auto app        = cast<CTrackMania>(GetApp());
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
        auto script     = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
        ForceAccel      = Truthy(script.HandicapForceGasDuration);
        NoBrake         = Truthy(script.HandicapNoBrakesDuration);
        NoEngine        = Truthy(script.HandicapNoGasDuration);
        NoGrip          = Truthy(script.HandicapNoGripDuration);
        NoSteer         = Truthy(script.HandicapNoSteeringDuration);

        yield();
    }
}
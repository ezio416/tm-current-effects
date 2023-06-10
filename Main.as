/*
c 2023-05-04
m 2023-06-10
*/

void Render() {
    auto app = cast<CTrackMania@>(GetApp());
    try {
        auto sequence = app.CurrentPlayground.UIConfigs[0].UISequence;
        if (
            !Show ||
            !UI::IsGameUIVisible() ||
            app.RootMap is null ||
            sequence == CGamePlaygroundUIConfig::EUISequence::Intro ||
            (app.Editor !is null && sequence != CGamePlaygroundUIConfig::EUISequence::Playing)
        ) return;
    } catch { return; }

    int windowFlags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoDocking |
                      UI::WindowFlags::NoTitleBar;
    if (!UI::IsOverlayShown()) windowFlags |= UI::WindowFlags::NoInputs;

    UI::PushFont(font);
    UI::Begin("Current Effects", windowFlags);
    if (PenaltyShow)     UI::Text(PenaltyColor     + Icons::Times               + "  Accel Penalty");
    if (CruiseShow)      UI::Text(CruiseColor      + Icons::Road                + "  Cruise Control");
    if (NoEngineShow)    UI::Text(NoEngineColor    + Icons::PowerOff            + "  Engine Off");
    if (ForcedAccelShow) UI::Text(ForcedAccelColor + Icons::Forward             + "  Forced Accel");
    if (FragileShow)     UI::Text(FragileColor     + Icons::ChainBroken         + "  Fragile");
    if (NoBrakesShow)    UI::Text(NoBrakesColor    + Icons::ExclamationTriangle + "  No Brakes");
    if (NoGripShow)      UI::Text(NoGripColor      + Icons::SnowflakeO          + "  No Grip");
    if (NoSteerShow)     UI::Text(NoSteerColor     + Icons::ArrowsH             + "  No Steering");
    if (ReactorShow)     UI::Text(ReactorColor     + ReactorIcon                + "  Reactor Boost");
    if (SlowMoShow)      UI::Text(SlowMoColor      + Icons::ClockO              + "  Slow-Mo");
    if (TurboShow)       UI::Text(TurboColor       + Icons::ArrowCircleUp       + "  Turbo");
    UI::End();
    UI::PopFont();
}

// I'm well aware this is garbage
bool IsSameVehicle(CSceneVehicleVis@ a, CSceneVehicleVis@ b) {
    if (a.AsyncState.Dir.x != b.AsyncState.Dir.x) return false;
    if (a.AsyncState.Dir.y != b.AsyncState.Dir.y) return false;
    if (a.AsyncState.Dir.z != b.AsyncState.Dir.z) return false;
    if (a.AsyncState.Position.x != b.AsyncState.Position.x) return false;
    if (a.AsyncState.Position.y != b.AsyncState.Position.y) return false;
    if (a.AsyncState.Position.z != b.AsyncState.Position.z) return false;
    return true;
}

// Will be written out when VehicleState is updated
array<CSceneVehicleVis@> AllVehicleVisWithoutPB(ISceneVis@ scene) {
    auto @vis = VehicleState::GetAllVis(scene);
    if (vis.Length < 3) return vis; // PB ghost already hidden

    for (uint i = 0; i <= vis.Length - 2; i++) {
        for (uint j = i; j <= 6; j++) {
            if (i < vis.Length - 1) {
                if (IsSameVehicle(vis[i], vis[j])) {
                    vis.RemoveAt(j);
                    vis.RemoveAt(i);
                    return vis;
                }
            } else break;
        }
    }
    return vis;  // should never happen
}

bool Truthy(uint num) {
    if (num > 0)
        return true;
    return false;
}

const string BLUE   = "\\$09D";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";
string DefaultColor = GRAY;
UI::Font@ font = null;

// bool Cruise;
string CruiseColor = DefaultColor;
bool   ForcedAccel;
string ForcedAccelColor;
// bool Fragile;
string FragileColor = DefaultColor;
bool   NoBrakes;
string NoBrakesColor;
bool   NoEngine;
string NoEngineColor;
bool   NoGrip;
string NoGripColor;
bool   NoSteer;
string NoSteerColor;
// bool   Penalty;
string PenaltyColor = DefaultColor;
string ReactorColor;
string ReactorIcon = Icons::Rocket;
uint   ReactorLevel;
uint   ReactorType;
float  SlowMo;
string SlowMoColor;
bool   Turbo;
string TurboColor;

[Setting category="General" name="Enabled"]
bool Show = true;
[Setting category="General" name="Font Size" description="change requires plugin reload"]
uint FontSize = 16;
[Setting category="Toggle Options" name="Acceleration Penalty" description="not working yet"]
bool PenaltyShow = false;
[Setting category="Toggle Options" name="Cruise Control" description="not working yet"]
bool CruiseShow = false;
[Setting category="Toggle Options" name="Engine Off"]
bool NoEngineShow = true;
[Setting category="Toggle Options" name="Forced Acceleration"]
bool ForcedAccelShow = true;
[Setting category="Toggle Options" name="Fragile" description="not working yet"]
bool FragileShow = false;
[Setting category="Toggle Options" name="No Brakes"]
bool NoBrakesShow = true;
[Setting category="Toggle Options" name="No Grip"]
bool NoGripShow = true;
[Setting category="Toggle Options" name="No Steering"]
bool NoSteerShow = true;
[Setting category="Toggle Options" name="Reactor Boost"]
bool ReactorShow= true;
[Setting category="Toggle Options" name="Slow-Mo"]
bool SlowMoShow = true;
[Setting category="Toggle Options" name="Turbo"]
bool TurboShow = true;

void Main() {
    @font = UI::LoadFont("DroidSans.ttf", FontSize, -1, -1, true, true, true);

    while (true) {
        try {
            auto app = cast<CTrackMania@>(GetApp());
            auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
            if (playground is null) throw("null_pg");
            auto serverInfo = cast<CTrackManiaNetworkServerInfo>(app.Network.ServerInfo);

            array<CSceneVehicleVis@> cars;  // annoying workaround - conditional vars are scoped, CSceneVehicleVis is uninstantiable
            if (playground.UIConfigs[0].UISequence != CGamePlaygroundUIConfig::EUISequence::Playing) {
                auto @vis = AllVehicleVisWithoutPB(app.GameScene);
                cars.InsertLast(vis[vis.Length - 1]);  // latest record clicked is shown (usually, still buggy)
            }
            auto car =
                (cars.Length > 0) ?
                    cars[0].AsyncState :
                    serverInfo.CurGameModeStr.EndsWith("_Online") ?
                        VehicleState::ViewingPlayerState() :
                        VehicleState::GetAllVis(app.GameScene)[0].AsyncState;
            if (car is null) {
                ReactorLevel = 0;
                ReactorType  = 0;
                SlowMo       = 0;
                Turbo        = false;
                ForcedAccel  = false;
                NoBrakes     = false;
                NoEngine     = false;
                NoGrip       = false;
                NoSteer      = false;
                // Penalty      = false;
                throw("null_car");
            }
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

            auto script = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
            ForcedAccel = Truthy(script.HandicapForceGasDuration);
            NoBrakes    = Truthy(script.HandicapNoBrakesDuration);
            NoEngine    = Truthy(script.HandicapNoGasDuration);
            NoGrip      = Truthy(script.HandicapNoGripDuration);
            NoSteer     = Truthy(script.HandicapNoSteeringDuration);

            ForcedAccelColor = ForcedAccel ? GREEN  : DefaultColor;
            NoBrakesColor    = NoBrakes    ? ORANGE : DefaultColor;
            NoEngineColor    = NoEngine    ? RED    : DefaultColor;
            NoGripColor      = NoGrip      ? BLUE   : DefaultColor;
            NoSteerColor     = NoSteer     ? PURPLE : DefaultColor;

        } catch { yield(); continue; }

        yield();
    }
}
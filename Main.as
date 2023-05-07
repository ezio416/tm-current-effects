/*
c 2023-05-04
m 2023-05-06
*/

void Render() {
    auto app = cast<CTrackMania>(GetApp());
    if (
        !Show ||
        !UI::IsGameUIVisible() ||
        app.RootMap is null
    ) return;

    int windowFlags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoDocking |
                      UI::WindowFlags::NoTitleBar;
    if (!UI::IsOverlayShown()) windowFlags |= UI::WindowFlags::NoInputs;

    UI::PushFont(font);
    UI::Begin("Current Effects", windowFlags);
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
    UI::Text(test);
    UI::End();
    UI::PopFont();
}

bool IsSameVehicle(CSceneVehicleVis@ a, CSceneVehicleVis@ b) {
    if (a.AsyncState.Dir.x != b.AsyncState.Dir.x) return false;
    if (a.AsyncState.Dir.y != b.AsyncState.Dir.y) return false;
    if (a.AsyncState.Dir.z != b.AsyncState.Dir.z) return false;
    if (a.AsyncState.Position.x != b.AsyncState.Position.x) return false;
    if (a.AsyncState.Position.y != b.AsyncState.Position.y) return false;
    if (a.AsyncState.Position.z != b.AsyncState.Position.z) return false;
    return true;
}

array<CSceneVehicleVis@> AllVehicleVisWithoutPB(ISceneVis scene) {
    auto @vis = VehicleState::GetAllVis(scene);
    // print(vis.Length);
    // vis.Length could be up to 10
    if (vis.Length < 3) return vis;

    uint index1;
    uint index1_final = vis.Length - 2;
    uint index2;
    uint index2_temp;
    for (uint i = 0; i <= index1_final; i++) {
        index2_temp = i + 1;
        if (IsSameVehicle(vis[i], vis[index2_temp])) {
            index1 = i;
            index2 = index2_temp;
            break;
        }

        // for (uint j = index1_final; j >= 0; j--) {
        //     index2_temp = vis.Length + i - j - 1;
        //     if (i < j && index2_temp < vis.Length - 1 && IsSameVehicle(vis[i], vis[index2_temp])) {
        //         // index1 = i;
        //         // index2 = index2_temp;
        //         // break;
        //         vis.RemoveAt(index2);
        //         vis.RemoveAt(index1);
        //         return vis;
        //     }
        // }

        print(i + " " + vis.Length);
        index2_temp += 1;
        if (i < vis.Length - 2) {
            if (IsSameVehicle(vis[i], vis[index2_temp])) {
                print("a " + i + " " + index2_temp);
                index1 = i;
                index2 = index2_temp;
                break;
            }
        } else continue;
        index2_temp += 1;
        if (i < vis.Length - 3) {
            if (IsSameVehicle(vis[i], vis[index2_temp])) {
                print("b " + i + " " + index2_temp);
                index1 = i;
                index2 = index2_temp;
                break;
            }
        } else continue;
        index2_temp += 1;
        if (i < vis.Length - 4) {
            if (IsSameVehicle(vis[i], vis[index2_temp])) {
                print("c " + i + " " + index2_temp);
                index1 = i;
                index2 = index2_temp;
                break;
            }
        } else continue;
        index2_temp += 1;
        if (i < vis.Length - 5) {
            if (IsSameVehicle(vis[i], vis[index2_temp])) {
                print("d " + i + " " + index2_temp);
                index1 = i;
                index2 = index2_temp;
                break;
            }
        } else continue;
        index2_temp += 1;
        if (i < vis.Length - 6) {
            if (IsSameVehicle(vis[i], vis[index2_temp])) {
                print("e " + i + " " + index2_temp);
                index1 = i;
                index2 = index2_temp;
                break;
            }
        } else continue;
        print("hi");
    }

    if (index2 > 0) {
        print("before remove " + vis.Length + ", indeces " + index1 + " " + index2);
        vis.RemoveAt(index2);
        vis.RemoveAt(index1);
    }
    print("after remove  " + vis.Length);
    // print(vis[0].AsyncState.GroundDist);
    return vis;
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

// bool   Cruise;
string CruiseColor = DefaultColor;
bool   ForcedAccel;
string ForcedAccelColor;
// bool   Fragile;
string FragileColor = DefaultColor;
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

string test;

[Setting name="Show Window" category="General"]
bool Show = true;
[Setting name="Font Size" category="General" description="change requires plugin reload"]
int FontSize = 16;
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
    @font = UI::LoadFont("DroidSans.ttf", FontSize, -1, -1, true, true, true);

    while (true) {
        try {
            auto app = cast<CTrackMania>(GetApp());
            auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
            if (playground is null) throw("");

            // auto @vis = VehicleState::GetAllVis(app.GameScene);
            // auto @vis = AllVehicleVisWithoutPB(app.GameScene);
            // int index = 0;
            // if (vis.Length > 1) {
            //     if (IsSameVehicle(vis[0], vis[1])) {
            //         index = 2;
            //     } else if (IsSameVehicle(vis[1], vis[2])) {
            //         index = 0;
            //     }
            //     // test = vis[0].Model.IdName + "  " + vis[1].Model.IdName;
            //     // index = 2;
            // }
            // test = vis.Length + " " + index;


            // auto car = vis[0].AsyncState;
            // uint index;
            array<CSceneVehicleVis@> cars;
            if (app.CurrentPlayground.GameTerminals[0].UISequence_Current != CGamePlaygroundUIConfig::EUISequence::Playing) {
                // print("watching");
                auto @vis = AllVehicleVisWithoutPB(app.GameScene);
                cars.InsertLast(vis[vis.Length - 1]);
                // cars.InsertLast(VehicleState::GetAllVis(app.GameScene)[0]);
            // } else {
            }
            auto carr = (cars.Length > 0) ? cars[0] : VehicleState::GetAllVis(app.GameScene)[0];
            // auto carr = cars[0];
            if (carr is null) {
                ReactorLevel = 0;
                ReactorType  = 0;
                SlowMo       = 0;
                Turbo        = false;
                ForcedAccel  = false;
                NoBrakes     = false;
                NoEngine     = false;
                NoGrip       = false;
                NoSteer      = false;
                // throw("");
                print(cars.Length + " null carr");
                yield();
                continue;
            }
            auto car = carr.AsyncState;
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

        } catch { yield(); continue; }

        yield();
    }
}
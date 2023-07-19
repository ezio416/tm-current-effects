/*
c 2023-05-04
m 2023-07-19
*/

void Main() {
    @font = UI::LoadFont("DroidSans.ttf", Settings::FontSize, -1, -1, true, true, true);

    while (true) {
        try {
            auto app = cast<CTrackMania@>(GetApp());
            auto playground = cast<CSmArenaClient@>(app.CurrentPlayground);
            if (playground is null) throw("null_pg");
            auto serverInfo = cast<CTrackManiaNetworkServerInfo@>(app.Network.ServerInfo);

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
            SlowMo       = car.SimulationTimeCoef;
            Turbo        = car.IsTurbo;

            if      (ReactorLevel == 0) ReactorColor = DefaultColor;
            else if (ReactorLevel == 1) ReactorColor = YELLOW;
            else                        ReactorColor = RED;

            if      (ReactorType == 0) ReactorIcon = Icons::Rocket;
            else if (ReactorType == 1) ReactorIcon = Icons::ChevronUp;
            else                       ReactorIcon = Icons::ChevronDown;

            if      (SlowMo == 1)        SlowMoColor = DefaultColor;
            else if (SlowMo == 0.57)     SlowMoColor = GREEN;
            else if (SlowMo == 0.3249)   SlowMoColor = YELLOW;
            else if (SlowMo == 0.185193) SlowMoColor = ORANGE;
            else                         SlowMoColor = RED;

            TurboColor = Turbo ? GREEN : DefaultColor;

            auto script = cast<CSmScriptPlayer@>(playground.Arena.Players[0].ScriptAPI);
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
            // CruiseColor      = Cruise      ? BLUE   : DefaultColor;
            // FragileColor     = Fragile     ? ORANGE : DefaultColor;
            // PenaltyColor     = Penalty     ? RED    : DefaultColor;
        } catch { }

        yield();
    }
}

void Render() {
    auto app = cast<CTrackMania@>(GetApp());
    try {
        auto sequence = app.CurrentPlayground.UIConfigs[0].UISequence;
        if (
            !Settings::Show ||
            (
                sequence != CGamePlaygroundUIConfig::EUISequence::Playing &&
                sequence != CGamePlaygroundUIConfig::EUISequence::UIInteraction  // watching replay
            ) ||
            (Settings::hideWithGame && !UI::IsGameUIVisible()) ||
            (Settings::hideWithOP && !UI::IsOverlayShown())
        ) return;
    } catch { return; }

    int windowFlags = UI::WindowFlags::AlwaysAutoResize |
                      UI::WindowFlags::NoCollapse |
                      UI::WindowFlags::NoTitleBar;

    UI::PushFont(font);
    UI::Begin("Current Effects", windowFlags);
    if (Settings::PenaltyShow)     UI::Text(PenaltyColor     + Icons::Times               + "  Accel Penalty");
    if (Settings::CruiseShow)      UI::Text(CruiseColor      + Icons::Road                + "  Cruise Control");
    if (Settings::NoEngineShow)    UI::Text(NoEngineColor    + Icons::PowerOff            + "  Engine Off");
    if (Settings::ForcedAccelShow) UI::Text(ForcedAccelColor + Icons::Forward             + "  Forced Accel");
    if (Settings::FragileShow)     UI::Text(FragileColor     + Icons::ChainBroken         + "  Fragile");
    if (Settings::NoBrakesShow)    UI::Text(NoBrakesColor    + Icons::ExclamationTriangle + "  No Brakes");
    if (Settings::NoGripShow)      UI::Text(NoGripColor      + Icons::SnowflakeO          + "  No Grip");
    if (Settings::NoSteerShow)     UI::Text(NoSteerColor     + Icons::ArrowsH             + "  No Steering");
    if (Settings::ReactorShow)     UI::Text(ReactorColor     + ReactorIcon                + "  Reactor Boost");
    if (Settings::SlowMoShow)      UI::Text(SlowMoColor      + Icons::ClockO              + "  Slow-Mo");
    if (Settings::TurboShow)       UI::Text(TurboColor       + Icons::ArrowCircleUp       + "  Turbo");
    UI::End();
    UI::PopFont();
}
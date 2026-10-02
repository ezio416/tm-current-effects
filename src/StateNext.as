#if TMNEXT

StateNext g_state;

class StateNext : State {
    uint8                            actionKey;
    bool                             cruiseControl;
    float                            cruiseControlSpeed;
    uint                             entityId;
    bool                             forcedAccel;
    bool                             fragile;
    float                            fragileDamage;
    bool                             launchRespawning;
    bool                             nametagVis;
    bool                             noBrake;
    bool                             noGrip;
    bool                             noSteer;
    CE::OpponentVis                  opponentVis;
    uint64                           p_phy;
    bool                             reactor;
    uint                             reactorDuration;
    uint                             reactorElapsed;
    float                            reactorFinalTimer;
    ESceneVehicleVisReactorBoostLvl  reactorLevel;
    uint                             reactorStartTick;
    uint                             reactorRemaining;
    ESceneVehicleVisReactorBoostType reactorType;
    bool                             respawning;
    bool                             slowMo;
    float                            slowMoCoefficient;
    uint                             slowMoDuration;
    uint                             slowMoEndTick;
    uint8                            slowMoLevel;
    uint                             slowMoRemaining;
    bool                             standRespawning;
    float                            steerLimit;
    uint8                            turboLevel;
    float                            wetness;
    string                           wsid;

    void RenderDebugRows() const override {
        State::RenderDebugRows();

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::SeparatorText("NEXT");
        UI::TableNextColumn();
        UI::SeparatorText("");

        _RenderDebugRow("actionKey",          Color::DebugInt(actionKey));
        _RenderDebugRow("cruiseControl",      Color::DebugBool(cruiseControl));
        _RenderDebugRow("cruiseControlSpeed", Color::DebugFloat(cruiseControlSpeed));
        _RenderDebugRow("entityId",           Color::DebugString(Text::Format("0x%x", entityId)));
        _RenderDebugRow("forcedAccel",        Color::DebugBool(forcedAccel));
        _RenderDebugRow("fragile",            Color::DebugBool(fragile));
        _RenderDebugRow("fragileDamage",      Color::DebugFloat(fragileDamage));
        _RenderDebugRow("launchRespawning",   Color::DebugBool(launchRespawning));
        _RenderDebugRow("nametagVis",         Color::DebugBool(nametagVis));
        _RenderDebugRow("noBrake",            Color::DebugBool(noBrake));
        _RenderDebugRow("noGrip",             Color::DebugBool(noGrip));
        _RenderDebugRow("noSteer",            Color::DebugBool(noSteer));
        _RenderDebugRow("opponentVis",        Color::DebugOpponentVis(opponentVis));
        _RenderDebugRow("p_phy",              Color::DebugPointer(p_phy));
        _RenderDebugRow("reactor",            Color::DebugBool(reactor));
        _RenderDebugRow("reactorDuration",    Color::DebugInt(reactorDuration));
        _RenderDebugRow("reactorElapsed",     Color::DebugInt(reactorElapsed));
        _RenderDebugRow("reactorFinalTimer",  Color::DebugFloat(reactorFinalTimer));
        _RenderDebugRow("reactorLevel",       Color::DebugReactorLevel(reactorLevel));
        _RenderDebugRow("reactorRemaining",   Color::DebugInt(reactorRemaining));
        _RenderDebugRow("reactorStartTick",   Color::DebugInt(reactorStartTick));
        _RenderDebugRow("reactorType",        Color::DebugReactorType(reactorType));
        _RenderDebugRow("respawning",         Color::DebugBool(respawning));
        _RenderDebugRow("slowMo",             Color::DebugBool(slowMo));
        _RenderDebugRow("slowMoCoefficient",  Color::DebugFloat(slowMoCoefficient));
        _RenderDebugRow("slowMoLevel",        Color::DebugInt(slowMoLevel));
        _RenderDebugRow("slowMoDuration",     Color::DebugInt(slowMoDuration));
        _RenderDebugRow("slowMoEndTick",      Color::DebugInt(slowMoEndTick));
        _RenderDebugRow("slowMoRemaining",    Color::DebugInt(slowMoRemaining));
        _RenderDebugRow("standRespawning",    Color::DebugBool(standRespawning));
        _RenderDebugRow("steerLimit",         Color::DebugFloat(steerLimit));
        _RenderDebugRow("turboLevel",         Color::DebugInt(turboLevel));
        _RenderDebugRow("wetness",            Color::DebugFloat(wetness));
        _RenderDebugRow("wsid",               Color::DebugString(wsid));
    }

    void Reset() override {
        State::Reset();

        actionKey          = 0;
        cruiseControl      = false;
        cruiseControlSpeed = 0.0f;
        forcedAccel        = false;
        fragile            = false;
        fragileDamage      = 0.0f;
        entityId           = 0;
        launchRespawning   = false;
        nametagVis         = false;
        noBrake            = false;
        noGrip             = false;
        noSteer            = false;
        opponentVis        = CE::OpponentVis::Unknown;
        p_phy              = 0x0;
        reactor            = false;
        reactorDuration    = 0;
        reactorElapsed     = 0;
        reactorFinalTimer  = 0.0f;
        reactorLevel       = ESceneVehicleVisReactorBoostLvl::None;
        reactorStartTick   = 0;
        reactorRemaining   = 0;
        reactorType        = ESceneVehicleVisReactorBoostType::None;
        respawning         = false;
        slowMo             = false;
        slowMoCoefficient  = 0.0f;
        slowMoDuration     = 0;
        slowMoEndTick      = 0;
        slowMoLevel        = 0;
        slowMoRemaining    = 0;
        standRespawning    = false;
        steerLimit         = 0.0f;
        turboLevel         = 0;
        wetness            = 0.0f;
        wsid               = "";
    }

    void Update() override {
        Reset();

        auto App = cast<CTrackMania>(GetApp());

        if (false
            or App.GameScene is null
            or App.CurrentProfile is null
            or App.CurrentProfile.ProfileNew is null
        ) {
            return;
        }

        auto Playground = cast<CSmArenaClient>(App.CurrentPlayground);
        if (false
            or Playground is null
            or Playground.GameTerminals.Length == 0
            or Playground.GameTerminals[0] is null
            or Playground.UIConfigs.Length == 0
            or Playground.UIConfigs[0] is null
        ) {
            return;
        }

        gameMode    = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        ghostVis    = Danger::GetGhostVisibility(App.CurrentProfile.ProfileNew);
        nametagVis  = Danger::GetNametagVisibility(App.CurrentProfile.ProfileNew);
        opponentVis = Danger::GetOpponentVisibility(App.CurrentProfile);
        sequence    = Playground.UIConfigs[0].UISequence;
        finished    = sequence == CGamePlaygroundUIConfig::EUISequence::Finish;
        ticks       = App.Network.PlaygroundClientScriptAPI.GameTime / 10 * 10;

        if (App.PlaygroundScript is null) {
            auto Player = cast<CSmPlayer>(Playground.GameTerminals[0].GUIPlayer);

            if (Player is Playground.GameTerminals[0].ControlledPlayer) {
                viewMode = CE::ViewMode::Server;
                camera = Danger::GetCurrentCamera(Playground.GameTerminals[0]);

            } else {
                viewMode = CE::ViewMode::Spectate;

                if (true
                    and Playground.Interface !is null
                    and Playground.Interface.ManialinkScriptHandler !is null
                    and Playground.Interface.ManialinkScriptHandler.Playground !is null
                ) {
                    switch (Playground.Interface.ManialinkScriptHandler.Playground.GetSpectatorCameraType()) {
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Follow:
                            switch (Playground.Interface.ManialinkScriptHandler.Playground.GetSpectatorTargetType()) {
                                case CGamePlaygroundClientScriptAPI::ESpectatorTargetType::Single:
                                    camera = CE::Camera::SpecFollow;
                                    break;
                                case CGamePlaygroundClientScriptAPI::ESpectatorTargetType::None:
                                    camera = CE::Camera::SpecFollowAll;
                                    break;
                            }
                            break;
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Free:
                            camera = CE::Camera::SpecFree;
                            break;
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Replay:
                            camera = CE::Camera::SpecReplay;
                            break;
                    }
                }
            }

            if (Player !is null) {
                _UpdateWithPlayer(Player);
                _UpdateWithVis(VehicleState::GetVis(App.GameScene, Player));

                if (viewMode == CE::ViewMode::Server) {
                    _UpdateWithVehicle(Danger::GetVehicleSecondary(vehicleType));
                }
            }

        } else if (Playground.GameTerminals.Length > 1) {
            viewMode = CE::ViewMode::SplitScreen;

        } else {
            if (Playground.GameTerminals[0].GUIPlayer !is null) {
                viewMode = CE::ViewMode::Solo;
                camera = Danger::GetCurrentCamera(Playground.GameTerminals[0]);

                auto Player = cast<CSmPlayer>(Playground.GameTerminals[0].ControlledPlayer);
                if (Player is null) {
                    return;
                }

                CSceneVehicleVis@ Vis = VehicleState::GetVis(App.GameScene, Player);
                if (Vis is null) {
                    return;
                }

                _UpdateWithPlayer(Player);
                _UpdateWithVis(Vis);
                _UpdateWithVehicle(Danger::GetVehicle(Player, Danger::GetItemModelIndex(Vis.AsyncState)));

            } else {
                viewMode = CE::ViewMode::Replay;

                CSceneVehicleVis@ Vis = VehicleState::GetSingularVis(App.GameScene);

                const bool multiGhost = Vis is null;
                if (multiGhost) {
                    entityId = Danger::GetViewingGhostEntityId(Playground.GameTerminals[0]);
                    if (entityId != 0x0) {
                        @Vis = VehicleState::GetVisFromId(App.GameScene, entityId);
                    }
                }

                if (Vis is null) {
                    return;
                }

                driving = true;
                _UpdateWithVis(Vis);

                if (!multiGhost) {
                    CGameDataFileManagerScript@ DFM = App.PlaygroundScript.DataFileMgr;
                    if (DFM !is null and DFM.Ghosts.Length > 0) {
                        CGameGhostScript@ Ghost = DFM.Ghosts[DFM.Ghosts.Length - 1];  // seems reliable with one ghost
                        if (Ghost !is null) {
                            name = Ghost.Nickname;
                        }
                    }
                }
            }
        }
    }

    private void _UpdateWithPlayer(CSmPlayer@ Player) {
        if (Player is null) {
            return;
        }

        if (Player.User !is null) {
            login = Player.User.Login;
            name  = Player.User.Name;
            wsid  = Player.User.WebServicesUserId;
        }

        auto ScriptPlayer = cast<CSmScriptPlayer>(Player.ScriptAPI);
        if (ScriptPlayer is null) {
            return;
        }

        startTick = ScriptPlayer.StartTime;
        spawning = true
            and ScriptPlayer.Post == CSmScriptPlayer::EPost::Char
            and startTick > ticks
        ;
        driving = true
            and ScriptPlayer.Post == CSmScriptPlayer::EPost::CarDriver
            and !finished
            and !spawning
        ;

        if (ScriptPlayer.Score !is null) {
            respawns = ScriptPlayer.Score.NbRespawnsRequested;
        }
    }

    private void _UpdateWithVehicle(CMwNod@ Vehicle) {
        if (Vehicle is null) {
            return;
        }

        p_phy = Danger::GetPointer(Vehicle);

        steerLimit = Danger::GetSteerLimit(Vehicle);
        actionKey = int(steerLimit * 5.0f);

        launchRespawning = Danger::GetLaunchRespawning(Vehicle);
        standRespawning = Danger::GetStandRespawning(Vehicle);
        respawning = launchRespawning or standRespawning;

        if (!fragile) {
            fragile = Danger::GetFragile(Vehicle);
        }

        if (reactor) {
            reactorStartTick = Danger::GetReactorStartTick(Vehicle);
            reactorDuration = Danger::GetReactorDuration(Vehicle);
            reactorElapsed = reactorStartTick > 0 ? ticks - reactorStartTick : 0;
            if (reactorElapsed <= reactorDuration) {
                reactorRemaining = reactorDuration - reactorElapsed;
            }
        }

        if (slowMo) {
            auto tunings = Danger::GetTunings(Vehicle);
            if (tunings !is null) {
                slowMoDuration = Danger::GetSlowMoDuration(tunings);  // TODO switching cars during slow-mo breaks this

                slowMoEndTick = Danger::GetSlowMoEndTick(Vehicle);
                if (slowMoEndTick == 0) {
                    slowMoRemaining = slowMoDuration;
                } else if (slowMoEndTick >= ticks) {
                    slowMoRemaining = slowMoEndTick - ticks;
                }
            }
        }
    }

    private void _UpdateWithVis(CSceneVehicleVis@ Vis) {
        if (Vis is null) {
            return;
        }

        entityId = Danger::GetEntityId(Vis);
        p_vis = Danger::GetPointer(Vis);

        if (Vis.AsyncState is null) {
            return;
        }

        cruiseControlSpeed = float(VehicleState::GetCruiseDisplaySpeed(Vis.AsyncState));
        cruiseControl      = cruiseControlSpeed != 0.0f;

        fragileDamage = Vis.AsyncState.FLBreakNormedCoef;
        if (false
            or fragileDamage > 0.0f
            or Vis.AsyncState.FLTireWear01 + Vis.AsyncState.FRTireWear01
                + Vis.AsyncState.RRTireWear01 + Vis.AsyncState.RLTireWear01 > 0.0f
        ) {
            fragile = true;
        }

        const uint8 handicaps = Danger::GetHandicaps(Vis.AsyncState);
        noEngine    = handicaps & 0x1  == 0x1;
        forcedAccel = handicaps & 0x2  == 0x2;
        noBrake     = handicaps & 0x4  == 0x4;
        noSteer     = handicaps & 0x8  == 0x8;
        noGrip      = handicaps & 0x10 == 0x10;

        reactorLevel = Vis.AsyncState.ReactorBoostLvl;
        reactorType = Vis.AsyncState.ReactorBoostType;
        reactor = (false
            or reactorLevel != ESceneVehicleVisReactorBoostLvl::None
            or reactorType != ESceneVehicleVisReactorBoostType::None
        );
        if (reactor) {
            reactorFinalTimer = VehicleState::GetReactorFinalTimer(Vis.AsyncState);
        }

        slowMoCoefficient = Vis.AsyncState.SimulationTimeCoef;
        slowMo = slowMoCoefficient != 1.0f;
        if (slowMo) {
            // for the current player, use the first number
            // for replays/spectating, use the latter ones
            // idk why the game does this
            switch (int(slowMoCoefficient * 1000.0f)) {
                case 570: case 568:            // 0.57, 0.56862748
                    slowMoLevel = 1; break;
                case 324: case 321: case 325:  // 0.3249, 0.321569, 0.32549021
                    slowMoLevel = 2; break;
                case 185: case 184:            // 0.185193, 0.18431373
                    slowMoLevel = 3; break;
                case 111: case 109:            // 0.111111, 0.1098039
                    slowMoLevel = 4; break;
            }
        }

        turbo = Vis.AsyncState.IsTurbo;
        if (turbo) {
            turboLevel = uint8(VehicleState::GetLastTurboLevel(Vis.AsyncState));
            turboTimer = Vis.AsyncState.TurboTime;  // slightly broken for roulette
        }

        switch (VehicleState::GetVehicleType(Vis.AsyncState)) {
            case VehicleState::VehicleType::CharacterPilot: vehicleType = CE::VehicleType::Human;   break;
            case VehicleState::VehicleType::CarSport:       vehicleType = CE::VehicleType::Stadium; break;
            case VehicleState::VehicleType::CarSnow:        vehicleType = CE::VehicleType::Snow;    break;
            case VehicleState::VehicleType::CarRally:       vehicleType = CE::VehicleType::Rally;   break;
            case VehicleState::VehicleType::CarDesert:      vehicleType = CE::VehicleType::Desert;  break;
        }

        wetness = Vis.AsyncState.WetnessValue01;
    }
}

#endif

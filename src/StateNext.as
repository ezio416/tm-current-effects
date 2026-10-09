#if TMNEXT

StateNext g_state;

class StateNext : State {
    uint8                            actionKey;
    bool                             brakePedal;
    bool                             cruiseControl;
    float                            cruiseControlSpeed;
    uint                             entityId;
    bool                             forcedAccel;
    bool                             fragile;
    float                            fragileDamage;
    bool                             launchRespawning;
    bool                             nametagVis;
    bool                             noBrakes;
    bool                             noGrip;
    bool                             noSteer;
    CurrentEffects::OpponentVis      opponentVis;
    uint64                           p_phy;
    bool                             reactor;
    uint                             reactorDuration;
    uint                             reactorElapsed;
    float                            reactorFinalTimer;
    ESceneVehicleVisReactorBoostLvl  reactorLevel;
    uint                             reactorStartTick;
    uint                             reactorRemaining;
    ESceneVehicleVisReactorBoostType reactorType;
    uint                             respawnDuration;
    uint                             respawnEndTick;
    bool                             respawning;
    uint                             respawnRemaining;
    bool                             slowMo;
    float                            slowMoCoefficient;
    uint                             slowMoDuration;
    uint                             slowMoEndTick;
    uint8                            slowMoLevel;
    uint                             slowMoRemaining;
    bool                             standRespawning;
    float                            steerLimit;
    uint8                            turboLevel;
    float                            water;
    string                           wsid;

    void RenderDebugRows() const override {
        State::RenderDebugRows();

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::SeparatorText("NEXT");
        UI::TableNextColumn();
        UI::SeparatorText("");

        _RenderDebugRow("actionKey",          ColorDebugInt(actionKey));
        _RenderDebugRow("brakePedal",         ColorDebugBool(brakePedal));
        _RenderDebugRow("cruiseControl",      ColorDebugBool(cruiseControl));
        _RenderDebugRow("cruiseControlSpeed", ColorDebugFloat(cruiseControlSpeed));
        _RenderDebugRow("entityId",           ColorDebugString(Text::Format("0x%x", entityId)));
        _RenderDebugRow("forcedAccel",        ColorDebugBool(forcedAccel));
        _RenderDebugRow("fragile",            ColorDebugBool(fragile));
        _RenderDebugRow("fragileDamage",      ColorDebugFloat(fragileDamage));
        _RenderDebugRow("launchRespawning",   ColorDebugBool(launchRespawning));
        _RenderDebugRow("nametagVis",         ColorDebugBool(nametagVis));
        _RenderDebugRow("noBrakes",           ColorDebugBool(noBrakes));
        _RenderDebugRow("noGrip",             ColorDebugBool(noGrip));
        _RenderDebugRow("noSteer",            ColorDebugBool(noSteer));
        _RenderDebugRow("opponentVis",        ColorDebugOpponentVis(opponentVis));
        _RenderDebugRow("p_phy",              ColorDebugPointer(p_phy));
        _RenderDebugRow("reactor",            ColorDebugBool(reactor));
        _RenderDebugRow("reactorDuration",    ColorDebugInt(reactorDuration));
        _RenderDebugRow("reactorElapsed",     ColorDebugInt(reactorElapsed));
        _RenderDebugRow("reactorFinalTimer",  ColorDebugFloat(reactorFinalTimer));
        _RenderDebugRow("reactorLevel",       ColorDebugReactorLevel(reactorLevel));
        _RenderDebugRow("reactorRemaining",   ColorDebugInt(reactorRemaining));
        _RenderDebugRow("reactorStartTick",   ColorDebugInt(reactorStartTick));
        _RenderDebugRow("reactorType",        ColorDebugReactorType(reactorType));
        _RenderDebugRow("respawnDuration",    ColorDebugInt(respawnDuration));
        _RenderDebugRow("respawnEndTick",     ColorDebugInt(respawnEndTick));
        _RenderDebugRow("respawning",         ColorDebugBool(respawning));
        _RenderDebugRow("respawnRemaining",   ColorDebugInt(respawnRemaining));
        _RenderDebugRow("slowMo",             ColorDebugBool(slowMo));
        _RenderDebugRow("slowMoCoefficient",  ColorDebugFloat(slowMoCoefficient));
        _RenderDebugRow("slowMoLevel",        ColorDebugInt(slowMoLevel));
        _RenderDebugRow("slowMoDuration",     ColorDebugInt(slowMoDuration));
        _RenderDebugRow("slowMoEndTick",      ColorDebugInt(slowMoEndTick));
        _RenderDebugRow("slowMoRemaining",    ColorDebugInt(slowMoRemaining));
        _RenderDebugRow("standRespawning",    ColorDebugBool(standRespawning));
        _RenderDebugRow("steerLimit",         ColorDebugFloat(steerLimit));
        _RenderDebugRow("turboLevel",         ColorDebugInt(turboLevel));
        _RenderDebugRow("water",              ColorDebugFloat(water));
        _RenderDebugRow("wsid",               ColorDebugString(wsid));
    }

    void Reset() override {
        State::Reset();

        actionKey          = 0;
        brakePedal         = false;
        cruiseControl      = false;
        cruiseControlSpeed = 0.0f;
        forcedAccel        = false;
        fragile            = false;
        fragileDamage      = 0.0f;
        entityId           = 0;
        launchRespawning   = false;
        nametagVis         = false;
        noBrakes           = false;
        noGrip             = false;
        noSteer            = false;
        opponentVis        = CurrentEffects::OpponentVis::Unknown;
        p_phy              = 0x0;
        reactor            = false;
        reactorDuration    = 0;
        reactorElapsed     = 0;
        reactorFinalTimer  = 0.0f;
        reactorLevel       = ESceneVehicleVisReactorBoostLvl::None;
        reactorStartTick   = 0;
        reactorRemaining   = 0;
        reactorType        = ESceneVehicleVisReactorBoostType::None;
        respawnDuration    = 0;
        respawnEndTick     = 0;
        respawning         = false;
        respawnRemaining   = 0;
        slowMo             = false;
        slowMoCoefficient  = 0.0f;
        slowMoDuration     = 0;
        slowMoEndTick      = 0;
        slowMoLevel        = 0;
        slowMoRemaining    = 0;
        standRespawning    = false;
        steerLimit         = 0.0f;
        turboLevel         = 0;
        water              = 0.0f;
        wsid               = "";
    }

    void Update() override {
        Reset();

        auto App = cast<CTrackMania>(GetApp());

        if (false
            or App.GameScene is null
            or App.ManiaPlanetScriptAPI is null
            or App.RootMap is null
            or App.CurrentProfile is null
            or App.CurrentProfile.ProfileNew is null
            or App.Viewport is null
            or App.Viewport.SystemConfig is null
            or App.Viewport.SystemConfig.Display is null
            or App.Network.PlaygroundClientScriptAPI is null
        ) {
            return;
        }

        auto Playground = cast<CSmArenaClient>(App.CurrentPlayground);
        if (false
            or Playground is null
            or Playground.Arena is null
            or Playground.Arena.Rules is null
            or Playground.GameTerminals.Length == 0
            or Playground.GameTerminals[0] is null
            or Playground.UIConfigs.Length == 0
            or Playground.UIConfigs[0] is null
        ) {
            return;
        }

        exeVersion  = App.ManiaPlanetScriptAPI.ExeVersion;
        fps         = App.Viewport.AverageFps;
        gameMode    = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        gameTime    = App.Network.PlaygroundClientScriptAPI.GameTime;
        ghostVis    = Danger::GetGhostVisibility(App.CurrentProfile.ProfileNew);
        mapCpCount  = Danger::GetCheckpointCount(App.RootMap);
        mapUid      = App.RootMap.EdChallengeId;
        mapWpCount  = mapCpCount + 1;
        maxFps      = App.Viewport.SystemConfig.Display.MaxFps;
        nametagVis  = Danger::GetNametagVisibility(App.CurrentProfile.ProfileNew);
        opponentVis = Danger::GetOpponentVisibility(App.CurrentProfile);
        sequence    = Playground.UIConfigs[0].UISequence;
        ticks       = gameTime / 10 * 10;
        wpCount     = Danger::GetWaypointCount(App.GameScene);

        if (App.PlaygroundScript is null) {
            auto Player = cast<CSmPlayer>(Playground.GameTerminals[0].GUIPlayer);

            if (Player is Playground.GameTerminals[0].ControlledPlayer) {
                viewMode = CurrentEffects::ViewMode::Server;
                camera = Danger::GetCurrentCamera(Playground.GameTerminals[0]);

            } else {
                viewMode = CurrentEffects::ViewMode::Spectate;

                if (true
                    and Playground.Interface !is null
                    and Playground.Interface.ManialinkScriptHandler !is null
                    and Playground.Interface.ManialinkScriptHandler.Playground !is null
                ) {
                    switch (Playground.Interface.ManialinkScriptHandler.Playground.GetSpectatorCameraType()) {
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Follow:
                            switch (Playground.Interface.ManialinkScriptHandler.Playground.GetSpectatorTargetType()) {
                                case CGamePlaygroundClientScriptAPI::ESpectatorTargetType::Single:
                                    camera = CurrentEffects::Camera::SpecFollow;
                                    break;
                                case CGamePlaygroundClientScriptAPI::ESpectatorTargetType::None:
                                    camera = CurrentEffects::Camera::SpecFollowAll;
                                    break;
                            }
                            break;
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Free:
                            camera = CurrentEffects::Camera::SpecFree;
                            break;
                        case CGamePlaygroundClientScriptAPI::ESpectatorCameraType::Replay:
                            camera = CurrentEffects::Camera::SpecReplay;
                            break;
                    }
                }
            }

            if (App.RootMap.TMObjective_IsLapRace) {
                _UpdateWithLaps(Danger::GetLapCount(Playground.Arena.Rules));
            } else {
                _UpdateWithLaps(0);
            }

            if (Player !is null) {
                _UpdateWithPlayer(Player);
                _UpdateWithVis(VehicleState::GetVis(App.GameScene, Player));

                if (viewMode == CurrentEffects::ViewMode::Server) {
                    _UpdateWithVehicle(Danger::GetVehicleSecondary(vehicleType));
                }
            }

        } else if (Playground.GameTerminals.Length > 1) {
            viewMode = CurrentEffects::ViewMode::SplitScreen;

        } else {
            if (Playground.GameTerminals[0].GUIPlayer !is null) {
                viewMode = CurrentEffects::ViewMode::Solo;
                camera = Danger::GetCurrentCamera(Playground.GameTerminals[0]);

                if (App.RootMap.TMObjective_IsLapRace) {
                    _UpdateWithLaps(App.RootMap.TMObjective_NbLaps);
                } else {
                    _UpdateWithLaps(0);
                }

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
                viewMode = CurrentEffects::ViewMode::Replay;

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

        if (false
            or name.Length == 0
            or viewMode == CurrentEffects::ViewMode::Replay
            or viewMode == CurrentEffects::ViewMode::Spectate
        ) {
            return;
        }

        wpTimes = Danger::GetWaypointTimes(Playground.Arena, name);
        if (wpTimes.Length == 0) {
            cpTime = raceTime;
            lapTime = raceTime;
            return;
        }

        lastWpTime = wpTimes[wpTimes.Length - 1];

        if (finished) {
            raceTime = lastWpTime;
            cpTime = wpTimes[wpTimes.Length - 1] - (wpTimes.Length > 0 ? wpTimes[wpTimes.Length - 2] : 0);
        } else if (raceTime > lastWpTime) {
            cpTime = raceTime - lastWpTime;
        }

        if (false
            or mapLapCount == 0
            or lapNum == 1
        ) {
            cpNum = Math::Min(wpTimes.Length, mapCpCount);
            cpTimes = cpLapTimes = wpTimes;
            lapTime = raceTime;
            return;
        }

        for (uint i = (mapCpCount + 1) * (lapNum - 1); i < wpTimes.Length; i++) {
            cpTimes.InsertLast(wpTimes[i]);
        }

        for (uint i = mapCpCount; i < wpTimes.Length; i += mapCpCount + 1) {
            lapTimes.InsertLast(wpTimes[i]);
        }

        lastLapTime = wpTimes[(mapCpCount + 1) * (lapNum - 1) - 1];

        if (raceTime > lastLapTime) {
            lapTime = raceTime - lastLapTime;
        }

        for (uint i = 0; i < cpTimes.Length; i++) {
            cpLapTimes.InsertLast(cpTimes[i] - lastLapTime);
        }

        for (uint i = 0; i < lapTimes.Length; i++) {
            lapLapTimes.InsertLast(lapTimes[i] - (i == 0 ? 0 : lapTimes[i - 1]));
        }
    }

    private void _UpdateWithLaps(const uint laps) {
        mapLapCount = laps;

        if (mapLapCount > 0) {
            mapWpCount *= mapLapCount;
        }

        finished = wpCount == mapWpCount or sequence == CGamePlaygroundUIConfig::EUISequence::Finish;
        cpNum    = finished ? mapCpCount : wpCount % (mapCpCount + 1);
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
        if (gameTime > startTick) {
            raceTime = gameTime - startTick;
        }

        driving = true
            and (false
                or viewMode == CurrentEffects::ViewMode::Spectate
                or ScriptPlayer.Post == CSmScriptPlayer::EPost::CarDriver
            )
            and !finished
            and !spawning
        ;

        switch (mapLapCount) {
            case 0:  break;
            case 1:  lapNum = 1; break;
            default: lapNum = finished ? mapLapCount : wpCount / (mapCpCount + 1) + 1;
        }

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

        brakePedal = Danger::GetBrakePedal(Vehicle);

        if (!finished) {
            launchRespawning = Danger::GetLaunchRespawning(Vehicle);
            standRespawning = Danger::GetStandRespawning(Vehicle);
            respawning = launchRespawning or standRespawning;

            if (startTick > ticks) {
                respawnDuration = 1580;
                respawnRemaining = startTick - ticks;
            } else {
                respawnDuration = 1000;
                respawnEndTick = Danger::GetRespawnEndTick(Vehicle);
                if (respawnEndTick != 0xffffffff and respawnEndTick > ticks) {
                    respawnRemaining = respawnEndTick - ticks;
                }
            }
        }

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
        noBrakes    = handicaps & 0x4  == 0x4;
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
            case VehicleState::VehicleType::CharacterPilot: vehicleType = CurrentEffects::VehicleType::Human;   break;
            case VehicleState::VehicleType::CarSport:       vehicleType = CurrentEffects::VehicleType::Stadium; break;
            case VehicleState::VehicleType::CarSnow:        vehicleType = CurrentEffects::VehicleType::Snow;    break;
            case VehicleState::VehicleType::CarRally:       vehicleType = CurrentEffects::VehicleType::Rally;   break;
            case VehicleState::VehicleType::CarDesert:      vehicleType = CurrentEffects::VehicleType::Desert;  break;
        }

        water = Vis.AsyncState.WetnessValue01;
    }
}

#endif

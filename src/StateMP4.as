#if MP4

StateMP4 g_state;

class StateMP4 : State {
    uint                        entityId;
    bool                        forcedAccel;
    bool                        nametagVis;
    bool                        noBrakes;
    bool                        noGrip;
    bool                        noSteer;
    CurrentEffects::OpponentVis opponentVis;
    bool                        spectateAuto;

    void RenderDebugRows() const override {
        State::RenderDebugRows();

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::SeparatorText("MP4");
        UI::TableNextColumn();
        UI::SeparatorText("");

        _RenderDebugRow("entityId",     ColorDebugString(Text::Format("0x%x", entityId)));
        _RenderDebugRow("forcedAccel",  ColorDebugBool(forcedAccel));
        _RenderDebugRow("nametagVis",   ColorDebugBool(nametagVis));
        _RenderDebugRow("noBrake",      ColorDebugBool(noBrakes));
        _RenderDebugRow("noGrip",       ColorDebugBool(noGrip));
        _RenderDebugRow("noSteer",      ColorDebugBool(noSteer));
        _RenderDebugRow("opponentVis",  ColorDebugOpponentVis(opponentVis));
        _RenderDebugRow("spectateAuto", ColorDebugBool(spectateAuto));
    }

    void Reset() override {
        State::Reset();

        entityId     = 0x0;
        forcedAccel  = false;
        nametagVis   = false;
        noBrakes     = false;
        noGrip       = false;
        noSteer      = false;
        opponentVis  = CurrentEffects::OpponentVis::Unknown;
        spectateAuto = false;
    }

    void Update() override {
        Reset();

        auto App = cast<CTrackMania>(GetApp());

        if (App.GameScene is null) {
            return;
        }

        auto Playground = cast<CTrackManiaRace>(App.CurrentPlayground);
        if (false
            or Playground is null
            or Playground.GameTerminals.Length != 1
            or Playground.GameTerminals[0] is null
            or Playground.UIConfigs.Length == 0
            or Playground.UIConfigs[0] is null
        ) {
            return;
        }

        fps         = App.Viewport.AverageFps;
        entityId    = VehicleState::GetViewingVisId();
        gameMode    = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        gameTime    = App.Network.PlaygroundClientScriptAPI.GameTime;
        ghostVis    = Playground.IsBestRaceGhostVisible;
        mapCpCount  = Danger::GetCheckpointCount(App.RootMap);
        mapWpCount  = mapCpCount + 1;
        maxFps      = App.Viewport.SystemConfig.Display.MaxFps;
        nametagVis  = Playground.ForceDisplayNames;
        opponentVis = Danger::GetOpponentVisibility();
        sequence    = Playground.UIConfigs[0].UISequence;
        ticks       = gameTime / 10 * 10;

        if (App.RootMap.TMObjective_IsLapRace) {
            mapLapCount = App.RootMap.TMObjective_NbLaps;
            mapWpCount *= mapLapCount;
        }

        switch (App.Network.PlaygroundClientScriptAPI.SettingsPlayerModelId.Value) {
            case 0x4000161f:
            case 0x40003cc5: vehicleType = CurrentEffects::VehicleType::Snow;    break;
            case 0x40001f21:
            case 0x40004aad: vehicleType = CurrentEffects::VehicleType::Desert;  break;
            case 0x40001fc2:
            case 0x40003b84: vehicleType = CurrentEffects::VehicleType::Bay;     break;
            case 0x40004852: vehicleType = CurrentEffects::VehicleType::Stadium; break;
            case 0x40001bc0: vehicleType = CurrentEffects::VehicleType::Human;   break;
            case 0x40004899: vehicleType = CurrentEffects::VehicleType::Canyon;  break;
            case 0x40004ec8: vehicleType = CurrentEffects::VehicleType::Valley;  break;
            case 0x40004edc: vehicleType = CurrentEffects::VehicleType::Lagoon;  break;
        }

        if (App.PlaygroundScript !is null) {
            camera   = Danger::GetCurrentCamera(Playground.GameTerminals[0]);
            viewMode = CurrentEffects::ViewMode::Solo;

            CGamePlayer@ Me = Playground.GameTerminals[0].ControlledPlayer;
            if (Me !is null) {
                _UpdateWithPlayer(cast<CTrackManiaPlayer>(Me));
                _UpdateWithVisState(VehicleState::GetVis(App.GameScene, Me));
            }

        } else {
            viewMode = CurrentEffects::ViewMode::Server;

            CGamePlayer@ Player;
            for (uint i = 0; i < Playground.Players.Length; i++) {
                if (Danger::GetEntityId(Playground.Players[i]) == entityId) {
                    @Player = Playground.Players[i];
                    break;
                }
            }

            if (Player is Playground.GameTerminals[0].ControlledPlayer) {
                camera = Danger::GetCurrentCamera(Playground.GameTerminals[0]);

            } else {
                viewMode = CurrentEffects::ViewMode::Spectate;

                switch (Playground.GameTerminals[0].SpectatorCameraType) {
                    case CGameTerminal::ESpectatorCameraType::_SpectatorCam_Follow:
                        camera = CurrentEffects::Camera::SpecFollow;
                        break;
                    case CGameTerminal::ESpectatorCameraType::_SpectatorCam_Free:
                        camera = CurrentEffects::Camera::SpecFree;
                        break;
                    case CGameTerminal::ESpectatorCameraType::_SpectatorCam_Replay:
                        camera = CurrentEffects::Camera::SpecReplay;
                        break;
                }

                spectateAuto = Playground.GameTerminals[0].SpectatorCameraTarget
                    == CGameTerminal::ESpectatorCameraTarget::_SpectatorCam_Auto;
            }

            _UpdateWithPlayer(cast<CTrackManiaPlayer>(Player));
            _UpdateWithVisState(VehicleState::GetVisStateWithId(entityId));
        }
    }

    private void _UpdateWithPlayer(CTrackManiaPlayer@ Player) {
        if (false
            or Player is null
            or Player.User is null
        ) {
            return;
        }

        login    = Player.User.Login;
        name     = Player.User.Name;
        respawns = Player.NbRespawns;

        if (mapLapCount > 0) {
            lapNum = Player.CurLapIndex;
        }

        auto ScriptPlayer = cast<CTrackManiaScriptPlayer>(Player.ScriptAPI);
        if (ScriptPlayer is null) {
            return;
        }

        startTick = ScriptPlayer.RaceStartTime;
        if (startTick == 0) {
            return;
        }

        driving = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::Running;
        if (driving) {
            raceTime = gameTime - startTick;
        }

        finished = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::Finished;
        spawning = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::BeforeStart;

        _UpdateWaypointTimes(ScriptPlayer.CurRace, ScriptPlayer.CurLap);
    }

    private void _UpdateWithVisState(CSceneVehicleVisState@ VisState) {
        if (false
            or VisState is null
            or VisState.m_vis is null
        ) {
            return;
        }

        noEngine    = VisState.ActiveEffects & 0x1  == 0x1;
        forcedAccel = VisState.ActiveEffects & 0x2  == 0x2;
        noBrakes    = VisState.ActiveEffects & 0x4  == 0x4;
        noSteer     = VisState.ActiveEffects & 0x8  == 0x8;
        noGrip      = VisState.ActiveEffects & 0x10 == 0x10;

        p_vis = Danger::GetPointer(VisState.m_vis);

        turbo = VisState.TurboActive;
        if (turbo) {
            turboTimer = Danger::GetTurboTimer(VisState.m_vis);
        }
    }
}

#endif

#if MP4

StateMP4 g_state;

class StateMP4 : State {
    uint                        cpNum;
    uint                        entityId;
    bool                        forcedAccel;
    uint                        lapNum;
    uint                        mapCpCount;
    uint                        mapLapCount;
    uint                        mapWpCount;
    bool                        nametagVis;
    bool                        noBrakes;
    bool                        noGrip;
    bool                        noSteer;
    CurrentEffects::OpponentVis opponentVis;
    bool                        spectateAuto;
    uint                        wpCount;

    void RenderDebugRows() const override {
        State::RenderDebugRows();

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::SeparatorText("MP4");
        UI::TableNextColumn();
        UI::SeparatorText("");

        _RenderDebugRow("cpNum",        ColorDebugInt(cpNum));
        _RenderDebugRow("entityId",     ColorDebugString(Text::Format("0x%x", entityId)));
        _RenderDebugRow("forcedAccel",  ColorDebugBool(forcedAccel));
        _RenderDebugRow("lapNum",       ColorDebugInt(lapNum));
        _RenderDebugRow("mapCpCount",   ColorDebugInt(mapCpCount));
        _RenderDebugRow("mapLapCount",  ColorDebugInt(mapLapCount));
        _RenderDebugRow("mapWpCount",   ColorDebugInt(mapWpCount));
        _RenderDebugRow("nametagVis",   ColorDebugBool(nametagVis));
        _RenderDebugRow("noBrake",      ColorDebugBool(noBrakes));
        _RenderDebugRow("noGrip",       ColorDebugBool(noGrip));
        _RenderDebugRow("noSteer",      ColorDebugBool(noSteer));
        _RenderDebugRow("opponentVis",  ColorDebugOpponentVis(opponentVis));
        _RenderDebugRow("spectateAuto", ColorDebugBool(spectateAuto));
        _RenderDebugRow("wpCount",      ColorDebugInt(wpCount));
    }

    void Reset() override {
        State::Reset();

        cpNum        = 0;
        entityId     = 0x0;
        forcedAccel  = false;
        lapNum       = 0;
        mapCpCount   = 0;
        mapLapCount  = 0;
        mapWpCount   = 0;
        nametagVis   = false;
        noBrakes     = false;
        noGrip       = false;
        noSteer      = false;
        opponentVis  = CurrentEffects::OpponentVis::Unknown;
        spectateAuto = false;
        wpCount      = 0;
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

        mapCpCount = Danger::GetCheckpointCount(App.RootMap);
        mapWpCount = mapCpCount + 1;

        if (App.RootMap.TMObjective_IsLapRace) {
            mapLapCount = App.RootMap.TMObjective_NbLaps;
            mapWpCount *= mapLapCount;
        }

        entityId    = VehicleState::GetViewingVisId();
        gameMode    = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        ghostVis    = Playground.IsBestRaceGhostVisible;
        nametagVis  = Playground.ForceDisplayNames;
        opponentVis = Danger::GetOpponentVisibility();
        sequence    = Playground.UIConfigs[0].UISequence;
        gameTime    = App.Network.PlaygroundClientScriptAPI.GameTime;
        ticks       = gameTime / 10 * 10;

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
                _Update(cast<CTrackManiaPlayer>(Me), VehicleState::GetVis(App.GameScene, Me));
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

            _Update(cast<CTrackManiaPlayer>(Player), VehicleState::GetVisStateWithId(entityId));
        }
    }

    private void _Update(CTrackManiaPlayer@ Player, CSceneVehicleVisState@ VisState) {
        if (Player !is null and Player.User !is null) {
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
            if (startTick > 0) {
                driving = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::Running;
                if (driving) {
                    raceTime = gameTime - startTick;
                }

                finished = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::Finished;
                spawning = ScriptPlayer.RaceState == CTrackManiaScriptPlayer::ERaceState::BeforeStart;

                if (driving or finished) {
                    if (ScriptPlayer.CurRace !is null) {
                        wpCount = ScriptPlayer.CurRace.Checkpoints.Length;
                    }

                    if (finished) {
                        cpNum = mapCpCount;
                    } else if (ScriptPlayer.CurLap !is null) {
                        cpNum = ScriptPlayer.CurLap.Checkpoints.Length;
                    }
                }
            }
        }

        if (VisState !is null and VisState.m_vis !is null) {
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
}

#endif

#if TURBO

StateTurbo g_state;

class StateTurbo : State {
    void Update() override {
        Reset();

        auto App = cast<CTrackMania>(GetApp());

        if (false
            or App.GameScene is null
            or App.Challenge is null
        ) {
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

        camera     = Danger::GetCurrentCamera(Playground.GameTerminals[0]);
        fps        = App.Viewport.AverageFps;
        gameMode   = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        gameTime   = App.Network.PlaygroundClientScriptAPI.GameTime;
        ghostVis   = Playground.IsBestRaceGhostVisible;
        mapCpCount = Danger::GetCheckpointCount(App.Challenge);
        mapUid     = App.Challenge.EdChallengeId;
        mapWpCount = mapCpCount + 1;
        maxFps     = App.Viewport.SystemConfig.Display.MaxFps;
        sequence   = Playground.UIConfigs[0].UISequence;
        ticks      = gameTime / 10 * 10;

        if (App.Challenge.TMObjective_IsLapRace) {
            mapLapCount = App.Challenge.TMObjective_NbLaps;
            mapWpCount *= mapLapCount;
        }

        if (App.Challenge.CollectionName == "Canyon") {
            vehicleType = CurrentEffects::VehicleType::Canyon;
        } else if (App.Challenge.CollectionName == "Valley") {
            vehicleType = CurrentEffects::VehicleType::Valley;
        } else if (App.Challenge.CollectionName == "Lagoon") {
            vehicleType = CurrentEffects::VehicleType::Lagoon;
        } else if (App.Challenge.CollectionName == "Stadium") {
            vehicleType = CurrentEffects::VehicleType::Stadium;
        }

        _UpdateWithPlayer(cast<CTrackManiaPlayer>(Playground.GameTerminals[0].ControlledPlayer));
        _UpdateWithVisState(VehicleState::ViewingPlayerState());

        if (App.PlaygroundScript !is null) {
            viewMode = CurrentEffects::ViewMode::Solo;
        } else {
            viewMode = CurrentEffects::ViewMode::Server;
            // TODO turbo spectating (but I don't want to)
        }
    }

    private void _UpdateWithPlayer(CTrackManiaPlayer@ Player) {
        if (Player is null) {
            return;
        }

        login    = Player.Login;
        name     = Player.Name;
        respawns = Player.NbRespawns;

        if (mapLapCount > 0) {
            lapNum = Player.CurLapIndex;
        }

        startTick = Player.RaceStartTime;
        if (startTick == 0) {
            return;
        }

        driving = Player.RaceState == CTrackManiaPlayer::ERaceState::Running;
        if (driving) {
            raceTime = gameTime - startTick;
        }

        finished = Player.RaceState == CTrackManiaPlayer::ERaceState::Finished;
        spawning = Player.RaceState == CTrackManiaPlayer::ERaceState::BeforeStart;

        _UpdateWaypointTimes(Player.CurRace, Player.CurLap);
    }

    private void _UpdateWithVisState(CSceneVehicleVisState@ VisState) {
        if (false
            or VisState is null
            or VisState.m_vis is null
        ) {
            return;
        }

        noEngine = VisState.ActiveEffects & 0x1 == 0x1;

        p_vis = Danger::GetPointer(VisState.m_vis);

        turbo = VisState.TurboActive;
        if (turbo) {
            turboTimer = VisState.TurboPercent;
        }
    }
}

#endif

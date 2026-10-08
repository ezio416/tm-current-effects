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
        _UpdateWithVis(VehicleState::ViewingPlayerState());

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

        if (finished) {
            cpNum = mapCpCount;
            lapNum = mapLapCount;
        }

        if (true
            and !driving
            and !finished
        ) {
            return;
        }

        if (Player.CurRace !is null) {
            wpCount = Player.CurRace.Checkpoints.Length;
            for (uint i = 0; i < wpCount; i++) {
                wpTimes.InsertLast(Player.CurRace.Checkpoints[i]);
            }
        }

        if (wpTimes.Length == 0) {
            cpTime = raceTime;
            lapTime = raceTime;
            return;
        }

        lastWpTime = wpTimes[wpTimes.Length - 1];

        if (finished) {
            raceTime = lastWpTime;
            cpTime = wpTimes[wpTimes.Length - 1] - (wpTimes.Length > 0 ? wpTimes[wpTimes.Length - 2] : 0);

        } else {
            if (raceTime > lastWpTime) {
                cpTime = raceTime - lastWpTime;
            }
        }

        if (Player.CurLap is null) {
            return;
        }

        if (!finished) {
            cpNum = Player.CurLap.Checkpoints.Length;
            for (uint i = 0; i < cpNum; i++) {
                cpLapTimes.InsertLast(Player.CurLap.Checkpoints[i]);
            }
        }

        if (false
            or mapLapCount == 0
            or lapNum == 1
        ) {
            cpTimes = cpLapTimes;
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

        for (uint i = 0; i < lapTimes.Length; i++) {
            lapLapTimes.InsertLast(lapTimes[i] - (i == 0 ? 0 : lapTimes[i - 1]));
        }
    }

    private void _UpdateWithVis(CSceneVehicleVisState@ VisState) {
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

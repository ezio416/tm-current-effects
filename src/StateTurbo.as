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

        camera   = Danger::GetCurrentCamera(Playground.GameTerminals[0]);
        gameMode = cast<CTrackManiaNetworkServerInfo>(App.Network.ServerInfo).CurGameModeStr;
        ghostVis = Playground.IsBestRaceGhostVisible;
        sequence = Playground.UIConfigs[0].UISequence;
        ticks    = App.Network.PlaygroundClientScriptAPI.GameTime / 10 * 10;  // 100 ticks/s, round down game time

        if (App.Challenge.CollectionName == "Canyon") {
            vehicleType = CE::VehicleType::Canyon;
        } else if (App.Challenge.CollectionName == "Valley") {
            vehicleType = CE::VehicleType::Valley;
        } else if (App.Challenge.CollectionName == "Lagoon") {
            vehicleType = CE::VehicleType::Lagoon;
        } else if (App.Challenge.CollectionName == "Stadium") {
            vehicleType = CE::VehicleType::Stadium;
        }

        _Update(
            cast<CTrackManiaPlayer>(Playground.GameTerminals[0].ControlledPlayer),
            VehicleState::ViewingPlayerState()
        );

        if (App.PlaygroundScript !is null) {
            viewMode = CE::ViewMode::Solo;
        } else {
            viewMode = CE::ViewMode::Server;
            // TODO turbo spectating (but I don't want to)
        }
    }

    private void _Update(CTrackManiaPlayer@ Player, CSceneVehicleVisState@ VisState) {
        if (Player !is null) {
            login    = Player.Login;
            name     = Player.Name;
            respawns = Player.NbRespawns;

            startTick = Player.RaceStartTime;
            if (startTick > 0) {
                driving  = Player.RaceState == CTrackManiaPlayer::ERaceState::Running;
                finished = Player.RaceState == CTrackManiaPlayer::ERaceState::Finished;
                spawning = Player.RaceState == CTrackManiaPlayer::ERaceState::BeforeStart;
            }
        }

        if (VisState !is null and VisState.m_vis !is null) {
            noEngine = VisState.ActiveEffects & 0x1 == 0x1;

            p_vis = Danger::GetPointer(VisState.m_vis);

            turbo = VisState.TurboActive;
            if (turbo) {
                turboTimer = VisState.TurboPercent;
            }
        }
    }
}

#endif

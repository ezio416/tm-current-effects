namespace CurrentEffects {
    Camera StatusCamera() {
        return g_state.camera;
    }

    uint[] StatusCheckpointLapTimes() {
        return g_state.cpLapTimes;
    }

    uint StatusCheckpointNumber() {
        return g_state.cpNum;
    }

    uint StatusCheckpointTime() {
        return g_state.cpTime;
    }

    uint[] StatusCheckpointTimes() {
        return g_state.cpTimes;
    }

    bool StatusDriving() {
        return g_state.driving;
    }

    string StatusExeVersion() {
        return g_state.exeVersion;
    }

    bool StatusFinished() {
        return g_state.finished;
    }

    float StatusFps() {
        return g_state.fps;
    }

    string StatusGameMode() {
        return g_state.gameMode;
    }

    uint StatusGameTime() {
        return g_state.gameTime;
    }

    bool StatusGhosts() {
        return g_state.ghostVis;
    }

    uint[] StatusLapLapTimes() {
        return g_state.lapLapTimes;
    }

    uint StatusLapNumber() {
        return g_state.lapNum;
    }

    uint StatusLapTime() {
        return g_state.lapTime;
    }

    uint[] StatusLapTimes() {
        return g_state.lapTimes;
    }

    uint StatusLastLapTime() {
        return g_state.lastLapTime;
    }

    uint StatusLastWaypointTime() {
        return g_state.lastWpTime;
    }

    string StatusLogin() {
        return g_state.login;
    }

    uint StatusMapCheckpointCount() {
        return g_state.mapCpCount;
    }

    uint StatusMapLapCount() {
        return g_state.mapLapCount;
    }

    string StatusMapUid() {
        return g_state.mapUid;
    }

    uint StatusMapWaypointCount() {
        return g_state.mapWpCount;
    }

    uint StatusMaxFps() {
        return g_state.maxFps;
    }

    string StatusName() {
        return g_state.name;
    }

    bool StatusNoEngine() {
        return g_state.noEngine;
    }

    uint StatusRaceTime() {
        return g_state.raceTime;
    }

    uint StatusRespawns() {
        return g_state.respawns;
    }

    CGamePlaygroundUIConfig::EUISequence StatusSequence() {
        return g_state.sequence;
    }

    bool StatusSpawning() {
        return g_state.spawning;
    }

    uint StatusStartTick() {
        return g_state.startTick;
    }

    uint StatusTicks() {
        return g_state.ticks;
    }

    bool StatusTurbo() {
        return g_state.turbo;
    }

    float StatusTurboTimer() {
        return g_state.turboTimer;
    }

    VehicleType StatusVehicleType() {
        return g_state.vehicleType;
    }

    ViewMode StatusViewMode() {
        return g_state.viewMode;
    }

    uint StatusWaypointCount() {
        return g_state.wpCount;
    }

    uint[] StatusWaypointTimes() {
        return g_state.wpTimes;
    }

#if TMNEXT

    bool Running() {
        return Safety::ShouldRun();
    }

    bool Safe() {
        return Safety::safe;
    }

    uint8 StatusActionKey() {
        return g_state.actionKey;
    }

    bool StatusBrakePedal() {
        return g_state.brakePedal;
    }

    bool StatusCruiseControl() {
        return g_state.cruiseControl;
    }

    float StatusCruiseControlSpeed() {
        return g_state.cruiseControlSpeed;
    }

    bool StatusFragile() {
        return g_state.fragile;
    }

    bool StatusLaunchRespawning() {
        return g_state.launchRespawning;
    }

    bool StatusReactor() {
        return g_state.reactor;
    }

    uint StatusReactorDuration() {
        return g_state.reactorDuration;
    }

    uint StatusReactorElapsed() {
        return g_state.reactorElapsed;
    }

    float StatusReactorFinalTimer() {
        return g_state.reactorFinalTimer;
    }

    ESceneVehicleVisReactorBoostLvl StatusReactorLevel() {
        return g_state.reactorLevel;
    }

    uint StatusReactorStartTick() {
        return g_state.reactorStartTick;
    }

    uint StatusReactorRemaining() {
        return g_state.reactorRemaining;
    }

    ESceneVehicleVisReactorBoostType StatusReactorType() {
        return g_state.reactorType;
    }

    uint StatusRespawnDuration() {
        return g_state.reactorDuration;
    }

    uint StatusRespawnEndTick() {
        return g_state.respawnEndTick;
    }

    bool StatusRespawning() {
        return g_state.respawning;
    }

    uint StatusRespawnRemaining() {
        return g_state.respawnRemaining;
    }

    bool StatusSlowMo() {
        return g_state.slowMo;
    }

    float StatusSlowMoCoefficient() {
        return g_state.slowMoCoefficient;
    }

    uint StatusSlowMoDuration() {
        return g_state.slowMoDuration;
    }

    uint StatusSlowMoEndTick() {
        return g_state.slowMoEndTick;
    }

    uint8 StatusSlowMoLevel() {
        return g_state.slowMoLevel;
    }

    uint StatusSlowMoRemaining() {
        return g_state.slowMoRemaining;
    }

    bool StatusStandRespawning() {
        return g_state.standRespawning;
    }

    uint StatusTurboLevel() {
        return g_state.turboLevel;
    }

    float StatusWater() {
        return g_state.water;
    }

    string StatusWebServicesUserId() {
        return g_state.wsid;
    }

#endif
#if MP4

    bool StatusSpectateAuto() {
        return g_state.spectateAuto;
    }

#endif
#if TMNEXT || MP4

    uint StatusEntityId() {
        return g_state.entityId;
    }

    bool StatusForcedAcceleration() {
        return g_state.forcedAccel;
    }

    bool StatusNametags() {
        return g_state.nametagVis;
    }

    bool StatusNoBrakes() {
        return g_state.noBrakes;
    }

    bool StatusNoGrip() {
        return g_state.noGrip;
    }

    bool StatusNoSteering() {
        return g_state.noSteer;
    }

    OpponentVis StatusOpponents() {
        return g_state.opponentVis;
    }

#endif
}

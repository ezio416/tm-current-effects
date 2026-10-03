namespace CurrentEffects {
    Camera StatusCamera() {
        return g_state.camera;
    }

    bool StatusGhosts() {
        return g_state.ghostVis;
    }

    VehicleType StatusVehicleType() {
        return g_state.vehicleType;
    }

    ViewMode StatusViewMode() {
        return g_state.viewMode;
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

    bool StatusFragile() {
        return g_state.fragile;
    }

    bool StatusLaunchRespawning() {
        return g_state.launchRespawning;
    }

    uint StatusReactorDuration() {
        return g_state.reactorDuration;
    }

    uint StatusReactorElapsed() {
        return g_state.reactorElapsed;
    }

    uint StatusReactorStartTick() {
        return g_state.reactorStartTick;
    }

    uint StatusReactorRemaining() {
        return g_state.reactorRemaining;
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

    uint StatusSlowMoDuration() {
        return g_state.slowMoDuration;
    }

    uint StatusSlowMoEndTick() {
        return g_state.slowMoEndTick;
    }

    uint StatusSlowMoRemaining() {
        return g_state.slowMoRemaining;
    }

    bool StatusStandRespawning() {
        return g_state.standRespawning;
    }

#endif
#if TMNEXT || MP4

    uint StatusEntityId() {
        return g_state.entityId;
    }

    bool StatusNametags() {
        return g_state.nametagVis;
    }

    OpponentVis StatusOpponents() {
        return g_state.opponentVis;
    }

#endif
}

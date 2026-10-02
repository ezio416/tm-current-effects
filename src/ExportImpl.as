namespace CurrentEffects {
    Camera StatusCamera() {
        return g_state.camera;
    }

    bool StatusGhostVisibility() {
        return g_state.ghostVis;
    }

#if TMNEXT

    bool StatusNametagVisibility() {
        return g_state.nametagVis;
    }

    OpponentVis StatusOpponentVisibility() {
        return g_state.opponentVis;
    }

    bool Running() {
        return Safety::ShouldRun();
    }

    bool Safe() {
        return Safety::safe;
    }

#endif
}

namespace CurrentEffects {
    /*
    the current camera
    */
    import Camera StatusCamera() from "CurrentEffects";

    /*
    ghosts are visible
    */
    import bool StatusGhosts() from "CurrentEffects";

    /*
    the current vehicle type (stadium, canyon, etc.)
    */
    import VehicleType StatusVehicleType() from "CurrentEffects";

    /*
    the current view mode (solo, spectating, etc.)
    */
    import ViewMode StatusViewMode() from "CurrentEffects";

#if TMNEXT

    /*
    the plugin is running, whether or not it's safe
    */
    import bool Running() from "CurrentEffects";

    /*
    it is safe to run the plugin with the current game version
    */
    import bool Safe() from "CurrentEffects";

    /*
    the current action key
    */
    import uint8 StatusActionKey() from "CurrentEffects";

    /*
    brake pedal is held
    */
    import bool StatusBrakePedal() from "CurrentEffects";

    /*
    fragile effect is active
    */
    import bool StatusFragile() from "CurrentEffects";

    /*
    car is doing a launched respawn
    */
    import bool StatusLaunchRespawning() from "CurrentEffects";

    /*
    race time of the player, to the thousandth
    */
    import uint StatusRaceTime() from "CurrentEffects";

    /*
    reactor ticks given
    */
    import uint StatusReactorDuration() from "CurrentEffects";

    /*
    ticks of reactor used
    */
    import uint StatusReactorElapsed() from "CurrentEffects";

    /*
    when reactor started
    */
    import uint StatusReactorStartTick() from "CurrentEffects";

    /*
    reactor ticks left
    */
    import uint StatusReactorRemaining() from "CurrentEffects";

    /*
    when the current respawn ends
    */
    import uint StatusRespawnEndTick() from "CurrentEffects";

    /*
    car is respawning
    */
    import bool StatusRespawning() from "CurrentEffects";

    /*
    respawn ticks left
    */
    import uint StatusRespawnRemaining() from "CurrentEffects";

    /*
    slow-mo ticks given
    */
    import uint StatusSlowMoDuration() from "CurrentEffects";

    /*
    when slow-mo ends
    */
    import uint StatusSlowMoEndTick() from "CurrentEffects";

    /*
    slow-mo ticks left
    */
    import uint StatusSlowMoRemaining() from "CurrentEffects";

    /*
    car is doing a standing respawn
    */
    import bool StatusStandRespawning() from "CurrentEffects";

#endif
#if TMNEXT || MP4

    /*
    the ID of the entity we're looking at
    */
    import uint StatusEntityId() from "CurrentEffects";

    /*
    nametags are visible
    */
    import bool StatusNametags() from "CurrentEffects";

    /*
    opponents are transparent, opaque, or off
    */
    import OpponentVis StatusOpponents() from "CurrentEffects";

#endif
}

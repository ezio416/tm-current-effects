namespace CurrentEffects {
    /*
    the current camera
    */
    import Camera StatusCamera() from "CurrentEffects";

    /*
    times of taken checkpoints on the current lap, referencing the start of the lap
    */
    import uint[] StatusCheckpointLapTimes() from "CurrentEffects";

    /*
    number of checkpoints taken
    */
    import uint StatusCheckpointNumber() from "CurrentEffects";

    /*
    time spent on the current checkpoint
    */
    import uint StatusCheckpointTime() from "CurrentEffects";

    /*
    times of taken checkpoints on the current lap
    */
    import uint[] StatusCheckpointTimes() from "CurrentEffects";

    /*
    player is driving
    */
    import bool StatusDriving() from "CurrentEffects";

    /*
    player is finished
    */
    import bool StatusFinished() from "CurrentEffects";

    /*
    framerate
    */
    import float StatusFps() from "CurrentEffects";

    /*
    game mode
    */
    import string StatusGameMode() from "CurrentEffects";

    /*
    running time of the playground to the 0.001s
    */
    import uint StatusGameTime() from "CurrentEffects";

    /*
    ghosts are visible
    */
    import bool StatusGhosts() from "CurrentEffects";

    /*
    times of finished laps, referencing the start of the lap
    */
    import uint[] StatusLapLapTimes() from "CurrentEffects";

    /*
    number of the current lap
    */
    import uint StatusLapNumber() from "CurrentEffects";

    /*
    time spent on the current lap
    */
    import uint StatusLapTime() from "CurrentEffects";

    /*
    times of finished laps
    */
    import uint[] StatusLapTimes() from "CurrentEffects";

    /*
    time of last lap finished
    */
    import uint StatusLastLapTime() from "CurrentEffects";

    /*
    time of the last waypoint taken
    */
    import uint StatusLastWaypointTime() from "CurrentEffects";

    /*
    login of the player
    */
    import string StatusLogin() from "CurrentEffects";

    /*
    number of collectable checkpoints in the map
    */
    import uint StatusMapCheckpointCount() from "CurrentEffects";

    /*
    number of laps in the map
    */
    import uint StatusMapLapCount() from "CurrentEffects";

    /*
    game-generated unique ID of the current map
    */
    import uint StatusMapUid() from "CurrentEffects";

    /*
    number of collectable waypoints in the map
    */
    import uint StatusMapWaypointCount() from "CurrentEffects";

    /*
    maximum framerate specified by game settings
    */
    import uint StatusMaxFps() from "CurrentEffects";

    /*
    name of the player
    */
    import string StatusName() from "CurrentEffects";

    /*
    engine off/free wheeling effect is active
    */
    import bool StatusNoEngine() from "CurrentEffects";

    /*
    race time of the player to the 0.001s
    */
    import uint StatusRaceTime() from "CurrentEffects";

    /*
    number of respawns
    */
    import uint StatusRespawns() from "CurrentEffects";

    /*
    current UI sequence
    */
    import CGamePlaygroundUIConfig::EUISequence StatusSequence() from "CurrentEffects";

    /*
    the player is spawning at the start of the race
    */
    import bool StatusSpawning() from "CurrentEffects";

    /*
    start tick of the player
    */
    import uint StatusStartTick() from "CurrentEffects";

    /*
    number of ticks simulated in the playground
    */
    import uint StatusTicks() from "CurrentEffects";

    /*
    turbo effect is active
    */
    import bool StatusTurbo() from "CurrentEffects";

    /*
    amount of time with turbo left, but not always in seconds
    */
    import float StatusTurboTimer() from "CurrentEffects";

    /*
    the current vehicle type (stadium, canyon, etc.)
    */
    import VehicleType StatusVehicleType() from "CurrentEffects";

    /*
    the current view mode (solo, spectating, etc.)
    */
    import ViewMode StatusViewMode() from "CurrentEffects";

    /*
    number of waypoints taken
    */
    import uint StatusWaypointCount() from "CurrentEffects";

    /*
    times of collected waypoints
    */
    import uint[] StatusWaypointTimes()  from "CurrentEffects";

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
    cruise control effect is active
    */
    import bool StatusCruiseControl() from "CurrentEffects";

    /*
    front speed locked by cruise control
    */
    import float StatusCruiseControlSpeed() from "CurrentEffects";

    /*
    fragile effect is active
    */
    import bool StatusFragile() from "CurrentEffects";

    /*
    car is doing a launched respawn
    */
    import bool StatusLaunchRespawning() from "CurrentEffects";

    /*
    reactor effect is active
    */
    import bool StatusReactor() from "CurrentEffects";

    /*
    reactor ticks given
    */
    import uint StatusReactorDuration() from "CurrentEffects";

    /*
    ticks of reactor used
    */
    import uint StatusReactorElapsed() from "CurrentEffects";

    /*
    timer counts from 0.0-1.0 in final second of reactor
    */
    import float StatusReactorFinalTimer() from "CurrentEffects";

    /*
    level of reactor
    */
    import ESceneVehicleVisReactorBoostLvl StatusReactorLevel() from "CurrentEffects";

    /*
    when reactor started
    */
    import uint StatusReactorStartTick() from "CurrentEffects";

    /*
    reactor ticks left
    */
    import uint StatusReactorRemaining() from "CurrentEffects";

    /*
    type of reactor
    */
    import ESceneVehicleVisReactorBoostType StatusReactorType() from "CurrentEffects";

    /*
    how long respawning takes
    */
    import uint StatusRespawnDuration() from "CurrentEffects";

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
    slow-mo effect is active
    */
    import bool StatusSlowMo() from "CurrentEffects";

    /*
    time factor used by slow-mo
    */
    import float StatusSlowMoCoefficient() from "CurrentEffects";

    /*
    slow-mo ticks given
    */
    import uint StatusSlowMoDuration() from "CurrentEffects";

    /*
    when slow-mo ends
    */
    import uint StatusSlowMoEndTick() from "CurrentEffects";

    /*
    level of slow-mo
    */
    import uint8 StatusSlowMoLevel() from "CurrentEffects";

    /*
    slow-mo ticks left
    */
    import uint StatusSlowMoRemaining() from "CurrentEffects";

    /*
    car is doing a standing respawn
    */
    import bool StatusStandRespawning() from "CurrentEffects";

    /*
    level of turbo
    */
    import uint StatusTurboLevel() from "CurrentEffects";

    /*
    percentage of wetness
    */
    import float StatusWater() from "CurrentEffects";

    /*
    online ID of the player
    */
    import string StatusWebServicesUserId() from "CurrentEffects";

#endif
#if MP4

    /*
    spectating target mode is set to automatic
    */
    import bool StatusSpectateAuto() from "CurrentEffects";

#endif
#if TMNEXT || MP4

    /*
    the ID of the entity we're looking at
    */
    import uint StatusEntityId() from "CurrentEffects";

    /*
    forced accel/fullspeed ahead effect is active
    */
    import bool StatusForcedAcceleration() from "CurrentEffects";

    /*
    nametags are visible
    */
    import bool StatusNametags() from "CurrentEffects";

    /*
    no brakes effect is active
    */
    import bool StatusNoBrakes() from "CurrentEffects";

    /*
    no grip effect is active
    */
    import bool StatusNoGrip() from "CurrentEffects";

    /*
    no steering effect is active
    */
    import bool StatusNoSteering() from "CurrentEffects";

    /*
    opponents are transparent, opaque, or off
    */
    import OpponentVis StatusOpponents() from "CurrentEffects";

#endif
}

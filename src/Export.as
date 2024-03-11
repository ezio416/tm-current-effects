// c 2024-01-12
// m 2024-03-10

namespace CurrentEffects {

#if TMNEXT

    // Returns true if experimental features are enabled.
    import bool GetExperimental() from "CurrentEffects";

    // Allows enabling experimental features from another plugin.
    import void SetExperimental(bool e) from "CurrentEffects";

    // (Very experimental) Returns true if the player bonked something.
    import bool GetAccelPenalty() from "CurrentEffects";

    // Returns true when in Cruise Control. Does not work when spectating.
    import bool GetCruiseControl() from "CurrentEffects";

    // (Experimental) Returns true when Fragile. Does not work when watching a replay or spectating.
    import bool GetFragile() from "CurrentEffects";

    // Returns the current Reactor Boost level.
    import ESceneVehicleVisReactorBoostLvl GetReactorLevel() from "CurrentEffects";

    // Returns 0.0-1.0 in the last second before a Reactor Boost runs out. Does not work when watching a replay.
    import float GetReactorFinalTimer() from "CurrentEffects";

    // Returns the current Reactor Boost type.
    import ESceneVehicleVisReactorBoostType GetReactorType() from "CurrentEffects";

    // Returns the current Slow-Mo level (0-4, 0 being none).
    import int GetSlowMoLevel() from "CurrentEffects";

    // Returns 0 for Stadium, 1 for Snow, and 2 for Rally car.
    import int GetVehicleType() from "CurrentEffects";

    // Returns the current TurboLevel (0-5, 0 being none). Does not work when spectating. Requires VehicleState dependency.
    import VehicleState::TurboLevel GetTurboLevel() from "CurrentEffects";

#elif MP4

    // Returns true when in Turbo.
    import bool GetTurbo() from "CurrentEffects";

#endif

    // Returns true when in Forced Acceleration (Fullspeed Ahead in MP4). Does not work when watching a replay.
    import bool GetForcedAccel() from "CurrentEffects";

    // Returns true when in No Brakes. Does not work when watching a replay.
    import bool GetNoBrakes() from "CurrentEffects";

    // Returns true when in Engine Off (Free Wheeling in MP4). Does not work when watching a replay.
    import bool GetNoEngine() from "CurrentEffects";

    // Returns true when in No Grip. Does not work when watching a replay.
    import bool GetNoGrip() from "CurrentEffects";

    // Returns true when in No Steering. Does not work when watching a replay.
    import bool GetNoSteer() from "CurrentEffects";
}
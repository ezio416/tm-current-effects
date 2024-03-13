// c 2024-01-12
// m 2024-03-13

/*
Shared namespace defining active effects on the viewed vehicle
When watching a replay, there must be only one vehicle active
*/
namespace CurrentEffects {
    /*
    Call this function to get access to variables in this plugin
    Use this instead of a new `CurrentEffects::State`
    */
    State@ GetState() {
        return state;
    }

#if TMNEXT
    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().AccelPenalty`
    Whether Acceleration Penalty is active
    (Experimental, probably wrong, TMNEXT only)
    */
    bool GetAccelPenalty() {
        WarnDeprecated();
        return state.AccelPenalty == 1;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().CruiseControl`
    Whether Cruise Control is active
    Does not work when spectating
    (TMNEXT only)
    */
    bool GetCruiseControl() {
        WarnDeprecated();
        return state.CruiseControl == 1;
    }
#endif

    /*
    DEPRECATED - INSTEAD USE CurrentEffects::GetState().ForcedAccel
    Whether Forced Acceleration/Fullspeed Ahead is active
    Does not work when watching a replay
    */
    bool GetForcedAccel() {
        WarnDeprecated();
        return state.ForcedAccel == 1;
    }

#if TMNEXT
    /*
    DEPRECATED - INSTEAD USE CurrentEffects::GetState().Experimental
    Whether experimental features are enabled
    Value is accessible to user as a setting
    */
    bool GetExperimental() {
        WarnDeprecated();
        return S_Experimental;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().Fragile`
    Whether Fragile is active
    Does not work when spectating or watching a replay
    (Experimental, TMNEXT only)
    */
    bool GetFragile() {
        WarnDeprecated();
        return state.Fragile == 1;
    }
#endif

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().NoBrakes`
    Whether No Brakes is active
    Does not work when watching a replay
    */
    bool GetNoBrakes() {
        WarnDeprecated();
        return state.NoBrakes == 1;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().NoEngine`
    Whether Engine Off/Free Wheeling is active
    Does not work when watching a replay
    */
    bool GetNoEngine() {
        WarnDeprecated();
        return state.NoEngine == 1;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().NoGrip`
    Whether No Grip is active
    Does not work when watching a replay
    */
    bool GetNoGrip() {
        WarnDeprecated();
        return state.NoGrip == 1;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().NoSteer`
    Whether No Steering is active
    Does not work when watching a replay
    */
    bool GetNoSteer() {
        WarnDeprecated();
        return state.NoSteer == 1;
    }

#if TMNEXT
    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().ReactorBoostFinalTimer`
    Timer that counts from `0.0 - 1.0` in the final second of Reactor Boost
    Does not work when watching a replay
    (TMNEXT only)
    */
    float GetReactorFinalTimer() {
        WarnDeprecated();
        return state.ReactorBoostFinalTimer;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().ReactorBoostLevel`
    Current level of Reactor Boost
    (TMNEXT only)
    */
    ESceneVehicleVisReactorBoostLvl GetReactorLevel() {
        WarnDeprecated();
        return ESceneVehicleVisReactorBoostLvl(state.ReactorBoostLevel);
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().ReactorBoostType`
    Current type of Reactor Boost
    (TMNEXT only)
    */
    ESceneVehicleVisReactorBoostType GetReactorType() {
        WarnDeprecated();
        return ESceneVehicleVisReactorBoostType(state.ReactorBoostType);
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().SlowMoLevel`
    Current level of Slow-Mo `0 - 4`
    (TMNEXT only)
    */
    int GetSlowMoLevel() {
        WarnDeprecated();
        return state.SlowMoLevel;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().Vehicle`
    Whether the current vehicle is the Snow Car
    (TMNEXT only)
    */
    bool GetSnowCar() {
        WarnDeprecated();
        return state.Vehicle == 1;
    }

    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().TurboLevel`
    Current level of Turbo
    Optionally cast to `VehicleState::TurboLevel`
    Does not work when spectating
    (TMNEXT only)
    */
    int GetTurboLevel() {
        WarnDeprecated();
        return state.TurboLevel;
    }

#elif MP4
    /*
    DEPRECATED - INSTEAD USE `CurrentEffects::GetState().TurboLevel`
    Whether Turbo is active
    */
    bool GetTurbo() {
        WarnDeprecated();
        return state.TurboLevel == 1;
    }
#endif

#if TMNEXT
    /*
    DEPRECATED - INSTEAD USE CurrentEffects::Experimental
    Allows toggling experimental features
    */
    void SetExperimental(bool e) {
        WarnDeprecated();
        S_Experimental = e;
    }
#endif
}

bool warnedDeprecated = false;
void WarnDeprecated() {
    if (warnedDeprecated)
        return;

    Meta::Plugin@ plugin = Meta::ExecutingPlugin();
    if (plugin is null)
        return;

    warnedDeprecated = true;

    warn("Warning: this plugin (" + plugin.Name + ") is using a deprecated function call from Current Effects. Please notify the author (" + plugin.Author + ") that these functions will be removed in a future update.");
}
// c 2024-03-10
// m 2024-06-04

/*
Shared namespace defining active effects on the viewed vehicle
When watching a replay, there must be only one vehicle active
*/
namespace CurrentEffects {
    // Shared enum defining the state of most available effects
    shared enum ActiveState {
        Disabled = -1,
        NotActive,
        Active,
    }

    /*
    Use this class to access all available values in the plugin
    Do not instantiate this class - instead use `CurrentEffects::GetState()`
    You may set any non-constant values
    It is safe to keep a handle to this around, though you should check its values every frame to ensure they're accurate
    */
    shared class State {  // making this abstract causes issues in dependent plugins
        State() { throw("Do not instantiate this class! Instead use CurrentEffects::GetState()"); }
        protected State(bool inherited) { }

        protected int    _cruise       = 0;
        protected bool   _experimental = false;
        protected int    _forced       = 0;
        protected int    _fragile      = 0;
        protected bool   _init         = false;
        protected int    _noBrakes     = 0;
        protected int    _noEngine     = 0;
        protected int    _noGrip       = 0;
        protected int    _noSteer      = 0;
        protected int    _penalty      = 0;
        protected int    _reactorLevel = 0;
        protected float  _reactorTimer = 0.0f;
        protected int    _reactorType  = 0;
        protected bool   _replay       = false;
        protected bool   _runHidden    = false;
        protected int    _slowMo       = 0;
        protected bool   _spectating   = false;
        protected int    _turbo        = 0;
        protected float  _turboTime    = 0.0f;
        protected int    _vehicle      = 0;

#if TMNEXT
        /*
        Whether Acceleration Penalty is active
        Does not work when spectating or watching a replay
        (Experimental, probably wrong, TMNEXT only)
        */
        const ActiveState get_AccelPenalty() {
            return ActiveState(_penalty);
        }

        /*
        Whether Cruise Control is active
        Does not work when spectating
        (TMNEXT only)
        */
        const ActiveState get_CruiseControl() {
            return ActiveState(_cruise);
        }
#endif

        /*
        Whether experimental features are enabled
        Value is accessible to user as a setting
        */
        bool get_Experimental() {
            return _experimental;
        }

        void set_Experimental(bool e) {
            _experimental = e;
        }

#if TMNEXT || MP4
        /*
        Whether Forced Acceleration/Fullspeed Ahead is active
        Does not work when watching a replay
        */
        const ActiveState get_ForcedAccel() {
            return ActiveState(_forced);
        }
#endif
#if TMNEXT
        /*
        Whether Fragile is active
        Does not work when spectating or watching a replay
        (Experimental, TMNEXT only)
        */
        const ActiveState get_Fragile() {
            return ActiveState(_fragile);
        }
#endif
#if TMNEXT || MP4
        /*
        Whether No Brakes is active
        Does not work when watching a replay
        */
        const ActiveState get_NoBrakes() {
            return ActiveState(_noBrakes);
        }
#endif
        /*
        Whether Engine Off/Free Wheeling is active
        Does not work when watching a replay
        */
        const ActiveState get_NoEngine() {
            return ActiveState(_noEngine);
        }
#if TMNEXT || MP4
        /*
        Whether No Grip is active
        Does not work when watching a replay
        */
        const ActiveState get_NoGrip() {
            return ActiveState(_noGrip);
        }

        /*
        Whether No Steering is active
        Does not work when watching a replay
        */
        const ActiveState get_NoSteer() {
            return ActiveState(_noSteer);
        }
#endif
#if TMNEXT
        /*
        Timer that counts from `0.0 - 1.0` in the final second of Reactor Boost
        Does not work when watching a replay
        (TMNEXT only)
        */
        const float get_ReactorBoostFinalTimer() {
            return _reactorTimer;
        }

        /*
        Current level of Reactor Boost
        (TMNEXT only)
        */
        const ESceneVehicleVisReactorBoostLvl get_ReactorBoostLevel() {
            return ESceneVehicleVisReactorBoostLvl(_reactorLevel);
        }

        /*
        Current type of Reactor Boost
        (TMNEXT only)
        */
        const ESceneVehicleVisReactorBoostType get_ReactorBoostType() {
            return ESceneVehicleVisReactorBoostType(_reactorType);
        }
#endif

        /*
        Whether plugin will run when its window is hidden
        Value is accessible to user as a setting
        Recommended: `true`
        */
        bool get_RunWhenHidden() {
            return _runHidden;
        }

        void set_RunWhenHidden(bool r) {
            _runHidden = r;
        }

#if TMNEXT
        /*
        Whether the user is spectating another player
        (TMNEXT only)
        */
        const bool get_Spectating() {
            return _spectating;
        }

        /*
        Current level of Slow-Mo `0 - 4`
        (TMNEXT only)
        */
        const int get_SlowMoLevel() {
            return _slowMo;
        }
#endif

        /*
        Current level of Turbo (`-1` when disabled)
        Does not work when spectating
        (TMNEXT) Optionally cast to `VehicleState::TurboLevel`
        (MP4) Only sets to `1` when active - does not know which level
        */
        const int get_TurboLevel() {
            return _turbo;
        }

#if TMNEXT
        /*
        Timer that counts from `0.0 - 1.0` as Turbo is running out
        Does not work when spectating
        (TMNEXT only)
        */
        const float get_TurboTime() {
            return _turboTime;
        }

        /*
        Current vehicle type (Pilot `0`, Stadium `1`, Snow `2`, Rally `3`, Desert `4`)
        Optionally cast to `VehicleState::VehicleType`
        (TMNEXT only)
        */
        const int get_Vehicle() {
            return _vehicle;
        }

        /*
        Whether the user is watching a replay
        (TMNEXT only)
        */
        const bool get_WatchingReplay() {
            return _replay;
        }
#endif
    }
}

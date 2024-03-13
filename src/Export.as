// c 2024-03-12
// m 2024-03-13

namespace CurrentEffects {
    import State@                           GetState()                from "CurrentEffects";

#if TMNEXT
    import bool                             GetExperimental()         from "CurrentEffects";
    import void                             SetExperimental(bool e)   from "CurrentEffects";
    import bool                             GetAccelPenalty()         from "CurrentEffects";
    import bool                             GetCruiseControl()        from "CurrentEffects";
    import bool                             GetFragile()              from "CurrentEffects";
    import ESceneVehicleVisReactorBoostLvl  GetReactorLevel()         from "CurrentEffects";
    import float                            GetReactorFinalTimer()    from "CurrentEffects";
    import ESceneVehicleVisReactorBoostType GetReactorType()          from "CurrentEffects";
    import int                              GetSlowMoLevel()          from "CurrentEffects";
    import bool                             GetSnowCar()              from "CurrentEffects";
    import int                              GetTurboLevel()           from "CurrentEffects";

#elif MP4
    import bool GetTurbo() from "CurrentEffects";
#endif

    import bool GetForcedAccel() from "CurrentEffects";
    import bool GetNoBrakes()    from "CurrentEffects";
    import bool GetNoEngine()    from "CurrentEffects";
    import bool GetNoGrip()      from "CurrentEffects";
    import bool GetNoSteer()     from "CurrentEffects";
}
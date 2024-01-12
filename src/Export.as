// c 2024-01-12
// m 2024-01-12

namespace CurrentEffects {

#if TMNEXT

    bool GetAccelPenalty()  { return penalty == 1; }
    // (Experimental) returns true if the player bonked something
    // import bool GetAccelPenalty() from "CurrentEffects";

    bool GetCruiseControl() { return cruise  == 1; }
    bool GetFragile()       { return fragile == 1; }
    bool GetSlowMo()        { return slowmo  == 1; }
    bool GetSnowCar()       { return snow    == 1 || alwaysSnow; }

    ESceneVehicleVisReactorBoostLvl GetReactorLevel() { return ESceneVehicleVisReactorBoostLvl(reactorLevel); }
    ESceneVehicleVisReactorBoostType GetReactorType() { return ESceneVehicleVisReactorBoostType(reactorType); }

    VehicleState::TurboLevel GetTurboLevel() { return VehicleState::TurboLevel(turbo); }

    bool GetExperimental()       { return S_Experimental; }
    // returns true if experimental features are enabled
    // import bool GetExperimental() from "CurrentEffects";

    void SetExperimental(bool e) { S_Experimental = e };

#elif MP4

    bool GetTurbo() { return turbo == 1; }

#endif

    bool GetForcedAccel() { return forced   == 1; }
    bool GetNoBrakes()    { return noBrakes == 1; }
    bool GetNoEngine()    { return noEngine == 1; }
    bool GetNoGrip()      { return noGrip   == 1; }
    bool GetNoSteer()     { return noSteer  == 1; }
}
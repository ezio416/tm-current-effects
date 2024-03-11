// c 2024-01-12
// m 2024-03-10

namespace CurrentEffects {

#if TMNEXT

    bool GetExperimental()       { return S_Experimental; }
    void SetExperimental(bool e) { S_Experimental = e; }

    bool  GetAccelPenalty()      { return penalty == 1; }
    bool  GetCruiseControl()     { return cruise  == 1; }
    bool  GetFragile()           { return fragile == 1; }
    float GetReactorFinalTimer() { return reactorTimer; }
    int   GetSlowMoLevel()       { return slowmo; }
    int   GetVehicleType()       { return vehicle };

    ESceneVehicleVisReactorBoostLvl GetReactorLevel() { return ESceneVehicleVisReactorBoostLvl(reactorLevel); }
    ESceneVehicleVisReactorBoostType GetReactorType() { return ESceneVehicleVisReactorBoostType(reactorType); }

    VehicleState::TurboLevel GetTurboLevel() { return VehicleState::TurboLevel(turbo); }

#elif MP4

    bool GetTurbo() { return turbo == 1; }

#endif

    bool GetForcedAccel() { return forced   == 1; }
    bool GetNoBrakes()    { return noBrakes == 1; }
    bool GetNoEngine()    { return noEngine == 1; }
    bool GetNoGrip()      { return noGrip   == 1; }
    bool GetNoSteer()     { return noSteer  == 1; }
}
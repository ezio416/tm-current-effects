// c 2024-03-10
// m 2024-03-10

namespace CurrentEffects {
    class EffectState {
        int    cruise       = 0;
        int    forced       = 0;
        int    fragile      = 0;
        int    noBrakes     = 0;
        int    noEngine     = 0;
        int    noGrip       = 0;
        int    noSteer      = 0;
        int    penalty      = 0;
        int    reactor      = 0;
        string reactorIcon;
        int    reactorLevel = 0;
        float  reactorTimer = 0.0f;
        int    reactorType  = 0;
        int    slowmo       = 0;
        int    turbo        = 0;
        int    vehicle      = 0;

        EffectState() { }
    }
}
/*
c 2023-06-10
m 2023-06-10
*/

namespace Settings {
    [Setting category="General" name="Enabled"]
    bool Show = true;

    [Setting category="General" name="Hide with game UI"]
    bool hideWithGame = true;

    [Setting category="General" name="Hide with Openplanet UI"]
    bool hideWithOP = false;

    [Setting category="General" name="Font size" description="change requires plugin reload"]
    uint FontSize = 16;

    [Setting category="Toggle Options" name="Acceleration Penalty" description="not working yet"]
    bool PenaltyShow = false;

    [Setting category="Toggle Options" name="Cruise Control" description="not working yet"]
    bool CruiseShow = false;

    [Setting category="Toggle Options" name="Engine Off"]
    bool NoEngineShow = true;

    [Setting category="Toggle Options" name="Forced Acceleration"]
    bool ForcedAccelShow = true;

    [Setting category="Toggle Options" name="Fragile" description="not working yet"]
    bool FragileShow = false;

    [Setting category="Toggle Options" name="No Brakes"]
    bool NoBrakesShow = true;

    [Setting category="Toggle Options" name="No Grip"]
    bool NoGripShow = true;

    [Setting category="Toggle Options" name="No Steering"]
    bool NoSteerShow = true;

    [Setting category="Toggle Options" name="Reactor Boost"]
    bool ReactorShow= true;

    [Setting category="Toggle Options" name="Slow-Mo"]
    bool SlowMoShow = true;

    [Setting category="Toggle Options" name="Turbo"]
    bool TurboShow = true;
}
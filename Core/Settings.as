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

    [Setting category="Toggles" name="Acceleration Penalty" description="not working yet"]
    bool PenaltyShow = false;

    [Setting category="Toggles" name="Cruise Control" description="not working yet"]
    bool CruiseShow = false;

    [Setting category="Toggles" name="Engine Off"]
    bool NoEngineShow = true;

    [Setting category="Toggles" name="Forced Acceleration"]
    bool ForcedAccelShow = true;

    [Setting category="Toggles" name="Fragile" description="not working yet"]
    bool FragileShow = false;

    [Setting category="Toggles" name="No Brakes"]
    bool NoBrakesShow = true;

    [Setting category="Toggles" name="No Grip"]
    bool NoGripShow = true;

    [Setting category="Toggles" name="No Steering"]
    bool NoSteerShow = true;

    [Setting category="Toggles" name="Reactor Boost"]
    bool ReactorShow= true;

    [Setting category="Toggles" name="Slow-Mo"]
    bool SlowMoShow = true;

    [Setting category="Toggles" name="Turbo"]
    bool TurboShow = true;
}
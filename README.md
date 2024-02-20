![Signed](https://img.shields.io/badge/Signed-Yes-00AA00)
![Number of downloads](https://img.shields.io/badge/dynamic/json?query=downloads&url=https%3A%2F%2Fopenplanet.dev%2Fapi%2Fplugin%2F382&label=Downloads&color=purple)
![Version](https://img.shields.io/badge/dynamic/json?query=version&url=https%3A%2F%2Fopenplanet.dev%2Fapi%2Fplugin%2F382&label=Version&color=red)
![Game Trackmania](https://img.shields.io/badge/Game-Trackmania-blue)
![Game Maniaplanet](https://img.shields.io/badge/Game-Maniaplanet_4-blue)
# Current Effects
The newest Trackmania has a number of special effects that can be applied to your car, including some helpers and many hinderances. It can be hard to keep track of what you currently have, especially in cases of LOL maps.

For Maniaplanet, this will display all available effects, but can't yet distinguish between turbo levels.

Showcase (older version): https://youtu.be/0rzvJQJC8gc

### Currently working:
- Cruise Control
- Engine Off (Free Wheeling in MP4)
- Forced Acceleration (Fullspeed Ahead in MP4)
- No Brakes
- No Grip
- No Steering
- Reactor Boost (yellow/red, up/down, last-second timer)
- Slow-Mo (all 4 levels)
- Snow Car
- Turbo (all 5 levels, timer)
- Editor playtest
- Playing on servers

### Partially working:
- Viewing replays (most effects unsupported)
- Spectating (some effects unsupported)
- Acceleration penalty (very experimental)
- Fragile (experimental, breaks in some instances (no pun intended))

### Not working/not implemented:
- Reactor Boost (full 6-second timer - the only reason I started this)
- Slow-Mo (timer)

## Exported Functions
Current Effects now allows you to use it as a dependency. To do so, include "CurrentEffects" in your `info.toml`'s dependency list. If you're developing for Trackmania (2020), I recommend also including "VehicleState." Experimental effects for TM2020 require an extra setting which you can access with Get and Set functions. Below are the exported functions which you may use in your own plugins:

- `bool GetForcedAccel()` - Returns true when in Forced Acceleration (Fullspeed Ahead in MP4). Does not work when watching a replay.
- `bool GetNoBrakes()` - Returns true when in No Brakes. Does not work when watching a replay.
- `bool GetNoEngine()` - Returns true when in Engine Off (Free Wheeling in MP4). Does not work when watching a replay.
- `bool GetNoGrip()` - Returns true when in No Grip. Does not work when watching a replay.
- `bool GetNoSteer()` - Returns true when in No Steering. Does not work when watching a replay.

### Trackmania (2020)-specific
- `bool GetExperimental()` - Returns true if experimental features are enabled.
- `void SetExperimental(bool e)` - Allows enabling experimental features from another plugin.
- `bool GetAccelPenalty()` - (Very experimental) Returns true if the player bonked something.
- `bool GetCruiseControl()` - Returns true when in Cruise Control. Does not work when spectating.
- `bool GetFragile()` - (Experimental) Returns true when Fragile. Does not work when watching a replay or spectating.
- `int GetSlowMoLevel()` - Returns the current Slow-Mo level (0-4, 0 being none).
- `bool GetSnowCar()` - Returns true when the current vehicle is the Snow Car.
- `ESceneVehicleVisReactorBoostLvl GetReactorLevel()` - Returns the current Reactor Boost level.
- `float GetReactorFinalTimer()` - Returns 0.0-1.0 in the last second before a Reactor Boost runs out. Does not work when watching a replay.
- `ESceneVehicleVisReactorBoostType GetReactorType()` - Returns the current Reactor Boost type.
- `VehicleState::TurboLevel GetTurboLevel()` - Returns the current Turbo level (0-5, 0 being none). Does not work when spectating. Requires VehicleState dependency.

### Maniaplanet 4-specific
- `bool GetTurbo()` - Returns true when in Turbo.
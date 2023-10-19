/*
c 2023-06-10
m 2023-10-19
*/

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

[Setting category="General" name="Font style/size" description="loading a font for the first time causes game to hang for a bit"]
Font S_Font = Font::DroidSansBold_20;

#if TMNEXT
[Setting category="General" name="Try experimental features" description="warning - may crash your game!"]
bool S_Experimental = false;


[Setting category="Toggles" name="Cruise Control" description="experimental - may not work!"]
bool S_Cruise = false;

[Setting category="Toggles" name="Engine Off"]
bool S_NoEngine = true;

[Setting category="Toggles" name="Forced Acceleration"]
bool S_Forced = true;

[Setting category="Toggles" name="Fragile" description="experimental - may not work!"]
bool S_Fragile = false;

#elif MP4
[Setting category="Toggles" name="Free Wheeling"]
bool S_NoEngine = true;

[Setting category="Toggles" name="Fullspeed Ahead"]
bool S_Forced = true;
#endif

[Setting category="Toggles" name="No Brakes"]
bool S_NoBrakes = true;

[Setting category="Toggles" name="No Grip"]
bool S_NoGrip = true;

[Setting category="Toggles" name="No Steering"]
bool S_NoSteer = true;

#if TMNEXT
[Setting category="Toggles" name="Reactor Boost"]
bool S_Reactor= true;

[Setting category="Toggles" name="Slow-Mo"]
bool S_SlowMo = true;
#endif

[Setting category="Toggles" name="Turbo"]
bool S_Turbo = true;
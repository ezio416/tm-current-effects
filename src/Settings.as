// c 2023-06-10
// m 2024-01-05

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

[Setting category="General" name="Font style/size" description="loading a font for the first time causes game to hang for a bit"]
Font S_Font = Font::DroidSansBold_20;

[Setting category="General" name="Enable all effects" description="helps with choosing custom colors"]
bool S_ShowAll = false;

#if TMNEXT

[Setting category="General" name="Reset all effects" description="Cruise Control/Fragile/Snow Car may get stuck, just click this once"]
bool S_Reset = false;

[Setting category="General" name="Try experimental features" description="warning - may crash your game!"]
bool S_Experimental = false;


[Setting category="Toggles" name="Acceleration Penalty" description="experimental - may not work!"]
bool S_Penalty = false;

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

[Setting category="Toggles" name="Snow Car" description="experimental - may not work!"]
bool S_Snow = true;

#endif

[Setting category="Toggles" name="Turbo"]
bool S_Turbo = true;


[Setting category="Colors" name="Effect Currently Off" color]
vec3 S_OffColor = vec3(0.5f, 0.5f, 0.5f);
string offColor;

string disabledColor;

#if TMNEXT

[Setting category="Colors" name="Effect Unsupported" description="i.e. when spectating, only some effects can be seen" color]
vec3 S_DisabledColor = vec3(0.3f, 0.3f, 0.3f);

[Setting category="Colors" name="Acceleration Penalty" color]
vec3 S_PenaltyColor = vec3(1.0f, 0.0f, 0.0f);
string penaltyColor;

[Setting category="Colors" name="Cruise Control" color]
vec3 S_CruiseColor = vec3(0.226f, 0.564f, 1.0f);
string cruiseColor;

[Setting category="Colors" name="Engine Off" color]
vec3 S_NoEngineColor = vec3(1.0f, 0.0f, 0.0f);
string noEngineColor;

[Setting category="Colors" name="Forced Acceleration" color]
vec3 S_ForcedColor = vec3(0.0f, 1.0f, 0.0f);
string forcedColor;

[Setting category="Colors" name="Fragile" color]
vec3 S_FragileColor = vec3(1.0f, 0.648f, 0.0f);
string fragileColor;

#elif MP4

[Setting category="Colors" name="Free Wheeling" color]
vec3 S_NoEngineColor = vec3(1.0f, 0.0f, 0.0f);
string noEngineColor;

[Setting category="Colors" name="Fullspeed Ahead" color]
vec3 S_ForcedColor = vec3(0.0f, 1.0f, 0.0f);
string forcedColor;

#endif

[Setting category="Colors" name="No Brakes" color]
vec3 S_NoBrakesColor = vec3(1.0f, 0.848f, 0.0f);
string noBrakesColor;

[Setting category="Colors" name="No Grip" color]
vec3 S_NoGripColor = vec3(0.049f, 0.861f, 1.0f);
string noGripColor;

[Setting category="Colors" name="No Steering" color]
vec3 S_NoSteerColor = vec3(0.951f, 0.0f, 1.0f);
string noSteerColor;

#if TMNEXT

[Setting category="Colors" name="Reactor Boost 1 (yellow/green)" color]
vec3 S_Reactor1Color = vec3(0.766f, 1.0f, 0.0f);
string reactor1Color;

[Setting category="Colors" name="Reactor Boost 2 (red/orange)" color]
vec3 S_Reactor2Color = vec3(1.0f, 0.463f, 0.0f);
string reactor2Color;

[Setting category="Colors" name="Slow-Mo 1" color]
vec3 S_SlowMo1Color = vec3(0.0f, 1.0f, 0.0f);
string slowMo1Color;

[Setting category="Colors" name="Slow-Mo 2" color]
vec3 S_SlowMo2Color = vec3(1.0f, 1.0f, 0.0f);
string slowMo2Color;

[Setting category="Colors" name="Slow-Mo 3" color]
vec3 S_SlowMo3Color = vec3(1.0f, 0.663f, 0.0f);
string slowMo3Color;

[Setting category="Colors" name="Slow-Mo 4" color]
vec3 S_SlowMo4Color = vec3(1.0f, 0.0f, 0.0f);
string slowMo4Color;

[Setting category="Colors" name="Snow Car" color]
vec3 S_SnowColor = vec3(0.0f, 1.0f, 1.0f);
string snowColor;

[Setting category="Colors" name="Turbo 1 (yellow)" color]
vec3 S_Turbo1Color = vec3(1.0f, 1.0f, 0.0f);
string turbo1Color;

[Setting category="Colors" name="Turbo 2 (red - super)" color]
vec3 S_Turbo2Color = vec3(1.0f, 0.0f, 0.0f);
string turbo2Color;

[Setting category="Colors" name="Turbo 3 (roulette yellow)" color]
vec3 S_Turbo3Color = vec3(1.0f, 1.0f, 0.0f);
string turbo3Color;

[Setting category="Colors" name="Turbo 4 (roulette cyan - super)" color]
vec3 S_Turbo4Color = vec3(0.0f, 1.0f, 1.0f);
string turbo4Color;

[Setting category="Colors" name="Turbo 5 (roulette purple - ultra)" color]
vec3 S_Turbo5Color = vec3(1.0f, 0.0f, 1.0f);
string turbo5Color;

#elif MP4

[Setting category="Colors" name="Turbo" color]
vec3 S_TurboColor = vec3(0.0f, 1.0f, 0.0f);
string turboColor;

#endif
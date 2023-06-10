/*
c 2023-06-10
m 2023-06-10
*/

const string BLUE   = "\\$09D";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";
string DefaultColor = GRAY;
UI::Font@ font = null;

// bool Cruise;
string CruiseColor = DefaultColor;
bool   ForcedAccel;
string ForcedAccelColor;
// bool Fragile;
string FragileColor = DefaultColor;
bool   NoBrakes;
string NoBrakesColor;
bool   NoEngine;
string NoEngineColor;
bool   NoGrip;
string NoGripColor;
bool   NoSteer;
string NoSteerColor;
// bool   Penalty;
string PenaltyColor = DefaultColor;
string ReactorColor;
string ReactorIcon = Icons::Rocket;
uint   ReactorLevel;
uint   ReactorType;
float  SlowMo;
string SlowMoColor;
bool   Turbo;
string TurboColor;
// c 2024-01-10
// m 2024-01-11

#if SIG_DEVELOPER && TMNEXT

const string BLUE   = "\\$09D";
const string CYAN   = "\\$2FF";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";

enum DataType {
    Bool,
    Int8,
    Uint8,
    Int16,
    Uint16,
    Int32,
    Uint32,
    Int64,
    Uint64,
    Float,
    // Double,
    Vec2,
    Vec3,
    Vec4,
    // Iso3,
    Iso4,
    // Nat2,
    // Nat3,
    // String
    Enum
}

enum ContactState1 {
    Air                     = 0,
    Unknown                 = 4,
    Ground                  = 8,
    TopContactWheels        = 16,
    TopContact              = 24,
    WheelsBurning           = 40,
    TopContactWheelsBurning = 56
}

enum ContactState2 {
    Unknown        = -104,
    Air            = -64,
    Falling        = -63,
    ReactorRaising = -60,
    ReactorFalling = -59,
    Ground         = -48,
    ReactorGround  = -40
}

shared enum FallingState {
    FallingAir    = 0,
    FallingWater  = 2,
    RestingGround = 4,
    RestingWater  = 6,
    GlidingGround = 8
}

enum TurboState {
    SelfFalse   = 8,
    SelfTrue    = 9,
    ReplayFalse = 28,
    ReplayTrue  = 29
}

string IntToHex(int i) {
    return "0x" + Text::Format("%X", i);
}

string Round(bool b) {
    return (b ? GREEN : RED) + b;
}

string Round(int num) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Math::Abs(num);
}

string Round(float num, uint precision = S_Precision) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Text::Format("%." + precision + "f", Math::Abs(num));
}

string Round(vec2 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision);
}

string Round(vec3 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision) + "\\$G , " + Round(vec.z, precision);
}

string Round(vec4 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision) + "\\$G , " + Round(vec.z, precision) + "\\$G , " + Round(vec.w, precision);
}

string Round(iso4 iso, uint precision = S_Precision) {
    string ret;

    ret += Round(iso.tx, precision) + "\\$G , " + Round(iso.ty, precision) + "\\$G , " + Round(iso.tz, precision) + "\n";
    ret += Round(iso.xx, precision) + "\\$G , " + Round(iso.xy, precision) + "\\$G , " + Round(iso.xz, precision) + "\n";
    ret += Round(iso.yx, precision) + "\\$G , " + Round(iso.yy, precision) + "\\$G , " + Round(iso.yz, precision) + "\n";
    ret += Round(iso.zx, precision) + "\\$G , " + Round(iso.zy, precision) + "\\$G , " + Round(iso.zz, precision);

    return ret;
}

string RoundUint(uint num) {  // separate function else a uint gets converted to an int, losing data
    return (num == 0 ? WHITE : GREEN) + num;
}

#endif
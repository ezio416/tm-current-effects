// c 2024-01-10
// m 2024-02-19

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

void HelpTextClickCopy() {
    UI::TextWrapped("Click on any value to copy it to your clipboard.");
}

void HelpTextPosNeg() {
    UI::TextWrapped("Values marked white are 0/enums/strings, " + GREEN + "green\\$G are positive/true/valid, and " + RED + "red\\$G are negative/false/null/empty.");
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

string[] OffsetValue(CMwNod@ Nod, int offset, const string &in name, DataType type, bool known = true) {
    string value;

    switch (type) {
        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (Nod, offset) == 1); break;
        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (Nod, offset));      break;
        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (Nod, offset));      break;
        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (Nod, offset));      break;
        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Nod, offset));      break;
        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (Nod, offset));      break;
        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Nod, offset));      break;
        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (Nod, offset));      break;
        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Nod, offset));      break;
        case DataType::Float:  value = Round(    Dev::GetOffsetFloat (Nod, offset));      break;
        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (Nod, offset));      break;
        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3  (Nod, offset));      break;
        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (Nod, offset));      break;
        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (Nod, offset));      break;
        default:;
    }

    return { tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

string[] OffsetValue(CSceneVehicleVis@ Vis, int offset, const string &in name, DataType type, bool known = true) {
    string value;

    switch (type) {
        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (Vis, offset) == 1); break;
        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (Vis, offset));      break;
        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (Vis, offset));      break;
        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (Vis, offset));      break;
        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Vis, offset));      break;
        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (Vis, offset));      break;
        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Vis, offset));      break;
        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (Vis, offset));      break;
        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Vis, offset));      break;
        case DataType::Float:  value = Round(    Dev::GetOffsetFloat (Vis, offset));      break;
        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (Vis, offset));      break;
        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3  (Vis, offset));      break;
        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (Vis, offset));      break;
        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (Vis, offset));      break;
        default:;
    }

    return { tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

string[] OffsetValue(CSceneVehicleVisState@ State, int offset, const string &in name, DataType type, bool known = true) {
    string value;

    if (name.EndsWith("GroundContactMaterial")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(EPlugSurfaceMaterialId(num));
    } else if (name.EndsWith("GroundContactEffect")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(EPlugSurfaceGameplayId(num));
    } else if (name.EndsWith("Falling")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(FallingState(num));
    } else {
        switch (type) {
            case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (State, offset) == 1); break;
            case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (State, offset));      break;
            case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (State, offset));      break;
            case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (State, offset));      break;
            case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(State, offset));      break;
            case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (State, offset));      break;
            case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(State, offset));      break;
            case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (State, offset));      break;
            case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(State, offset));      break;
            case DataType::Float:  value = Round(    Dev::GetOffsetFloat (State, offset));      break;
            case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (State, offset));      break;
            case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3  (State, offset));      break;
            case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (State, offset));      break;
            case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (State, offset));      break;
            default:;
        }
    }

    return { tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

#endif
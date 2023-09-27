/*
c 2023-09-26
m 2023-09-26
*/

uint16 handicapOffset = 0;

int GetHandicapSum(CSceneVehicleVisState@ state) {
    if (handicapOffset == 0) {
        auto type = Reflection::GetType("CSceneVehicleVisState");
        if (type is null) {
            error("Unable to find reflection info for CSceneVehicleVisState!");
            return 0;
        }
        handicapOffset = type.GetMember("TurboTime").Offset + 12;
    }

    return Dev::GetOffsetInt32(state, handicapOffset);
}

void SetHandicaps(int sum) {
    switch (sum) {
        case 256: case 257: case 258:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1024: case 1025: case 1026:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1280: case 1281: case 1282:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 1536: case 1537: case 1538:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = DefaultColor;
            break;
        case 2048: case 2049: case 2050:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 2304: case 2305: case 2306:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3072: case 3073: case 3074:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3328: case 3329: case 3330:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 3584: case 3585: case 3586:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = DefaultColor;
            break;
        case 4096: case 4097: case 4098:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 4352: case 4353: case 4354:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5120: case 5121: case 5122:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5376: case 5377: case 5378:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5632: case 5633: case 5634:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 5888: case 5889: case 5890:
            NoEngineColor = RED;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = DefaultColor;
            NoGripColor   = BLUE;
            break;
        case 6144: case 6145: case 6146:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        case 6400: case 6401: case 6402:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        case 7424: case 7425: case 7426:
            NoEngineColor = RED;
            ForcedColor   = DefaultColor;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        case 7680: case 7681: case 7682:
            NoEngineColor = DefaultColor;
            ForcedColor   = GREEN;
            NoBrakesColor = ORANGE;
            NoSteerColor  = PURPLE;
            NoGripColor   = BLUE;
            break;
        default:
            NoEngineColor = DefaultColor;
            ForcedColor   = DefaultColor;
            NoBrakesColor = DefaultColor;
            NoGripColor   = DefaultColor;
            NoSteerColor  = DefaultColor;
    }
}
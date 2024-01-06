// c 2023-09-26
// m 2024-01-05

uint16 handicapOffset = 0;

int GetHandicapSum(CSceneVehicleVisState@ state) {

#if TMNEXT

    if (handicapOffset == 0) {
        const Reflection::MwClassInfo@ type = Reflection::GetType("CSceneVehicleVisState");

        if (type is null) {
            error("Unable to find reflection info for CSceneVehicleVisState!");
            return 0;
        }

        handicapOffset = type.GetMember("TurboTime").Offset + 12;
    }

    return Dev::GetOffsetInt32(state, handicapOffset);

#elif MP4
    return int(state.ActiveEffects);
#endif
}

void SetHandicaps(int sum) {

#if TMNEXT

    switch (sum) {
        case 256: case 257: case 258:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 1024: case 1025: case 1026:
            forced   = 0;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 1280: case 1281: case 1282:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 1536: case 1537: case 1538:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 2048: case 2049: case 2050:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 2304: case 2305: case 2306:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 3072: case 3073: case 3074:
            forced   = 0;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 3328: case 3329: case 3330:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 3584: case 3585: case 3586:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 4096: case 4097: case 4098:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 4352: case 4353: case 4354:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 5120: case 5121: case 5122:
            forced   = 0;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 5376: case 5377: case 5378:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 5632: case 5633: case 5634:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 5888: case 5889: case 5890:
            forced   = 1;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 6144: case 6145: case 6146:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 6400: case 6401: case 6402:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 7424: case 7425: case 7426:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 7680: case 7681: case 7682:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 1;
            break;
        default:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 0;
    }

#elif MP4

    switch (sum) {
        case 1:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 5:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 6:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 0;
            break;
        case 8:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 9:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 13:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 14:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 1;
            break;
        case 16:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 17:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 21:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 22:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 0;
            break;
        case 24:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 25:
            forced   = 0;
            noBrakes = 0;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 29:
            forced   = 0;
            noBrakes = 1;
            noEngine = 1;
            noGrip   = 1;
            noSteer  = 1;
            break;
        case 30:
            forced   = 1;
            noBrakes = 1;
            noEngine = 0;
            noGrip   = 1;
            noSteer  = 1;
            break;
        default:
            forced   = 0;
            noBrakes = 0;
            noEngine = 0;
            noGrip   = 0;
            noSteer  = 0;
            break;
    }

#endif
}
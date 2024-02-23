// c 2023-09-26
// m 2024-02-23

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

    noEngine = (sum & 0x100  == 0x100)  ? 1 : 0;
    forced   = (sum & 0x200  == 0x200)  ? 1 : 0;
    noBrakes = (sum & 0x400  == 0x400)  ? 1 : 0;
    noSteer  = (sum & 0x800  == 0x800)  ? 1 : 0;
    noGrip   = (sum & 0x1000 == 0x1000) ? 1 : 0;

#elif MP4

    noEngine = (sum & 0x1  == 0x1)  ? 1 : 0;
    forced   = (sum & 0x2  == 0x2)  ? 1 : 0;
    noBrakes = (sum & 0x4  == 0x4)  ? 1 : 0;
    noSteer  = (sum & 0x8  == 0x8)  ? 1 : 0;
    noGrip   = (sum & 0x10 == 0x10) ? 1 : 0;

#endif
}
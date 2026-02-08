uint16 GetMemberOffset(const string &in className, const string &in memberName) {
    const Reflection::MwClassInfo@ type = Reflection::GetType(className);

    if (type is null)
        throw("Unable to find reflection info for " + className);

    const Reflection::MwMemberInfo@ member = type.GetMember(memberName);

    return member.Offset;
}

#if TMNEXT

uint16 handicapFlagsOffset = 0;
uint16 sparks1offset       = 0;
uint16 sparks2offset       = 0;
uint16 sparks3Offset       = 0;

int GetHandicapFlags(CSceneVehicleVisState@ State) {
    if (handicapFlagsOffset == 0)
        handicapFlagsOffset = GetMemberOffset("CSceneVehicleVisState", "TurboTime") + 12;

    return Dev::GetOffsetInt32(State, handicapFlagsOffset);
}

int GetSparks1(CSceneVehicleVisState@ State) {  // front/back impact strength? 0 - 16,843,009
    if (sparks1offset == 0)
        sparks1offset = GetMemberOffset("CSceneVehicleVisState", "WaterImmersionCoef") - 8;

    return Dev::GetOffsetInt32(State, sparks1offset);
}

int GetSparks2(CSceneVehicleVisState@ State) {  // back impact? 0 - 1
    if (sparks2offset == 0)
        sparks2offset = GetMemberOffset("CSceneVehicleVisState", "WaterImmersionCoef") - 4;

    return Dev::GetOffsetInt32(State, sparks2offset);
}

int GetSparks3(CSceneVehicleVisState@ State) {  // any impact? 0 - ~1,065,000,000
    if (sparks3Offset == 0)
        sparks3Offset = GetMemberOffset("CSceneVehicleVisState", "WetnessValue01") + 8;

    return Dev::GetOffsetInt32(State, sparks3Offset);
}

#endif

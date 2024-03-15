// c 2024-02-26
// m 2024-03-15

uint16 GetMemberOffset(const string &in className, const string &in memberName) {
    const Reflection::MwClassInfo@ type = Reflection::GetType(className);

    if (type is null)
        throw("Unable to find reflection info for " + className);

    const Reflection::MwMemberInfo@ member = type.GetMember(memberName);

    return member.Offset;
}

#if TMNEXT

uint16 cruiseOffset        = 0;
uint16 handicapFlagsOffset = 0;
uint16 sparks1offset       = 0;
uint16 sparks2offset       = 0;
uint16 sparks3Offset       = 0;
uint16 vehicleTypeOffset   = 0;

int GetCruiseSpeed(CSceneVehicleVisState@ State) {
    if (cruiseOffset == 0)
        cruiseOffset = GetMemberOffset("CSceneVehicleVisState", "FrontSpeed") + 12;

    return Dev::GetOffsetInt32(State, cruiseOffset);
}

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

int GetVehicleType(CSceneVehicleVisState@ State) {
    if (vehicleTypeOffset == 0)
        vehicleTypeOffset = GetMemberOffset("CSceneVehicleVisState", "InputSteer") - 8;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (
        Playground is null
        || Playground.Arena is null
        || Playground.Arena.Resources is null
        || Playground.Arena.Resources.m_AllGameItemModels.Length == 0
    )
        return 1;  // stadium

    const uint index = Dev::GetOffsetUint8(State, vehicleTypeOffset);

    if (index < Playground.Arena.Resources.m_AllGameItemModels.Length) {
        CGameItemModel@ Model = Playground.Arena.Resources.m_AllGameItemModels[index];
        if (Model is null)
                return 1;  // stadium

        switch (Model.Id.Value) {
            case 0x4000625B: return 0;  // pilot
            case 0x40004C95: return 1;  // stadium
            case 0x400016D9: return 2;  // snow
            case 0x40003CE4: return 3;  // rally
            // case 0x4000????: return 4;  // desert
            default: return 1;  // stadium
        }
    }

    return 1;  // stadium
}

#endif
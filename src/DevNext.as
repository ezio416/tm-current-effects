// - all Dev:: (and related) calls for the plugin live here
// - this should make it easier for maintainers and reviewers
// - namespaced so source files can be grepped for "Danger::"

#if TMNEXT

// valid for game version 2026-02-02_17_51, 2026-07-22_18_27

namespace Danger {
    // indices
    const uint I_SCENE_ARENAVISMGR = 56;

    // offsets
    const uint16 O_APP_VEHICLEMGR             = GetMemberOffset("CTrackMania", "GameScene") + 0x8;
    const uint16 O_ARENARULES_LAP_COUNT       = GetMemberOffset("CSmArenaRules", "RulesMode") - 0x30;
    const uint16 O_ARENAVISMGR_WP_COUNT       = 0x1318;
    const uint16 O_MAP_CP_COUNT               = GetMemberOffset("CGameCtnChallenge", "ScriptMetadata") + 0x98;
    const uint16 O_PLAYER_VEHICLE             = GetMemberOffset("CSmPlayer", "Score") + 0xb0;
    const uint16 O_PROFILE_GHOST_VIS          = GetMemberOffset("CGameUserProfile", "Editor_ShowHelp") - 0x94;
    const uint16 O_PROFILE_NAMETAG_VIS        = GetMemberOffset("CGameUserProfile", "Editor_ShowHelp") - 0x78;
    const uint16 O_SCENE_MANAGER_COUNT        = 0x8;
    const uint16 O_SCENE_MANAGERS             = 0x10;
    const uint16 O_TERMINAL_ALT_CAMERA        = GetMemberOffset("CGameTerminal", "GUIPlayer") + 0x10;
    const uint16 O_TERMINAL_BW_CAMERA         = GetMemberOffset("CGameTerminal", "MediaClipPlayer") - 0x2c;
    const uint16 O_TERMINAL_CUR_CAMERA        = GetMemberOffset("CGameTerminal", "GUIPlayer") + 0x14;
    const uint16 O_TERMINAL_GHOST_ENTITY_ID   = GetMemberOffset("CGameTerminal", "MediaAmbianceClipPlayer") + 0x6c;
    const uint16 O_TUNINGS_SLOWMO_DURATION    = 0x36e4;
    const uint16 O_VEHICLE_BRAKE_PEDAL        = 0x9c;
    const uint16 O_VEHICLE_FRAGILE            = 0x1360;
    const uint16 O_VEHICLE_LAUNCH_RESPAWNING  = 0x1394;
    const uint16 O_VEHICLE_REACTOR_DURATION   = 0x13bc;
    const uint16 O_VEHICLE_REACTOR_START_TICK = 0x13b0;
    const uint16 O_VEHICLE_RESPAWN_END_TICK   = 0x12dc;
    const uint16 O_VEHICLE_SLOWMO_END_TICK    = 0x1380;
    const uint16 O_VEHICLE_STAND_RESPAWNING   = 0x16e8;
    const uint16 O_VEHICLE_STEER_LIMIT        = 0x1720;
    const uint16 O_VEHICLE_TUNINGS            = 0x88;
    const uint16 O_VEHICLEMGR_VEHICLES        = 0x910;
    const uint16 O_VEHICLES_DESERT            = 0 * 0x10 + 0x8;
    const uint16 O_VEHICLES_RALLY             = 3 * 0x10 + 0x8;
    const uint16 O_VEHICLES_SNOW              = 1 * 0x10 + 0x8;
    const uint16 O_VEHICLES_STADIUM           = 2 * 0x10 + 0x8;
    const uint16 O_VIS_ENTITY_ID              = 0x0;
    const uint16 O_VISSTATE_HANDICAPS         = GetMemberOffset("CSceneVehicleVisState", "RaceStartTime") + 0x4;
    const uint16 O_VISSTATE_ITEM_MODEL_INDEX  = 0x8;
    const uint16 O_WRAPPER_OPPONENT_VIS       = GetMemberOffset("CGameUserProfileWrapper", "ProfileOld") + 0x38;

    bool GetBrakePedal(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetFloat(Vehicle, O_VEHICLE_BRAKE_PEDAL) == 1.0f;
    }

    uint GetCheckpointCount(CGameCtnChallenge@ Map) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Map, O_MAP_CP_COUNT);
    }

    CurrentEffects::Camera GetCurrentCamera(CGameTerminal@ Terminal) {
        if (!Safety::ShouldRun()) {
            return CurrentEffects::Camera::Unknown;
        }

        const bool alt = Dev::GetOffsetUint32(Terminal, O_TERMINAL_ALT_CAMERA) == 0;

        const uint cam = Dev::GetOffsetUint32(Terminal, O_TERMINAL_CUR_CAMERA);
        if (cam == 0x2) {
            return alt ? CurrentEffects::Camera::Alt7 : CurrentEffects::Camera::Cam7;
        }

        const bool backwards = Dev::GetOffsetUint32(Terminal, O_TERMINAL_BW_CAMERA) == 1;
        if (backwards) {
            return CurrentEffects::Camera::Backwards;
        }

        switch (cam) {
            case 0x12: return alt ? CurrentEffects::Camera::Alt1 : CurrentEffects::Camera::Cam1;
            case 0x13: return alt ? CurrentEffects::Camera::Alt2 : CurrentEffects::Camera::Cam2;
            case 0x14: return alt ? CurrentEffects::Camera::Alt3 : CurrentEffects::Camera::Cam3;
            default:   return CurrentEffects::Camera::Unknown;
        }
    }

    uint GetEntityId(CSceneVehicleVis@ Vis) {
        if (!Safety::ShouldRun()) {
            return 0x0;
        }

        return Dev::GetOffsetUint32(Vis, O_VIS_ENTITY_ID);
    }

    bool GetFragile(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_FRAGILE) == 1;
    }

    bool GetGhostVisibility(CGameUserProfile@ Profile) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetUint32(Profile, O_PROFILE_GHOST_VIS) == 1;
    }

    uint8 GetHandicaps(CSceneVehicleVisState@ Vis) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return uint8(Dev::GetOffsetUint16(Vis, O_VISSTATE_HANDICAPS) >> 0x8);
    }

    uint8 GetItemModelIndex(CSceneVehicleVisState@ Vis) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint8(Vis, O_VISSTATE_ITEM_MODEL_INDEX);
    }

    uint GetLapCount(CSmArenaRules@ Rules) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Rules, O_ARENARULES_LAP_COUNT);
    }

    bool GetLaunchRespawning(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_LAUNCH_RESPAWNING) == 1;
    }

    bool GetNametagVisibility(CGameUserProfile@ Profile) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetUint32(Profile, O_PROFILE_NAMETAG_VIS) == 1;
    }

    CurrentEffects::OpponentVis GetOpponentVisibility(CGameUserProfileWrapper@ Wrapper) {
        if (!Safety::ShouldRun()) {
            return CurrentEffects::OpponentVis::Unknown;
        }

        return CurrentEffects::OpponentVis(Dev::GetOffsetUint32(Wrapper, O_WRAPPER_OPPONENT_VIS));
    }

    uint64 GetPointer(CSceneVehicleVis@ Vis) {
        if (!Safety::ShouldRun()) {
            return 0x0;
        }

        return Dev::ForceCast<uint64>(Vis).Get();
    }

    uint GetReactorDuration(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_REACTOR_DURATION);
    }

    uint GetReactorStartTick(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_REACTOR_START_TICK);
    }

    uint GetRespawnEndTick(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_RESPAWN_END_TICK);
    }

    uint GetSlowMoDuration(CMwNod@ Tunings) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Tunings, O_TUNINGS_SLOWMO_DURATION);
    }

    uint GetSlowMoEndTick(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        return Dev::GetOffsetUint32(Vehicle, O_VEHICLE_SLOWMO_END_TICK);
    }

    bool GetStandRespawning(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return false;
        }

        return Dev::GetOffsetInt32(Vehicle, O_VEHICLE_STAND_RESPAWNING) == -1;  // why -1?
    }

    float GetSteerLimit(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return 0.0f;
        }

        return Dev::GetOffsetFloat(Vehicle, O_VEHICLE_STEER_LIMIT);
    }

    CMwNod@ GetTunings(CMwNod@ Vehicle) {
        if (!Safety::ShouldRun()) {
            return null;
        }

        return Dev::GetOffsetNod(Vehicle, O_VEHICLE_TUNINGS);
    }

    CMwNod@ GetVehicle(CSmPlayer@ Player, const uint8 index) {
        if (false
            or index > 4  // stadium, snow, rally, desert
            or !Safety::ShouldRun()
        ) {
            return null;
        }

        return Dev::GetOffsetNod(Player, O_PLAYER_VEHICLE + index * 0x10);
    }

    CMwNod@ GetVehicleSecondary(const CurrentEffects::VehicleType type) {  // prefer not to use this one
        if (!Safety::ShouldRun()) {
            return null;
        }

        auto Mgr = Dev::GetOffsetNod(GetApp(), O_APP_VEHICLEMGR);
        if (Mgr is null) {
            return null;
        }

        auto Vehicles = Dev::GetOffsetNod(Mgr, O_VEHICLEMGR_VEHICLES);
        if (Vehicles is null) {
            return null;
        }

        switch (type) {
            case CurrentEffects::VehicleType::Desert:
                return Dev::GetOffsetNod(Vehicles, O_VEHICLES_DESERT);
            case CurrentEffects::VehicleType::Snow:
                return Dev::GetOffsetNod(Vehicles, O_VEHICLES_SNOW);
            case CurrentEffects::VehicleType::Stadium:
                return Dev::GetOffsetNod(Vehicles, O_VEHICLES_STADIUM);
            case CurrentEffects::VehicleType::Rally:
                return Dev::GetOffsetNod(Vehicles, O_VEHICLES_RALLY);
        }

        return null;
    }

    uint GetViewingGhostEntityId(CGameTerminal@ Terminal) {
        if (!Safety::ShouldRun()) {
            return 0x0;
        }

        return Dev::GetOffsetUint32(Terminal, O_TERMINAL_GHOST_ENTITY_ID);
    }

    uint GetWaypointCount(ISceneVis@ Scene) {
        if (!Safety::ShouldRun()) {
            return 0;
        }

        const uint mgrCount = Dev::GetOffsetUint32(Scene, O_SCENE_MANAGER_COUNT);
        if (I_SCENE_ARENAVISMGR >= mgrCount) {
            return 0;
        }

        auto Mgr = Dev::GetOffsetNod(Scene, O_SCENE_MANAGERS + 0x8 * I_SCENE_ARENAVISMGR);
        if (Mgr is null) {
            return 0;
        }

        return Dev::GetOffsetUint32(Mgr, O_ARENAVISMGR_WP_COUNT);
    }
}

#endif

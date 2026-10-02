// - all Dev:: (and related) calls for the plugin live here
// - this should make it easier for maintainers and reviewers
// - namespaced so source files can be grepped for "Danger::"

#if MP4

// valid for game version 2019-11-19_18_50

namespace Danger {
    // addresses
    const uint64 A_OPPONENT_VIS = Dev::BaseAddress() + 0x1b42bc8;  // global variable access, not ideal

    // offsets
    const uint16 O_CAMERA_SYSTEM_BW_CAMERA = 0xa0;
    const uint16 O_PLAYER_ENTITY_ID        = GetMemberOffset("CGamePlayer", "User") + 0x2ac;
    const uint16 O_PLAYER_VIS              = GetMemberOffset("CGamePlayer", "User") + 0x2a0;
    const uint16 O_TERMINAL_ALT_CAMERA     = GetMemberOffset("CGameTerminal", "CameraSet") + 0x18;
    const uint16 O_TERMINAL_CUR_CAMERA     = GetMemberOffset("CGameTerminal", "CameraSet") + 0x10;
    const uint16 O_VIS_ENTITY_ID           = 0x0;
    const uint16 O_VIS_TURBO_TIMER         = 0x608;  // should probably add this to VehicleState

    CurrentEffects::Camera GetCurrentCamera(CGameTerminal@ Terminal) {
        const uint cam = Dev::GetOffsetUint32(Terminal, O_TERMINAL_CUR_CAMERA);
        if (cam == 0x2) {
            const bool alt = Dev::GetOffsetUint32(Terminal, O_TERMINAL_ALT_CAMERA) == 0;
            return alt ? CurrentEffects::Camera::Alt7 : CurrentEffects::Camera::Cam7;
        }

        if (Terminal.CameraSet is null) {
            return CurrentEffects::Camera::Unknown;
        }

        const bool backwards = Dev::GetOffsetUint32(Terminal.CameraSet, O_CAMERA_SYSTEM_BW_CAMERA) == 4;  // why 4?
        if (backwards) {
            return CurrentEffects::Camera::Backwards;
        }

        switch (cam) {
            case 0x12: return CurrentEffects::Camera::Cam1;
            case 0x13: return CurrentEffects::Camera::Cam2;
            case 0x14: return CurrentEffects::Camera::Cam3;
            default:   return CurrentEffects::Camera::Unknown;
        }
    }

    uint GetEntityId(CGamePlayer@ Player) {
        return Dev::GetOffsetUint32(Player, O_PLAYER_ENTITY_ID);
    }

    uint GetEntityId(CSceneVehicleVis@ Vis) {
        return Dev::GetOffsetUint32(Vis, O_VIS_ENTITY_ID);
    }

    CurrentEffects::OpponentVis GetOpponentVisibility() {
        return CurrentEffects::OpponentVis(Dev::ReadUint32(A_OPPONENT_VIS));
    }

    float GetTurboTimer(CMwNod@ Vis) {  // using CSceneVehicleVis crashes game
        return Dev::GetOffsetFloat(Vis, O_VIS_TURBO_TIMER);
    }

    CSceneVehicleVis@ GetVis(CGamePlayer@ Player) {
        return cast<CSceneVehicleVis>(Dev::GetOffsetNod(Player, O_PLAYER_VIS));
    }
}

#endif

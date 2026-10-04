// - all Dev:: (and related) calls for the plugin live here
// - this should make it easier for maintainers and reviewers
// - namespaced so source files can be grepped for "Danger::"

#if TURBO

// valid for game version 2016-11-07_16_15

namespace Danger {
    // offsets
    const uint16 O_TERMINAL_CUR_CAMERA = GetMemberOffset("CGameTerminal", "CameraSet") + 0xc;

    CurrentEffects::Camera GetCurrentCamera(CGameTerminal@ Terminal) {
        switch (Dev::GetOffsetUint32(Terminal, O_TERMINAL_CUR_CAMERA)) {
            case 0x4: return CurrentEffects::Camera::Cam1;
            case 0x5: return CurrentEffects::Camera::Cam2;
            case 0x6: return CurrentEffects::Camera::Cam3;
            default:  return CurrentEffects::Camera::Unknown;
        }
    }
}

#endif

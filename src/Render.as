enum Style {
    Legacy,
}

void RenderLegacy() {
    uint available = 0;
    for (uint i = 0; i < g_statuses.Length; i++) {
        if (g_statuses[i].available) {
            available++;
            break;
        }
    }
    if (available == 0) {
        return;
    }

    if (S_HideInactive) {
        uint active = 0;
        for (uint i = 0; i < g_statuses.Length; i++) {
            if (g_statuses[i].active and g_statuses[i].enabled) {
                active++;
                break;
            }
        }
        if (active == 0) {
            return;
        }
    }

    const int flags = UI::GetDefaultWindowFlags()
        | UI::WindowFlags::AlwaysAutoResize
        | UI::WindowFlags::NoFocusOnAppearing
        | UI::WindowFlags::NoTitleBar
    ;

    if (UI::Begin(PLUGIN_TITLE + "###main-" + PLUGIN_META.ID, S_Enabled, flags)) {
        UI::PushFont(g_font, S_FontSize);
        RenderLegacyWindow();
        UI::PopFont();
    }
    try {  // UI assertion fails when last item has progress bar but it's fine
        UI::End();
    } catch { }
}

void RenderLegacyWindow() {
    if (g_state.viewMode == CurrentEffects::ViewMode::Replay) {
        UI::Text("watching replay:");
        UI::Text(g_state.name.Length > 0 ? g_state.name : "(multiple)");
    } else if (g_state.viewMode == CurrentEffects::ViewMode::Spectate) {
        UI::Text("spectating:");
        UI::Text(g_state.name);
    }

    for (uint i = 0; i < g_statuses.Length; i++) {
        if (g_statuses[i].available) {
            g_statuses[i].RenderLegacy();
        }
    }
}

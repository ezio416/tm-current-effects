enum Style {
    Legacy,
}

void RenderLegacy() {
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
    uint count = 0;

    for (uint i = 0; i < g_statuses.Length; i++) {
        if (g_statuses[i].available) {
            g_statuses[i].RenderLegacy();
            count++;
        }
    }

    if (count == 0) {
        UI::Text("\\$f00all statuses disabled :(");
    }
}

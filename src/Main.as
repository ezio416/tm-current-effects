const string  PLUGIN_COLOR = "\\$f00";
const string  PLUGIN_ICON  = Icons::Code;
Meta::Plugin@ PLUGIN_META  = Meta::ExecutingPlugin();
const string  PLUGIN_TITLE = PLUGIN_COLOR + PLUGIN_ICON + "\\$g " + PLUGIN_META.Name;

void Main() {
    ChangeFont();
    OnSettingsChanged();

#if TMNEXT
    Safety::CheckAsync();
#endif
}

void OnSettingsChanged() {
    Color::SetStrings();
}

void Render() {
    if (false
        or !S_Enabled
        or g_state.p_vis == 0x0
        or (true
            and S_HideWithGame
            and !UI::IsGameUIVisible()
        )
        or (true
            and S_HideWithOP
            and !UI::IsOverlayShown()
        )
    ) {
        return;
    }

    RenderLegacy();
}

void RenderMenu() {
    if (UI::MenuItem(PLUGIN_TITLE, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}

void Update(float) {
    g_state.Update();
}

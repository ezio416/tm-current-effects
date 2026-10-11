const string TIME_FORMAT_REFERENCE_LINK = "https://cplusplus.com/reference/ctime/strftime/";

#if TMNEXT

Status@[] g_statuses = {
    ActionKey(),
    Checkpoints(),
    CheckpointTime(),
    Clock(1),
    Clock(2),
    Clock(3),
    CruiseControl(),
    NoEngine(),
    ExeVersion(),
    ForcedAccel(),
    Fps(),
    Fragile(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
    MapType(),
    MapUid(),
    Nametags(),
    NoBrakes(),
    NoGrip(),
    NoSteer(),
    Opponents(),
    RaceTime(),
    Reactor(),
    Respawning(),
    Sequence(),
    SlowMo(),
    Turbo(),
    VehicleType(),
    Water(),
};

#elif MP4

const Status@[] g_statuses = {
    Checkpoints(),
    CheckpointTime(),
    Clock(1),
    Clock(2),
    Clock(3),
    ExeVersion(),
    ForcedAccel(),
    Fps(),
    NoEngine(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
    MapType(),
    MapUid(),
    Nametags(),
    NoBrakes(),
    NoGrip(),
    NoSteer(),
    Opponents(),
    RaceTime(),
    Sequence(),
    Turbo(),
    VehicleType(),
};

#elif TURBO

const Status@[] g_statuses = {
    Checkpoints(),
    CheckpointTime(),
    Clock(1),
    Clock(2),
    Clock(3),
    ExeVersion(),
    Fps(),
    NoEngine(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
    MapType(),
    MapUid(),
    RaceTime(),
    Sequence(),
    Turbo(),
};

#endif

abstract class Status {
    bool bar     = true;
    bool enabled = true;
    int  modes   = 0x0;

    bool get_active() const {
        throw("unimplemented");
        return false;
    }

    bool get_available() const final {
        return true
            and enabled
            and g_state.viewMode != CurrentEffects::ViewMode::Unknown
            and modes & g_state.viewMode == g_state.viewMode
        ;
    }

    protected void _Dedent() const {
        UI::Indent(-30.0f);
    }

    protected string _Icon() const {
        throw("unimplemented");
        return "";
    }

    protected void _Indent() const {
        UI::Indent(30.0f);
    }

    void RenderLegacy() const {
        throw("unimplemented");
    }

    protected void _RenderLegacyBar(const float num, const float max, const vec3&in color) const final {
        if (!bar) {
            return;
        }

        const vec2 pos = UI::GetCursorPos();
        const float scale = UI::GetScale();
        UI::SetCursorPos(vec2(pos.x, pos.y - scale * 5.0f));
        UI::PushStyleColor(UI::Col::PlotHistogram, vec4(color, S_Opacity));
        UI::ProgressBar(num / max, vec2(-1.0f, scale * 2.0f));
        UI::PopStyleColor();
        UI::SetCursorPos(pos);
    }

    void RenderSettings() {
        throw("unimplemented");
    }

    void Set() {
        throw("unimplemented");
    }
}

abstract class Handicap : Status {
    Handicap() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }
}

#if TMNEXT

class ActionKey : Status {
    bool get_active() const override {
        return 0 < g_state.actionKey and g_state.actionKey < 5;
    }

    ActionKey() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
    }

    string _Icon() const override {
        return S_Icons ? Icons::Percent + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorActionKey() + _Icon() + "Action Key " + g_state.actionKey);

        vec3 color = S_OffColor;
        switch (g_state.actionKey) {
            case 1: color = S_AK1Color; break;
            case 2: color = S_AK2Color; break;
            case 3: color = S_AK3Color; break;
            case 4: color = S_AK4Color; break;
        }

        _RenderLegacyBar(g_state.steerLimit, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_ActionKey = UI::Checkbox("Action Key", enabled);

        _Indent();

        bar = S_ActionKeyBar = UI::Checkbox("progress bar", bar);

        S_AK1Color = UI::InputColor3("1 - 20%", S_AK1Color);
        g_AK1Color = Text::FormatOpenplanetColor(S_AK1Color);
        S_AK2Color = UI::InputColor3("2 - 40%", S_AK2Color);
        g_AK2Color = Text::FormatOpenplanetColor(S_AK2Color);
        S_AK3Color = UI::InputColor3("3 - 60%", S_AK3Color);
        g_AK3Color = Text::FormatOpenplanetColor(S_AK3Color);
        S_AK4Color = UI::InputColor3("4 - 80%", S_AK4Color);
        g_AK4Color = Text::FormatOpenplanetColor(S_AK4Color);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        bar     = S_ActionKeyBar;
        enabled = S_ActionKey;
    }
}

#endif

class Checkpoints : Status {
    bool get_active() const override {
        return g_state.mapCpCount > 0;
    }

    Checkpoints() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Undo + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_checkpointsColor + _Icon() + "CP: " + g_state.cpNum + " / " + g_state.mapCpCount);
        _RenderLegacyBar(g_state.cpNum, Math::Max(1, g_state.mapCpCount), S_CheckpointsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Checkpoints = UI::Checkbox("Checkpoints", enabled);

        _Indent();

        bar = S_CheckpointsBar = UI::Checkbox("progress bar", bar);

        S_CheckpointsColor = UI::InputColor3("", S_CheckpointsColor);
        g_checkpointsColor = Text::FormatOpenplanetColor(S_CheckpointsColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        bar     = S_CheckpointsBar;
        enabled = S_Checkpoints;
    }
}

class CheckpointTime : Status {
    bool get_active() const override {
        return g_state.mapCpCount > 0;
    }

    CheckpointTime() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::FlagO + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_checkpointTimeColor + _Icon() + Time::Format(g_state.cpTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_CheckpointTime = UI::Checkbox("Checkpoint Time", enabled);

        _Indent();

        S_CheckpointTimeColor = UI::InputColor3("", S_CheckpointTimeColor);
        g_checkpointTimeColor = Text::FormatOpenplanetColor(S_CheckpointTimeColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_CheckpointTime;
    }
}

class Clock : Status {
    int num = -1;

    bool get_active() const override {
        switch (num) {
            case 1: return g_clock1FormatValid;
            case 2: return g_clock2FormatValid;
            case 3: return g_clock3FormatValid;
        }
        return false;  // impossible, for compiler
    }

    Clock(const int num) {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif

        switch (num) {
            case 1: case 2: case 3:
                this.num = num;
                break;
            default:
                throw("invalid clock number: " + num);
        }
    }

    string _Icon() const override {
        return S_Icons ? Icons::ClockO + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        switch (num) {
            case 1: UI::Text(g_clock1Color + _Icon() + Time::FormatString(S_Clock1Format)); break;
            case 2: UI::Text(g_clock2Color + _Icon() + Time::FormatString(S_Clock2Format)); break;
            case 3: UI::Text(g_clock3Color + _Icon() + Time::FormatString(S_Clock3Format)); break;
        }
    }

    void RenderSettings() override {
        UI::PushID(this);

        bool changed;

        switch (num) {
            case 1:
                enabled = S_Clock1 = UI::Checkbox("Clock 1", enabled);

                _Indent();

                S_Clock1Format = UI::InputText("format", S_Clock1Format, changed);
                if (changed) {
                    g_clock1FormatValid = VerifyTimeFormat(S_Clock1Format);
                }

                if (UI::Button("reset")) {
                    PLUGIN_META.GetSetting("S_Clock1Format").Reset();
                    g_clock1FormatValid = VerifyTimeFormat(S_Clock1Format);
                }

                UI::SameLine();
                _RenderTimeFormatReferenceButton();

                UI::SameLine();
                if (g_clock1FormatValid) {
                    UI::Text("preview: " + Time::FormatString(S_Clock1Format));
                } else {
                    UI::Text("\\$f33invalid time format");
                }

                S_Clock1Color = UI::InputColor3("", S_Clock1Color);
                g_clock1Color = Text::FormatOpenplanetColor(S_Clock1Color);

                _Dedent();

                break;

            case 2:
                enabled = S_Clock2 = UI::Checkbox("Clock 2", enabled);

                _Indent();

                S_Clock2Format = UI::InputText("format", S_Clock2Format, changed);
                if (changed) {
                    g_clock2FormatValid = VerifyTimeFormat(S_Clock2Format);
                }

                if (UI::Button("reset")) {
                    PLUGIN_META.GetSetting("S_Clock2Format").Reset();
                    g_clock2FormatValid = VerifyTimeFormat(S_Clock2Format);
                }

                UI::SameLine();
                _RenderTimeFormatReferenceButton();

                UI::SameLine();
                if (g_clock2FormatValid) {
                    UI::Text("preview: " + Time::FormatString(S_Clock2Format));
                } else {
                    UI::Text("\\$f33invalid time format");
                }

                S_Clock2Color = UI::InputColor3("", S_Clock2Color);
                g_clock2Color = Text::FormatOpenplanetColor(S_Clock2Color);

                _Dedent();

                break;

            case 3:
                enabled = S_Clock3 = UI::Checkbox("Clock 3", enabled);

                _Indent();

                S_Clock3Format = UI::InputText("format", S_Clock3Format, changed);
                if (changed) {
                    g_clock3FormatValid = VerifyTimeFormat(S_Clock3Format);
                }

                if (UI::Button("reset")) {
                    PLUGIN_META.GetSetting("S_Clock3Format").Reset();
                    g_clock3FormatValid = VerifyTimeFormat(S_Clock3Format);
                }

                UI::SameLine();
                _RenderTimeFormatReferenceButton();

                UI::SameLine();
                if (g_clock3FormatValid) {
                    UI::Text("preview: " + Time::FormatString(S_Clock3Format));
                } else {
                    UI::Text("\\$f33invalid time format");
                }

                S_Clock3Color = UI::InputColor3("", S_Clock3Color);
                g_clock3Color = Text::FormatOpenplanetColor(S_Clock3Color);

                _Dedent();

                break;
        }

        UI::PopID();
    }

    private void _RenderTimeFormatReferenceButton() const {
        if (UI::Button(Icons::ExternalLinkSquare + " reference")) {
            OpenBrowserURL(TIME_FORMAT_REFERENCE_LINK);
        }

        UI::SetItemTooltip(TIME_FORMAT_REFERENCE_LINK);
    }

    void Set() override {
        switch (num) {
            case 1: enabled = S_Clock1; break;
            case 2: enabled = S_Clock2; break;
            case 3: enabled = S_Clock3; break;
        }
    }
}

#if TMNEXT

class CruiseControl : Status {
    bool get_active() const override {
        return g_state.cruiseControl;
    }

    CruiseControl() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    string _Icon() const override {
        return S_Icons ? Icons::Tachometer + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorCruise() + _Icon() + "Cruise Control");
        _RenderLegacyBar(g_state.cruiseControlSpeed, 1000.0f, S_CruiseColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Cruise = UI::Checkbox("Cruise Control", enabled);

        _Indent();

        bar = S_CruiseBar = UI::Checkbox("progress bar", bar);

        S_CruiseColor = UI::InputColor3("", S_CruiseColor);
        g_cruiseColor = Text::FormatOpenplanetColor(S_CruiseColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Cruise;
    }
}

#endif

class ExeVersion : Status {
    bool get_active() const override {
        return g_state.exeVersion.Length > 0;
    }

    ExeVersion() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Cogs + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_exeVersionColor + _Icon() + g_state.exeVersion);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_ExeVersion = UI::Checkbox("Executable Version", enabled);

        _Indent();

        S_ExeVersionColor = UI::InputColor3("", S_ExeVersionColor);
        g_exeVersionColor = Text::FormatOpenplanetColor(S_ExeVersionColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_ExeVersion;
    }
}

#if TMNEXT || MP4

class ForcedAccel : Handicap {
    bool get_active() const override {
        return g_state.forcedAccel;
    }

    string _Icon() const override {
        return S_Icons ? Icons::Forward + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

#if TMNEXT
        UI::Text(ColorForced() + _Icon() + "Forced Accel");
#elif MP4
        UI::Text(ColorForced() + _Icon() + "Fullspeed Ahead");
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

#if TMNEXT
        enabled = S_Forced = UI::Checkbox("Forced Acceleration", enabled);
#elif MP4
        enabled = S_Forced = UI::Checkbox("Fullspeed Ahead", enabled);
#endif

        _Indent();

        S_ForcedColor = UI::InputColor3("", S_ForcedColor);
        g_forcedColor = Text::FormatOpenplanetColor(S_ForcedColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Forced;
    }
}

#endif

class Fps : Status {
    bool get_active() const override {
        return true;
    }

    Fps() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::VideoCamera + " " : "";
    }

    void RenderLegacy() const override {
        UI::Text(g_fpsColor + _Icon() + "FPS: " + int(Math::Round(g_state.fps)));
        _RenderLegacyBar(g_state.fps, g_state.maxFps, S_FpsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Fps = UI::Checkbox("Framerate", enabled);

        _Indent();

        bar = S_FpsBar = UI::Checkbox("progress bar", bar);

        S_FpsColor = UI::InputColor3("", S_FpsColor);
        g_fpsColor = Text::FormatOpenplanetColor(S_FpsColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Fps;
    }
}

#if TMNEXT

class Fragile : Status {
    bool get_active() const override {
        return g_state.fragile;
    }

    Fragile() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    string _Icon() const override {
        return S_Icons ? Icons::ChainBroken + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorFragile() + _Icon() + "Fragile");
        _RenderLegacyBar(g_state.fragileDamage, 1.0f, S_FragileColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Fragile = UI::Checkbox("Fragile", enabled);

        _Indent();

        bar = S_FragileBar = UI::Checkbox("progress bar", bar);

        S_FragileColor = UI::InputColor3("", S_FragileColor);
        g_fragileColor = Text::FormatOpenplanetColor(S_FragileColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Fragile;
    }
}

#endif

class GameMode : Status {
    bool get_active() const override {
        return g_state.gameMode.Length > 0;
    }

    GameMode() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Gamepad + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_gameModeColor + _Icon() + g_state.gameMode);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_GameMode = UI::Checkbox("Game Mode", enabled);

        _Indent();

        S_GameModeColor = UI::InputColor3("", S_GameModeColor);
        g_gameModeColor = Text::FormatOpenplanetColor(S_GameModeColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_GameMode;
    }
}

class Ghosts : Status {
    bool get_active() const override {
        return g_state.ghostVis;
    }

    Ghosts() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::SnapchatGhost + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorGhosts() + _Icon() + "Ghosts");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Ghosts = UI::Checkbox("Ghosts", enabled);

        _Indent();

        S_GhostsColor = UI::InputColor3("", S_GhostsColor);
        g_ghostsColor = Text::FormatOpenplanetColor(S_GhostsColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Ghosts;
    }
}

class Laps : Status {
    bool get_active() const override {
        return g_state.mapLapCount > 0;
    }

    Laps() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Retweet + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_lapsColor + _Icon() + "Lap: " + g_state.lapNum + " / " + g_state.mapLapCount);
        _RenderLegacyBar(g_state.lapNum, Math::Max(1, g_state.mapLapCount), S_LapsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Laps = UI::Checkbox("Laps", enabled);

        _Indent();

        bar = S_LapsBar = UI::Checkbox("progress bar", bar);

        S_LapsColor = UI::InputColor3("", S_LapsColor);
        g_lapsColor = Text::FormatOpenplanetColor(S_LapsColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Laps;
    }
}

class LapTime : Status {
    bool get_active() const override {
        return g_state.mapLapCount > 0;
    }

    LapTime() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::FlagCheckered + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_lapTimeColor + _Icon() + Time::Format(g_state.lapTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_LapTime = UI::Checkbox("Lap Time", enabled);

        _Indent();

        S_LapTimeColor = UI::InputColor3("", S_LapTimeColor);
        g_lapTimeColor = Text::FormatOpenplanetColor(S_LapTimeColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_LapTime;
    }
}

class MapType : Status {
    bool get_active() const override {
        return g_state.mapType.Length > 0;
    }

    MapType() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::MapO + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_mapTypeColor + _Icon() + g_state.mapType);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_MapType = UI::Checkbox("Map Type", enabled);

        _Indent();

        S_MapTypeColor = UI::InputColor3("", S_MapTypeColor);
        g_mapTypeColor = Text::FormatOpenplanetColor(S_MapTypeColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_MapType;
    }
}

class MapUid : Status {
    bool get_active() const override {
        return g_state.mapUid.Length > 0;
    }

    MapUid() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Map + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_mapUidColor + _Icon() + g_state.mapUid);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_MapUid = UI::Checkbox("Map UID", enabled);

        _Indent();

        S_MapUidColor = UI::InputColor3("", S_MapUidColor);
        g_mapUidColor = Text::FormatOpenplanetColor(S_MapUidColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_MapUid;
    }
}

#if TMNEXT || MP4

class Nametags : Status {
    bool get_active() const override {
        return g_state.nametagVis;
    }

    Nametags() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Tag + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNametags() + _Icon() + "Nametags");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Nametags = UI::Checkbox("Nametags", enabled);

        _Indent();

        S_NametagsColor = UI::InputColor3("", S_NametagsColor);
        g_nametagsColor = Text::FormatOpenplanetColor(S_NametagsColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Nametags;
    }
}

class NoBrakes : Handicap {
    bool get_active() const override {
        return g_state.noBrakes;
    }

    string _Icon() const override {
        return S_Icons ? Icons::ExclamationTriangle + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoBrakes() + _Icon() + "No Brakes");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_NoBrakes = UI::Checkbox("No Brakes", enabled);

        _Indent();

        S_NoBrakesColor = UI::InputColor3("", S_NoBrakesColor);
        g_noBrakesColor = Text::FormatOpenplanetColor(S_NoBrakesColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoBrakes;
    }
}

#endif

class NoEngine : Handicap {
    bool get_active() const override {
        return g_state.noEngine;
    }

    string _Icon() const override {
        return S_Icons ? Icons::PowerOff + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

#if TMNEXT
        UI::Text(ColorNoEngine() + _Icon() + "Engine Off");
#else
        UI::Text(ColorNoEngine() + _Icon() + "Free Wheeling");
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

#if TMNEXT
        enabled = S_NoEngine = UI::Checkbox("Engine Off", enabled);
#else
        enabled = S_NoEngine = UI::Checkbox("Free Wheeling", enabled);
#endif

        _Indent();

        S_NoEngineColor = UI::InputColor3("", S_NoEngineColor);
        g_noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoEngine;
    }
}

#if TMNEXT || MP4

class NoGrip : Handicap {
    bool get_active() const override {
        return g_state.noGrip;
    }

    string _Icon() const override {
        return S_Icons ? Icons::SnowflakeO + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoGrip() + _Icon() + "No Grip");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_NoGrip = UI::Checkbox("No Grip", enabled);

        _Indent();

        S_NoGripColor = UI::InputColor3("", S_NoGripColor);
        g_noGripColor = Text::FormatOpenplanetColor(S_NoGripColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoGrip;
    }
}

class NoSteer : Handicap {
    bool get_active() const override {
        return g_state.noSteer;
    }

    string _Icon() const override {
        return S_Icons ? Icons::ArrowsH + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoSteer() + _Icon() + "No Steering");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_NoSteer = UI::Checkbox("No Steering", enabled);

        _Indent();

        S_NoSteerColor = UI::InputColor3("", S_NoSteerColor);
        g_noSteerColor = Text::FormatOpenplanetColor(S_NoSteerColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoSteer;
    }
}

class Opponents : Status {
    bool get_active() const override {
        return g_state.opponentVis == CurrentEffects::OpponentVis::Opaque
            or g_state.opponentVis == CurrentEffects::OpponentVis::Transparent;
    }

    Opponents() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Users + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorOpponents() + _Icon() + "Opponents");
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Opponents = UI::Checkbox("Opponents", enabled);

        _Indent();

        S_OpponentsTransColor = UI::InputColor3("transparent", S_OpponentsTransColor);
        g_opponentsTransColor = Text::FormatOpenplanetColor(S_OpponentsTransColor);

        S_OpponentsOpaqueColor = UI::InputColor3("opaque", S_OpponentsOpaqueColor);
        g_opponentsOpaqueColor = Text::FormatOpenplanetColor(S_OpponentsOpaqueColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Opponents;
    }
}

#endif

class RaceTime : Status {
    bool get_active() const override {
        return g_state.raceTime > 0;
    }

    RaceTime() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Flag + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_raceTimeColor + _Icon() + Time::Format(g_state.raceTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_RaceTime = UI::Checkbox("Race Time", enabled);

        _Indent();

        S_RaceTimeColor = UI::InputColor3("", S_RaceTimeColor);
        g_raceTimeColor = Text::FormatOpenplanetColor(S_RaceTimeColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_RaceTime;
    }
}

#if TMNEXT

class Reactor : Status {
    bool get_active() const override {
        return g_state.reactor;
    }

    Reactor() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    string _Icon() const override {
        if (!S_Icons) {
            return "";
        }

        string reactorIcon = Icons::Rocket;
        switch (g_state.reactorType) {
            case ESceneVehicleVisReactorBoostType::Up:
                reactorIcon = Icons::ChevronUp; break;
            case ESceneVehicleVisReactorBoostType::Down:
                reactorIcon = Icons::ChevronDown; break;
        }

        return reactorIcon + " ";
    }

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + _Icon() + "Reactor Boost");
            _RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        UI::Text(ColorReactor() + _Icon() + "Reactor Boost");

        float f;

        if (!Safety::ShouldRun()) {
            f = g_state.reactorFinalTimer;
        } else switch (g_state.viewMode) {
            case CurrentEffects::ViewMode::Solo:
            case CurrentEffects::ViewMode::Server:
                f = float(g_state.reactorRemaining) / Math::Max(1, g_state.reactorDuration);
                break;
            case CurrentEffects::ViewMode::Replay:
                f = 0.0f;
                break;
            case CurrentEffects::ViewMode::Spectate:
                f = g_state.reactorFinalTimer;
                break;
        }

        vec3 color = S_OffColor;
        switch (g_state.reactorLevel) {
            case ESceneVehicleVisReactorBoostLvl::Lvl1:
                color = S_Reactor1Color; break;
            case ESceneVehicleVisReactorBoostLvl::Lvl2:
                color = S_Reactor2Color; break;
        }

        _RenderLegacyBar(f, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Reactor = UI::Checkbox("Reactor Boost", enabled);

        _Indent();

        bar = S_ReactorBar = UI::Checkbox("progress bar", bar);

        S_Reactor1Color = UI::InputColor3("level 1", S_Reactor1Color);
        g_reactor1Color = Text::FormatOpenplanetColor(S_Reactor1Color);
        S_Reactor2Color = UI::InputColor3("level 2", S_Reactor2Color);
        g_reactor2Color = Text::FormatOpenplanetColor(S_Reactor2Color);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Reactor;
    }
}

class Respawning : Status {
    bool get_active() const override {
        return g_state.respawning;
    }

    Respawning() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
    }

    string _Icon() const override {
        return S_Icons ? Icons::Refresh + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorRespawning() + _Icon() + "Respawning");

        vec3 color = S_OffColor;
        if (g_state.launchRespawning) {
            color = S_LaunchRespawnColor;
        } else if (g_state.standRespawning) {
            color = S_StandRespawnColor;
        }

        _RenderLegacyBar(float(g_state.respawnRemaining) / Math::Max(1, g_state.respawnDuration), 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Respawning = UI::Checkbox("Respawning", enabled);

        _Indent();

        bar = S_RespawningBar = UI::Checkbox("progress bar", bar);

        S_LaunchRespawnColor = UI::InputColor3("launched", S_LaunchRespawnColor);
        g_launchRespawnColor = Text::FormatOpenplanetColor(S_LaunchRespawnColor);
        S_StandRespawnColor = UI::InputColor3("standstill", S_StandRespawnColor);
        g_standRespawnColor = Text::FormatOpenplanetColor(S_StandRespawnColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Respawning;
    }
}

#endif

class Sequence : Status {
    bool get_active() const override {
        return true;
    }

    Sequence() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Film + " " : "";
    }

    void RenderLegacy() const override {
        UI::Text(g_sequenceColor + _Icon() + tostring(g_state.sequence));
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Sequence = UI::Checkbox("Sequence", enabled);

        _Indent();

        S_SequenceColor = UI::InputColor3("", S_SequenceColor);
        g_sequenceColor = Text::FormatOpenplanetColor(S_SequenceColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Sequence;
    }
}

#if TMNEXT

class SlowMo : Status {
    bool get_active() const override {
        return g_state.slowMo;
    }

    SlowMo() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    string _Icon() const override {
        return S_Icons ? Icons::ClockO + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + _Icon() + "Slow-Mo");
            _RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        UI::Text(ColorSlowMo() + _Icon() + "Slow-Mo");

        vec3 color = S_OffColor;
        switch (g_state.slowMoLevel) {
            case 1: color = S_SlowMo1Color; break;
            case 2: color = S_SlowMo2Color; break;
            case 3: color = S_SlowMo3Color; break;
            case 4: color = S_SlowMo4Color; break;
        }

        float f = 0.0f;

        if (Safety::ShouldRun()) {
            switch (g_state.viewMode) {
                case CurrentEffects::ViewMode::Solo:
                case CurrentEffects::ViewMode::Server:
                    f = float(g_state.slowMoRemaining) / Math::Max(1, g_state.slowMoDuration);
                    break;
            }
        }

        _RenderLegacyBar(f, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_SlowMo = UI::Checkbox("Slow-Mo", enabled);

        _Indent();

        bar = S_SlowMoBar = UI::Checkbox("progress bar", bar);

        S_SlowMo1Color = UI::InputColor3("level 1", S_SlowMo1Color);
        g_slowMo1Color = Text::FormatOpenplanetColor(S_SlowMo1Color);
        S_SlowMo2Color = UI::InputColor3("level 2", S_SlowMo2Color);
        g_slowMo2Color = Text::FormatOpenplanetColor(S_SlowMo2Color);
        S_SlowMo3Color = UI::InputColor3("level 3", S_SlowMo3Color);
        g_slowMo3Color = Text::FormatOpenplanetColor(S_SlowMo3Color);
        S_SlowMo4Color = UI::InputColor3("level 4", S_SlowMo4Color);
        g_slowMo4Color = Text::FormatOpenplanetColor(S_SlowMo4Color);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_SlowMo;
    }
}

#endif

class Turbo : Status {
    bool get_active() const override {
        return g_state.turbo;
    }

    Turbo() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay | CurrentEffects::ViewMode::Server;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::ArrowCircleUp + " " : "";
    }

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + _Icon() + "Turbo");
            _RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        UI::Text(ColorTurbo() + _Icon() + "Turbo");

#if TMNEXT
        vec3 color;
        switch (g_state.turboLevel) {
            case 1: color = S_Turbo1Color; break;
            case 2: color = S_Turbo2Color; break;
            case 3: color = S_Turbo3Color; break;
            case 4: color = S_Turbo4Color; break;
            case 5: color = S_Turbo5Color; break;
        }
        _RenderLegacyBar(1.0f - g_state.turboTimer, 1.0f, color);
#else
        _RenderLegacyBar(1.0f - g_state.turboTimer, 1.0f, S_TurboColor);
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Turbo = UI::Checkbox("Turbo", enabled);

        _Indent();

        bar = S_TurboBar = UI::Checkbox("progress bar", bar);

#if TMNEXT
        S_Turbo1Color = UI::InputColor3("normal", S_Turbo1Color);
        g_turbo1Color = Text::FormatOpenplanetColor(S_Turbo1Color);
        S_Turbo2Color = UI::InputColor3("super", S_Turbo2Color);
        g_turbo2Color = Text::FormatOpenplanetColor(S_Turbo2Color);
        S_Turbo3Color = UI::InputColor3("roulette - normal", S_Turbo3Color);
        g_turbo3Color = Text::FormatOpenplanetColor(S_Turbo3Color);
        S_Turbo4Color = UI::InputColor3("roulette - super", S_Turbo4Color);
        g_turbo4Color = Text::FormatOpenplanetColor(S_Turbo4Color);
        S_Turbo5Color = UI::InputColor3("roulette - ultra", S_Turbo5Color);
        g_turbo5Color = Text::FormatOpenplanetColor(S_Turbo5Color);
#else
        S_TurboColor = UI::InputColor3("", S_TurboColor);
        g_turboColor = Text::FormatOpenplanetColor(S_TurboColor);
#endif

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Turbo;
    }
}

class VehicleType : Status {
    bool get_active() const override {
        return g_state.vehicleType != CurrentEffects::VehicleType::Stadium;
    }

    VehicleType() {
#if TMNEXT
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif MP4
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#elif TURBO
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
#endif
    }

    string _Icon() const override {
        return S_Icons ? Icons::Kenney::Car + " " : "";
    }

    void RenderLegacy() const override {
        switch (g_state.vehicleType) {
#if TMNEXT || MP4
            case CurrentEffects::VehicleType::Snow:
                UI::Text(g_snowColor + _Icon() + "Snow Car");
                break;
            case CurrentEffects::VehicleType::Desert:
                UI::Text(g_desertColor + _Icon() + "Desert Car");
                break;
            case CurrentEffects::VehicleType::Rally:
                UI::Text(g_rallyColor + _Icon() + "Rally Car");
                break;
#endif
#if MP4
            case CurrentEffects::VehicleType::Island:
                UI::Text(g_islandColor + _Icon() + "Island Car");
                break;
            case CurrentEffects::VehicleType::Bay:
                UI::Text(g_bayColor + _Icon() + "Bay Car");
                break;
            case CurrentEffects::VehicleType::Coast:
                UI::Text(g_coastColor + _Icon() + "Coast Car");
                break;
            case CurrentEffects::VehicleType::Traffic:
                UI::Text(g_trafficColor + _Icon() + "Traffic Car");
                break;
#endif
#if MP4 || TURBO
            case CurrentEffects::VehicleType::Canyon:
                UI::Text(g_canyonColor + _Icon() + "Canyon Car");
                break;
            case CurrentEffects::VehicleType::Valley:
                UI::Text(g_valleyColor + _Icon() + "Valley Car");
                break;
            case CurrentEffects::VehicleType::Lagoon:
                UI::Text(g_lagoonColor + _Icon() + "Lagoon Car");
                break;
#endif
            default:
                if (!S_HideInactive) {
                    UI::Text(g_offColor + _Icon() + "Stadium Car");
                }
        }
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Vehicle = UI::Checkbox("Vehicle Type", enabled);

        _Indent();

#if TMNEXT || MP4
        S_SnowColor = UI::InputColor3("snow", S_SnowColor);
        g_snowColor = Text::FormatOpenplanetColor(S_SnowColor);
        S_DesertColor = UI::InputColor3("desert", S_DesertColor);
        g_desertColor = Text::FormatOpenplanetColor(S_DesertColor);
        S_RallyColor = UI::InputColor3("rally", S_RallyColor);
        g_rallyColor = Text::FormatOpenplanetColor(S_RallyColor);
#endif
#if MP4
        S_IslandColor = UI::InputColor3("island", S_IslandColor);
        g_islandColor = Text::FormatOpenplanetColor(S_IslandColor);
        S_BayColor = UI::InputColor3("bay", S_BayColor);
        g_bayColor = Text::FormatOpenplanetColor(S_BayColor);
        S_CoastColor = UI::InputColor3("coast", S_CoastColor);
        g_coastColor = Text::FormatOpenplanetColor(S_CoastColor);
        S_TrafficColor = UI::InputColor3("traffic", S_TrafficColor);
        g_trafficColor = Text::FormatOpenplanetColor(S_TrafficColor);
#endif
#if MP4 || TURBO
        S_CanyonColor = UI::InputColor3("canyon", S_CanyonColor);
        g_canyonColor = Text::FormatOpenplanetColor(S_CanyonColor);
        S_ValleyColor = UI::InputColor3("valley", S_ValleyColor);
        g_valleyColor = Text::FormatOpenplanetColor(S_ValleyColor);
        S_LagoonColor = UI::InputColor3("lagoon", S_LagoonColor);
        g_lagoonColor = Text::FormatOpenplanetColor(S_LagoonColor);
#endif

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Vehicle;
    }
}

#if TMNEXT

class Water : Status {
    bool get_active() const override {
        return g_state.water != 0.0f;
    }

    Water() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay | CurrentEffects::ViewMode::Server;
    }

    string _Icon() const override {
        return S_Icons ? Icons::Tint + " " : "";
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorWater() + _Icon() + "Water");
        _RenderLegacyBar(g_state.water, 1.0f, S_WaterColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        enabled = S_Water = UI::Checkbox("Water", enabled);

        _Indent();

        bar = S_WaterBar = UI::Checkbox("progress bar", bar);

        S_WaterColor = UI::InputColor3("", S_WaterColor);
        g_waterColor = Text::FormatOpenplanetColor(S_WaterColor);

        _Dedent();

        UI::PopID();
    }

    void Set() override {
        enabled = S_Water;
    }
}

#endif

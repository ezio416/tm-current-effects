#if TMNEXT

Status@[] g_statuses = {
    ActionKey(),
    Checkpoints(),
    CheckpointTime(),
    CruiseControl(),
    NoEngine(),
    ForcedAccel(),
    Fps(),
    Fragile(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
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
    NoEngine(),
    Fps(),
    ForcedAccel(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
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
    Fps(),
    NoEngine(),
    GameMode(),
    Ghosts(),
    Laps(),
    LapTime(),
    RaceTime(),
    Sequence(),
    Turbo()
};

#endif

abstract class Status {
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

    void RenderLegacy() const {
        throw("unimplemented");
    }

    protected void RenderLegacyBar(const float num, const float max, const vec3&in color) const final {
        const vec2 pos = UI::GetCursorPos();
        const float scale = UI::GetScale();
        UI::SetCursorPos(vec2(pos.x, pos.y - scale * 5.0f));
        UI::PushStyleColor(UI::Col::PlotHistogram, vec4(color, 1.0f));
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

    void Set(const bool b) {
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorActionKey() + Icons::Percent + " Action Key " + g_state.actionKey);

        vec3 color = S_OffColor;
        switch (g_state.actionKey) {
            case 1: color = S_AK1Color; break;
            case 2: color = S_AK2Color; break;
            case 3: color = S_AK3Color; break;
            case 4: color = S_AK4Color; break;
        }

        RenderLegacyBar(g_state.steerLimit, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Action Key", S_ActionKey));

        S_AK1Color = UI::InputColor3("1 - 20%", S_AK1Color);
        g_AK1Color = Text::FormatOpenplanetColor(S_AK1Color);
        S_AK2Color = UI::InputColor3("2 - 40%", S_AK2Color);
        g_AK2Color = Text::FormatOpenplanetColor(S_AK2Color);
        S_AK3Color = UI::InputColor3("3 - 60%", S_AK3Color);
        g_AK3Color = Text::FormatOpenplanetColor(S_AK3Color);
        S_AK4Color = UI::InputColor3("4 - 80%", S_AK4Color);
        g_AK4Color = Text::FormatOpenplanetColor(S_AK4Color);

        UI::PopID();
    }

    void Set() override {
        enabled = S_ActionKey;
    }

    void Set(const bool b) override {
        enabled = S_ActionKey = b;
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

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_checkpointsColor + Icons::Undo + " CP: " + g_state.cpNum + " / " + g_state.mapCpCount);
        RenderLegacyBar(g_state.cpNum, Math::Max(1, g_state.mapCpCount), S_CheckpointsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Checkpoints", S_Checkpoints));
        S_CheckpointsColor = UI::InputColor3("", S_CheckpointsColor);
        g_checkpointsColor = Text::FormatOpenplanetColor(S_CheckpointsColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Checkpoints;
    }

    void Set(const bool b) override {
        enabled = S_Checkpoints = b;
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

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_checkpointTimeColor + Icons::FlagO + " " + Time::Format(g_state.cpTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Checkpoint Time", S_CheckpointTime));
        S_CheckpointTimeColor = UI::InputColor3("", S_CheckpointTimeColor);
        g_checkpointTimeColor = Text::FormatOpenplanetColor(S_CheckpointTimeColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_CheckpointTime;
    }

    void Set(const bool b) override {
        enabled = S_CheckpointTime = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorCruise() + Icons::Tachometer + " Cruise Control");
        RenderLegacyBar(g_state.cruiseControlSpeed, 1000.0f, S_CruiseColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Cruise Control", S_Cruise));
        S_CruiseColor = UI::InputColor3("", S_CruiseColor);
        g_cruiseColor = Text::FormatOpenplanetColor(S_CruiseColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Cruise;
    }

    void Set(const bool b) override {
        enabled = S_Cruise = b;
    }
}

class Fragile : Status {
    bool get_active() const override {
        return g_state.fragile;
    }

    Fragile() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorFragile() + Icons::ChainBroken + " Fragile");
        RenderLegacyBar(g_state.fragileDamage, 1.0f, S_FragileColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Fragile", S_Fragile));
        S_FragileColor = UI::InputColor3("", S_FragileColor);
        g_fragileColor = Text::FormatOpenplanetColor(S_FragileColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Fragile;
    }

    void Set(const bool b) override {
        enabled = S_Fragile = b;
    }
}

#endif
#if TMNEXT || MP4

class ForcedAccel : Handicap {
    bool get_active() const override {
        return g_state.forcedAccel;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

#if TMNEXT
        UI::Text(ColorForced() + Icons::Forward + " Forced Accel");
#elif MP4
        UI::Text(ColorForced() + Icons::Forward + " Fullspeed Ahead");
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

#if TMNEXT
        Set(UI::Checkbox("Forced Acceleration", S_Forced));
#elif MP4
        Set(UI::Checkbox("Fullspeed Ahead", S_Forced));
#endif

        S_ForcedColor = UI::InputColor3("", S_ForcedColor);
        g_forcedColor = Text::FormatOpenplanetColor(S_ForcedColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Forced;
    }

    void Set(const bool b) override {
        enabled = S_Forced = b;
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

    void RenderLegacy() const override {
        UI::Text(g_fpsColor + Icons::VideoCamera + " FPS: " + int(Math::Round(g_state.fps)));
        RenderLegacyBar(g_state.fps, g_state.maxFps, S_FpsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Framerate", S_Fps));

        S_FpsColor = UI::InputColor3("", S_FpsColor);
        g_fpsColor = Text::FormatOpenplanetColor(S_FpsColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Fps;
    }

    void Set(const bool b) override {
        enabled = S_Fps = b;
    }
}

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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_gameModeColor + Icons::Gamepad + " " + g_state.gameMode);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Game Mode", S_GameMode));

        S_GameModeColor = UI::InputColor3("", S_GameModeColor);
        g_gameModeColor = Text::FormatOpenplanetColor(S_GameModeColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_GameMode;
    }

    void Set(const bool b) override {
        enabled = S_GameMode = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorGhosts() + Icons::SnapchatGhost + " Ghosts");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Ghosts", S_Ghosts));

        S_GhostsColor = UI::InputColor3("", S_GhostsColor);
        g_ghostsColor = Text::FormatOpenplanetColor(S_GhostsColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Ghosts;
    }

    void Set(const bool b) override {
        enabled = S_Ghosts = b;
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

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_lapsColor + Icons::Retweet + " Lap: " + g_state.lapNum + " / " + g_state.mapLapCount);
        RenderLegacyBar(g_state.lapNum, Math::Max(1, g_state.mapLapCount), S_LapsColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Laps", S_Laps));
        S_LapsColor = UI::InputColor3("", S_LapsColor);
        g_lapsColor = Text::FormatOpenplanetColor(S_LapsColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Laps;
    }

    void Set(const bool b) override {
        enabled = S_Laps = b;
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

    void RenderLegacy() const override {
        if (!active) {
            return;
        }

        UI::Text(g_lapTimeColor + Icons::FlagCheckered + " " + Time::Format(g_state.lapTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Lap Time", S_LapTime));
        S_LapTimeColor = UI::InputColor3("", S_LapTimeColor);
        g_lapTimeColor = Text::FormatOpenplanetColor(S_LapTimeColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_LapTime;
    }

    void Set(const bool b) override {
        enabled = S_LapTime = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNametags() + Icons::Tag + " Nametags");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Nametags", S_Nametags));

        S_NametagsColor = UI::InputColor3("", S_NametagsColor);
        g_nametagsColor = Text::FormatOpenplanetColor(S_NametagsColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Nametags;
    }

    void Set(const bool b) override {
        enabled = S_Nametags = b;
    }
}

class NoBrakes : Handicap {
    bool get_active() const override {
        return g_state.noBrakes;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoBrakes() + Icons::ExclamationTriangle + " No Brakes");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("No Brakes", S_NoBrakes));

        S_NoBrakesColor = UI::InputColor3("", S_NoBrakesColor);
        g_noBrakesColor = Text::FormatOpenplanetColor(S_NoBrakesColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoBrakes;
    }

    void Set(const bool b) override {
        enabled = S_NoBrakes = b;
    }
}

#endif

class NoEngine : Handicap {
    bool get_active() const override {
        return g_state.noEngine;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

#if TMNEXT
        UI::Text(ColorNoEngine() + Icons::PowerOff + " Engine Off");
#else
        UI::Text(ColorNoEngine() + Icons::PowerOff + " Free Wheeling");
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

#if TMNEXT
        Set(UI::Checkbox("Engine Off", S_NoEngine));
#else
        Set(UI::Checkbox("Free Wheeling", S_NoEngine));
#endif

        S_NoEngineColor = UI::InputColor3("", S_NoEngineColor);
        g_noEngineColor = Text::FormatOpenplanetColor(S_NoEngineColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoEngine;
    }

    void Set(const bool b) override {
        enabled = S_NoEngine = b;
    }
}

#if TMNEXT || MP4

class NoGrip : Handicap {
    bool get_active() const override {
        return g_state.noGrip;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoGrip() + Icons::SnowflakeO + " No Grip");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("No Grip", S_NoGrip));

        S_NoGripColor = UI::InputColor3("", S_NoGripColor);
        g_noGripColor = Text::FormatOpenplanetColor(S_NoGripColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoGrip;
    }

    void Set(const bool b) override {
        enabled = S_NoGrip = b;
    }
}

class NoSteer : Handicap {
    bool get_active() const override {
        return g_state.noSteer;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorNoSteer() + Icons::ArrowsH + " No Steering");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("No Steering", S_NoSteer));

        S_NoSteerColor = UI::InputColor3("", S_NoSteerColor);
        g_noSteerColor = Text::FormatOpenplanetColor(S_NoSteerColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_NoSteer;
    }

    void Set(const bool b) override {
        enabled = S_NoSteer = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorOpponents() + Icons::Users + " Opponents");
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Opponents", S_Opponents));

        S_OpponentsTransColor = UI::InputColor3("transparent", S_OpponentsTransColor);
        g_opponentsTransColor = Text::FormatOpenplanetColor(S_OpponentsTransColor);

        S_OpponentsOpaqueColor = UI::InputColor3("opaque", S_OpponentsOpaqueColor);
        g_opponentsOpaqueColor = Text::FormatOpenplanetColor(S_OpponentsOpaqueColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Opponents;
    }

    void Set(const bool b) override {
        enabled = S_Opponents = b;
    }
}

#endif
#if TMNEXT

class Reactor : Status {
    bool get_active() const override {
        return g_state.reactor;
    }

    Reactor() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Replay
            | CurrentEffects::ViewMode::Server | CurrentEffects::ViewMode::Spectate;
    }

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + Icons::Rocket + " Reactor Boost");
            RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        string reactorIcon = Icons::Rocket;
        switch (g_state.reactorType) {
            case ESceneVehicleVisReactorBoostType::Up:
                reactorIcon = Icons::ChevronUp; break;
            case ESceneVehicleVisReactorBoostType::Down:
                reactorIcon = Icons::ChevronDown; break;
        }

        UI::Text(ColorReactor() + reactorIcon + " Reactor Boost");

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

        RenderLegacyBar(f, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Reactor Boost", S_Reactor));

        S_Reactor1Color = UI::InputColor3("level 1", S_Reactor1Color);
        g_reactor1Color = Text::FormatOpenplanetColor(S_Reactor1Color);
        S_Reactor2Color = UI::InputColor3("level 2", S_Reactor2Color);
        g_reactor2Color = Text::FormatOpenplanetColor(S_Reactor2Color);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Reactor;
    }

    void Set(const bool b) override {
        enabled = S_Reactor = b;
    }
}

class Respawning : Status {
    bool get_active() const override {
        return g_state.respawning;
    }

    Respawning() {
        modes = CurrentEffects::ViewMode::Solo | CurrentEffects::ViewMode::Server;
    }

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorRespawning() + Icons::Refresh + " Respawning");

        vec3 color = S_OffColor;
        if (g_state.launchRespawning) {
            color = S_LaunchRespawnColor;
        } else if (g_state.standRespawning) {
            color = S_StandRespawnColor;
        }

        RenderLegacyBar(float(g_state.respawnRemaining) / Math::Max(1, g_state.respawnDuration), 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Respawning", S_Respawning));

        S_LaunchRespawnColor = UI::InputColor3("launched", S_LaunchRespawnColor);
        g_launchRespawnColor = Text::FormatOpenplanetColor(S_LaunchRespawnColor);
        S_StandRespawnColor = UI::InputColor3("standstill", S_StandRespawnColor);
        g_standRespawnColor = Text::FormatOpenplanetColor(S_StandRespawnColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Respawning;
    }

    void Set(const bool b) override {
        enabled = S_Respawning = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(g_raceTimeColor + Icons::Flag + " " + Time::Format(g_state.raceTime));
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Race Time", S_RaceTime));

        S_RaceTimeColor = UI::InputColor3("", S_RaceTimeColor);
        g_raceTimeColor = Text::FormatOpenplanetColor(S_RaceTimeColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_RaceTime;
    }

    void Set(const bool b) override {
        enabled = S_RaceTime = b;
    }
}

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

    void RenderLegacy() const override {
        UI::Text(g_sequenceColor + Icons::Film + " " + tostring(g_state.sequence));
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Sequence", S_Sequence));

        S_SequenceColor = UI::InputColor3("", S_SequenceColor);
        g_sequenceColor = Text::FormatOpenplanetColor(S_SequenceColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Sequence;
    }

    void Set(const bool b) override {
        enabled = S_Sequence = b;
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

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + Icons::ClockO + " Slow-Mo");
            RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        UI::Text(ColorSlowMo() + Icons::ClockO + " Slow-Mo");

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

        RenderLegacyBar(f, 1.0f, color);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Slow-Mo", S_SlowMo));

        S_SlowMo1Color = UI::InputColor3("level 1", S_SlowMo1Color);
        g_slowMo1Color = Text::FormatOpenplanetColor(S_SlowMo1Color);
        S_SlowMo2Color = UI::InputColor3("level 2", S_SlowMo2Color);
        g_slowMo2Color = Text::FormatOpenplanetColor(S_SlowMo2Color);
        S_SlowMo3Color = UI::InputColor3("level 3", S_SlowMo3Color);
        g_slowMo3Color = Text::FormatOpenplanetColor(S_SlowMo3Color);
        S_SlowMo4Color = UI::InputColor3("level 4", S_SlowMo4Color);
        g_slowMo4Color = Text::FormatOpenplanetColor(S_SlowMo4Color);

        UI::PopID();
    }

    void Set() override {
        enabled = S_SlowMo;
    }

    void Set(const bool b) override {
        enabled = S_SlowMo = b;
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

    void RenderLegacy() const override {
        if (!active) {
            if (S_HideInactive) {
                return;
            }

            UI::Text(g_offColor + Icons::ArrowCircleUp + " Turbo");
            RenderLegacyBar(0.0f, 1.0f, S_OffColor);
            return;
        }

        UI::Text(ColorTurbo() + Icons::ArrowCircleUp + " Turbo");

#if TMNEXT
        vec3 color;
        switch (g_state.turboLevel) {
            case 1: color = S_Turbo1Color; break;
            case 2: color = S_Turbo2Color; break;
            case 3: color = S_Turbo3Color; break;
            case 4: color = S_Turbo4Color; break;
            case 5: color = S_Turbo5Color; break;
        }
        RenderLegacyBar(1.0f - g_state.turboTimer, 1.0f, color);
#else
        RenderLegacyBar(1.0f - g_state.turboTimer, 1.0f, S_TurboColor);
#endif
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Turbo", S_Turbo));

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

        UI::PopID();
    }

    void Set() override {
        enabled = S_Turbo;
    }

    void Set(const bool b) override {
        enabled = S_Turbo = b;
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

    void RenderLegacy() const override {
        switch (g_state.vehicleType) {
#if TMNEXT || MP4
            case CurrentEffects::VehicleType::Snow:
                UI::Text(g_snowColor + Icons::Kenney::Car + " Snow Car");
                break;
            case CurrentEffects::VehicleType::Desert:
                UI::Text(g_desertColor + Icons::Kenney::Car + " Desert Car");
                break;
            case CurrentEffects::VehicleType::Rally:
                UI::Text(g_rallyColor  + Icons::Kenney::Car + " Rally Car");
                break;
#endif
#if MP4
            // case CurrentEffects::VehicleType::Island:
            //     UI::Text(g_islandColor + Icons::Kenney::Car + " Island Car");
            //     break;
            case CurrentEffects::VehicleType::Bay:
                UI::Text(g_desertColor + Icons::Kenney::Car + " Bay Car");
                break;
            // case CurrentEffects::VehicleType::Coast:
            //     UI::Text(g_coastColor  + Icons::Kenney::Car + " Coast Car");
            //     break;
#endif
#if MP4 || TURBO
            case CurrentEffects::VehicleType::Canyon:
                UI::Text(g_canyonColor + Icons::Kenney::Car + " Canyon Car");
                break;
            case CurrentEffects::VehicleType::Valley:
                UI::Text(g_valleyColor + Icons::Kenney::Car + " Valley Car");
                break;
            case CurrentEffects::VehicleType::Lagoon:
                UI::Text(g_lagoonColor + Icons::Kenney::Car + " Lagoon Car");
                break;
#endif
            default:
                if (!S_HideInactive) {
                    UI::Text(g_offColor + Icons::Kenney::Car + " Stadium Car");
                }
        }
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Vehicle Type", S_Vehicle));

#if TMNEXT || MP4
        S_SnowColor = UI::InputColor3("snow", S_SnowColor);
        g_snowColor = Text::FormatOpenplanetColor(S_SnowColor);
        S_DesertColor = UI::InputColor3("desert", S_DesertColor);
        g_desertColor = Text::FormatOpenplanetColor(S_DesertColor);
        S_RallyColor = UI::InputColor3("rally", S_RallyColor);
        g_rallyColor = Text::FormatOpenplanetColor(S_RallyColor);
#endif
#if MP4
        // S_IslandColor = UI::InputColor3("island", S_IslandColor);
        // g_islandColor = Text::FormatOpenplanetColor(S_IslandColor);
        S_BayColor = UI::InputColor3("bay", S_BayColor);
        g_bayColor = Text::FormatOpenplanetColor(S_BayColor);
        // S_CoastColor = UI::InputColor3("coast", S_CoastColor);
        // g_coastColor = Text::FormatOpenplanetColor(S_CoastColor);
#endif
#if MP4 || TURBO
        S_CanyonColor = UI::InputColor3("canyon", S_CanyonColor);
        g_canyonColor = Text::FormatOpenplanetColor(S_CanyonColor);
        S_ValleyColor = UI::InputColor3("valley", S_ValleyColor);
        g_valleyColor = Text::FormatOpenplanetColor(S_ValleyColor);
        S_LagoonColor = UI::InputColor3("lagoon", S_LagoonColor);
        g_lagoonColor = Text::FormatOpenplanetColor(S_LagoonColor);
#endif

        UI::PopID();
    }

    void Set() override {
        enabled = S_Vehicle;
    }

    void Set(const bool b) override {
        enabled = S_Vehicle = b;
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

    void RenderLegacy() const override {
        if (S_HideInactive and !active) {
            return;
        }

        UI::Text(ColorWater() + Icons::Tint + " Water");
        RenderLegacyBar(g_state.water, 1.0f, S_WaterColor);
    }

    void RenderSettings() override {
        UI::PushID(this);

        Set(UI::Checkbox("Water", S_Water));
        S_WaterColor = UI::InputColor3("", S_WaterColor);
        g_waterColor = Text::FormatOpenplanetColor(S_WaterColor);

        UI::PopID();
    }

    void Set() override {
        enabled = S_Water;
    }

    void Set(const bool b) override {
        enabled = S_Water = b;
    }
}

#endif

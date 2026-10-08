abstract class State {
    CurrentEffects::Camera               camera;
    uint[]                               cpLapTimes;
    uint                                 cpNum;
    uint                                 cpTime;
    uint[]                               cpTimes;
    bool                                 driving;
    bool                                 finished;
    float                                fps;
    string                               gameMode;
    uint                                 gameTime;
    bool                                 ghostVis;
    uint[]                               lapLapTimes;
    uint                                 lapNum;
    uint                                 lapTime;
    uint[]                               lapTimes;
    uint                                 lastLapTime;
    uint                                 lastWpTime;
    string                               login;
    uint                                 mapCpCount;
    uint                                 mapLapCount;
    uint                                 mapWpCount;
    uint                                 maxFps;
    string                               name;
    bool                                 noEngine;
    uint64                               p_vis;
    uint                                 raceTime;
    uint                                 respawns;
    CGamePlaygroundUIConfig::EUISequence sequence;
    bool                                 spawning;
    uint                                 startTick;
    uint                                 ticks;
    bool                                 turbo;
    float                                turboTimer;
    CurrentEffects::VehicleType          vehicleType;
    CurrentEffects::ViewMode             viewMode;
    uint                                 wpCount;
    uint[]                               wpTimes;

    State() {
        Reset();
    }

    protected void _RenderDebugRow(const string&in name, const string&in value) const final {
        UI::TableNextRow();

        UI::TableNextColumn();
        UI::Text(name);

        UI::TableNextColumn();
        UI::Text(value);
    }

    void RenderDebugRows() const {
        _RenderDebugRow("camera",      ColorDebugCamera(camera));
        _RenderDebugRow("cpLapTimes",  ColorDebugArrayUint32(cpLapTimes));
        _RenderDebugRow("cpNum",       ColorDebugInt(cpNum));
        _RenderDebugRow("cpTime",      ColorDebugInt(cpTime));
        _RenderDebugRow("cpTimes",     ColorDebugArrayUint32(cpTimes));
        _RenderDebugRow("driving",     ColorDebugBool(driving));
        _RenderDebugRow("finished",    ColorDebugBool(finished));
        _RenderDebugRow("fps",         ColorDebugFloat(fps));
        _RenderDebugRow("gameMode",    ColorDebugString(gameMode));
        _RenderDebugRow("gameTime",    ColorDebugInt(gameTime));
        _RenderDebugRow("ghostVis",    ColorDebugBool(ghostVis));
        _RenderDebugRow("lapLapTimes", ColorDebugArrayUint32(lapLapTimes));
        _RenderDebugRow("lapNum",      ColorDebugInt(lapNum));
        _RenderDebugRow("lapTime",     ColorDebugInt(lapTime));
        _RenderDebugRow("lapTimes",    ColorDebugArrayUint32(lapTimes));
        _RenderDebugRow("lastLapTime", ColorDebugInt(lastLapTime));
        _RenderDebugRow("lastWpTime",  ColorDebugInt(lastWpTime));
        _RenderDebugRow("login",       ColorDebugString(login));
        _RenderDebugRow("mapCpCount",  ColorDebugInt(mapCpCount));
        _RenderDebugRow("mapLapCount", ColorDebugInt(mapLapCount));
        _RenderDebugRow("mapWpCount",  ColorDebugInt(mapWpCount));
        _RenderDebugRow("maxFps",      ColorDebugInt(maxFps));
        _RenderDebugRow("name",        ColorDebugFormattedString(name));
        _RenderDebugRow("noEngine",    ColorDebugBool(noEngine));
        _RenderDebugRow("p_vis",       ColorDebugPointer(p_vis));
        _RenderDebugRow("raceTime",    ColorDebugInt(raceTime));
        _RenderDebugRow("respawns",    ColorDebugInt(respawns));
        _RenderDebugRow("sequence",    ColorDebugSequence(sequence));
        _RenderDebugRow("spawning",    ColorDebugBool(spawning));
        _RenderDebugRow("startTick",   ColorDebugInt(startTick));
        _RenderDebugRow("ticks",       ColorDebugInt(ticks));
        _RenderDebugRow("turbo",       ColorDebugBool(turbo));
        _RenderDebugRow("turboTimer",  ColorDebugFloat(turboTimer));
        _RenderDebugRow("vehicleType", ColorDebugVehicleType(vehicleType));
        _RenderDebugRow("viewMode",    ColorDebugViewMode(viewMode));
        _RenderDebugRow("wpCount",     ColorDebugInt(wpCount));
        _RenderDebugRow("wpTimes",     ColorDebugArrayUint32(wpTimes));
    }

    void Reset() {
        camera      = CurrentEffects::Camera::Unknown;
        cpLapTimes  = {};
        cpNum       = 0;
        cpTime      = 0;
        cpTimes     = {};
        driving     = false;
        finished    = false;
        fps         = 0.0f;
        gameMode    = "";
        gameTime    = 0;
        ghostVis    = false;
        lapLapTimes = {};
        lapNum      = 0;
        lapTime     = 0;
        lapTimes    = {};
        lastLapTime = 0;
        lastWpTime  = 0;
        login       = "";
        mapCpCount  = 0;
        mapLapCount = 0;
        mapWpCount  = 0;
        maxFps      = 0;
        name        = "";
        noEngine    = false;
        p_vis       = 0x0;
        raceTime    = 0;
        respawns    = 0;
        sequence    = CGamePlaygroundUIConfig::EUISequence::None;
        spawning    = false;
        startTick   = 0;
        ticks       = 0;
        turbo       = false;
        turboTimer  = 0.0f;
        vehicleType = CurrentEffects::VehicleType::Unknown;
        viewMode    = CurrentEffects::ViewMode::Unknown;
        wpCount     = 0;
        wpTimes     = {};
    }

    void Update() {
        throw("State::Update() unimplemented");
    }
}

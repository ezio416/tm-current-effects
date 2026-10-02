abstract class State {
    CurrentEffects::Camera                           camera;
    bool                                 driving;
    bool                                 finished;
    string                               gameMode;
    bool                                 ghostVis;
    string                               login;
    string                               name;
    bool                                 noEngine;
    uint64                               p_vis;
    uint                                 respawns;
    CGamePlaygroundUIConfig::EUISequence sequence;
    bool                                 spawning;
    uint                                 startTick;
    uint                                 ticks;
    bool                                 turbo;
    float                                turboTimer;
    CurrentEffects::VehicleType                      vehicleType;
    CurrentEffects::ViewMode                         viewMode;

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
        _RenderDebugRow("camera",      Color::DebugCamera(camera));
        _RenderDebugRow("driving",     Color::DebugBool(driving));
        _RenderDebugRow("finished",    Color::DebugBool(finished));
        _RenderDebugRow("gameMode",    Color::DebugString(gameMode));
        _RenderDebugRow("ghostVis",    Color::DebugBool(ghostVis));
        _RenderDebugRow("login",       Color::DebugString(login));
        _RenderDebugRow("name",        Color::DebugFormattedString(name));
        _RenderDebugRow("noEngine",    Color::DebugBool(noEngine));
        _RenderDebugRow("p_vis",       Color::DebugPointer(p_vis));
        _RenderDebugRow("respawns",    Color::DebugInt(respawns));
        _RenderDebugRow("sequence",    Color::DebugSequence(sequence));
        _RenderDebugRow("spawning",    Color::DebugBool(spawning));
        _RenderDebugRow("startTick",   Color::DebugInt(startTick));
        _RenderDebugRow("ticks",       Color::DebugInt(ticks));
        _RenderDebugRow("turbo",       Color::DebugBool(turbo));
        _RenderDebugRow("turboTimer",  Color::DebugFloat(turboTimer));
        _RenderDebugRow("vehicleType", Color::DebugVehicleType(vehicleType));
        _RenderDebugRow("viewMode",    Color::DebugViewMode(viewMode));
    }

    void Reset() {
        camera      = CurrentEffects::Camera::Unknown;
        driving     = false;
        finished    = false;
        gameMode    = "";
        ghostVis    = false;
        login       = "";
        name        = "";
        noEngine    = false;
        p_vis       = 0x0;
        respawns    = 0;
        sequence    = CGamePlaygroundUIConfig::EUISequence::None;
        spawning    = false;
        startTick   = 0;
        ticks       = 0;
        turbo       = false;
        turboTimer  = 0.0f;
        vehicleType = CurrentEffects::VehicleType::Unknown;
        viewMode    = CurrentEffects::ViewMode::Unknown;
    }

    void Update() {
        throw("State::Update() unimplemented");
    }
}

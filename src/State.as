abstract class State {
    CurrentEffects::Camera               camera;
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
    CurrentEffects::VehicleType          vehicleType;
    CurrentEffects::ViewMode             viewMode;

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
        _RenderDebugRow("driving",     ColorDebugBool(driving));
        _RenderDebugRow("finished",    ColorDebugBool(finished));
        _RenderDebugRow("gameMode",    ColorDebugString(gameMode));
        _RenderDebugRow("ghostVis",    ColorDebugBool(ghostVis));
        _RenderDebugRow("login",       ColorDebugString(login));
        _RenderDebugRow("name",        ColorDebugFormattedString(name));
        _RenderDebugRow("noEngine",    ColorDebugBool(noEngine));
        _RenderDebugRow("p_vis",       ColorDebugPointer(p_vis));
        _RenderDebugRow("respawns",    ColorDebugInt(respawns));
        _RenderDebugRow("sequence",    ColorDebugSequence(sequence));
        _RenderDebugRow("spawning",    ColorDebugBool(spawning));
        _RenderDebugRow("startTick",   ColorDebugInt(startTick));
        _RenderDebugRow("ticks",       ColorDebugInt(ticks));
        _RenderDebugRow("turbo",       ColorDebugBool(turbo));
        _RenderDebugRow("turboTimer",  ColorDebugFloat(turboTimer));
        _RenderDebugRow("vehicleType", ColorDebugVehicleType(vehicleType));
        _RenderDebugRow("viewMode",    ColorDebugViewMode(viewMode));
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

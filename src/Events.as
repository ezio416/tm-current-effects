// c 2023-10-01
// m 2023-03-13

#if TMNEXT

bool fragileBeforeCp = false;
bool intercepting    = false;

void Intercept() {
    if (!S_Experimental)
        return;

    if (intercepting) {
        warn("Intercept called, but it's already running!");
        return;
    }

    ResetEventEffects();

    if (GetApp().CurrentPlayground is null)
        return;

    trace("Intercept starting for \"LayerCustomEvent\"");

    try {
        Dev::InterceptProc("CGameManiaApp", "LayerCustomEvent", _Intercept);
        intercepting = true;
    } catch {
        warn("Intercept error: " + getExceptionInfo());
    }
}

void ResetIntercept() {
    if (!intercepting) {
        warn("ResetIntercept called, but Intercept isn't running!");
        return;
    }

    trace("Intercept ending for \"LayerCustomEvent\"");

    try {
        Dev::ResetInterceptProc("CGameManiaApp", "LayerCustomEvent");
        intercepting = false;
    } catch {
        warn("ResetIntercept error: " + getExceptionInfo());
    }
}

void ToggleIntercept() {
    if (S_Experimental && !intercepting) {
        Intercept();
        return;
    }

    if (!S_Experimental && intercepting)
        ResetIntercept();
}

bool _Intercept(CMwStack &in stack, CMwNod@ nod) {
    try {
        CaptureEvent(stack.CurrentWString(1), stack.CurrentBufferWString());
    } catch {
        warn("Exception in Intercept: " + getExceptionInfo());
    }

    return true;
}

void CaptureEvent(const string &in type, MwFastBuffer<wstring> &in data) {
    if (type == "BlockHelper_Event_GameplaySpecial") {  // only works while playing
        if (data[0].Contains("Reset"))
            ResetEventEffects();
        else if (data[0].Contains("Fragile"))
            state.Fragile = CurrentEffects::ActiveState::Active;
    } else if (type == "TMGame_RaceCheckpoint_Waypoint") {  // works while spectating?
        fragileBeforeCp = state.Fragile == 1;
    }
}

void ResetEventEffects() {
    state.Fragile = CurrentEffects::ActiveState::NotActive;
}

#endif

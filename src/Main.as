// c 2023-05-04
// m 2024-03-13

bool           lastExperimental = false;
bool           lastRunHidden    = false;
string         loginLocal;
InternalState@ state;
uint           totalRespawns    = 0;

void RenderMenu() {
    if (UI::MenuItem("\\$F00" + Icons::React + "\\$G Current Effects", "", S_Enabled))
        S_Enabled = !S_Enabled;
}

#if TMNEXT
void OnDestroyed() { OnDisabled(); }
void OnDisabled() {
    if (intercepting)
        ResetIntercept();
}
#endif

void Main() {
    @state = InternalState();

    startnew(CacheLocalLogin);
    ChangeFont();
    SetColors();

#if TMNEXT
    Intercept();
#endif
}

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();

    SetColors();

#if TMNEXT
    ToggleIntercept();
#endif
}

void Update(float) {
    if (state is null)
        return;

    if (!state.Init) {
        state.Init = true;
        state.Experimental = S_Experimental;
        state.RunWhenHidden = S_RunHidden;
        return;
    }

    if (lastExperimental != S_Experimental) {
        lastExperimental = S_Experimental;
        state.Experimental = S_Experimental;
    } else
        S_Experimental = state.Experimental;

    if (lastRunHidden != S_RunHidden) {
        lastRunHidden = S_RunHidden;
        state.RunWhenHidden = S_RunHidden;
    } else
        S_RunHidden = state.RunWhenHidden;
}

void Render() {
    const bool shouldHide = (S_HideWithGame && !UI::IsGameUIVisible()) || (S_HideWithOP && !UI::IsOverlayShown());
    if (
        !S_Enabled
        || font is null
        || (shouldHide && !S_RunHidden)
    ) {
        ResetAllEffects();
        return;
    }

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

#if MP4 || TURBO
    CGamePlayground@ Playground = App.CurrentPlayground;

    if (Playground is null) {
        ResetAllEffects();
        return;
    }

#elif TMNEXT
    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);

    if (Playground is null) {
        if (intercepting)
            ResetIntercept();

        totalRespawns = 0;
        ResetAllEffects();
        return;
    }

    if (App.RootMap is null) {
        ResetAllEffects();
        return;
    }

    if (!intercepting)
        Intercept();

    CSmArena@ Arena = Playground.Arena;

    if (Arena is null || Arena.Players.Length == 0) {
        ResetAllEffects();
        return;
    }

    CSmScriptPlayer@ ScriptPlayer = cast<CSmScriptPlayer@>(Arena.Players[0].ScriptAPI);
    if (ScriptPlayer is null) {
        ResetAllEffects();
        return;
    }

    if (ScriptPlayer.CurrentRaceTime < 1) {
        ResetEventEffects();
        fragileBeforeCp = false;
    }

    CSmArenaScore@ Score = ScriptPlayer.Score;
    if (Score is null) {
        ResetAllEffects();
        return;
    }

    uint respawns = Score.NbRespawnsRequested;

    if (totalRespawns < respawns) {
        totalRespawns = respawns;
        ResetEventEffects();

        if (fragileBeforeCp)
            state.Fragile = CurrentEffects::ActiveState::Active;
    }
#endif

    if (Playground.GameTerminals.Length != 1 || Playground.UIConfigs.Length == 0) {
        ResetAllEffects();
        return;
    }

#if TMNEXT
    ISceneVis@ Scene = App.GameScene;
#elif MP4 || TURBO
    CGameScene@ Scene = App.GameScene;
#endif

    if (Scene is null) {
        ResetAllEffects();
        return;
    }

#if TMNEXT
    CSceneVehicleVis@ Vis;
#elif MP4 || TURBO
    CSceneVehicleVisState@ Vis;
#endif

#if TURBO
    @Vis = VehicleState::ViewingPlayerState();
#else
    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);

    if (Player !is null) {
        @Vis = VehicleState::GetVis(Scene, Player);
        state.WatchingReplay = false;
    } else {
        @Vis = VehicleState::GetSingularVis(Scene);
        state.WatchingReplay = true;
    }
#endif

#if MP4
    if (Vis is null) {
        CSceneVehicleVisState@[] states = VehicleState::GetAllVis(Scene);

        if (states.Length > 0)
            @Vis = states[0];
    }
#endif

    if (Vis is null) {
        ResetAllEffects();
        return;
    }

    CGamePlaygroundUIConfig::EUISequence Sequence = Playground.UIConfigs[0].UISequence;
    if (
        Sequence != CGamePlaygroundUIConfig::EUISequence::Playing &&
        !(Sequence == CGamePlaygroundUIConfig::EUISequence::EndRound
#if TMNEXT
        && state.WatchingReplay
#endif
    )) {
        ResetAllEffects();
        return;
    }

#if TMNEXT
    CSmPlayer@ ViewingPlayer = VehicleState::GetViewingPlayer();
    state.Spectating = ((ViewingPlayer is null ? "" : ViewingPlayer.ScriptAPI.Login) != loginLocal) && !state.WatchingReplay;
#endif

#if TURBO
    RenderEffects(Vis, shouldHide);
#else
    RenderEffects(Vis.AsyncState, shouldHide);
#endif
}

// courtesy of "Auto-hide Opponents" plugin - https://github.com/XertroV/tm-autohide-opponents
void CacheLocalLogin() {
    while (true) {
        sleep(100);

        loginLocal = GetLocalLogin();

        if (loginLocal.Length > 10)
            break;
    }
}

class InternalState : CurrentEffects::State {
    InternalState() { super(true); }

    void set_AccelPenalty           (CurrentEffects::ActiveState a)      { _penalty      = a; }
    void set_CruiseControl          (CurrentEffects::ActiveState a)      { _cruise       = a; }
    void set_ForcedAccel            (CurrentEffects::ActiveState a)      { _forced       = a; }
    void set_Fragile                (CurrentEffects::ActiveState a)      { _fragile      = a; }
    void set_NoBrakes               (CurrentEffects::ActiveState a)      { _noBrakes     = a; }
    void set_NoEngine               (CurrentEffects::ActiveState a)      { _noEngine     = a; }
    void set_NoGrip                 (CurrentEffects::ActiveState a)      { _noGrip       = a; }
    void set_NoSteer                (CurrentEffects::ActiveState a)      { _noSteer      = a; }
    void set_ReactorBoostFinalTimer (float f)                            { _reactorTimer = f; }

#if TMNEXT
    void set_ReactorBoostLevel      (ESceneVehicleVisReactorBoostLvl e)  { _reactorLevel = e; }
    void set_ReactorBoostType       (ESceneVehicleVisReactorBoostType e) { _reactorType  = e; }
#endif

    void set_Spectating             (bool b)                             { _spectating   = b; }
    void set_SlowMoLevel            (int i)                              { _slowMo       = i; }
    void set_TurboLevel             (int i)                              { _turbo        = i; }
    void set_TurboTime              (float f)                            { _turboTime    = f; }
    void set_Vehicle                (int i)                              { _vehicle      = i; }
    void set_WatchingReplay         (bool b)                             { _replay       = b; }

    bool get_Init()       { return _init; }
    void set_Init(bool i) { _init = i;    }
}

// c 2023-05-04
// m 2024-02-26

string loginLocal;
bool   replay        = false;
bool   spectating    = false;
uint   totalRespawns = 0;

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

void Render() {
    if (!S_Enabled
        || font is null
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    ) {
        ResetAllEffects();
        return;
    }

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

#if MP4

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
            fragile = 1;
    }

#endif

    if (Playground.GameTerminals.Length != 1 || Playground.UIConfigs.Length == 0) {
        ResetAllEffects();
        return;
    }

#if TMNEXT
    ISceneVis@ Scene = App.GameScene;
#elif MP4
    CGameScene@ Scene = cast<CGameScene@>(App.GameScene);
#endif

    if (Scene is null) {
        ResetAllEffects();
        return;
    }

#if TMNEXT
    CSceneVehicleVis@ Vis;
#elif MP4
    CSceneVehicleVisState@ Vis;
#endif

    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);

    if (Player !is null) {
        @Vis = VehicleState::GetVis(Scene, Player);
        replay = false;
    } else {
        @Vis = VehicleState::GetSingularVis(Scene);
        replay = true;
    }

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
        !(Sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(Sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    ) {
        ResetAllEffects();
        return;
    }

#if TMNEXT

    CSmPlayer@ ViewingPlayer = VehicleState::GetViewingPlayer();
    spectating = ((ViewingPlayer is null ? "" : ViewingPlayer.ScriptAPI.Login) != loginLocal) && !replay;

#endif

    RenderEffects(Vis.AsyncState);
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
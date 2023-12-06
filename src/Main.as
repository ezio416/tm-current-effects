/*
c 2023-05-04
m 2023-11-26
*/

string loginLocal = GetLocalLogin();
bool replay;
bool spectating;
uint totalRespawns = 0;

void Main() {
    startnew(CacheLocalLogin);
    ChangeFont();
    SetColors();
    Intercept();
}

void OnDisabled()  { ResetIntercept(); }
void OnDestroyed() { ResetIntercept(); }

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();

    SetColors();
    ToggleIntercept();
}

void RenderMenu() {
    if (UI::MenuItem("\\$F00" + Icons::React + "\\$G Current Effects", "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Render() {
    if (
        !S_Enabled ||
        font is null ||
        (S_HideWithGame && !UI::IsGameUIVisible()) ||
        (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    CTrackMania@ app = cast<CTrackMania@>(GetApp());

#if TMNEXT
    CSmArenaClient@ playground = cast<CSmArenaClient@>(app.CurrentPlayground);
#elif MP4
    CGamePlayground@ playground = cast<CGamePlayground@>(app.CurrentPlayground);
#endif

    if (playground is null) {
        if (intercepting)
            ResetIntercept();
        totalRespawns = 0;
        return;
    }

#if TMNEXT

    if (!intercepting)
        Intercept();

    CSmArena@ arena = cast<CSmArena@>(playground.Arena);

    if (arena is null)
        return;

    if (arena.Players.Length == 0)
        return;

    CSmScriptPlayer@ script = cast<CSmScriptPlayer@>(arena.Players[0].ScriptAPI);

    if (script is null)
        return;

    if (script.CurrentRaceTime < 1) {
        ResetEventEffects(true, true);
        fragileBeforeCp = false;
        snowBeforeCp = false;
    }

    CSmArenaScore@ score = cast<CSmArenaScore@>(script.Score);

    if (score is null)
        return;

    uint respawns = score.NbRespawnsRequested;
    if (totalRespawns < respawns) {
        totalRespawns = respawns;
        ResetEventEffects(true, true);
        if (fragileBeforeCp)
            fragile = 1;
        if (snowBeforeCp)
            snow = 1;
    }

#endif

    if (
        playground.GameTerminals.Length != 1 ||
        playground.UIConfigs.Length == 0
    )
        return;

#if TMNEXT
    ISceneVis@ scene = cast<ISceneVis@>(app.GameScene);
#elif MP4
    CGameScene@ scene = cast<CGameScene@>(app.GameScene);
#endif

    if (scene is null)
        return;

#if TMNEXT
    CSceneVehicleVis@ vis;
#elif MP4
    CSceneVehicleVisState@ vis;
#endif

    CSmPlayer@ player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
    if (player !is null) {
        @vis = VehicleState::GetVis(scene, player);
        replay = false;
    } else {
        @vis = VehicleState::GetSingularVis(scene);
        replay = true;
    }

#if MP4

    if (vis is null) {
        CSceneVehicleVisState@[] states = VehicleState::GetAllVis(scene);
        if (states.Length > 0)
            @vis = states[0];
    }

#endif

    if (vis is null)
        return;

    CGamePlaygroundUIConfig::EUISequence sequence = playground.UIConfigs[0].UISequence;
    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    )
        return;

#if TMNEXT

    CGamePlaygroundInterface@ pgInterface = cast<CGamePlaygroundInterface@>(playground.Interface);
    if (pgInterface is null)
        return;

    CGameScriptHandlerPlaygroundInterface@ handler = cast<CGameScriptHandlerPlaygroundInterface@>(pgInterface.ManialinkScriptHandler);
    if (handler is null)
        return;

    CGamePlaygroundClientScriptAPI@ pgAPI = cast<CGamePlaygroundClientScriptAPI@>(handler.Playground);
    if (pgAPI is null)
        return;

    CSmPlayer@ ViewingPlayer = VehicleState::GetViewingPlayer();
    spectating = ((ViewingPlayer is null ? "" : ViewingPlayer.ScriptAPI.Login) != loginLocal) && !replay;

#endif

    RenderEffects(vis.AsyncState);
}

// from "Auto-hide Opponents" plugin - https://github.com/XertroV/tm-autohide-opponents
void CacheLocalLogin() {
    while (true) {
        sleep(100);
        loginLocal = GetLocalLogin();
        if (loginLocal.Length > 10)
            break;
    }
}
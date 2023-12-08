/*
c 2023-05-04
m 2023-12-07
*/

bool alwaysSnow = false;  // to change when starting as CarSnow is no longer broken
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

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

#if TMNEXT

    CGameCtnChallenge@ Map = App.RootMap;
    if (Map is null) {
        alwaysSnow = false;
        return;
    }

    if (Map.VehicleName.GetName() == "CarSnow") {
        alwaysSnow = true;
        snow = 1;
    }

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);

#elif MP4

    CGamePlayground@ Playground = cast<CGamePlayground@>(App.CurrentPlayground);

#endif

    if (Playground is null) {
        if (intercepting)
            ResetIntercept();
        totalRespawns = 0;
        return;
    }

#if TMNEXT

    if (!intercepting)
        Intercept();

    CSmArena@ Arena = cast<CSmArena@>(Playground.Arena);

    if (Arena is null)
        return;

    if (Arena.Players.Length == 0)
        return;

    CSmScriptPlayer@ Script = cast<CSmScriptPlayer@>(Arena.Players[0].ScriptAPI);

    if (Script is null)
        return;

    if (Script.CurrentRaceTime < 1) {
        ResetEventEffects(true, true);
        fragileBeforeCp = false;
        snowBeforeCp = false;
    }

    CSmArenaScore@ Score = cast<CSmArenaScore@>(Script.Score);

    if (Score is null)
        return;

    uint respawns = Score.NbRespawnsRequested;
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
        Playground.GameTerminals.Length != 1 ||
        Playground.UIConfigs.Length == 0
    )
        return;

#if TMNEXT
    ISceneVis@ Scene = cast<ISceneVis@>(App.GameScene);
#elif MP4
    CGameScene@ Scene = cast<CGameScene@>(App.GameScene);
#endif

    if (Scene is null)
        return;

#if TMNEXT
    CSceneVehicleVis@ vis;
#elif MP4
    CSceneVehicleVisState@ vis;
#endif

    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    if (Player !is null) {
        @vis = VehicleState::GetVis(Scene, Player);
        replay = false;
    } else {
        @vis = VehicleState::GetSingularVis(Scene);
        replay = true;
    }

#if MP4

    if (vis is null) {
        CSceneVehicleVisState@[] states = VehicleState::GetAllVis(Scene);
        if (states.Length > 0)
            @vis = states[0];
    }

#endif

    if (vis is null)
        return;

    CGamePlaygroundUIConfig::EUISequence Sequence = Playground.UIConfigs[0].UISequence;
    if (
        !(Sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(Sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    )
        return;

#if TMNEXT

    // CGamePlaygroundInterface@ pgInterface = cast<CGamePlaygroundInterface@>(Playground.Interface);
    // if (pgInterface is null)
    //     return;

    // CGameScriptHandlerPlaygroundInterface@ Handler = cast<CGameScriptHandlerPlaygroundInterface@>(pgInterface.ManialinkScriptHandler);
    // if (Handler is null)
    //     return;

    // CGamePlaygroundClientScriptAPI@ PgAPI = cast<CGamePlaygroundClientScriptAPI@>(Handler.Playground);
    // if (PgAPI is null)
    //     return;

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
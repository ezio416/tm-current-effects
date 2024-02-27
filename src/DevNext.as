// c 2024-01-09
// m 2024-02-27

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string titleDev         = title + " (Developer)";
string version;

// game versions for which the offsets in this file are valid
const string[] validGameVersions = {
    "2024-01-10_12_53",  // released 2024-01-10
    // "2024-02-26_11_36"   // released 2024-02-27
};

// offsets for which a value is known
const int[] knownVisOffsets = {
    0, 140, 144, 312, 316, 320, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 384, 388, 392, 396, 400,
    404, 408, 412, 416, 544, 580, 592, 652, 656, 660, 664, 668, 672
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedVisOffsets = {
    124, 128, 456, 460, 464, 480, 484, 488, 504, 508, 512, 528, 532, 536, 548, 552, 556, 564, 560, 568, 572, 576, 584, 588, 596
};

const int[] knownStateOffsets = {
    0, 8, 16, 20, 24, 32, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 116, 120, 128, 136, 138, 139,
    168, 172, 176, 180, 184, 185, 188, 192, 196, 200, 204, 208,  // FL
    212, 216, 220, 224, 228, 229, 232, 236, 240, 244, 248, 252,  // FR
    256, 260, 264, 268, 272, 273, 276, 280, 284, 288, 292, 296,  // RR
    300, 304, 308, 312, 316, 317, 320, 324, 328, 332, 336, 340,  // RL
    368, 372, 376, 380, 381, 384, 388, 392, 396, 400, 404, 408, 420, 428, 436, 440, 456, 460, 464, 468, 472, 536,
    560, 564, 568, 572, 576, 788, 792, 796, 800, 804, 808
};

const int[] observedStateOffsets = {
    12, 104, 108, 112, 412, 552, 556, 612, 780, 784, 812, 816, 840, 864, 1704, 1728
};

const int[] knownPlayerOffsets = {
    396, 400, 404, 416, 428, 432, 436, 448, 464, 468, 476, 536, 540, 544, 552, 680, 876, 880, 884,
    3612, 3616, 3620, 3624, 3628, 3632, 3768, 3772, 3776, 3780, 3784, 3788, 3804, 3808, 3812, 3816, 3820, 3824, 3828, 3840, 3844, 3860, 3872, 3876, 3880, 3884, 3888, 3892, 3896, 3900, 3904, 4132, 4136, 4140, 4152
};

const int[] observedPlayerOffsets = {
    564, 596, 628, 632, 636, 640, 648, 652, 660, 664, 668, 672, 864, 868, 3596, 3600, 3604, 3608, 3792, 3796, 3800, 4128
};

const int[] knownScoreOffsets = {
};

const int[] observedScoreOffsets = {
};

const int[] knownScriptOffsets = {
};

const int[] observedScriptOffsets = {
};

const int[] knownUserOffsets = {
};

const int[] observedUserOffsets = {
};

void InitDevNext() {
    version = GetApp().SystemPlatform.ExeVersion;
    gameVersionValid = validGameVersions.Find(version) > -1;

    if (!S_OffsetTabsAlways)
        S_OffsetTabs = false;
}

void RenderDevNext() {
    if (
        !S_Dev
        || version.Length == 0
        || (S_DevHideWithGame && !UI::IsGameUIVisible())
        || (S_DevHideWithOP && !UI::IsOverlayShown())
    )
        return;

    UI::Begin(titleDev, S_Dev, UI::WindowFlags::None);
        if (!gameVersionValid)
            UI::TextWrapped(RED + "Game version " + version + " not marked valid! Values may be wrong.");

        UI::BeginTabBar("##dev-tabs");
            Tab_Vis();
            Tab_State();
            Tab_Player();
            Tab_Score();
            Tab_Script();
            Tab_User();
        UI::EndTabBar();
    UI::End();
}

void Tab_Vis() {
    if (!UI::BeginTabItem("CSceneVehicleVis"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    ISceneVis@ Scene = cast<ISceneVis@>(App.GameScene);
    if (Scene is null) {
        UI::Text(RED + "null Scene");
        UI::EndTabItem();
        return;
    }

    bool meExists = false;

    CSceneVehicleVis@[] AllVis = VehicleState::GetAllVis(Scene);

    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    CSceneVehicleVis@ MyVis = Player !is null ? VehicleState::GetVis(Scene, Player) : VehicleState::GetSingularVis(Scene);
    if (MyVis !is null) {
        AllVis.InsertAt(0, MyVis);
        meExists = true;
    }

    UI::TextWrapped(ORANGE + "CSceneVehicleVis\\$G's are part of " + ORANGE + "App.GameScene\\$G, and are accessible with the VehicleState plugin.");
    UI::TextWrapped("This tab is mainly only for values that have not been found directly in " + ORANGE + "CSceneVehicleVisState\\$G, or are in different locations.");

    UI::BeginTabBar("##vis-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < AllVis.Length; i++) {
            CSceneVehicleVis@ Vis = AllVis[i];

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::Eye + " Viewing" : tostring(i))) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##vis-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderVisApiValues(Vis); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderVisOffsetValues(Vis); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderVisOffsets(Vis); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderVisApiValues(CSceneVehicleVis@ Vis) {
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##vis-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::TableNextRow();
        UI::TableNextColumn(); UI::Text("Turbo");
        UI::TableNextColumn(); UI::Text("Float");

        string value = Round(Vis.Turbo);
        UI::TableNextColumn();
        if (UI::Selectable(value, false))
            SetClipboard(value);

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderVisOffsetValues(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast(OffsetValue(Vis, 0,   "VehicleId",            DataType::Int32));
    values.InsertLast(OffsetValue(Vis, 140, "LinearHue",            DataType::Float));
    values.InsertLast(OffsetValue(Vis, 144, "LinearHue",            DataType::Float));

    values.InsertLast({"312,324,336", "0x138,144,150", "Left", "Vec3", Round(vec3(Dev::GetOffsetFloat(Vis, 312), Dev::GetOffsetFloat(Vis, 324), Dev::GetOffsetFloat(Vis, 336)))});
    values.InsertLast({"316,328,340", "0x13C,148,154", "Up",   "Vec3", Round(vec3(Dev::GetOffsetFloat(Vis, 316), Dev::GetOffsetFloat(Vis, 328), Dev::GetOffsetFloat(Vis, 340)))});
    values.InsertLast({"320,332,344", "0x140,14C,158", "Dir",  "Vec3", Round(vec3(Dev::GetOffsetFloat(Vis, 320), Dev::GetOffsetFloat(Vis, 332), Dev::GetOffsetFloat(Vis, 344)))});

    values.InsertLast(OffsetValue(Vis, 348, "Position",             DataType::Vec3));
    values.InsertLast(OffsetValue(Vis, 360, "WorldVel",             DataType::Vec3));
    values.InsertLast(OffsetValue(Vis, 372, "NbRespawnsOrResets",   DataType::Int32));
    values.InsertLast(OffsetValue(Vis, 376, "IsWheelsBurning",      DataType::Bool));
    values.InsertLast(OffsetValue(Vis, 384, "FLIcing01",            DataType::Float));
    values.InsertLast(OffsetValue(Vis, 388, "FRIcing01",            DataType::Float));
    values.InsertLast(OffsetValue(Vis, 392, "RRIcing01",            DataType::Float));
    values.InsertLast(OffsetValue(Vis, 396, "RLIcing01",            DataType::Float));
    values.InsertLast(OffsetValue(Vis, 400, "FLSlipCoef",           DataType::Float));
    values.InsertLast(OffsetValue(Vis, 404, "FRSlipCoef",           DataType::Float));
    values.InsertLast(OffsetValue(Vis, 408, "RRSlipCoef",           DataType::Float));
    values.InsertLast(OffsetValue(Vis, 412, "RLSlipCoef",           DataType::Float));
    values.InsertLast(OffsetValue(Vis, 416, "InputGasPedal",        DataType::Float));
    values.InsertLast(OffsetValue(Vis, 456, "FL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 460, "FL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 464, "FL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 480, "FR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 484, "FR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 488, "FR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 504, "RR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 508, "RR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 512, "RR",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 528, "RL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 532, "RL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 536, "RL",                   DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 544, "InputIsBraking",       DataType::Float));
    values.InsertLast(OffsetValue(Vis, 548, "BrakingCoefStrong",    DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 552, "ReactorDesired",       DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 556, "Reactor",              DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 560, "YellowReactorDesired", DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 564, "YellowReactor",        DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 568, "RedReactorDesired",    DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 572, "RedReactor",           DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 576, "TurboDesired",         DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 580, "Turbo",                DataType::Float));
    values.InsertLast(OffsetValue(Vis, 584, "TurboDesired",         DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 588, "Turbo",                DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 592, "InputIsBraking",       DataType::Float));
    values.InsertLast(OffsetValue(Vis, 596, "BrakingCoefWeak",      DataType::Float, false));
    values.InsertLast(OffsetValue(Vis, 652, "AirBrakeDesired",      DataType::Float));
    values.InsertLast(OffsetValue(Vis, 656, "AirBrakeNormed",       DataType::Float));
    values.InsertLast(OffsetValue(Vis, 660, "SpoilerOpenDesired",   DataType::Float));
    values.InsertLast(OffsetValue(Vis, 664, "SpoilerOpenNormed",    DataType::Float));
    values.InsertLast(OffsetValue(Vis, 668, "WingsOpenDesired",     DataType::Float));
    values.InsertLast(OffsetValue(Vis, 672, "WingsOpenNormed",      DataType::Float));

    if (UI::BeginTable("##vis-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 140.0f);
        UI::TableSetupColumn("Variable",     UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",         UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);
                UI::TableNextColumn(); UI::Text(values[i][2]);
                UI::TableNextColumn(); UI::Text(values[i][3]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][4], false))
                    SetClipboard(values[i][4]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##vis-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownVisOffsets.Find(offset) > -1 ? "" : (observedVisOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  Vis, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  Vis, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( Vis, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( Vis, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Vis, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( Vis, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Vis, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( Vis, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Vis, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( Vis, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  Vis, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  Vis, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  Vis, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  Vis, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    value = YELLOW + getExceptionInfo();
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

void Tab_State() {
    if (!UI::BeginTabItem("CSceneVehicleVisState"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    ISceneVis@ Scene = cast<ISceneVis@>(App.GameScene);
    if (Scene is null) {
        UI::Text(RED + "null Scene");
        UI::EndTabItem();
        return;
    }

    bool meExists = false;

    CSceneVehicleVis@[] AllVis = VehicleState::GetAllVis(Scene);

    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    CSceneVehicleVis@ MyVis = Player !is null ? VehicleState::GetVis(Scene, Player) : VehicleState::GetSingularVis(Scene);
    if (MyVis !is null) {
        AllVis.InsertAt(0, MyVis);
        meExists = true;
    }

    UI::TextWrapped(ORANGE + "CSceneVehicleVisState\\$G is a part of " + ORANGE + "CSceneVehicleVis\\$G.");

    UI::BeginTabBar("##state-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < AllVis.Length; i++) {
            CSceneVehicleVis@ Vis = AllVis[i];
            CSceneVehicleVisState@ State = Vis.AsyncState;

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::Eye + " Viewing" : tostring(i))) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##state-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderStateApiValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderStateOffsetValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderStateOffsets(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderStateApiValues(CSceneVehicleVisState@ State) {
    UI::TextWrapped("Variables marked " + CYAN + "cyan\\$G are from the VehicleState plugin.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast({"AirBrakeNormed",           "Float",   Round(    State.AirBrakeNormed)});
    values.InsertLast({"BulletTimeNormed",         "Float",   Round(    State.BulletTimeNormed)});
    values.InsertLast({"CamGrpStates",             "???",     RED + "unknown new type"});
    values.InsertLast({"CurGear",                  "Uint32",  RoundUint(State.CurGear)});
    values.InsertLast({"Dir",                      "Vec3",    Round(    State.Dir)});
    values.InsertLast({"DiscontinuityCount",       "Uint8",   RoundUint(State.DiscontinuityCount)});
    values.InsertLast({"EngineOn",                 "Bool",    Round(    State.EngineOn)});
    values.InsertLast({CYAN + "EngineRPM",         "Float",   Round(    VehicleState::GetRPM(State))});
    values.InsertLast({"FLBreakNormedCoef",        "Float",   Round(    State.FLBreakNormedCoef)});
    values.InsertLast({"FLDamperLen",              "Float",   Round(    State.FLDamperLen)});
    values.InsertLast({CYAN + "FLDirt",            "Float",   Round(    VehicleState::GetWheelDirt(State, 0))});
    values.InsertLast({"FLGroundContactMaterial",  "Enum",    tostring( State.FLGroundContactMaterial)});
    values.InsertLast({"FLIcing01",                "Float",   Round(    State.FLIcing01)});
    values.InsertLast({"FLSlipCoef",               "Float",   Round(    State.FLSlipCoef)});
    values.InsertLast({"FLSteerAngle",             "Float",   Round(    State.FLSteerAngle)});
    values.InsertLast({"FLTireWear01",             "Float",   Round(    State.FLTireWear01)});
    values.InsertLast({"FLWheelRot",               "Float",   Round(    State.FLWheelRot)});
    values.InsertLast({"FLWheelRotSpeed",          "Float",   Round(    State.FLWheelRotSpeed)});
    values.InsertLast({"FRBreakNormedCoef",        "Float",   Round(    State.FRBreakNormedCoef)});
    values.InsertLast({"FRDamperLen",              "Float",   Round(    State.FRDamperLen)});
    values.InsertLast({CYAN + "FRDirt",            "Float",   Round(    VehicleState::GetWheelDirt(State, 1))});
    values.InsertLast({"FRGroundContactMaterial",  "Enum",    tostring( State.FRGroundContactMaterial)});
    values.InsertLast({"FRIcing01",                "Float",   Round(    State.FRIcing01)});
    values.InsertLast({"FRSlipCoef",               "Float",   Round(    State.FRSlipCoef)});
    values.InsertLast({"FRSteerAngle",             "Float",   Round(    State.FRSteerAngle)});
    values.InsertLast({"FrontSpeed",               "Float",   Round(    State.FrontSpeed)});
    values.InsertLast({"FRTireWear01",             "Float",   Round(    State.FRTireWear01)});
    values.InsertLast({"FRWheelRot",               "Float",   Round(    State.FRWheelRot)});
    values.InsertLast({"FRWheelRotSpeed",          "Float",   Round(    State.FRWheelRotSpeed)});
    values.InsertLast({"GroundDist",               "Float",   Round(    State.GroundDist)});
    values.InsertLast({"InputBrakePedal",          "Float",   Round(    State.InputBrakePedal)});
    values.InsertLast({"InputGasPedal",            "Float",   Round(    State.InputGasPedal)});
    values.InsertLast({"InputIsBraking",           "Bool",    Round(    State.InputIsBraking)});
    values.InsertLast({"InputSteer",               "Float",   Round(    State.InputSteer)});
    values.InsertLast({"InputVertical",            "Float",   Round(    State.InputVertical)});
    values.InsertLast({"IsGroundContact",          "Bool",    Round(    State.IsGroundContact)});
    values.InsertLast({"IsReactorGroundMode",      "Bool",    Round(    State.IsReactorGroundMode)});
    values.InsertLast({"IsTopContact",             "Bool",    Round(    State.IsTopContact)});
    values.InsertLast({"IsTurbo",                  "Bool",    Round(    State.IsTurbo)});
    values.InsertLast({"IsWheelsBurning",          "Bool",    Round(    State.IsWheelsBurning)});
    values.InsertLast({CYAN + "LastTurboLevel",    "Enum",    tostring( VehicleState::GetLastTurboLevel(State))});
    values.InsertLast({"Left",                     "Vec3",    Round(    State.Left)});
    values.InsertLast({"Position",                 "Vec3",    Round(    State.Position)});
    values.InsertLast({"RaceStartTime",            "Uint32",  RoundUint(State.RaceStartTime)});
    values.InsertLast({"ReactorAirControl",        "Vec3",    Round(    State.ReactorAirControl)});
    values.InsertLast({"ReactorBoostLvl",          "Enum",    tostring( State.ReactorBoostLvl)});
    values.InsertLast({"ReactorBoostType",         "Enum",    tostring( State.ReactorBoostType)});
    values.InsertLast({CYAN + "ReactorFinalTimer", "Float",   Round(    VehicleState::GetReactorFinalTimer(State))});
    values.InsertLast({"ReactorInputsX",           "Bool",    Round(    State.ReactorInputsX)});
    values.InsertLast({"RLBreakNormedCoef",        "Float",   Round(    State.RLBreakNormedCoef)});
    values.InsertLast({"RLDamperLen",              "Float",   Round(    State.RLDamperLen)});
    values.InsertLast({CYAN + "RLDirt",            "Float",   Round(    VehicleState::GetWheelDirt(State, 2))});
    values.InsertLast({"RLGroundContactMaterial",  "Enum",    tostring( State.RLGroundContactMaterial)});
    values.InsertLast({"RLIcing01",                "Float",   Round(    State.RLIcing01)});
    values.InsertLast({"RLSlipCoef",               "Float",   Round(    State.RLSlipCoef)});
    values.InsertLast({"RLSteerAngle",             "Float",   Round(    State.RLSteerAngle)});
    values.InsertLast({"RLTireWear01",             "Float",   Round(    State.RLTireWear01)});
    values.InsertLast({"RLWheelRot",               "Float",   Round(    State.RLWheelRot)});
    values.InsertLast({"RLWheelRotSpeed",          "Float",   Round(    State.RLWheelRotSpeed)});
    values.InsertLast({"RRBreakNormedCoef",        "Float",   Round(    State.RRBreakNormedCoef)});
    values.InsertLast({"RRDamperLen",              "Float",   Round(    State.RRDamperLen)});
    values.InsertLast({CYAN + "RRDirt",            "Float",   Round(    VehicleState::GetWheelDirt(State, 3))});
    values.InsertLast({"RRGroundContactMaterial",  "Enum",    tostring( State.RRGroundContactMaterial)});
    values.InsertLast({"RRIcing01",                "Float",   Round(    State.RRIcing01)});
    values.InsertLast({"RRSlipCoef",               "Float",   Round(    State.RRSlipCoef)});
    values.InsertLast({"RRSteerAngle",             "Float",   Round(    State.RRSteerAngle)});
    values.InsertLast({"RRTireWear01",             "Float",   Round(    State.RRTireWear01)});
    values.InsertLast({"RRWheelRot",               "Float",   Round(    State.RRWheelRot)});
    values.InsertLast({"RRWheelRotSpeed",          "Float",   Round(    State.RRWheelRotSpeed)});
    values.InsertLast({CYAN + "SideSpeed",         "Float",   Round(    VehicleState::GetSideSpeed(State))});
    values.InsertLast({"SimulationTimeCoef",       "Float",   Round(    State.SimulationTimeCoef)});
    values.InsertLast({"SpoilerOpenNormed",        "Float",   Round(    State.SpoilerOpenNormed)});
    values.InsertLast({"TurboTime",                "Float",   Round(    State.TurboTime)});
    values.InsertLast({"Up",                       "Vec3",    Round(    State.Up)});
    values.InsertLast({"WaterImmersionCoef",       "Float",   Round(    State.WaterImmersionCoef)});
    values.InsertLast({"WaterOverDistNormed",      "Float",   Round(    State.WaterOverDistNormed)});
    values.InsertLast({"WaterOverSurfacePos",      "Vec3",    Round(    State.WaterOverSurfacePos)});
    values.InsertLast({"WetnessValue01",           "Float",   Round(    State.WetnessValue01)});
    values.InsertLast({"WingsOpenNormed",          "Float",   Round(    State.WingsOpenNormed)});
    values.InsertLast({"WorldCarUp",               "Vec3",    Round(    State.WorldCarUp)});
    values.InsertLast({"WorldVel",                 "Vec3",    Round(    State.WorldVel)});

    if (UI::BeginTable("##state-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][2], false))
                    SetClipboard(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderStateOffsetValues(CSceneVehicleVisState@ State) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast(OffsetValue(State, 0,    "EntityId",                DataType::Uint32));
    values.InsertLast(OffsetValue(State, 8,    "VehicleType",             DataType::Uint8));
    values.InsertLast(OffsetValue(State, 16,   "InputSteer",              DataType::Float));
    values.InsertLast(OffsetValue(State, 20,   "InputGasPedal",           DataType::Float));
    values.InsertLast(OffsetValue(State, 24,   "InputBrakePedal",         DataType::Float));
    values.InsertLast(OffsetValue(State, 32,   "InputIsBraking",          DataType::Bool));

    values.InsertLast({"44,56,68", "0x2C,38,44", "Left", "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 44), Dev::GetOffsetFloat(State, 56), Dev::GetOffsetFloat(State, 68)))});
    values.InsertLast({"48,60,72", "0x30,3C,48", "Up",   "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 48), Dev::GetOffsetFloat(State, 60), Dev::GetOffsetFloat(State, 72)))});
    values.InsertLast({"52,64,76", "0x34,40,4C", "Dir",  "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 52), Dev::GetOffsetFloat(State, 64), Dev::GetOffsetFloat(State, 76)))});

    values.InsertLast(OffsetValue(State, 80,   "Position",                DataType::Vec3));
    values.InsertLast(OffsetValue(State, 92,   "WorldVel",                DataType::Vec3));
    values.InsertLast(OffsetValue(State, 116,  "FrontSpeed",              DataType::Float));
    values.InsertLast(OffsetValue(State, 120,  "SideSpeed",               DataType::Float));
    values.InsertLast(OffsetValue(State, 128,  "CruiseDisplaySpeed",      DataType::Int32));

    values.InsertLast({"136", "0x88", "ContactState1", "Enum", tostring(ContactState1(Dev::GetOffsetInt8(State, 136)))});
    values.InsertLast({"138", "0x8A", "ContactState2", "Enum", tostring(ContactState2(Dev::GetOffsetInt8(State, 138)))});
    values.InsertLast({"139", "0x8B", "IsTurbo",       "Enum", tostring(TurboState   (Dev::GetOffsetInt8(State, 139)))});

    values.InsertLast(OffsetValue(State, 168,  "FLDamperLen",             DataType::Float));
    values.InsertLast(OffsetValue(State, 172,  "FLWheelRot",              DataType::Float));
    values.InsertLast(OffsetValue(State, 176,  "FLWheelRotSpeed",         DataType::Float));
    values.InsertLast(OffsetValue(State, 180,  "FLSteerAngle",            DataType::Float));
    values.InsertLast(OffsetValue(State, 184,  "FLGroundContactMaterial", DataType::Enum));
    values.InsertLast(OffsetValue(State, 185,  "FLGroundContactEffect",   DataType::Enum));
    values.InsertLast(OffsetValue(State, 188,  "FLSlipCoef",              DataType::Float));
    values.InsertLast(OffsetValue(State, 192,  "FLDirt",                  DataType::Float));
    values.InsertLast(OffsetValue(State, 196,  "FLIcing01",               DataType::Float));
    values.InsertLast(OffsetValue(State, 200,  "FLTireWear01",            DataType::Float));
    values.InsertLast(OffsetValue(State, 204,  "FLBreakNormedCoef",       DataType::Float));
    values.InsertLast(OffsetValue(State, 208,  "FLFalling",               DataType::Enum));

    values.InsertLast(OffsetValue(State, 212,  "FRDamperLen",             DataType::Float));
    values.InsertLast(OffsetValue(State, 216,  "FRWheelRot",              DataType::Float));
    values.InsertLast(OffsetValue(State, 220,  "FRWheelRotSpeed",         DataType::Float));
    values.InsertLast(OffsetValue(State, 224,  "FRSteerAngle",            DataType::Float));
    values.InsertLast(OffsetValue(State, 228,  "FRGroundContactMaterial", DataType::Enum));
    values.InsertLast(OffsetValue(State, 229,  "FRGroundContactEffect",   DataType::Enum));
    values.InsertLast(OffsetValue(State, 232,  "FRSlipCoef",              DataType::Float));
    values.InsertLast(OffsetValue(State, 236,  "FRDirt",                  DataType::Float));
    values.InsertLast(OffsetValue(State, 240,  "FRIcing01",               DataType::Float));
    values.InsertLast(OffsetValue(State, 244,  "FRTireWear01",            DataType::Float));
    values.InsertLast(OffsetValue(State, 248,  "FRBreakNormedCoef",       DataType::Float));
    values.InsertLast(OffsetValue(State, 252,  "FRFalling",               DataType::Enum));

    values.InsertLast(OffsetValue(State, 256,  "RRDamperLen",             DataType::Float));
    values.InsertLast(OffsetValue(State, 260,  "RRWheelRot",              DataType::Float));
    values.InsertLast(OffsetValue(State, 264,  "RRWheelRotSpeed",         DataType::Float));
    values.InsertLast(OffsetValue(State, 268,  "RRSteerAngle",            DataType::Float));
    values.InsertLast(OffsetValue(State, 272,  "RRGroundContactMaterial", DataType::Enum));
    values.InsertLast(OffsetValue(State, 273,  "RRGroundContactEffect",   DataType::Enum));
    values.InsertLast(OffsetValue(State, 276,  "RRSlipCoef",              DataType::Float));
    values.InsertLast(OffsetValue(State, 280,  "RRDirt",                  DataType::Float));
    values.InsertLast(OffsetValue(State, 284,  "RRIcing01",               DataType::Float));
    values.InsertLast(OffsetValue(State, 288,  "RRTireWear01",            DataType::Float));
    values.InsertLast(OffsetValue(State, 292,  "RRBreakNormedCoef",       DataType::Float));
    values.InsertLast(OffsetValue(State, 296,  "RRFalling",               DataType::Enum));

    values.InsertLast(OffsetValue(State, 300,  "RLDamperLen",             DataType::Float));
    values.InsertLast(OffsetValue(State, 304,  "RLWheelRot",              DataType::Float));
    values.InsertLast(OffsetValue(State, 308,  "RLWheelRotSpeed",         DataType::Float));
    values.InsertLast(OffsetValue(State, 312,  "RLSteerAngle",            DataType::Float));
    values.InsertLast(OffsetValue(State, 316,  "RLGroundContactMaterial", DataType::Enum));
    values.InsertLast(OffsetValue(State, 317,  "RLGroundContactEffect",   DataType::Enum));
    values.InsertLast(OffsetValue(State, 320,  "RLSlipCoef",              DataType::Float));
    values.InsertLast(OffsetValue(State, 324,  "RLDirt",                  DataType::Float));
    values.InsertLast(OffsetValue(State, 328,  "RLIcing01",               DataType::Float));
    values.InsertLast(OffsetValue(State, 332,  "RLTireWear01",            DataType::Float));
    values.InsertLast(OffsetValue(State, 336,  "RLBreakNormedCoef",       DataType::Float));
    values.InsertLast(OffsetValue(State, 340,  "RLFalling",               DataType::Enum));

    values.InsertLast({"368", "0x170", "LastTurboLevel",   "Enum", tostring(VehicleState::TurboLevel        (Dev::GetOffsetInt8(State, 368)))});
    values.InsertLast({"372", "0x174", "ReactorBoostLvl",  "Enum", tostring(ESceneVehicleVisReactorBoostLvl (Dev::GetOffsetInt8(State, 372)))});
    values.InsertLast({"376", "0x178", "ReactorBoostType", "Enum", tostring(ESceneVehicleVisReactorBoostType(Dev::GetOffsetInt8(State, 376)))});

    values.InsertLast(OffsetValue(State, 380,  "ReactorFinalTimer",       DataType::Float));
    values.InsertLast(OffsetValue(State, 384,  "ReactorAirControl",       DataType::Vec3));
    values.InsertLast(OffsetValue(State, 396,  "Up",                      DataType::Vec3));
    values.InsertLast(OffsetValue(State, 408,  "EngineRPM",               DataType::Float));
    values.InsertLast(OffsetValue(State, 420,  "CurGear",                 DataType::Uint32));
    values.InsertLast(OffsetValue(State, 428,  "TurboTime",               DataType::Float));
    values.InsertLast(OffsetValue(State, 436,  "RaceStartTime",           DataType::Uint32));
    values.InsertLast(OffsetValue(State, 440,  "HandicapSum",             DataType::Int32));
    values.InsertLast(OffsetValue(State, 456,  "LinearHue",               DataType::Float));
    values.InsertLast(OffsetValue(State, 460,  "LinearHue",               DataType::Float));
    values.InsertLast(OffsetValue(State, 464,  "LinearHueRed",            DataType::Float));
    values.InsertLast(OffsetValue(State, 468,  "LinearHueGreen",          DataType::Float));
    values.InsertLast(OffsetValue(State, 472,  "LinearHueBlue",           DataType::Float));
    values.InsertLast(OffsetValue(State, 536,  "GroundDist",              DataType::Float));
    values.InsertLast(OffsetValue(State, 560,  "SimulationTimeCoef",      DataType::Float));
    values.InsertLast(OffsetValue(State, 564,  "BulletTimeNormed",        DataType::Float));
    values.InsertLast(OffsetValue(State, 568,  "AirBrakeNormed",          DataType::Float));
    values.InsertLast(OffsetValue(State, 572,  "SpoilerOpenNormed",       DataType::Float));
    values.InsertLast(OffsetValue(State, 576,  "WingsOpenNormed",         DataType::Float));
    values.InsertLast(OffsetValue(State, 780,  "Sparks1",                 DataType::Int32, false));
    values.InsertLast(OffsetValue(State, 784,  "Sparks2",                 DataType::Int32, false));
    values.InsertLast(OffsetValue(State, 788,  "WaterImmersionCoef",      DataType::Float));
    values.InsertLast(OffsetValue(State, 792,  "WaterOverDistNormed",     DataType::Float));
    values.InsertLast(OffsetValue(State, 796,  "WaterOverSurfacePos",     DataType::Vec3));
    values.InsertLast(OffsetValue(State, 808,  "WetnessValue01",          DataType::Float));
    values.InsertLast(OffsetValue(State, 816,  "Sparks3",                 DataType::Int32, false));
    values.InsertLast(OffsetValue(State, 840,  "EntityId",                DataType::Uint32, false));
    values.InsertLast(OffsetValue(State, 864,  "EntityIdLast",            DataType::Uint32, false));
    values.InsertLast(OffsetValue(State, 1704, "EntityIdLast",            DataType::Uint32, false));
    values.InsertLast(OffsetValue(State, 1728, "StartingEntityId",        DataType::Uint32, false));

    if (UI::BeginTable("##state-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 140.0f);
        UI::TableSetupColumn("Variable",     UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",         UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);
                UI::TableNextColumn(); UI::Text(values[i][2]);
                UI::TableNextColumn(); UI::Text(values[i][3]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][4], false))
                    SetClipboard(values[i][4]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderStateOffsets(CSceneVehicleVisState@ State) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##state-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownStateOffsets.Find(offset) > -1 ? "" : (observedStateOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  State, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  State, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( State, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( State, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(State, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( State, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(State, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( State, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(State, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( State, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  State, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  State, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  State, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  State, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

void Tab_Player() {
    if (!UI::BeginTabItem("CSmPlayer"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    CSmArena@ Arena = Playground.Arena;
    if (Arena is null) {
        UI::Text(RED + "null Arena");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    CSmPlayer@ GUIPlayer = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    // if (GUIPlayer is null) {
    //     UI::Text(RED + "null GUIPlayer");
    //     UI::EndTabItem();
    //     return;
    // }

    MwFastBuffer<CSmPlayer@> Players;

    if (GUIPlayer !is null)
        Players.Add(GUIPlayer);

    for (uint i = 0; i < Arena.Players.Length; i++)
        Players.Add(Arena.Players[i]);

    UI::TextWrapped(ORANGE + "CSmPlayer\\$Gs can be found at " + ORANGE + "App.CurrentPlayground.Players\\$G and " + ORANGE + "App.CurrentPlayground.Arena.Players\\$G.");
    UI::TextWrapped("The current player (self) can also be found at " + ORANGE + "App.CurrentPlayground.GameTerminals[0].{ControlledPlayer/GUIPlayer}\\$G.");
    UI::TextWrapped("This tab is mainly only for values that have not been found directly in its sub-objects, or are in different locations.");

    UI::BeginTabBar("##player-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < Players.Length; i++) {
            CSmPlayer@ Player = Players[i];

            if (UI::BeginTabItem(i == 0 && GUIPlayer !is null ? Icons::User + " Me" : i + "_" + Player.User.Name)) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##player-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderPlayerApiValues(Player); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderPlayerOffsetValues(Player); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderPlayerOffsets(Player); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderPlayerApiValues(CSmPlayer@ Player) {
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast({"CurrentLaunchedRespawnLandmarkIndex",   "Uint32", RoundUint(Player.CurrentLaunchedRespawnLandmarkIndex)});
    values.InsertLast({"CurrentStoppedRespawnLandmarkIndex",    "Uint32", RoundUint(Player.CurrentStoppedRespawnLandmarkIndex)});
    values.InsertLast({"GetCurrentEntityID()",                  "Uint32", RoundUint(Player.GetCurrentEntityID())});
    values.InsertLast({"EdClan",                                "Uint32", RoundUint(Player.EdClan)});
    values.InsertLast({"EndTime",                               "Int32",  Round(    Player.EndTime)});
    values.InsertLast({"Flags",                                 "Uint8",  RoundUint(Player.Flags)});
    values.InsertLast({"Id.GetName()",                          "String",           Player.Id.GetName()});
    values.InsertLast({"Id.Value",                              "Uint32", RoundUint(Player.Id.Value)});
    values.InsertLast({"IdName",                                "String",           Player.IdName});
    values.InsertLast({"LinearHue",                             "Float",  Round(    Player.LinearHue)});
    values.InsertLast({"LinearHueSrgb",                         "Vec3",   Round(    Player.LinearHueSrgb)});
    values.InsertLast({"SkippedInputs",                         "Bool",   Round(    Player.SkippedInputs)});
    values.InsertLast({"SpawnableObjectModelIndex",             "Uint32", RoundUint(Player.SpawnableObjectModelIndex)});
    values.InsertLast({"SpawnIndex",                            "Int32",  Round(    Player.SpawnIndex)});
    values.InsertLast({"Speaking",                              "Bool",   Round(    Player.Speaking)});
    values.InsertLast({"StartTime",                             "Int32",  Round(    Player.StartTime)});
    values.InsertLast({"TrustClientSimu",                       "Bool",   Round(    Player.TrustClientSimu)});
    values.InsertLast({"TrustClientSimu_Client_IsTrustedState", "Bool",   Round(    Player.TrustClientSimu_Client_IsTrustedState)});
    values.InsertLast({"TrustClientSimu_ServerOverrideCount",   "Uint32", RoundUint(Player.TrustClientSimu_ServerOverrideCount)});
    values.InsertLast({"UseDelayedVisuals",                     "Bool",   Round(    Player.UseDelayedVisuals)});

    if (UI::BeginTable("##player-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 400.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][2], false))
                    SetClipboard(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderPlayerOffsetValues(CSmPlayer@ Player) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast(OffsetValue(Player, 396,  "InputSteerDirection",        DataType::Float));  // left (-1.0), right (1.0)
    values.InsertLast(OffsetValue(Player, 400,  "InputGasPedal",              DataType::Float));
    values.InsertLast(OffsetValue(Player, 404,  "InputBrakePedal",            DataType::Float));
    values.InsertLast(OffsetValue(Player, 416,  "InputActionKey",             DataType::Uint32));  // 1 (1028), 2 (4128), 3 (16384), 4 (65536), 5 (262144)
    values.InsertLast(OffsetValue(Player, 428,  "InputSteerDirection",        DataType::Float));
    values.InsertLast(OffsetValue(Player, 432,  "InputGasPedal",              DataType::Float));
    values.InsertLast(OffsetValue(Player, 436,  "InputBrakePedal",            DataType::Float));
    values.InsertLast(OffsetValue(Player, 448,  "InputActionKey",             DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 464,  "UseDelayedVisuals",          DataType::Bool));
    values.InsertLast(OffsetValue(Player, 468,  "TrustClientSimu",            DataType::Bool));
    values.InsertLast(OffsetValue(Player, 476,  "SpawnIndex",                 DataType::Int32));
    values.InsertLast(OffsetValue(Player, 536,  "StartTime",                  DataType::Int32));
    values.InsertLast(OffsetValue(Player, 540,  "StartTime",                  DataType::Int32));
    values.InsertLast(OffsetValue(Player, 544,  "LastRespawnTime",            DataType::Int32));  // -1 when not respawned
    values.InsertLast(OffsetValue(Player, 552,  "EndTime",                    DataType::Int32));
    values.InsertLast(OffsetValue(Player, 632,  "StadiumCarEntityId",         DataType::Uint32, false));
    values.InsertLast(OffsetValue(Player, 660,  "StadiumCarEntityId",         DataType::Uint32, false));
    values.InsertLast(OffsetValue(Player, 664,  "DesertCarEntityId",          DataType::Uint32, false));  // may be swapped with rally
    values.InsertLast(OffsetValue(Player, 668,  "RallyCarEntityId",           DataType::Uint32, false));  // may be swapped with desert
    values.InsertLast(OffsetValue(Player, 672,  "SnowCarEntityId",            DataType::Uint32, false));
    values.InsertLast(OffsetValue(Player, 680,  "SpawnableObjectModelIndex",  DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 876,  "Speaking",                   DataType::Bool));
    values.InsertLast(OffsetValue(Player, 880,  "SkippedInputs",              DataType::Bool));
    values.InsertLast(OffsetValue(Player, 884,  "LinearHue",                  DataType::Float));
    values.InsertLast(OffsetValue(Player, 3612, "Position",                   DataType::Vec3));
    values.InsertLast(OffsetValue(Player, 3624, "Velocity",                   DataType::Vec3));
    values.InsertLast(OffsetValue(Player, 3768, "Position",                   DataType::Vec3));
    values.InsertLast(OffsetValue(Player, 3780, "AimDirection",               DataType::Vec3));
    values.InsertLast(OffsetValue(Player, 3804, "FrontSpeed",                 DataType::Float));
    values.InsertLast(OffsetValue(Player, 3808, "DisplaySpeed",               DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3812, "InputSteer",                 DataType::Float));
    values.InsertLast(OffsetValue(Player, 3816, "InputGasPedal",              DataType::Float));
    values.InsertLast(OffsetValue(Player, 3820, "InputIsBraking",             DataType::Bool));
    values.InsertLast(OffsetValue(Player, 3824, "EngineRPM",                  DataType::Float));
    values.InsertLast(OffsetValue(Player, 3828, "EngineCurGear",              DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3840, "WheelsContactCount",         DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3844, "WheelsSkiddingCount",        DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3860, "FlyingDuration",             DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3872, "SkiddingDuration",           DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3876, "HandicapNoGasDuration",      DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3880, "HandicapForceGasDuration",   DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3884, "HandicapNoBrakesDuration",   DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3888, "HandicapNoSteeringDuration", DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3892, "HandicapNoGripDuration",     DataType::Uint32));
    values.InsertLast(OffsetValue(Player, 3896, "SkiddingDistance",           DataType::Float));
    values.InsertLast(OffsetValue(Player, 3900, "FlyingDistance",             DataType::Float));
    values.InsertLast(OffsetValue(Player, 3904, "Distance",                   DataType::Float));
    values.InsertLast(OffsetValue(Player, 4132, "InputSteerDirection",        DataType::Float));
    values.InsertLast(OffsetValue(Player, 4136, "InputGasPedal",              DataType::Float));
    values.InsertLast(OffsetValue(Player, 4140, "InputBrakePedal",            DataType::Float));
    values.InsertLast(OffsetValue(Player, 4152, "InputActionKey",             DataType::Uint32));

    if (UI::BeginTable("##player-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 140.0f);
        UI::TableSetupColumn("Variable",     UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",         UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);
                UI::TableNextColumn(); UI::Text(values[i][2]);
                UI::TableNextColumn(); UI::Text(values[i][3]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][4], false))
                    SetClipboard(values[i][4]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderPlayerOffsets(CSmPlayer@ Player) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##player-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownPlayerOffsets.Find(offset) > -1 ? "" : (observedPlayerOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  Player, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  Player, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( Player, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( Player, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Player, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( Player, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Player, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( Player, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Player, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( Player, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  Player, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  Player, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  Player, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  Player, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

void Tab_Score() {
    if (!UI::BeginTabItem("CSmArenaScore"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    CSmArena@ Arena = Playground.Arena;
    if (Arena is null) {
        UI::Text(RED + "null Arena");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    CSmPlayer@ GUIPlayer = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    if (GUIPlayer is null) {
        UI::Text(RED + "null GUIPlayer");
        UI::EndTabItem();
        return;
    }

    MwFastBuffer<CSmPlayer@> Players;
    Players.Add(GUIPlayer);

    for (uint i = 0; i < Arena.Players.Length; i++)
        Players.Add(Arena.Players[i]);

    UI::TextWrapped(ORANGE + "CSmArenaScore\\$G is a part of " + ORANGE + "CSmPlayer\\$G.");

    UI::BeginTabBar("##score-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < Players.Length; i++) {
            CSmPlayer@ Player = Players[i];

            if (UI::BeginTabItem(i == 0 ? Icons::User + " Me" : i + "_" + Player.User.Name)) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##score-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderScoreApiValues(Player.Score); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("API Arrays")) {
                    try   { RenderScoreApiArrays(Player.Score); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderScoreOffsetValues(Player.Score); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderScoreOffsets(Player.Score); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderScoreApiValues(CSmArenaScore@ Score) {
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast({"DamageInflicted",            "Uint32", RoundUint(Score.DamageInflicted)});
    values.InsertLast({"DamageInflicted_Ed",         "Uint32", RoundUint(Score.DamageInflicted_Ed)});
    values.InsertLast({"Id.GetName()",               "String",           Score.Id.GetName()});
    values.InsertLast({"Id.Value",                   "Uint32", RoundUint(Score.Id.Value)});
    values.InsertLast({"IdName",                     "String",           Score.IdName});
    values.InsertLast({"IsRegisteredForLadderMatch", "Bool",   Round(    Score.IsRegisteredForLadderMatch)});
    values.InsertLast({"LadderClan",                 "Uint32", RoundUint(Score.LadderClan)});
    values.InsertLast({"LadderMatchScoreValue",      "Float",  Round(    Score.LadderMatchScoreValue)});
    values.InsertLast({"LadderRankSortValue",        "Int32",  Round(    Score.LadderRankSortValue)});
    values.InsertLast({"LadderScore",                "Float",  Round(    Score.LadderScore)});
    values.InsertLast({"NbEliminationsInflicted",    "Uint32", RoundUint(Score.NbEliminationsInflicted)});
    values.InsertLast({"NbEliminationsInflicted_Ed", "Uint32", RoundUint(Score.NbEliminationsInflicted_Ed)});
    values.InsertLast({"NbEliminationsTaken",        "Uint32", RoundUint(Score.NbEliminationsTaken)});
    values.InsertLast({"NbEliminationsTaken_Ed",     "Uint32", RoundUint(Score.NbEliminationsTaken_Ed)});
    values.InsertLast({"NbEliminationsTaken",        "Uint32", RoundUint(Score.NbEliminationsTaken)});
    values.InsertLast({"NbRespawnsRequested",        "Uint32", RoundUint(Score.NbRespawnsRequested)});
    values.InsertLast({"Points",                     "Int32",  Round(    Score.Points)});
    values.InsertLast({"RoundPoints",                "Int32",  Round(    Score.RoundPoints)});
    values.InsertLast({"TeamNum",                    "Uint32", RoundUint(Score.TeamNum)});

    if (UI::BeginTable("##score-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 280.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][2], false))
                    SetClipboard(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderScoreApiArrays(CSmArenaScore@ Score) {
    UI::TextWrapped("These arrays of type " + ORANGE + "MsWArray<uint>\\$G don't actually seem to populate from my testing.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    UI::BeginTabBar("##score-api-arrays");
        if (UI::BeginTabItem("BestLapTimes")) {
            if (UI::BeginTable("##score-api-bestlap-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Score.BestLapTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Score.BestLapTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Score.BestLapTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("BestRaceTimes")) {
            if (UI::BeginTable("##score-api-bestrace-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Race");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Score.BestRaceTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Score.BestRaceTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Score.BestRaceTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("PrevLapTimes")) {
            if (UI::BeginTable("##score-api-prevlap-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Score.PrevLapTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Score.PrevLapTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Score.PrevLapTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("PrevRaceTimes")) {
            if (UI::BeginTable("##score-api-prevrace-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Race");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Score.PrevRaceTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Score.PrevRaceTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Score.PrevRaceTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

    UI::EndTabBar();
}

void RenderScoreOffsetValues(CSmArenaScore@ Score) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    ;
}

void RenderScoreOffsets(CSmArenaScore@ Score) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##score-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownScoreOffsets.Find(offset) > -1 ? "" : (observedScoreOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  Score, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  Score, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( Score, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( Score, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Score, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( Score, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Score, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( Score, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Score, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( Score, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  Score, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  Score, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  Score, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  Score, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

void Tab_Script() {
    if (!UI::BeginTabItem("CSmScriptPlayer"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    CSmArena@ Arena = Playground.Arena;
    if (Arena is null) {
        UI::Text(RED + "null Arena");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    CSmPlayer@ GUIPlayer = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    if (GUIPlayer is null) {
        UI::Text(RED + "null GUIPlayer");
        UI::EndTabItem();
        return;
    }

    MwFastBuffer<CSmPlayer@> Players;
    Players.Add(GUIPlayer);

    for (uint i = 0; i < Arena.Players.Length; i++)
        Players.Add(Arena.Players[i]);

    UI::TextWrapped(ORANGE + "CSmScriptPlayer\\$G is a part of " + ORANGE + "CSmPlayer\\$G.");

    UI::BeginTabBar("##script-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < Players.Length; i++) {
            CSmPlayer@ Player = Players[i];

            if (UI::BeginTabItem(i == 0 ? Icons::User + " Me" : i + "_" + Player.User.Name)) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##script-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderScriptApiValues(cast<CSmScriptPlayer@>(Player.ScriptAPI)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("API Arrays")) {
                    try   { RenderScriptApiArrays(cast<CSmScriptPlayer@>(Player.ScriptAPI)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderScriptOffsetValues(cast<CSmScriptPlayer@>(Player.ScriptAPI)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderScriptOffsets(cast<CSmScriptPlayer@>(Player.ScriptAPI)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderScriptApiValues(CSmScriptPlayer@ Script) {
    UI::TextWrapped("Most things here are remnants from Shootmania and serve no purpose in Trackmania.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast({"AccelCoef",                    "Float",   Round(    Script.AccelCoef)});
    values.InsertLast({"ActionWheelSelectedSlotIndex", "Uint32",  RoundUint(Script.ActionWheelSelectedSlotIndex)});
    values.InsertLast({"AdherenceCoef",                "Float",   Round(    Script.AdherenceCoef)});
    values.InsertLast({"AimDirection",                 "Vec3",    Round(    Script.AimDirection)});
    values.InsertLast({"AimPitch",                     "Float",   Round(    Script.AimPitch)});
    values.InsertLast({"AimRoll",                      "Float",   Round(    Script.AimRoll)});
    values.InsertLast({"AimYaw",                       "Float",   Round(    Script.AimYaw)});
    values.InsertLast({"AllowProgressiveJump",         "Bool",    Round(    Script.AllowProgressiveJump)});
    values.InsertLast({"AllowWallJump",                "Bool",    Round(    Script.AllowWallJump)});
    values.InsertLast({"AmmoGain",                     "Float",   Round(    Script.AmmoGain)});
    values.InsertLast({"AmmoPower",                    "Float",   Round(    Script.AmmoPower)});
    values.InsertLast({"Armor",                        "Uint32",  RoundUint(Script.Armor)});
    values.InsertLast({"ArmorGain",                    "Uint32",  RoundUint(Script.ArmorGain)});
    values.InsertLast({"ArmorMax",                     "Uint32",  RoundUint(Script.ArmorMax)});
    values.InsertLast({"ArmorPower",                   "Float",   Round(    Script.ArmorPower)});
    values.InsertLast({"ArmorReplenishGain",           "Uint32",  RoundUint(Script.ArmorReplenishGain)});
    values.InsertLast({"AutoSwitchWeapon",             "Bool",    Round(    Script.AutoSwitchWeapon)});
    values.InsertLast({"CapturedLandmark",             "Object",            Script.CapturedLandmark is null ? RED + "null" : GREEN + "valid (unimplemented here)"});
    values.InsertLast({"ControlCoef",                  "Float",   Round(    Script.ControlCoef)});
    values.InsertLast({"CurAmmo",                      "Uint32",  RoundUint(Script.CurAmmo)});
    values.InsertLast({"CurAmmoMax",                   "Uint32",  RoundUint(Script.CurAmmoMax)});
    values.InsertLast({"CurAmmoUnit",                  "Uint32",  RoundUint(Script.CurAmmoUnit)});
    values.InsertLast({"CurrentClan",                  "Int32",   Round(    Script.CurrentClan)});
    values.InsertLast({"CurrentLapNumber",             "Uint32",  RoundUint(Script.CurrentLapNumber)});
    values.InsertLast({"CurrentLapTime",               "Int32",   Round(    Script.CurrentLapTime)});
    values.InsertLast({"CurrentRaceTime",              "Int32",   Round(    Script.CurrentRaceTime)});
    values.InsertLast({"CurWeapon",                    "Uint32",  RoundUint(Script.CurWeapon)});
    values.InsertLast({"DisplaySpeed",                 "Uint32",  RoundUint(Script.DisplaySpeed)});
    values.InsertLast({"Distance",                     "Float",   Round(    Script.Distance)});
    values.InsertLast({"Dossard",                      "String",            Script.Dossard});
    values.InsertLast({"Dossard_Color",                "Vec3",    Round(    Script.Dossard_Color)});
    values.InsertLast({"Dossard_Number",               "String",            Script.Dossard_Number});
    values.InsertLast({"Dossard_Trigram",              "String",            Script.Dossard_Trigram});
    values.InsertLast({"Driver",                       "Object",            Script.Driver is null ? RED + "null" : GREEN + "valid (unimplemented here)"});
    values.InsertLast({"EndTime",                      "Int32",   Round(    Script.EndTime)});
    values.InsertLast({"Energy",                       "Float",   Round(    Script.Energy)});
    values.InsertLast({"EnergyLevel",                  "Float",   Round(    Script.EnergyLevel)});
    values.InsertLast({"EngineCurGear",                "Int32",   Round(    Script.EngineCurGear)});
    values.InsertLast({"EngineRpm",                    "Float",   Round(    Script.EngineRpm)});
    values.InsertLast({"EngineTurboRatio",             "Float",   Round(    Script.EngineTurboRatio)});
    values.InsertLast({"FlyingDistance",               "Float",   Round(    Script.FlyingDistance)});
    values.InsertLast({"FlyingDuration",               "Uint32",  RoundUint(Script.FlyingDuration)});
    values.InsertLast({"ForceColor",                   "Vec3",    Round(    Script.ForceColor)});
    values.InsertLast({"ForceLinearHue",               "Float",   Round(    Script.ForceLinearHue)});
    values.InsertLast({"ForceModelId.GetName()",       "String",            Script.ForceModelId.GetName()});
    values.InsertLast({"ForceModelId.Value",           "Uint32",  RoundUint(Script.ForceModelId.Value)});
    values.InsertLast({"GetLinearHue",                 "Float",   Round(    Script.GetLinearHue)});
    values.InsertLast({"GravityCoef",                  "Float",   Round(    Script.GravityCoef)});
    values.InsertLast({"HandicapForceGasDuration",     "Uint32",  RoundUint(Script.HandicapForceGasDuration)});
    values.InsertLast({"HandicapNoBrakesDuration",     "Uint32",  RoundUint(Script.HandicapNoBrakesDuration)});
    values.InsertLast({"HandicapNoGasDuration",        "Uint32",  RoundUint(Script.HandicapNoGasDuration)});
    values.InsertLast({"HandicapNoGripDuration",       "Uint32",  RoundUint(Script.HandicapNoGripDuration)});
    values.InsertLast({"HandicapNoSteeringDuration",   "Uint32",  RoundUint(Script.HandicapNoSteeringDuration)});
    values.InsertLast({"HasShield",                    "Bool",    Round(    Script.HasShield)});
    values.InsertLast({"Id.GetName()",                 "String",            Script.Id.GetName()});
    values.InsertLast({"Id.Value",                     "Uint32",  RoundUint(Script.Id.Value)});
    values.InsertLast({"IdleDuration",                 "Uint32",  RoundUint(Script.IdleDuration)});
    values.InsertLast({"IdName",                       "String",            Script.IdName});
    values.InsertLast({"InputGasPedal",                "Float",   Round(    Script.InputGasPedal)});
    values.InsertLast({"InputIsBraking",               "Bool",    Round(    Script.InputIsBraking)});
    values.InsertLast({"InputSteer",                   "Float",   Round(    Script.InputSteer)});
    values.InsertLast({"IsAttractorActivable",         "Bool",    Round(    Script.IsAttractorActivable)});
    values.InsertLast({"IsBot",                        "Bool",    Round(    Script.IsBot)});
    values.InsertLast({"IsCapturing",                  "Bool",    Round(    Script.IsCapturing)});
    values.InsertLast({"IsEntityStateAvailable",       "Bool",    Round(    Script.IsEntityStateAvailable)});
    values.InsertLast({"IsFakePlayer",                 "Bool",    Round(    Script.IsFakePlayer)});
    values.InsertLast({"IsHighlighted",                "Bool",    Round(    Script.IsHighlighted)});
    values.InsertLast({"IsInAir",                      "Bool",    Round(    Script.IsInAir)});
    values.InsertLast({"IsInOffZone",                  "Bool",    Round(    Script.IsInOffZone)});
    values.InsertLast({"IsInVehicle",                  "Bool",    Round(    Script.IsInVehicle)});
    values.InsertLast({"IsInWater",                    "Bool",    Round(    Script.IsInWater)});
    values.InsertLast({"IsOnTech",                     "Bool",    Round(    Script.IsOnTech)});
    values.InsertLast({"IsOnTechArmor",                "Bool",    Round(    Script.IsOnTechArmor)});
    values.InsertLast({"IsOnTechArrow",                "Bool",    Round(    Script.IsOnTechArrow)});
    values.InsertLast({"IsOnTechGround",               "Bool",    Round(    Script.IsOnTechGround)});
    values.InsertLast({"IsOnTechLaser",                "Bool",    Round(    Script.IsOnTechLaser)});
    values.InsertLast({"IsOnTechNoWeapon",             "Bool",    Round(    Script.IsOnTechNoWeapon)});
    values.InsertLast({"IsOnTechNucleus",              "Bool",    Round(    Script.IsOnTechNucleus)});
    values.InsertLast({"IsOnTechSafeZone",             "Bool",    Round(    Script.IsOnTechSafeZone)});
    values.InsertLast({"IsOnTechTeleport",             "Bool",    Round(    Script.IsOnTechTeleport)});
    values.InsertLast({"IsPowerJumpActivable",         "Bool",    Round(    Script.IsPowerJumpActivable)});
    values.InsertLast({"IsRunning",                    "Bool",    Round(    Script.IsRunning)});
    values.InsertLast({"IsStuck",                      "Bool",    Round(    Script.IsStuck)});
    values.InsertLast({"IsTeleportActivable",          "Bool",    Round(    Script.IsTeleportActivable)});
    values.InsertLast({"IsTouchingGround",             "Bool",    Round(    Script.IsTouchingGround)});
    values.InsertLast({"IsUnderground",                "Bool",    Round(    Script.IsUnderground)});
    values.InsertLast({"JumpPower",                    "Float",   Round(    Script.JumpPower)});
    values.InsertLast({"LandmarkOrderSelector_Race",   "Int32",   Round(    Script.LandmarkOrderSelector_Race)});
    values.InsertLast({"LapStartTime",                 "Int32",   Round(    Script.LapStartTime)});
    values.InsertLast({"LeftDirection",                "Vec3",    Round(    Script.LeftDirection)});
    values.InsertLast({"Login",                        "String",            Script.Login});
    values.InsertLast({"MarkerId.GetName()",           "String",            Script.MarkerId.GetName()});
    values.InsertLast({"MarkerId.Value",               "Uint32",  RoundUint(Script.MarkerId.Value)});
    values.InsertLast({"Name",                         "WString", string(   Script.Name)});
    values.InsertLast({"NbActiveAttractors",           "Uint32",  RoundUint(Script.NbActiveAttractors)});
    values.InsertLast({"Objects",                      "Object[]",          Script.Objects.Length == 0 ? RED + "none" : GREEN + Script.Objects.Length + " (unimplemented here)"});
    values.InsertLast({"Position",                     "Vec3",    Round(    Script.Position)});
    values.InsertLast({"Post",                         "Enum",    tostring( Script.Post)});
    values.InsertLast({"RequestedClan",                "Int32",   Round(    Script.RequestedClan)});
    values.InsertLast({"RequestsSpectate",             "Bool",    Round(    Script.RequestsSpectate)});
    values.InsertLast({"SkiddingDistance",             "Float",   Round(    Script.SkiddingDistance)});
    values.InsertLast({"SkiddingDuration",             "Uint32",  RoundUint(Script.SkiddingDuration)});
    values.InsertLast({"SpawnStatus",                  "Enum",    tostring( Script.SpawnStatus)});
    values.InsertLast({"Speed",                        "Float",   Round(    Script.Speed)});
    values.InsertLast({"SpeedPower",                   "Float",   Round(    Script.SpeedPower)});
    values.InsertLast({"Stamina",                      "Uint32",  RoundUint(Script.Stamina)});
    values.InsertLast({"StaminaGain",                  "Float",   Round(    Script.StaminaGain)});
    values.InsertLast({"StaminaMax",                   "Float",   Round(    Script.StaminaMax)});
    values.InsertLast({"StaminaMaxValue",              "Uint32",  RoundUint(Script.StaminaMaxValue)});
    values.InsertLast({"StaminaPower",                 "Float",   Round(    Script.StaminaPower)});
    values.InsertLast({"StartTime",                    "Int32",   Round(    Script.StartTime)});
    values.InsertLast({"ThrowSpeed",                   "Float",   Round(    Script.ThrowSpeed)});
    values.InsertLast({"TrustClientSimu",              "Bool",    Round(    Script.TrustClientSimu)});
    values.InsertLast({"UpDirection",                  "Vec3",    Round(    Script.UpDirection)});
    values.InsertLast({"Upwardness",                   "Float",   Round(    Script.Upwardness)});
    values.InsertLast({"UseAlternateWeaponVisual",     "Bool",    Round(    Script.UseAlternateWeaponVisual)});
    values.InsertLast({"UseCrudeExtrapolation",        "Bool",    Round(    Script.UseCrudeExtrapolation)});
    values.InsertLast({"UseDelayedVisuals",            "Bool",    Round(    Script.UseDelayedVisuals)});
    values.InsertLast({"Vehicle",                      "Object",            Script.Vehicle is null ? RED + "null" : GREEN + "valid (unimplemented here)"});
    values.InsertLast({"Velocity",                     "Vec3",    Round(    Script.Velocity)});
    values.InsertLast({"WheelsContactCount",           "Uint32",  RoundUint(Script.WheelsContactCount)});
    values.InsertLast({"WheelsSkiddingCount",          "Uint32",  RoundUint(Script.WheelsSkiddingCount)});

    if (UI::BeginTable("##script-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 280.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][2], false))
                    SetClipboard(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderScriptApiArrays(CSmScriptPlayer@ Script) {
    UI::TextWrapped("These arrays of type " + ORANGE + "MwFastBuffer<uint>\\$G don't actually seem to populate from my testing.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    UI::BeginTabBar("##script-api-arrays");
        if (UI::BeginTabItem("CurrentLapWaypointTimes")) {
            if (UI::BeginTable("##script-api-curlap-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Script.CurrentLapWaypointTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Script.CurrentLapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Script.CurrentLapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("LapWaypointTimes")) {
            if (UI::BeginTable("##script-api-lap-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Script.LapWaypointTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Script.LapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Script.LapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("PreviousLapWaypointTimes")) {
            if (UI::BeginTable("##script-api-prevlap-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Script.PreviousLapWaypointTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Script.PreviousLapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Script.PreviousLapWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

        if (UI::BeginTabItem("RaceWaypointTimes")) {
            if (UI::BeginTable("##script-api-race-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Lap");
                UI::TableSetupColumn("Time (Uint32)");
                UI::TableSetupColumn("Time (Formatted)");
                UI::TableHeadersRow();

                UI::ListClipper clipper(Script.RaceWaypointTimes.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();
                        UI::TableNextColumn(); UI::Text(tostring(i));

                        string value = tostring(Script.RaceWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);

                        value = Time::Format(Script.RaceWaypointTimes[i]);
                        UI::TableNextColumn();
                        if (UI::Selectable(value, false))
                            SetClipboard(value);
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }

            UI::EndTabItem();
        }

    UI::EndTabBar();
}

void RenderScriptOffsetValues(CSmScriptPlayer@ Script) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    ;
}

void RenderScriptOffsets(CSmScriptPlayer@ Script) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##script-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownScriptOffsets.Find(offset) > -1 ? "" : (observedScriptOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  Script, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  Script, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( Script, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( Script, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Script, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( Script, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Script, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( Script, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Script, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( Script, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  Script, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  Script, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  Script, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  Script, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

void Tab_User() {
    if (!UI::BeginTabItem("CTrackManiaPlayerInfo"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    CSmArena@ Arena = Playground.Arena;
    if (Arena is null) {
        UI::Text(RED + "null Arena");
        UI::EndTabItem();
        return;
    }

    if (Playground.GameTerminals.Length == 0) {
        UI::Text(RED + "no GameTerminals");
        UI::EndTabItem();
        return;
    }

    CSmPlayer@ GUIPlayer = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    if (GUIPlayer is null) {
        UI::Text(RED + "null GUIPlayer");
        UI::EndTabItem();
        return;
    }

    MwFastBuffer<CSmPlayer@> Players;
    Players.Add(GUIPlayer);

    for (uint i = 0; i < Arena.Players.Length; i++)
        Players.Add(Arena.Players[i]);

    UI::TextWrapped(ORANGE + "CTrackManiaPlayerInfo\\$G is a part of " + ORANGE + "App\\$G, " + ORANGE + "CSmPlayer\\$G, " + ORANGE + "CSmArenaScore\\$G, and " + ORANGE + "CSmScriptPlayer\\$G.");

    UI::BeginTabBar("##user-tabs", UI::TabBarFlags::FittingPolicyScroll | UI::TabBarFlags::TabListPopupButton);
        for (uint i = 0; i < Players.Length; i++) {
            CSmPlayer@ Player = Players[i];

            if (UI::BeginTabItem(i == 0 ? Icons::User + " Me" : i + "_" + Player.User.Name)) {
                if (!S_OffsetTabs && UI::Button(Icons::Eye + " Show offset tabs"))
                        S_OffsetTabs = true;

                UI::BeginTabBar("##user-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderUserApiValues(cast<CTrackManiaPlayerInfo@>(Player.User)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("API Arrays")) {
                    try   { RenderUserApiArrays(cast<CTrackManiaPlayerInfo@>(Player.User)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Offset Values")) {
                    try   { RenderUserOffsetValues(cast<CTrackManiaPlayerInfo@>(Player.User)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (S_OffsetTabs && UI::BeginTabItem("Raw Offsets")) {
                    try   { RenderUserOffsets(cast<CTrackManiaPlayerInfo@>(Player.User)); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderUserApiValues(CTrackManiaPlayerInfo@ User) {
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    values.InsertLast({"AvatarDisplayName",               "WString", string(   User.AvatarDisplayName)});
    values.InsertLast({"AvatarUrl",                       "String",            User.AvatarUrl});
    values.InsertLast({"BroadcastTVLogin",                "String",            User.BroadcastTVLogin});
    values.InsertLast({"ChallengeSequenceNumber",         "Uint32",  RoundUint(User.ChallengeSequenceNumber)});
    values.InsertLast({"Character_SkinOptions",           "String",            User.Character_SkinOptions});
    values.InsertLast({"ClubLink",                        "String",            User.ClubLink});
    values.InsertLast({"ClubTag",                         "WString", string(   User.ClubTag)});
    values.InsertLast({"Color",                           "Vec3",    Round(    User.Color)});
    values.InsertLast({"ColorblindModeEnabled",           "Bool",    Round(    User.ColorblindModeEnabled)});
    values.InsertLast({"CountryFlagUrl",                  "String",            User.CountryFlagUrl});
    values.InsertLast({"CountryPath",                     "WString", string(   User.CountryPath)});
    values.InsertLast({"CustomDataDeactivated",           "Bool",    Round(    User.CustomDataDeactivated)});
    values.InsertLast({"DbgClientUId",                    "Uint32",  RoundUint(User.DbgClientUId)});
    values.InsertLast({"Description",                     "WString", string(   User.Description)});
    values.InsertLast({"DownloadRate",                    "Uint32",  RoundUint(User.DownloadRate)});
    values.InsertLast({"Echelon",                         "Enum",    tostring( User.Echelon)});
    values.InsertLast({"EnableHomologation",              "Bool",    Round(    User.EnableHomologation)});
    values.InsertLast({"FameStars",                       "Uint",    RoundUint(User.FameStars)});
    values.InsertLast({"ForcedSpectator",                 "Bool",    Round(    User.ForcedSpectator)});
    values.InsertLast({"GameStateName",                   "String",            User.GameStateName});
    values.InsertLast({"HackCamHmdDisabled",              "Bool",    Round(    User.HackCamHmdDisabled)});
    values.InsertLast({"HornDisplayName",                 "WString", string(   User.HornDisplayName)});
    values.InsertLast({"Id.GetName()",                    "String",            User.Id.GetName()});
    values.InsertLast({"Id.Value",                        "Uint32",  RoundUint(User.Id.Value)});
    values.InsertLast({"IdName",                          "String",            User.IdName});
    values.InsertLast({"IsBeginner",                      "Bool",    Round(    User.IsBeginner)});
    values.InsertLast({"IsConnectedToMasterServer",       "Bool",    Round(    User.IsConnectedToMasterServer)});
    values.InsertLast({"IsFakeUser",                      "Bool",    Round(    User.IsFakeUser)});
    values.InsertLast({"IsFirstPartyDisplayName",         "Bool",    Round(    User.IsFirstPartyDisplayName)});
    values.InsertLast({"LadderPoints",                    "Float",   Round(    User.LadderPoints)});
    values.InsertLast({"LadderRank",                      "Uint32",  RoundUint(User.LadderRank)});
    values.InsertLast({"LadderTotal",                     "Uint32",  RoundUint(User.LadderTotal)});
    values.InsertLast({"LadderZoneFlagUrl",               "String",            User.LadderZoneFlagUrl});
    values.InsertLast({"LadderZoneName",                  "WString", string(   User.LadderZoneName)});
    values.InsertLast({"Language",                        "String",            User.Language});
    values.InsertLast({"LatestNetUpdate",                 "Uint32",  RoundUint(User.LatestNetUpdate)});
    values.InsertLast({"LightTrailLinearHue",             "Float",   Round(    User.LightTrailLinearHue)});
    values.InsertLast({"Live_HasRetrieveTimeLeft",        "Bool",    Round(    User.Live_HasRetrieveTimeLeft)});
    values.InsertLast({"Live_IsRegisteredToMasterServer", "Bool",    Round(    User.Live_IsRegisteredToMasterServer)});
    values.InsertLast({"Live_RetrievingTimeLeft",         "Bool",    Round(    User.Live_RetrievingTimeLeft)});
    values.InsertLast({"Live_Updating",                   "Bool",    Round(    User.Live_Updating)});
    values.InsertLast({"Live_UpdateLastTime",             "Uint32",  RoundUint(User.Live_UpdateLastTime)});
    values.InsertLast({"LiveUpdate_Counter",              "Uint32",  RoundUint(User.LiveUpdate_Counter)});
    values.InsertLast({"Login",                           "String",            User.Login});
    values.InsertLast({"Model_CarSport_SkinName",         "WString", string(   User.Model_CarSport_SkinName)});
    values.InsertLast({"Model_CarSport_SkinUrl",          "String",            User.Model_CarSport_SkinUrl});
    values.InsertLast({"Model_CharacterPilot_SkinName",   "WString", string(   User.Model_CharacterPilot_SkinName)});
    values.InsertLast({"Model_CharacterPilot_SkinUrl",    "String",            User.Model_CharacterPilot_SkinUrl});
    values.InsertLast({"Name",                            "WString", string(   User.Name)});
    values.InsertLast({"NbSpectators",                    "Uint32",  RoundUint(User.NbSpectators)});
    values.InsertLast({"NextEchelonPercent",              "Uint32",  RoundUint(User.NextEchelonPercent)});
    values.InsertLast({"PlayerType",                      "Enum",    tostring( User.PlayerType)});
    values.InsertLast({"PlaygroundRoundNum",              "Uint32",  RoundUint(User.PlaygroundRoundNum)});
    values.InsertLast({"PlaygroundTeamRequested",         "Uint32",  RoundUint(User.PlaygroundTeamRequested)});
    values.InsertLast({"Prestige_SkinOptions",            "String",            User.Prestige_SkinOptions});
    values.InsertLast({"ReferenceScore",                  "Float",   Round(    User.ReferenceScore)});
    values.InsertLast({"RequestedClan",                   "Uint32",  RoundUint(User.RequestedClan)});
    values.InsertLast({"RequestsSpectate",                "Bool",    Round(    User.RequestsSpectate)});
    values.InsertLast({"SpectatorMode",                   "Enum",    tostring( User.SpectatorMode)});
    values.InsertLast({"State",                           "Uint32",  RoundUint(User.State)});
    values.InsertLast({"SteamUserId",                     "String",            User.SteamUserId});
    values.InsertLast({"StereoDisplayMode",               "Enum",    tostring( User.StereoDisplayMode)});
    values.InsertLast({"StrLadderDraws",                  "String",            User.StrLadderDraws});
    values.InsertLast({"StrLadderLastPoints",             "String",            User.StrLadderLastPoints});
    values.InsertLast({"StrLadderLosses",                 "String",            User.StrLadderLosses});
    values.InsertLast({"StrLadderNbrTeams",               "String",            User.StrLadderNbrTeams});
    values.InsertLast({"StrLadderRanking",                "WString", string(   User.StrLadderRanking)});
    values.InsertLast({"StrLadderRankingSimple",          "WString", string(   User.StrLadderRankingSimple)});
    values.InsertLast({"StrLadderScore",                  "String",            User.StrLadderScore});
    values.InsertLast({"StrLadderScoreRounded",           "String",            User.StrLadderScoreRounded});
    values.InsertLast({"StrLadderTeamName",               "String",            User.StrLadderTeamName});
    values.InsertLast({"StrLadderTeamRanking",            "String",            User.StrLadderTeamRanking});
    values.InsertLast({"StrLadderTeamRankingSimple",      "String",            User.StrLadderTeamRankingSimple});
    values.InsertLast({"StrLadderWins",                   "String",            User.StrLadderWins});
    values.InsertLast({"Trigram",                         "String",            User.Trigram});
    values.InsertLast({"UploadRate",                      "Uint32",  RoundUint(User.UploadRate)});

    if (User.VoiceChat is null)
        values.InsertLast({"VoiceChat",                   "Object",  RED + "null"});
    else {
        values.InsertLast({"VoiceChat.Id.GetName()",      "String",            User.VoiceChat.Id.GetName()});
        values.InsertLast({"VoiceChat.Id.Value",          "Uint32",  RoundUint(User.VoiceChat.Id.Value)});
        values.InsertLast({"VoiceChat.IdName",            "String",            User.VoiceChat.IdName});
        values.InsertLast({"VoiceChat.IsConnected",       "Bool",    Round(    User.VoiceChat.IsConnected)});
        values.InsertLast({"VoiceChat.IsLocal",           "Bool",    Round(    User.VoiceChat.IsLocal)});
        values.InsertLast({"VoiceChat.IsMuted",           "Bool",    Round(    User.VoiceChat.IsMuted)});
        values.InsertLast({"VoiceChat.IsSpeaking",        "Bool",    Round(    User.VoiceChat.IsSpeaking)});
        values.InsertLast({"VoiceChat.MuteChangePending", "Bool",    Round(    User.VoiceChat.MuteChangePending)});
        values.InsertLast({"VoiceChat.MuteSetting",       "Enum",    tostring( User.VoiceChat.MuteSetting)});
        values.InsertLast({"VoiceChat.Supported",         "Bool",    Round(    User.VoiceChat.Supported)});
    }

    values.InsertLast({"WebServicesUserId",               "String",            User.WebServicesUserId});
    values.InsertLast({"WishSpectator",                   "Bool",    Round(    User.WishSpectator)});
    values.InsertLast({"ZoneBitmap",                      "Object",            User.ZoneBitmap is null ? RED + "null" : GREEN + "valid (unimplemented here)"});
    values.InsertLast({"ZoneFlagUrl",                     "String",            User.ZoneFlagUrl});

    if (User.ZoneLeague is null)
        values.InsertLast({"ZoneLeague",                  "Object",  RED + "null"});
    else {
        values.InsertLast({"ZoneLeague.Description",      "WString", string(   User.ZoneLeague.Description)});
        values.InsertLast({"ZoneLeague.Id.GetName()",     "String",            User.ZoneLeague.Id.GetName()});
        values.InsertLast({"ZoneLeague.Id.Value",         "Uint32",  RoundUint(User.ZoneLeague.Id.Value)});
        values.InsertLast({"ZoneLeague.IdName",           "String",            User.ZoneLeague.IdName});
        values.InsertLast({"ZoneLeague.IsGroup",          "Bool",    Round(    User.ZoneLeague.IsGroup)});
        values.InsertLast({"ZoneLeague.Login",            "String",            User.ZoneLeague.Login});
        values.InsertLast({"ZoneLeague.Name",             "WString", string(   User.ZoneLeague.Name)});
        values.InsertLast({"ZoneLeague.Path",             "WString", string(   User.ZoneLeague.Path)});
    }

    values.InsertLast({"ZonePath",                        "WString", string(   User.ZonePath)});

    if (UI::BeginTable("##user-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 280.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);

                UI::TableNextColumn();
                if (UI::Selectable(values[i][2], false))
                    SetClipboard(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderUserApiArrays(CTrackManiaPlayerInfo@ User) {
    // User.AlliesConnected
    // User.Tags_Comments
    // User.Tags_Deliverer
    // User.Tags_Favored_Indices
    // User.Tags_Id
    // User.Tags_Type
    // User.ZoneIdPath
}

void RenderUserOffsetValues(CTrackManiaPlayerInfo@ User) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    string[][] values;
    ;
}

void RenderUserOffsets(CTrackManiaPlayerInfo@ User) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    HelpTextPosNeg();
    HelpTextClickCopy();

    if (UI::BeginTable("##user-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownUserOffsets.Find(offset) > -1 ? "" : (observedUserOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                string value;
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8(  User, offset) == 1); break;
                        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8(  User, offset));      break;
                        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8( User, offset));      break;
                        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16( User, offset));      break;
                        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(User, offset));      break;
                        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32( User, offset));      break;
                        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(User, offset));      break;
                        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64( User, offset));      break;
                        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(User, offset));      break;
                        case DataType::Float:  value = Round(    Dev::GetOffsetFloat( User, offset));      break;
                        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2(  User, offset));      break;
                        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3(  User, offset));      break;
                        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4(  User, offset));      break;
                        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4(  User, offset));      break;
                        default:               value = "Unsupported!";
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
                UI::TableNextColumn();
                if (UI::Selectable(value, false))
                    SetClipboard(value);
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

#endif
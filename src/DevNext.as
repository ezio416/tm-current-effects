// c 2024-01-09
// m 2024-01-11

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string titleDev         = title + " (Developer)";
string version;

// offsets for which a value is known
const int[] knownVisOffsets = {
    0, 348, 352, 356, 360, 364, 368
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedVisOffsets = {
};

// offsets for which a value is known
const int[] knownStateOffsets = {
    0, 16, 20, 24, 32, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 116, 120, 128, 136, 138, 139,
    168, 172, 176, 180, 184, 185, 188, 192, 196, 200, 204, 208,  // FL
    212, 216, 220, 224, 228, 229, 232, 236, 240, 244, 248, 252,  // FR
    256, 260, 264, 268, 272, 273, 276, 280, 284, 288, 292, 296,  // RR
    300, 304, 308, 312, 316, 317, 320, 324, 328, 332, 336, 340,  // RL
    368, 372, 376, 380, 381, 384, 388, 392, 396, 400, 404, 408, 420, 428, 436, 440, 456, 460, 464, 468, 472, 536, 560, 564, 568, 572, 576, 788, 792, 796, 800, 804, 808
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedStateOffsets = {
    12, 104, 108, 112, 556, 612, 812
};

// game versions for which the offsets in this file are valid
const string[] validGameVersions = {
    "2024-01-10_12_53"  // released 2024-01-10
};

void InitDevNext() {
    version = GetApp().SystemPlatform.ExeVersion;
    gameVersionValid = validGameVersions.Find(version) > -1;
}

void RenderDevNext() {
    if (
        !S_Dev ||
        version.Length == 0 ||
        (S_DevHideWithGame && !UI::IsGameUIVisible()) ||
        (S_DevHideWithOP && !UI::IsOverlayShown())
    )
        return;

    UI::Begin(titleDev, S_Dev, UI::WindowFlags::None);
        if (!gameVersionValid)
            UI::TextWrapped(RED + "Game version " + version + " not marked valid! Values may be wrong.");

        UI::BeginTabBar("##dev-tabs");
            Tab_Vis();
            Tab_State();
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

    UI::TextWrapped("This tab is only for values which are not in CSceneVehicleVisState.");

    UI::BeginTabBar("##vis-tabs");
        for (uint i = 0; i < AllVis.Length; i++) {
            CSceneVehicleVis@ Vis = AllVis[i];

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::User + " Me" : i + "_" + Vis.Model.Id.GetName())) {
                UI::BeginTabBar("##vis-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderVisApiValues(Vis); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offset Values")) {
                    try   { RenderVisOffsetValues(Vis); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offsets")) {
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
        UI::TableNextColumn(); UI::Text(Round(Vis.Turbo));

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderVisOffsetValues(CSceneVehicleVis@ Vis) {
    ;
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    UI::TextWrapped("Values marked white are 0, " + GREEN + " green\\$G are positive/true, and " + RED + "red\\$G are negative/false.");

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

                UI::TableNextColumn();
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   UI::Text(Round(    Dev::GetOffsetInt8  (Vis, offset) == 1)); break;
                        case DataType::Int8:   UI::Text(Round(    Dev::GetOffsetInt8  (Vis, offset)));      break;
                        case DataType::Uint8:  UI::Text(RoundUint(Dev::GetOffsetUint8 (Vis, offset)));      break;
                        case DataType::Int16:  UI::Text(Round(    Dev::GetOffsetInt16 (Vis, offset)));      break;
                        case DataType::Uint16: UI::Text(RoundUint(Dev::GetOffsetUint16(Vis, offset)));      break;
                        case DataType::Int32:  UI::Text(Round(    Dev::GetOffsetInt32 (Vis, offset)));      break;
                        case DataType::Uint32: UI::Text(RoundUint(Dev::GetOffsetUint32(Vis, offset)));      break;
                        case DataType::Int64:  UI::Text(Round(    Dev::GetOffsetInt64 (Vis, offset)));      break;
                        case DataType::Uint64: UI::Text(RoundUint(Dev::GetOffsetUint64(Vis, offset)));      break;
                        case DataType::Float:  UI::Text(Round(    Dev::GetOffsetFloat (Vis, offset)));      break;
                        case DataType::Vec2:   UI::Text(Round(    Dev::GetOffsetVec2  (Vis, offset)));      break;
                        case DataType::Vec3:   UI::Text(Round(    Dev::GetOffsetVec3  (Vis, offset)));      break;
                        case DataType::Vec4:   UI::Text(Round(    Dev::GetOffsetVec4  (Vis, offset)));      break;
                        case DataType::Iso4:   UI::Text(Round(    Dev::GetOffsetIso4  (Vis, offset)));      break;
                        default:               UI::Text("Unsupported!");
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
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

    UI::BeginTabBar("##state-tabs");
        for (uint i = 0; i < AllVis.Length; i++) {
            CSceneVehicleVis@ Vis = AllVis[i];
            CSceneVehicleVisState@ State = Vis.AsyncState;

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::User + " Me" : i + "_" + Vis.Model.Id.GetName())) {
                UI::BeginTabBar("##state-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderStateApiValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offset Values")) {
                    try   { RenderStateOffsetValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offsets")) {
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

    string[][] values;
    values.InsertLast({"AirBrakeNormed",           "Float",   Round(    State.AirBrakeNormed)});
    values.InsertLast({"BulletTimeNormed",         "Float",   Round(    State.BulletTimeNormed)});
    values.InsertLast({"CamGrpStates",             "Unknown", "unknown new type"});
    values.InsertLast({"CurGear",                  "Uint",    RoundUint(State.CurGear)});
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
    values.InsertLast({"RaceStartTime",            "Uint",    RoundUint(State.RaceStartTime)});
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
                UI::TableNextColumn(); UI::Text(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderStateOffsetValues(CSceneVehicleVisState@ State) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");

    string[][] values;
    values.InsertLast(StateOffsetValue(State, 0,   "VehicleId",               DataType::Int32));
    values.InsertLast(StateOffsetValue(State, 16,  "InputSteer",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 20,  "InputGasPedal",           DataType::Float));
    values.InsertLast(StateOffsetValue(State, 24,  "InputBrakePedal",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 32,  "InputIsBraking",          DataType::Bool));

    values.InsertLast({"44,56,68", "0x2C,38,44", "Left", "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 44), Dev::GetOffsetFloat(State, 56), Dev::GetOffsetFloat(State, 68)))});
    values.InsertLast({"48,60,72", "0x30,3C,48", "Up",   "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 48), Dev::GetOffsetFloat(State, 60), Dev::GetOffsetFloat(State, 72)))});
    values.InsertLast({"52,64,76", "0x34,40,4C", "Dir",  "Vec3", Round(vec3(Dev::GetOffsetFloat(State, 52), Dev::GetOffsetFloat(State, 64), Dev::GetOffsetFloat(State, 76)))});

    values.InsertLast(StateOffsetValue(State, 80,  "Position",                DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 92,  "WorldVel",                DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 116, "FrontSpeed",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 120, "SideSpeed",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 128, "CruiseDisplaySpeed",      DataType::Int32));

    values.InsertLast({"136", "0x88", "ContactState1", "Enum", tostring(ContactState1(Dev::GetOffsetInt8(State, 136)))});
    values.InsertLast({"138", "0x8A", "ContactState2", "Enum", tostring(ContactState2(Dev::GetOffsetInt8(State, 138)))});
    values.InsertLast({"139", "0x8B", "IsTurbo",       "Enum", tostring(TurboState   (Dev::GetOffsetInt8(State, 139)))});

    values.InsertLast(StateOffsetValue(State, 168, "FLDamperLen",             DataType::Float));
    values.InsertLast(StateOffsetValue(State, 172, "FLWheelRot",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 176, "FLWheelRotSpeed",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 180, "FLSteerAngle",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 184, "FLGroundContactMaterial", DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 185, "FLGroundContactEffect",   DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 188, "FLSlipCoef",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 192, "FLDirt",                  DataType::Float));
    values.InsertLast(StateOffsetValue(State, 196, "FLIcing01",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 200, "FLTireWear01",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 204, "FLBreakNormedCoef",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 208, "FLFalling",               DataType::Enum));

    values.InsertLast(StateOffsetValue(State, 212, "FRDamperLen",             DataType::Float));
    values.InsertLast(StateOffsetValue(State, 216, "FRWheelRot",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 220, "FRWheelRotSpeed",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 224, "FRSteerAngle",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 228, "FRGroundContactMaterial", DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 229, "FRGroundContactEffect",   DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 232, "FRSlipCoef",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 236, "FRDirt",                  DataType::Float));
    values.InsertLast(StateOffsetValue(State, 240, "FRIcing01",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 244, "FRTireWear01",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 248, "FRBreakNormedCoef",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 252, "FRFalling",               DataType::Enum));

    values.InsertLast(StateOffsetValue(State, 256, "RRDamperLen",             DataType::Float));
    values.InsertLast(StateOffsetValue(State, 260, "RRWheelRot",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 264, "RRWheelRotSpeed",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 268, "RRSteerAngle",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 272, "RRGroundContactMaterial", DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 273, "RRGroundContactEffect",   DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 276, "RRSlipCoef",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 280, "RRDirt",                  DataType::Float));
    values.InsertLast(StateOffsetValue(State, 284, "RRIcing01",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 288, "RRTireWear01",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 292, "RRBreakNormedCoef",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 296, "RRFalling",               DataType::Enum));

    values.InsertLast(StateOffsetValue(State, 300, "RLDamperLen",             DataType::Float));
    values.InsertLast(StateOffsetValue(State, 304, "RLWheelRot",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 308, "RLWheelRotSpeed",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 312, "RLSteerAngle",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 316, "RLGroundContactMaterial", DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 317, "RLGroundContactEffect",   DataType::Enum));
    values.InsertLast(StateOffsetValue(State, 320, "RLSlipCoef",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 324, "RLDirt",                  DataType::Float));
    values.InsertLast(StateOffsetValue(State, 328, "RLIcing01",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 332, "RLTireWear01",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 336, "RLBreakNormedCoef",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 340, "RLFalling",               DataType::Enum));

    values.InsertLast({"368", "0x170", "LastTurboLevel",   "Enum", tostring(VehicleState::TurboLevel        (Dev::GetOffsetInt8(State, 368)))});
    values.InsertLast({"372", "0x174", "ReactorBoostLvl",  "Enum", tostring(ESceneVehicleVisReactorBoostLvl (Dev::GetOffsetInt8(State, 372)))});
    values.InsertLast({"376", "0x178", "ReactorBoostType", "Enum", tostring(ESceneVehicleVisReactorBoostType(Dev::GetOffsetInt8(State, 376)))});

    values.InsertLast(StateOffsetValue(State, 380, "ReactorFinalTimer",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 384, "ReactorAirControl",       DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 396, "Up",                      DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 408, "EngineRPM",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 420, "CurGear",                 DataType::Uint32));
    values.InsertLast(StateOffsetValue(State, 428, "TurboTime",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 436, "RaceStartTime",           DataType::Uint32));
    values.InsertLast(StateOffsetValue(State, 440, "HandicapSum",             DataType::Int32));
    values.InsertLast(StateOffsetValue(State, 456, "LinearHue",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 460, "LinearHue",               DataType::Float));
    values.InsertLast(StateOffsetValue(State, 464, "LinearHueRed",            DataType::Float));
    values.InsertLast(StateOffsetValue(State, 468, "LinearHueGreen",          DataType::Float));
    values.InsertLast(StateOffsetValue(State, 472, "LinearHueBlue",           DataType::Float));
    values.InsertLast(StateOffsetValue(State, 536, "GroundDist",              DataType::Float));
    values.InsertLast(StateOffsetValue(State, 560, "SimulationTimeCoef",      DataType::Float));
    values.InsertLast(StateOffsetValue(State, 564, "BulletTimeNormed",        DataType::Float));
    values.InsertLast(StateOffsetValue(State, 568, "AirBrakeNormed",          DataType::Float));
    values.InsertLast(StateOffsetValue(State, 572, "SpoilerOpenNormed",       DataType::Float));
    values.InsertLast(StateOffsetValue(State, 576, "WingsOpenNormed",         DataType::Float));
    values.InsertLast(StateOffsetValue(State, 788, "WaterImmersionCoef",      DataType::Float));
    values.InsertLast(StateOffsetValue(State, 792, "WaterOverDistNormed",     DataType::Float));
    values.InsertLast(StateOffsetValue(State, 796, "WaterOverSurfacePos",     DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 808, "WetnessValue01",          DataType::Float));

    // values.InsertLast(StateOffsetValue(State, 376, "IsWheelsBurning",   DataType::Bool));
    // values.InsertLast(StateOffsetValue(State, 548, "BrakingCoefStrong", DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 552, "HasReactor",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 556, "Reactor???",        DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 560, "HasYellowReactor",  DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 564, "YellowReactor???",  DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 568, "HasRedReactor",     DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 572, "RedReactor???",     DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 580, "Turbo",             DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 592, "InputIsBraking",    DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 596, "BrakingCoefWeak",   DataType::Float, false));

    if (UI::BeginTable("##state-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
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
                UI::TableNextColumn(); UI::Text(values[i][4]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

string[] StateOffsetValue(CSceneVehicleVisState@ State, int offset, const string &in name, DataType type, bool known = true) {
    string value;

    if (name.EndsWith("GroundContactMaterial")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(EPlugSurfaceMaterialId(num));
    } else if (name.EndsWith("GroundContactEffect")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(EPlugSurfaceGameplayId(num));
    } else if (name.EndsWith("Falling")) {
        int8 num = Dev::GetOffsetInt8(State, offset);
        value = Round(num) + " " + tostring(FallingState(num));
    } else {
        switch (type) {
            case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (State, offset) == 1); break;
            case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (State, offset));      break;
            case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (State, offset));      break;
            case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (State, offset));      break;
            case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(State, offset));      break;
            case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (State, offset));      break;
            case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(State, offset));      break;
            case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (State, offset));      break;
            case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(State, offset));      break;
            case DataType::Float:  value = Round(    Dev::GetOffsetFloat (State, offset));      break;
            case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (State, offset));      break;
            case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3  (State, offset));      break;
            case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (State, offset));      break;
            case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (State, offset));      break;
            default:;
        }
    }

    return { tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

void RenderStateOffsets(CSceneVehicleVisState@ State) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    UI::TextWrapped("Values marked white are 0, " + GREEN + " green\\$G are positive/true, and " + RED + "red\\$G are negative/false.");

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

                UI::TableNextColumn();
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   UI::Text(Round(    Dev::GetOffsetInt8  (State, offset) == 1)); break;
                        case DataType::Int8:   UI::Text(Round(    Dev::GetOffsetInt8  (State, offset)));      break;
                        case DataType::Uint8:  UI::Text(RoundUint(Dev::GetOffsetUint8 (State, offset)));      break;
                        case DataType::Int16:  UI::Text(Round(    Dev::GetOffsetInt16 (State, offset)));      break;
                        case DataType::Uint16: UI::Text(RoundUint(Dev::GetOffsetUint16(State, offset)));      break;
                        case DataType::Int32:  UI::Text(Round(    Dev::GetOffsetInt32 (State, offset)));      break;
                        case DataType::Uint32: UI::Text(RoundUint(Dev::GetOffsetUint32(State, offset)));      break;
                        case DataType::Int64:  UI::Text(Round(    Dev::GetOffsetInt64 (State, offset)));      break;
                        case DataType::Uint64: UI::Text(RoundUint(Dev::GetOffsetUint64(State, offset)));      break;
                        case DataType::Float:  UI::Text(Round(    Dev::GetOffsetFloat (State, offset)));      break;
                        case DataType::Vec2:   UI::Text(Round(    Dev::GetOffsetVec2  (State, offset)));      break;
                        case DataType::Vec3:   UI::Text(Round(    Dev::GetOffsetVec3  (State, offset)));      break;
                        case DataType::Vec4:   UI::Text(Round(    Dev::GetOffsetVec4  (State, offset)));      break;
                        case DataType::Iso4:   UI::Text(Round(    Dev::GetOffsetIso4  (State, offset)));      break;
                        default:               UI::Text("Unsupported!");
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

#endif
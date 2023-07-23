/*
c 2023-06-10
m 2023-07-19
*/

// Will be written out when VehicleState is updated
CSceneVehicleVis@[] AllVehicleVisWithoutPB(ISceneVis@ scene) {
    auto @allVis = VehicleState::GetAllVis(scene);
    if (allVis.Length < 3) return allVis; // PB ghost already hidden

    for (uint i = 0; i <= allVis.Length - 2; i++) {
        for (uint j = i; j <= 6; j++) {
            if (i < allVis.Length - 1) {
                if (IsSameVehicle(allVis[i], allVis[j])) {
                    allVis.RemoveAt(j);
                    allVis.RemoveAt(i);
                    return allVis;
                }
            } else break;
        }
    }
    return allVis;  // should never happen
}

// I'm well aware this is garbage
bool IsSameVehicle(CSceneVehicleVis@ a, CSceneVehicleVis@ b) {
    if (a.AsyncState.Dir.x != b.AsyncState.Dir.x) return false;
    if (a.AsyncState.Dir.y != b.AsyncState.Dir.y) return false;
    if (a.AsyncState.Dir.z != b.AsyncState.Dir.z) return false;
    if (a.AsyncState.Position.x != b.AsyncState.Position.x) return false;
    if (a.AsyncState.Position.y != b.AsyncState.Position.y) return false;
    if (a.AsyncState.Position.z != b.AsyncState.Position.z) return false;
    return true;
}

string ReactorText(float c) {
    if (c == 0)   return ReactorColor + ReactorIcon + "  Reactor Boost";
    if (c < 0.09) return ReactorColor + ReactorIcon + "  Reactor Boos" + DefaultColor + "t";
    if (c < 0.17) return ReactorColor + ReactorIcon + "  Reactor Boo" + DefaultColor + "st";
    if (c < 0.25) return ReactorColor + ReactorIcon + "  Reactor Bo" + DefaultColor + "ost";
    if (c < 0.33) return ReactorColor + ReactorIcon + "  Reactor B" + DefaultColor + "oost";
    if (c < 0.41) return ReactorColor + ReactorIcon + "  Reactor " + DefaultColor + "Boost";
    if (c < 0.49) return ReactorColor + ReactorIcon + "  Reacto" + DefaultColor + "r Boost";
    if (c < 0.57) return ReactorColor + ReactorIcon + "  React" + DefaultColor + "or Boost";
    if (c < 0.65) return ReactorColor + ReactorIcon + "  Reac" + DefaultColor + "tor Boost";
    if (c < 0.73) return ReactorColor + ReactorIcon + "  Rea" + DefaultColor + "ctor Boost";
    if (c < 0.81) return ReactorColor + ReactorIcon + "  Re" + DefaultColor + "actor Boost";
    if (c < 0.89) return ReactorColor + ReactorIcon + "  R" + DefaultColor + "eactor Boost";
    return ReactorColor + ReactorIcon + DefaultColor + "  Reactor Boost";
}

bool Truthy(uint num) {
    if (num > 0)
        return true;
    return false;
}

string TurboText(float c) {
    if (c == 0)  return TurboColor + Icons::ArrowCircleUp + "  Turbo";
    if (c < 0.2) return TurboColor + Icons::ArrowCircleUp + "  Turb" + DefaultColor + "o";
    if (c < 0.4) return TurboColor + Icons::ArrowCircleUp + "  Tur" + DefaultColor + "bo";
    if (c < 0.6) return TurboColor + Icons::ArrowCircleUp + "  Tu" + DefaultColor + "rbo";
    if (c < 0.8) return TurboColor + Icons::ArrowCircleUp + "  T" + DefaultColor + "urbo";
    return TurboColor + Icons::ArrowCircleUp + DefaultColor + "  Turbo";
}
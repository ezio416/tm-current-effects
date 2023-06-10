/*
c 2023-06-10
m 2023-06-10
*/

// Will be written out when VehicleState is updated
array<CSceneVehicleVis@> AllVehicleVisWithoutPB(ISceneVis@ scene) {
    auto @vis = VehicleState::GetAllVis(scene);
    if (vis.Length < 3) return vis; // PB ghost already hidden

    for (uint i = 0; i <= vis.Length - 2; i++) {
        for (uint j = i; j <= 6; j++) {
            if (i < vis.Length - 1) {
                if (IsSameVehicle(vis[i], vis[j])) {
                    vis.RemoveAt(j);
                    vis.RemoveAt(i);
                    return vis;
                }
            } else break;
        }
    }
    return vis;  // should never happen
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

bool Truthy(uint num) {
    if (num > 0)
        return true;
    return false;
}
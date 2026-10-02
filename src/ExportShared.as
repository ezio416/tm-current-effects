namespace CurrentEffects {
    shared enum Camera {
        Unknown = -1,
        Cam1,
        Alt1,
        Cam2,
        Alt2,
        Cam3,
        Alt3,
        Cam7,
        Alt7,
        Backwards,
        SpecFollow,
        SpecFollowAll,
        SpecFree,
        SpecReplay,
    }

    shared enum OpponentVis {
        Unknown     = -1,
        Off         = 0,  // while already default enum behavior, since
        Transparent = 1,  // we directly create an enum instance from
        Opaque      = 2,  // the game's value, it's good to be explicit
    }

    shared enum VehicleType {
        Unknown = -1,
        Snow,
        Desert,
        Rally,
        Island,
        Bay,
        Coast,
        Stadium,
        Canyon,
        Human,  // CharacterPilot or ArenaPlayer
        Valley,
        Lagoon,
        Traffic,
    }

    shared enum ViewMode {
        Unknown     = -1,
        Solo        = 0x1,
        Replay      = 0x2,
        Server      = 0x4,
        Spectate    = 0x8,
        SplitScreen = 0x10,
    }
}

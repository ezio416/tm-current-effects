namespace CurrentEffects {
    /*
    the current camera
    */
    import Camera StatusCamera() from "CurrentEffects";

    /*
    ghosts are visible
    */
    import bool StatusGhostVisibility() from "CurrentEffects";

#if TMNEXT

    /*
    nametags are visible
    */
    import bool StatusNametagVisibility() from "CurrentEffects";

    /*
    opponents are transparent, opaque, or off
    */
    import OpponentVis StatusOpponentVisibility() from "CurrentEffects";

    /*
    the plugin is running, whether or not it's safe
    */
    import bool Running() from "CurrentEffects";

    /*
    it is safe to run the plugin with the current game version
    */
    import bool Safe() from "CurrentEffects";

#endif
}

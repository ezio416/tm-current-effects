#if TMNEXT

namespace Safety {
    const vec4 NOTIFY_COLOR = vec4(0.9f, 0.4f, 0.0f, 0.8f);
    const string NOTIFY_MSG = "Looks like your game got an update! This plugin will have limited functionality until "
        "the developer updates it. If you want to risk crashing your game, you can override this safety check in the "
        "settings.";
    const string[] SAFE_GAME_VERSIONS = {
        "2026-02-02_17_51",
        "2026-07-22_18_27"
    };

    bool checked   = false;
    bool disregard = false;
    bool notified  = false;
    bool safe      = false;

    void CheckAsync() {
        if (checked) {
            return;
        }

        const string ver = GetApp().SystemPlatform.ExeVersion;

        if (SAFE_GAME_VERSIONS.Find(ver) != -1) {
            checked = safe = true;
            return;
        }

        ;  // TODO safety req

        NotifyUnsafe();
    }

    void NotifyUnsafe() {
        if (!notified) {
            UI::ShowNotification(PLUGIN_TITLE, NOTIFY_MSG, NOTIFY_COLOR, 15000);
            notified = true;
        }
    }

    bool ShouldRun() {
        return safe;// or S_OverrideSafety;
    }
}

#endif

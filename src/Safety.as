#if TMNEXT

namespace Safety {
    const vec4 NOTIFY_COLOR = vec4(0.9f, 0.5f, 0.0f, 0.8f);
    const string NOTIFY_MSG = "Looks like your game got an update! This plugin will have limited functionality until "
        "the developer updates it. If you want to risk crashing your game, you can override this safety check in the "
        "settings.";
    const string[] SAFE_GAME_VERSIONS = {
        "2026-02-02_17_51",
        "2026-07-22_18_27"
    };
    const string VERSION_COMPAT_URL = "https://api.openplanet.dev/plugin/currenteffects/config/versions";

    string gameVersion;
    bool   notified  = false;
    bool   runAnyway = false;
    bool   safe      = false;

    void CheckAsync() {
        if (safe) {
            return;
        }

        gameVersion = GetApp().SystemPlatform.ExeVersion;

        if (SAFE_GAME_VERSIONS.Find(gameVersion) != -1) {
            safe = true;
            return;
        }

        if (!GetVersionCompatAsync()) {
            NotifyUnsafe();
        }
    }

    bool GetVersionCompatAsync() {
        trace("GetVersionCompatAsync: starting");

        for (uint i = 5; i --> 0;) {
            Net::HttpRequest@ req = Net::HttpGet(VERSION_COMPAT_URL);
            while (!req.Finished()) {
                yield();
            }

            const int code = req.ResponseCode();
            if (code != 200) {
                warn("GetVersionCompatAsync: bad response (" + code + "): " + req.String());
                warn("retrying in a second...");
                sleep(1000);
                continue;
            }

            Json::Value@ response;
            try {
                @response = req.Json();
            } catch {
                error("GetVersionCompatAsync: exception: " + getExceptionInfo());
                error("response: " + req.String());
                warn("retrying in a second...");
                sleep(1000);
                continue;
            }

            if (false
                or response.GetType() != Json::Type::Object
                or response[gameVersion].GetType() != Json::Type::Object
            ) {
                warn("GetVersionCompatAsync: unrecognized game version: " + gameVersion);
                return false;
            }

            if (false
                or response[gameVersion][PLUGIN_META.Version].GetType() != Json::Type::Boolean
                or !bool(response[gameVersion][PLUGIN_META.Version])
            ) {
                warn("GetVersionCompatAsync: outdated plugin version: " + PLUGIN_META.Version);
                return false;
            }

            trace("GetVersionCompatAsync: plugin version " + PLUGIN_META.Version
                + " still works on game version " + gameVersion);
            safe = true;
            return true;
        }

        error("GetVersionCompatAsync: retried too many times");
        return false;
    }

    void NotifyUnsafe() {
        if (notified) {
            return;
        }

        Meta::Plugin@[]@ plugins = Meta::AllPlugins();
        dictionary dependents;

        for (uint i = 0; i < plugins.Length; i++) {
            if (plugins[i] is PLUGIN_META) {
                continue;
            }

            for (uint j = 0; j < plugins[i].Dependencies.Length; j++) {
                if (plugins[i].Dependencies[j] == PLUGIN_META.ID) {
                    dependents.Set(plugins[i].Name, 0);
                    break;
                }
            }

            for (uint j = 0; j < plugins[i].OptionalDependencies.Length; j++) {
                if (plugins[i].OptionalDependencies[j] == PLUGIN_META.ID) {
                    dependents.Set(plugins[i].Name, 0);
                    break;
                }
            }
        }

        if (dependents.IsEmpty()) {
            UI::ShowNotification(PLUGIN_TITLE, NOTIFY_MSG, NOTIFY_COLOR, 20000);
        } else {
            string extra = " There are also some dependent plugins which may be affected:";
            string[]@ keys = dependents.GetKeys();
            for (uint i = 0; i < keys.Length; i++) {
                extra += "\n  - " + keys[i];
            }
            UI::ShowNotification(PLUGIN_TITLE, NOTIFY_MSG + extra, NOTIFY_COLOR, 20000);
        }

        notified = true;
    }

    bool ShouldRun() {
        return safe or runAnyway;
    }
}

#endif

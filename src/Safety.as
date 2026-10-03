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

    bool   checked            = false;
    bool   checkingApi        = false;
    bool   notified           = false;
    bool   safe               = false;
    string version;
    uint   versionSafeRetries = 0;

    void CheckAsync() {
        if (checked) {
            return;
        }

        version = GetApp().SystemPlatform.ExeVersion;

        if (SAFE_GAME_VERSIONS.Find(version) != -1) {
            checked = safe = true;
            return;
        }

        if (!GetStatusFromOpenplanetAsync()) {
            NotifyUnsafe();
        }
    }

    bool GetStatusFromOpenplanetAsync() {
        if (checkingApi) {
            return false;
        }

        checkingApi = true;

        trace("GetStatusFromOpenplanet starting");

        Net::HttpRequest@ req = Net::HttpGet("https://api.openplanet.dev/plugin/currenteffects/config/version-compat");
        while (!req.Finished()) {
            yield();
        }

        int code = req.ResponseCode();
        if (code != 200) {
            warn("GetStatusFromOpenplanet error: code: " + code
                + "; error: " + req.Error() + "; body: " + req.String());
            checkingApi = false;
            return RetryGetStatusAsync();
        }

        try {
            string pluginVersion = Meta::ExecutingPlugin().Version;
            Json::Value@ response = Json::Parse(req.String());

            if (response.GetType() == Json::Type::Object) {
                if (response.HasKey(pluginVersion)) {
                    if (response[pluginVersion].HasKey(version) && bool(response[pluginVersion][version])) {
                        checkingApi = false;
                        trace("GetStatusFromOpenplanet good");
                        return true;
                    } else {
                        warn("GetStatusFromOpenplanet warning: game version " + version
                            + " not marked good with plugin version " + pluginVersion);
                    }
                } else {
                    warn("GetStatusFromOpenplanet warning: plugin version " + pluginVersion + " not specified");
                }
            } else {
                warn("GetStatusFromOpenplanet error: wrong JSON type received");
            }

            checkingApi = false;
            return false;

        } catch {
            warn("GetStatusFromOpenplanet exception: " + getExceptionInfo());
            checkingApi = false;
            return RetryGetStatusAsync();
        }
    }

    void NotifyUnsafe() {
        if (!notified) {
            UI::ShowNotification(PLUGIN_TITLE, NOTIFY_MSG, NOTIFY_COLOR, 15000);
            notified = true;
        }
    }

    bool RetryGetStatusAsync() {
        checkingApi = true;

        trace("retrying GetStatusFromOpenplanet in 1000 ms");

        sleep(1000);

        if (versionSafeRetries++ > 5) {
            warn("not retrying GetStatusFromOpenplanet anymore, too many failures");
            checkingApi = false;
            return false;
        }

        trace("retrying GetStatusFromOpenplanet...");

        checkingApi = false;
        return GetStatusFromOpenplanetAsync();
    }

    bool ShouldRun() {
        return safe or S_OverrideSafety;
    }
}

#endif

Font      g_currentFont = S_Font;
UI::Font@ g_font;
UI::Font@ g_fontDroidSans;
UI::Font@ g_fontDroidSansBold;
UI::Font@ g_fontDroidSansMono;
string[]  g_fontErrors;

enum Font {
    DroidSans,
    DroidSansBold,
    DroidSansMono,
    Montserrat,
    MontserratBold,
    Oswald,
    OswaldBold,
    System
}

void ChangeFont() {
    switch (S_Font) {
        case Font::DroidSans:      @g_font = UI::LoadFont("DroidSans.ttf");       break;
        case Font::DroidSansBold:  @g_font = UI::LoadFont("DroidSans-Bold.ttf");  break;
        case Font::DroidSansMono:  @g_font = UI::LoadFont("DroidSansMono.ttf");   break;
        case Font::Montserrat:     @g_font = UI::LoadFont("Montserrat.ttf");      break;
        case Font::MontserratBold: @g_font = UI::LoadFont("Montserrat-Bold.ttf"); break;
        case Font::Oswald:         @g_font = UI::LoadFont("Oswald.ttf");          break;
        case Font::OswaldBold:     @g_font = UI::LoadFont("Oswald-Bold.ttf");     break;

        case Font::System:
            try {
                @g_font = UI::LoadSystemFont(S_SystemFont);
            } catch {
                @g_font = null;
            }
            if (g_font is null) {
                const string msg = "error loading system font '" + S_SystemFont + "', reverting to DroidSans";
                error(msg + ", error: " + getExceptionInfo());
                UI::ShowNotification(
                    "Current Effects",
                    msg,
                    vec4(1.0f, 0.2f, 0.2f, 0.5f)
                );

                if (g_fontErrors.Find(S_SystemFont) == -1) {
                    g_fontErrors.InsertLast(S_SystemFont);
                }
                S_SystemFont = "";
                S_Font = Font::DroidSans;
                ChangeFont();
                return;
            }
    }

    g_currentFont = S_Font;
}

void RenderFontSettings() {
    if (UI::BeginCombo("Font", S_Font == Font::System ? S_SystemFont : tostring(S_Font))) {
        for (int i = 0; i < Font::System; i++) {
            const Font f = Font(i);
            if (UI::Selectable(tostring(f), S_Font == f)) {
                S_Font = f;
                ChangeFont();
            }
        }

        const string systemFonts = "C:/Windows/Fonts/";
        if (IO::FolderExists(systemFonts)) {
            UI::Separator();

            string[]@ files = IO::IndexFolder(systemFonts, false);
            for (uint i = 0; i < files.Length; i++) {
                if (files[i].ToLower().EndsWith(".ttf")) {
                    const string fileName = files[i].Replace(systemFonts, "");
                    const string displayName = fileName.Replace(".ttf", "").Replace(".TTF", "");
                    if (UI::Selectable(
                        (g_fontErrors.Find(fileName) > -1 ? "\\$F00" : "") + displayName + "##" + i,
                        S_SystemFont == fileName
                    )) {
                        S_Font = Font::System;
                        S_SystemFont = fileName;
                        ChangeFont();
                    }
                }
            }
        }

        UI::EndCombo();
    }

    S_FontSize = UI::SliderInt("Font size", S_FontSize, 8, 72);
}

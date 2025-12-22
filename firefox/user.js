// Enable custom userChrome.css and userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Enable SVG context properties (often needed for icons in themes)
user_pref("svg.context-properties.content.enabled", true);

// Enable WebRender (usually on by default now, but good to ensure for performance)
user_pref("gfx.webrender.all", true);

// Optional: DevTools theme to dark (matches the aesthetic)
user_pref("devtools.theme", "dark");

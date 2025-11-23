const THEMES = ["dark-theme", "light-theme"];
const INVERT = {"dark-theme": "light-theme", "light-theme": "dark-theme"};
const SELECTORS = {"dark-theme": "darkTheme", "light-theme": "lightTheme"};

const DARK = '(prefers-color-scheme: dark)'
const LIGHT = '(prefers-color-scheme: light)'

function getClassList() {
    return document.documentElement.classList
}

function getThemed(invert = false) {
    const currentTheme = getCurrentTheme();
    var theme = currentTheme;
    if (invert) {
        theme = INVERT[currentTheme];
    }
    return document.querySelectorAll("." + SELECTORS[theme]);
}

function getStoredTheme() {
    return localStorage.getItem("theme");
}

function setStoredTheme(theme) {
    localStorage.setItem("theme", theme);
}

function getDefaultTheme() {
    return window
    .getComputedStyle(document.documentElement)
    .getPropertyValue('content')
    .replace(/"/g, '');
}

function getCurrentTheme() {
    const classes = getClassList();
    var theme;
    classes.forEach(function (value, key, listObj) {
        if (!theme) {
            if (THEMES.includes(value)) {
                theme = value;
            }
        }}
    );
    return theme
}

function setTheme(theme) {
    var classes = getClassList();
    const old_theme = getCurrentTheme();
    console.log(old_theme, theme);
    if (old_theme != theme) {
        if (old_theme) {
            classes.toggle(old_theme);
        }
        classes.toggle(theme);
    };
    setStoredTheme(theme);
    const themed = getThemed();
    themed.forEach(function (value, key, listObj) {
        value.style.display = "initial";
    });
    const unthemed = getThemed(true);
    unthemed.forEach(function (value, key, listObj) {
        value.style.display = "none";
    });
}

function initialiseTheme() {
    if (window.matchMedia) {
        function listener({ matches, media }) {
            if (!matches) {
                // Not matching anymore = not interesting
                return
            }

            if (media === DARK) {
                window
                .getComputedStyle(document.documentElement)
                .setPropertyValue('content', THEMES[0])
            } else if (media === LIGHT) {
                window
                .getComputedStyle(document.documentElement)
                .setPropertyValue('content', THEMES[1])
            }
        }

        const mqDark = window.matchMedia(DARK);
        mqDark.addEventListener('change', listener);

        const mqLight = window.matchMedia(LIGHT);
        mqLight.addEventListener('change', listener);
    }

    const theme = getStoredTheme() || getDefaultTheme() || THEMES[0];
    setTheme(theme);
}

function toggleTheme() {
    const old_theme = getCurrentTheme();
    var theme;
    if (old_theme) {
        theme = INVERT[old_theme];
    } else {
        return
    }
    if (theme) {
        setTheme(theme);
    } else {
        return
    }
}

document.addEventListener('DOMContentLoaded', () => {
    initialiseTheme();
});

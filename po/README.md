# Translations

ColorBrush follows your system language automatically. Plasma loads the matching
`.mo` file from `package/contents/locale/<lang>/LC_MESSAGES/plasma_applet_org.seaq.colorbrush.mo`.
If there is no translation for your language, the English source text is shown.

## Add a new language

```sh
cp po/plasma_applet_org.seaq.colorbrush.pot po/<lang>.po   # e.g. sv, ja, uk, ru
# translate every msgstr "" entry, then:
./scripts/compile-translations.sh
```

## After changing UI strings

```sh
./scripts/update-template.sh        # refresh the .pot and merge into all .po files
./scripts/compile-translations.sh   # rebuild the .mo files
```

Requires `gettext` (`sudo dnf install gettext`).

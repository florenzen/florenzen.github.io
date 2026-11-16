#!/bin/sh
# Turns every file r/<name> (containing a URL) into _site/r/<name>.html,
# a static redirect page. GitHub Pages serves it at /r/<name>.
set -eu
cd "$(dirname "$0")/.."
out=_site
rm -rf "$out"
mkdir -p "$out/r"
for f in r/*; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    case "$name" in
    *[!A-Za-z0-9_-]*)
        echo "error: $f: name may only contain A-Z a-z 0-9 _ -" >&2
        exit 1
        ;;
    esac
    # first line that is not empty and not a # comment
    url=$(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$f" | head -n 1 | tr -d '[:space:]')
    case "$url" in
    http://* | https://*) ;;
    *)
        echo "error: $f: no http(s) URL found" >&2
        exit 1
        ;;
    esac
    esc=$(printf '%s' "$url" | sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
    cat > "$out/r/$name.html" << HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Redirecting…</title>
<meta name="robots" content="noindex">
<link rel="canonical" href="$esc">
<meta http-equiv="refresh" content="0; url=$esc">
</head>
<body>
<p>Redirecting to <a href="$esc">$esc</a>…</p>
</body>
</html>
HTML
    echo "r/$name -> $url"
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
valac --pkg gtk+-3.0 --pkg webkit2gtk-4.0 --pkg gmodule-2.0 -C Valaswer.vala BrowserWindow.vala Configuration.vala
$DIR/Valaswer

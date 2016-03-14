using Gtk;

namespace Valaswer {
    public static int main(string [] argv) {

        Gtk.init(ref argv);
		var mainWindow = new BrowserWindow();
		mainWindow.window.show_all();
		Gtk.main();

        return 0;
    }

}

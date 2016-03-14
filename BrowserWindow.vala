using Gtk;
using WebKit;

namespace Valaswer {

    public class BrowserWindow : GLib.Object {

        private Window browserWindow;
        public Window window {
            get { return browserWindow; }
        }
        private Entry input;
        private WebView webview;
        private Builder builder;

        public BrowserWindow() {
            initWindow();
            initComponents();
        }

        private void initWindow() {

            builder = new Builder();
            builder.add_from_file ("BrowserWindow.glade");
            builder.connect_signals (null);
            //browserWindow = new Window();
            browserWindow = builder.get_object("applicationwindow1") as Window;


            //browserWindow.title = "ValaBox";
            //browserWindow.border_width = 0;
            //browserWindow.window_position = WindowPosition.CENTER;
            browserWindow.set_default_size(1280, 720);
            browserWindow.destroy.connect(Gtk.main_quit);
            //browserWindow.set_decorated(false);
        }

        private void initComponents() {
            webview = new WebView();
            var settings = new WebKit.Settings();
            webview.set_settings(settings);
            settings.set_user_agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");
            webview.load_uri(Configuration.HOMEPAGE);
            webview.load_changed.connect(onLoad);

            var view = builder.get_object("viewport1") as Viewport;
            view.add(webview);

            input = builder.get_object("entry1") as Entry;
            input.activate.connect(onUrl);

            var hBar = builder.get_object("headerbar1") as HeaderBar;
        }

        public void onLoad(LoadEvent event) {
            (builder.get_object("label1") as Label).label = webview.title;
            input.text = webview.uri;
        }

        public void onUrl() {
            print("Input: " + input.text +"\n");
            string url = input.text;
            if (url.contains("http://") || url.contains("https://")) {
                webview.load_uri(input.text);
            } else {
                webview.load_uri("http://" + input.text);
            }

        }

    }

}

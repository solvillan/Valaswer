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
        private Stack head;
        private ProgressBar pbar;

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
            webview.authenticate.connect(auth);

            var view = builder.get_object("viewport1") as Viewport;
            view.add(webview);

            input = builder.get_object("entry1") as Entry;
            input.activate.connect(onUrl);
            input.key_press_event.connect(inputKeyHandler);

            var hbar = builder.get_object("headerbar1") as HeaderBar;

            head = builder.get_object("stack1") as Stack;
            pbar = builder.get_object("progressbar1") as ProgressBar;
            //pbar.min_hrizontal_bar_height = hbar.
        }

        public bool inputKeyHandler(Gdk.EventKey event) {
            sizeURLBar();
            return false;
        }

        public void sizeURLBar() {
            input.set_width_chars(int.parse(input.text_length.to_string()));
        }

        public bool auth(AuthenticationRequest request) {
            print("Auth!\n");
            var authWin = new AuthWindow(request);
            authWin.destroySig.connect(destroyAuthWin);
            return true;
        }

        public void destroyAuthWin(AuthWindow authWin) {
            authWin.destroy();
        }

        public void onLoad(LoadEvent event) {
            if (event == LoadEvent.STARTED) {
                head.set_visible_child_name("pBar");
                pbar.set_fraction(0);
            }
            (builder.get_object("label1") as Label).label = webview.title;
            input.text = webview.uri;
            sizeURLBar();
            pbar.set_fraction(webview.estimated_load_progress);
            if (event == LoadEvent.FINISHED) {
                head.set_visible_child_name("urlBar");
            }
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

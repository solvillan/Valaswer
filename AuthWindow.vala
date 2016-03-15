using Gtk;
using WebKit;

namespace Valaswer {
    public class AuthWindow : Window {

        public signal void destroySig(AuthWindow authWindow);
        private Builder builder;
        private AuthenticationRequest req;

        public AuthWindow(AuthenticationRequest request) {
            print("AuthWindow!\n");
            builder = new Builder();
            builder.add_from_file ("AuthWindow.glade");
            builder.connect_signals (null);
            this.add((builder.get_object("viewport1") as Viewport));
            this.set_default_size(400, 150);
            this.req = request;
            this.window_position = WindowPosition.CENTER;
            this.title = "Authenticate: " + request.get_host();
            this.border_width = 10;
            this.show_all();
            var ok = builder.get_object("auth") as Button;
            ok.clicked.connect(doAuth);
            var cancel = builder.get_object("cancel") as Button;
            cancel.clicked.connect(doCancel);
            var pass = builder.get_object("password") as Entry;
            pass.activate.connect(doAuth);
        }

        public void doAuth() {
            var user = builder.get_object("username") as Entry;
            var pass = builder.get_object("password") as Entry;

            var cred = new Credential(user.text, pass.text, CredentialPersistence.FOR_SESSION);
            req.authenticate(cred);
            print("Auth with " + user.text);
            destroySig(this);
        }

        public void doCancel() {
            req.cancel();
            destroySig(this);
        }


    }
}

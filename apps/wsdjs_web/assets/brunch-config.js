exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(js\/desktop)|(node_modules)/,
        "js/vendor.js": /^(vendor\/desktop)|(deps)/,
        "js/app-mobile.js": /^(js\/mobile)|(node_modules)/,
        "js/vendor-mobile.js": /^(vendor\/mobile)|(deps)/,
      }

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //  "js/app.js": /^(js)/,
      //  "js/vendor.js": /^(vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "vendor/js/jquery-2.1.1.js",
      //     "vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(css\/desktop)|(node_modules)/,
        "css/app-mobile.css": /^(css\/mobile)|(node_modules)/,
      }
    }
    //,
    //templates: {
    //  joinTo: "js/app.js"
    //}
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/desktop/app"],
      "js/app-mobile.js": ["js/mobile/app"],
    }
  },

  npm: {
    enabled: true,
    static: ["node_modules/pjax-api/dist/pjax-api.js"]
  }
};

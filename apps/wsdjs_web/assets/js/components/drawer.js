class Drawer {
    constructor() {
        document.addEventListener("click", e => {
            if (e.target && this.isOutside(e) && this.drawerIsOpen()) {
                this.hide();
            }
            if (e.target && e.target.closest("[data-js-drawer]")) {
                this.show();
            }
        }, false);
    }

    isOutside(e) {
        return e.target.matches(".facets-container.open");
    }

    drawerIsOpen() {
        return document.querySelector(".facets-container.open");
    }

    show() {
        let d = document.querySelector(".facets-container");
        if (d) {
            d.classList.add("open");
        }
    }

    hide() {
        let d = document.querySelector(".facets-container.open");
        if (d) {
            d.classList.remove("open");
        }
    }
}

export default new Drawer();
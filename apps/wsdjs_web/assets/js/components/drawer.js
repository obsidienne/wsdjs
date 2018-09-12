class Drawer {
    constructor() {
        document.addEventListener("click", e => {
            if (e.target && this.isOutside(e) && this.drawerIsOpen()) {
                this.hide();
            }
        }, false);
    }

    isOutside(e) {
        return e.target.matches(".facets-container.open");
    }

    drawerIsOpen() {
        return document.querySelector(".facets-container.open");
    }

    hide() {
        let d = document.querySelector(".facets-container.open");
        if (d) {
            d.classList.remove("open");
        }
    }
}

export default new Drawer();
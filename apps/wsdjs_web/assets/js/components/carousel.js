class Carousel {
    constructor() {
        document.addEventListener("click", e => {
            if (e.target && e.target.matches(".carousel-prev")) {
                e.preventDefault();
                e.stopPropagation();
                this.prev(e.target);
            }
        }, false);

        document.addEventListener("click", e => {
            if (e.target && e.target.matches(".carousel-next")) {
                e.preventDefault();
                e.stopPropagation();
                this.next(e.target);
            }
        }, false);
    }

    _getItemsContainer(el) {
        let container = el.closest(".carousel");
        return container.querySelector("ul.carousel-items");
    }

    _getStepSize() {
        let width = window.innerWidth;
        if (width < 576) {
            return 320;
        }
        if (width < 768) {
            return 576;
        }
        if (width < 992) {
            return 480;
        }
        if (width < 1200) {
            return 704;
        }
        return 920;
    }

    _getNextStepSize(el) {
        let step_size = this._getStepSize();
        let current_step = this._extractStep(el.style.transform);
        return current_step - step_size;
    }

    _getPrevStepSize(el) {
        let step_size = this._getStepSize();
        let current_step = this._extractStep(el.style.transform);
        return Math.min(current_step + step_size, 0);
    }

    _extractStep(str) {
        let regex = /translateX\((-?\d+)px\)/;
        let step = str.match(regex);

        if (step === null)
            return 0;
        return parseInt(step[1]);
    }

    prev(el) {
        let items_container = this._getItemsContainer(el);
        let step = this._getPrevStepSize(items_container);
        items_container.style.transform = "translateX(" + step + "px)";
    }

    next(el) {
        let items_container = this._getItemsContainer(el);
        let step = this._getNextStepSize(items_container);
        let max_width = items_container.scrollWidth;
        if (Math.abs(step) > max_width) {
            return;
        }

        items_container.style.transform = "translateX(" + step + "px)";
    }
}

export default new Carousel();
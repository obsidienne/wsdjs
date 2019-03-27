import SimpleBar from "simplebar";

class Carousel {
  constructor() {
    document.addEventListener(
      "click",
      e => {
        if (e.target && e.target.matches(".carousel-prev:not(.disabled)")) {
          e.preventDefault();
          e.stopPropagation();
          this.prev(e.target);
        }
      },
      false
    );

    document.addEventListener(
      "click",
      e => {
        if (e.target && e.target.matches(".carousel-next:not(.disabled)")) {
          e.preventDefault();
          e.stopPropagation();
          this.next(e.target);
        }
      },
      false
    );
  }

  _getItemsContainer(el) {
    let container = el.closest(".carousel");
    return container.querySelector("[data-simplebar]");
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
    return 880;
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

    if (step === null) return 0;
    return parseInt(step[1]);
  }

  _switchDisable(el) {
    let root = el.closest(".carousel");
    let next_ctrl = root.querySelector(".carousel-next");
    let prev_ctrl = root.querySelector(".carousel-prev");

    let current_step = Math.abs(this._extractStep(el.style.transform));
    let max_width = el.scrollWidth;
    let step_size = this._getStepSize();

    if (current_step === 0) {
      next_ctrl.classList.remove("disabled");
      prev_ctrl.classList.add("disabled");
    } else if (step_size + current_step < max_width) {
      next_ctrl.classList.remove("disabled");
      prev_ctrl.classList.remove("disabled");
    } else if (step_size + current_step + 16 >= max_width) {
      next_ctrl.classList.add("disabled");
      prev_ctrl.classList.remove("disabled");
    }
  }

  prev(el) {
    let items_container = this._getItemsContainer(el);
    console.log(items_container);
    let step = this._getPrevStepSize(items_container);
    items_container.style.transform = "translateX(" + step + "px)";
    this._switchDisable(items_container);
  }

  next(el) {
    let items_container = this._getItemsContainer(el);
    let step = this._getNextStepSize(items_container);
    let max_width = items_container.scrollWidth;
    if (Math.abs(step) > max_width) {
      return;
    }

    items_container.style.transform = "translateX(" + step + "px)";
    this._switchDisable(items_container);
  }
}

export default new Carousel();

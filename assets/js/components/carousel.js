
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
    return container.querySelector(".simplebar-content");
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

  _switchDisable(el) {
    let root = el.closest(".carousel");
    let next_ctrl = root.querySelector(".carousel-next");
    let prev_ctrl = root.querySelector(".carousel-prev");

    let current_step = el.scrollLeft;
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
    let step = this._getStepSize();
    items_container.scrollLeft = items_container.scrollLeft - step;
    this._switchDisable(items_container);
  }

  next(el) {
    let items_container = this._getItemsContainer(el);
    let step = this._getStepSize();
    items_container.scrollLeft = items_container.scrollLeft + step;
    this._switchDisable(items_container);
  }
}

export default new Carousel();

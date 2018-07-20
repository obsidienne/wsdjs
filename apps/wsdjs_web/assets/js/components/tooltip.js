import Tippy from 'tippy.js/dist/tippy.all';

class Tooltip {
  mount() {
    console.log("mounting tooltip...");

    this.tip = new Tippy("main", {
      arrow: true,
      arrowType: 'round',
      performance: true,
      target: ".tippy",
      dynamicTitle: true
    });
  }

  unmount() {
    console.log("unmountint tooltip...");
    this.tip.destroyAll();
  }
}

export default new Tooltip();
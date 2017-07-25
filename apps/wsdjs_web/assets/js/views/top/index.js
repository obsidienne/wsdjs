import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';
import Tippy from 'tippy.js/dist/tippy';

export default class View {
  constructor() {
  }

  mount() { 
    // cloudinary
    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();

    // tooltip
    new Tippy(".tippy[title]", {performance: true, size: "small", position: "top"});
  }

  unmount() { 
 //   this.tip.destroyAll();
 //   this.tip = undefined;
  }
}
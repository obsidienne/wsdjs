import CloudinaryCore from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class View {
  constructor() { }

  mount() { 
    // cloudinary
    var cl = CloudinaryCore.Cloudinary.new();
    cl.init();
    cl.responsive();
  }
  unmount() { }
}
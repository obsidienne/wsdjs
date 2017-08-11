import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

class MyCloudinary {
  constructor() {
    this.cl = cloudinary.Cloudinary.new();
    this.cl.init();
    this.cl.responsive();
  }

  refresh() {
    this.cl.responsive();
  }
}

export default new MyCloudinary();
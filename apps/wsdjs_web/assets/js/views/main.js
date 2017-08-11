import MyCloudinary from '../components/my-cloudinary';

export default class MainView {
  mount() {
    MyCloudinary.refresh();
  }
  umount() {
    MyCloudinary.disconnect();
  }
}

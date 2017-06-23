import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this.cloudinary();

    console.log('SongEditView mounted');
  }

  cloudinary() {
    var params = { upload_preset: "music_cover_staging",
                   cloud_name: "don2kwaju",
                   thumbnail_transformation: { width: 300, crop: 'scale' } };

    var uploaded = function() {
      cloudinary.openUploadWidget(params, function(error, result) {
        document.getElementById("art_thumbnail").setAttribute("src", result[0]['thumbnail_url']);
        document.getElementById("song_art_cld_id").value = result[0]['public_id'];
        document.getElementById("song_art_version").value = result[0]['version'];
      })
    };

    document.getElementById("upload_widget_opener").addEventListener("click", uploaded, false);
  }
}

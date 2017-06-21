import MainView from '../main';

export default class View extends MainView {
    mount() {
        super.mount();

        this.cloudinary();

        // Specific logic here
        console.log('UserEditView mounted');
    }

    cloudinary() {
        document.getElementById("upload_widget_opener").addEventListener("click", function() {
            cloudinary.openUploadWidget({ 
                upload_preset:"music_cover_staging",
                cloud_name:"don2kwaju"
            }, 
            function(error, result) { 
                console.log(error, result); 
            });                    
            return false;
        }, false);
    }
}



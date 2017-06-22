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
                let list = result;
                if (list.length > 0) {
                    let firstElement = list[0];
                    let publicID = firstElement['public_id'];
                    let version = firstElement['version'];
                    console.log("RESULT TO HANDLE = " + publicID + " - " + version);
                    let baseURL = 'http://res.cloudinary.com/don2kwaju/image/upload/w_300/c_scale/';
                    let imageUri = baseURL + 'v' + version + '/' +  publicID + '.jpg';
                    console.log("imageUri = " + imageUri);
                    var imageElement = `
                        <img src="`+ imageUri +`" style="width:250px;height:250px;">
                    `;
                    document.getElementById("avatar_div").innerHTML = imageElement;

                    var testHTML = `
                        <input class="form-control" id="user_cl_public_id" name="user[cl_public_id]" type="hidden" value="`+publicID+`">
                        <input class="form-control" id="user_cl_version" name="user[cl_version]" type="hidden" value="`+version+`">
                    `;
                    document.getElementById("divToChange").innerHTML = testHTML;
                }
                
                console.log(error, result); 
            });                    
        }, false);
    }
}



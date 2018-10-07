import MainView from '../main';

export default class View extends MainView {
    constructor() {
        super();

        document.addEventListener("click", (e) => {
            if (e.target && e.target.closest(".search-results-container")) {
                this.addSong(e);
            }
        }, false);
    }

    addSong(e) {
        console.log(e);
    }
}
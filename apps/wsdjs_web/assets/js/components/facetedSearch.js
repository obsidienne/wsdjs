import lazyload from './lazyload';
import opinionPicker from './opinionPicker';
import playlistPicker from './playlistPicker';

class FacetedSearch {
    constructor() {
        document.addEventListener("click", e => {
            if (e.target && this.isOutside(e) && this.drawerIsOpen()) {
                this.hide();
            }
            if (e.target && e.target.closest("[data-js-drawer]")) {
                this.show();
            }
        }, false);

        document.addEventListener("submit", e => {
            if (e.target && e.target.matches("#facets-form")) {
                e.preventDefault();
                e.stopPropagation();
                this.search();
                return false;
            }
        })

        var timeout;
        document.addEventListener("keyup", e => {
            if (e.target && e.target.matches("#query-input")) {
                clearTimeout(timeout);
                timeout = setTimeout(() => {
                    this.count();
                }, 50);
            }
        })
    }

    isOutside(e) {
        return e.target.matches(".facets-container.open");
    }

    drawerIsOpen() {
        return document.querySelector(".facets-container.open");
    }

    show() {
        let d = document.querySelector(".facets-container");
        if (d) {
            d.classList.add("open");
        }
    }

    hide() {
        let d = document.querySelector(".facets-container.open");
        if (d) {
            d.classList.remove("open");
        }
    }

    search() {
        let esc = encodeURIComponent;
        let form = document.getElementById('facets-form')
        let fd = new FormData(form);

        let params = "?" + [...fd.entries()].map(e => esc(e[0]) + "=" + esc(e[1])).join('&');

        fetch(form.action + params, {
                credentials: 'include',
                method: "GET",
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then((response) => {
                if (response.ok) {
                    return response.text();
                } else {
                    console.log('Mauvaise réponse du réseau');
                }
            })
            .then((data) => {
                const container = document.getElementById("song-list");
                container.innerHTML = "";
                container.insertAdjacentHTML('beforeend', data);
                lazyload.refresh();
                opinionPicker.remount();
                playlistPicker.remount();

                this.hide();
            })

    }

    count() {}
}

export default new FacetedSearch();
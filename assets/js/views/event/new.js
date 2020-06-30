import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
  }

  mount() {
    super.mount();
    let adress = places({
      container: document.querySelector('.search-place'),
      type: "address"
    })

    adress.on('change', e => {
      document.getElementById("event_lng").value = e.suggestion.latlng.lng;
      document.getElementById("event_lat").value = e.suggestion.latlng.lat;
    });
  }
}

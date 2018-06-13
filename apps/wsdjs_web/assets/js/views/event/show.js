import MainView from '../main';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

// stupid hack so that leaflet's images work after going through webpack
import marker from 'leaflet/dist/images/marker-icon.png';
import marker2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

delete L.Icon.Default.prototype._getIconUrl;

export default class View extends MainView {
  mount() {
    super.mount();

    L.Icon.Default.mergeOptions({
      iconRetinaUrl: `/js/${marker2x}`,
      iconUrl: `/js/${marker}`,
      shadowUrl: `/js/${markerShadow}`
    });

    let el = document.getElementById("mapid");

    var map = L.map('mapid').setView([el.dataset.lat, el.dataset.lon], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    L.marker([el.dataset.lat, el.dataset.lon]).addTo(map)
      .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
      .openPopup();
  }
}
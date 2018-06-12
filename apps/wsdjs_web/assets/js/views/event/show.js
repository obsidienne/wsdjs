import MainView from '../main';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

export default class View extends MainView {
  mount() {
    super.mount();

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
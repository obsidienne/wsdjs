import Places from 'places.js/dist/cdn/places.js';

export default class View {
  mount() {
    Places({
      container: document.querySelector('#user_country'),
      type: 'country',
      templates: {
        suggestion: function(suggestion) {
          return '<i class="flag ' + suggestion.countryCode + '"></i> ' +  suggestion.highlight.name;
        }
      }
    })
  }
}

class Outdated {
  constructor() {
    var self = this;
    window.addEventListener('click', function(e) { 
      if (e.target && e.target.matches("#btnCloseUpdateBrowser")) {
        var outdated = document.getElementById("outdated");
        outdated.parentNode.removeChild(outdated);

        e.preventDefault();
        e.stopPropagation();
      }
    }, false);
  }

  check() {
    var outdated = document.getElementById("outdated");
    
    if (this._verifyValidaty()) {
        outdated.parentNode.removeChild(outdated);
        console.log("valid browser");
      } else {
        outdated.removeAttribute("hidden");
        console.log("outdated browser");
      }
  }

  _verifyValidaty() {
    var outdated = document.getElementById("outdated");

    return outdated 
        && window.Promise !== undefined 
        && window.Promise !== null 
        && Object.prototype.toString.call(window.Promise.resolve()) === '[object Promise]';
  }
}

export default new Outdated();
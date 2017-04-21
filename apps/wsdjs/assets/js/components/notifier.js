export default class Notifier {
  show_all() {
    var notifications = document.querySelectorAll('.notifier-container .notifier'), i;

    for (i = 0; i < notifications.length; ++i) {
      notifications[i].classList.add("shown");
      this.hide(notifications[i].getAttribute("id"));
    }
  }

  hide(id) {
    setTimeout(function() {
      var notification = document.getElementById(id);
      notification.classList.remove("shown");
      setTimeout(function() {
        notification.parentNode.removeChild(notification);
      }, 600);
    }, 4000);
  }
}

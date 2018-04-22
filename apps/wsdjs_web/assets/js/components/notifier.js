export default class Notifier {
  show_all() {
    var notifications = document.querySelectorAll('.notifier-container .notifier'),
      i;

    for (i = 0; i < notifications.length; ++i) {
      notifications[i].classList.add("shown");
      this.hide(notifications[i].getAttribute("id"));
    }
  }

  hide(id) {
    var timeout_value = 5000;
    var notification = document.getElementById(id);
    if (notification.classList.contains("notifier-container-sticky")) {
      timeout_value = 15000;
    }
    console.log(timeout_value);

    setTimeout(function () {
      var notification = document.getElementById(id);
      notification.classList.remove("shown");
      setTimeout(function () {
        notification.parentNode.removeChild(notification);
      }, 800);
    }, timeout_value);
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToLatestMessage();
  }

  dismissFeedback(e) {
    var btn = e.target
    var parentElement = btn.closest('[data-govuk-chat-id]')
    parentElement.hidden = true
    btn.hidden = true
  }
  
  focusOnLatestMessage(latestMessage) {
    latestMessage.setAttribute("tabindex", -1);
    latestMessage.focus({preventScroll: true});
  }
  
  scrollToLatestMessage() {
    var messages = document.querySelectorAll(".govuk-chat-message")
    if(messages.length) {
      var latestMessage = messages[messages.length - 1]
      if(latestMessage) {
          latestMessage.scrollIntoView({
            behavior: "smooth"
        });
        this.focusOnLatestMessage(latestMessage)
      }
    }
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var loadingIndicator = document.querySelector(".govuk-chat-loading-indicator");
    this.setJSEnabled();

    document.addEventListener("turbo:submit-start", function(e) {
      if(e.target.className === "govuk-form govuk-chat-form") {
        loadingIndicator.style.display = "flex";
        loadingIndicator.scrollIntoView({
          behavior: "smooth"
        });
      }
    })
  
    document.addEventListener("turbo:submit-end", function(e) {
      document.getElementById("govuk-chat-input").value = "";
      loadingIndicator.style.display = "none";
    })
  }
  
  setJSEnabled() {
    var jsEnabled = document.querySelectorAll("#js_enabled");
    if(jsEnabled.length > 0) {
      for(var i = 0; i < jsEnabled.length; i++) {
        jsEnabled[i].value = true;
      }
    }
  }
}

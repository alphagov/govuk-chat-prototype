import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  characterCountMessage = document.querySelector(".govuk-character-count__message");
  characterLimit = 300;
  characterWarningBoundary = 50;

  countCharacters(e) {
    var characterCount = e.target.value.length;
    var charactersRemaining = this.characterLimit - characterCount;
    this.characterCountMessage.textContent = "You have " + charactersRemaining + " characters remaining.";
    
    charactersRemaining <= this.characterWarningBoundary ? this.characterCountMessage.hidden = false : this.characterCountMessage.hidden = true;
  }

  checkInputForPII(string) {
    var EMAIL_PATTERN = /[^\s=/?&#]+(?:@|%40)[^\s=/?&]+/g
    var CREDIT_CARD_PATTERN = /\b\d{13,16}\b/g
    var PHONE_NUMBER_PATTERN = /\b[\+]?[(]?\d{3}[)]?[-\s\.]?\d{3}[-\s\.]?\d{4,6}\b/g
    var NI_PATTERN = /\b[A-Za-z]{2}\s?([0-9 ]+){6,8}\s?[A-Za-z]\b/g

    var stripped = string.replace(EMAIL_PATTERN, '[redacted]')
    stripped = stripped.replace(CREDIT_CARD_PATTERN, '[redacted]')
    stripped = stripped.replace(PHONE_NUMBER_PATTERN, '[redacted]')
    stripped = stripped.replace(NI_PATTERN, '[redacted]')

    return stripped
  }

  detectPIIOnSubmit(e, inputEl) {
    inputEl.removeAttribute("aria-describedby");
    var errorMessageContainer = document.querySelector(".govuk-error-message__container");
    var errorDetected = this.checkInputForPII(inputEl.value).indexOf("[redacted]") !== -1 ? true : false;

    if(errorDetected) {
      e.preventDefault();

      inputEl.style.border = "2px solid #d4351c";
      errorMessageContainer.hidden = false;

      var errorMessageEl = errorMessageContainer.querySelector(".govuk-error-message");
      var errorMessageText = errorMessageEl.textContent;
      errorMessageEl.textContent = "";
      errorMessageEl.textContent = errorMessageText;

      inputEl.setAttribute("aria-describedby", errorMessageEl.id)
    }
    else {
        errorMessageContainer.hidden = true;
        inputEl.style.border = "2px solid #0b0c0c";
    }
  }

  submit(e) {
    var inputEl = document.querySelector("[data-govuk-chat-input]");
    this.detectPIIOnSubmit(e, inputEl);
  }
}

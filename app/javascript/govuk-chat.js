(function initialiseGOVUKChatJS() {
    // Used for debugging purposes
    console.log("GOVUK Chat JS loaded");

    var hasReceivedNewMessage = initialiseMessageState();

    // Set up mutation observer
    var target = document.querySelector("html");
    var config = { childList: true }
    var observer = new MutationObserver(function() {
        if(document.querySelectorAll(".govuk-chat-message").length > 1) {
            var messages = document.querySelectorAll(".govuk-chat-message");
            var messageCount = messages.length;
            var latestMessage = document.querySelectorAll(".govuk-chat-message")[(messageCount - 2)];
            var newMessageReceived = hasReceivedNewMessage(messageCount);
            addDismissListeners();
            setJSEnabled();
            detectPIIOnSubmit();
            addCharacterCountListener();

            if(document.querySelector(".govuk-chat-form") && newMessageReceived) {
                scrollToLatestMessage();
                addTurboSubmitListeners(newMessageReceived, latestMessage);
                setJSEnabled();
                focusOnLatestMessage(messages);
            }
        } else if(document.querySelectorAll(".govuk-chat-message").length === 1) {
            addTurboSubmitListeners();
            setJSEnabled();
            detectPIIOnSubmit();
            addCharacterCountListener();
        }
    });

    window.addEventListener("DOMContentLoaded", function() {
        observer.observe(target, config);
        triggerMutation();
    })
})();

function triggerMutation() {
    var htmlEl = document.querySelector("html");
    var el = document.createElement("div");
    el.id = "toBeRemoved";

    htmlEl.appendChild(el);
    htmlEl.removeChild(document.getElementById("toBeRemoved"));
}

function scrollToLatestMessage() {
    var messages = document.querySelectorAll(".govuk-chat-message")
    if(messages.length) {
        var latestMessage = messages[messages.length - 1]
        if(latestMessage) {
            latestMessage.scrollIntoView();
        }
    }
}

function scrollToBottom(params) {
    params.loadingIndicator.scrollIntoView({
        behavior: "smooth"
    });
}

function initialiseMessageState() {
    var messageCount = 0;

    return function (messages) {
        var newMessageReceived = false;

        if(!messages) {
            messageCount = 0;
        }
        else if(messages > messageCount) {
            newMessageReceived = true;
            messageCount = messages;
        }

        return newMessageReceived
    }
}

function addDismissListeners() {
    var dismissButtons = document.querySelectorAll('[data-govuk-chat-feedback-dismiss-button]')
    for(var i = 0; i < dismissButtons.length; i++) {
        var button = dismissButtons[i]

        // Check if this function has already been run on the button, and skip if so.
        if(button.getAttribute('data-govuk-chat-dismiss-listener-added')) {
            continue
        }

        // Check if the feedback message was hidden on a previous DOM load, and hide it if so.
        var parentElement = button.closest('[data-govuk-chat-id]')
        var feedbackId = parentElement.getAttribute('data-govuk-chat-id')
        window.hiddenFeedbacks = window.hiddenFeedbacks || []
        if(window.hiddenFeedbacks.indexOf(feedbackId) !== -1) {
            parentElement.hidden = true
            button.hidden = true
            continue
        }

        button.addEventListener('click', function(e) {
            var btn = e.target
            var parentElement = btn.closest('[data-govuk-chat-id]')
            parentElement.hidden = true
            btn.hidden = true

            var feedbackId = parentElement.getAttribute('data-govuk-chat-id')
            window.hiddenFeedbacks = window.hiddenFeedbacks || []
            window.hiddenFeedbacks.push(feedbackId)
        })

        button.setAttribute('data-govuk-chat-dismiss-listener-added', 'true')
    }
}

function getOuterHeight(element) {
    var height = element.offsetHeight;
    var style = getComputedStyle(element);
    
    height += parseInt(style.marginBottom) + parseInt(style.marginTop);
    return height;
}

function detectPIIOnSubmit() {
    var submitBtn = document.querySelector("[data-govuk-chat-send-button]");

    // Prevents the listener being added more than once, as this attribute only exists once the listener is attached.
    if(submitBtn.getAttribute('data-govuk-chat-pii-listener-added')) {
        return
    }

    submitBtn.addEventListener('click', function(e) {
        var chatInput = document.getElementById("govuk-chat-input");
        var errorMessageContainer = document.querySelector(".govuk-error-message__container");
        var errorDetected = checkInputForPII(chatInput.value).indexOf("[redacted]") !== -1 ? true : false;

        if(errorDetected) {
            e.preventDefault();

            chatInput.style.border = "2px solid #d4351c";
            errorMessageContainer.hidden = false;

            var errorMessageEl = errorMessageContainer.querySelector(".govuk-error-message");
            var errorMessageText = errorMessageEl.textContent;
            errorMessageEl.textContent = "";
            errorMessageEl.textContent = errorMessageText;
        }
        else {
            errorMessageContainer.hidden = true;
            chatInput.style.border = "2px solid #0b0c0c";
        }
    })

    submitBtn.setAttribute('data-govuk-chat-pii-listener-added', 'true')
}

function checkInputForPII(string) {
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

function addTurboSubmitListeners(newMessageReceived, latestMessage) {
    document.addEventListener("turbo:submit-start", function(e) {
        if(e.target.className === "govuk-form govuk-chat-form") {
            document.querySelector(".govuk-chat-loading-indicator").style.display = "flex";

            scrollToBottom({
                loadingIndicator: document.querySelector(".govuk-chat-loading-indicator")
            })
            window.lastSubmitType = 'chat';
        }
        else if(e.target.className === "govuk-form govuk-chat__feedback-form") {
            var chat = document.querySelector(".govuk-chat-container");
            window.scrollPosition = chat.scrollTop;
            window.lastSubmitType = 'feedback';
        }
    })

    document.addEventListener("turbo:submit-end", function(e) {
        document.querySelector(".govuk-chat-loading-indicator").style.display = "none";
    })

    document.addEventListener("turbo:render", function(e) {
        if(window.lastSubmitType === 'feedback') {
            scrollToPrevPosition();
        }
        else {
            scrollToLatestMessage();
        }
    })
}

function scrollToPrevPosition() {
    var chat = document.querySelector(".govuk-chat-container");
    var top = window.scrollPosition;

    if (top) {
        chat.scrollTop = parseInt(top, 10);
    }
}

function setJSEnabled() {
    var jsEnabled = document.querySelectorAll("#js_enabled");
    if(jsEnabled.length > 0) {
        for(var i = 0; i < jsEnabled.length; i++) {
            jsEnabled[i].value = true;
        }
    }
};

function focusOnLatestMessage(messages) {
    var latestMessage = messages[messages.length - 1];
    latestMessage.setAttribute("tabindex", -1);
    latestMessage.focus({preventScroll: true});
}

function addCharacterCountListener() {
    var input = document.getElementById("govuk-chat-input");
    var characterCountMessage = document.querySelector(".govuk-character-count__message");
    var characterLimit = 300;
    var characterBoundary = 50;

    input.addEventListener('keyup', function(e) {
        var characterCount = e.target.value.length;
        var charactersRemaining = characterLimit - characterCount;
        characterCountMessage.textContent = "You have " + charactersRemaining + " characters remaining.";
        
        charactersRemaining <= characterBoundary ? characterCountMessage.hidden = false : characterCountMessage.hidden = true;
    })
}

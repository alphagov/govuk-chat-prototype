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

            setJSEnabled();
            
            if(document.querySelector(".govuk-chat-form") && newMessageReceived) {
                scrollToLatestMessage();
                detectPIIOnSubmit();
                addTurboSubmitListeners(newMessageReceived, latestMessage);
                setJSEnabled();
                focusOnLatestMessage(messages);
            }
        } else if(document.querySelectorAll(".govuk-chat-message").length === 1) {
            detectPIIOnSubmit();
            addTurboSubmitListeners();
            setJSEnabled();
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

function getOuterHeight(element) {
    var height = element.offsetHeight;
    var style = getComputedStyle(element);
    
    height += parseInt(style.marginBottom) + parseInt(style.marginTop);
    return height;
}

function detectPIIOnSubmit() {
    var label = document.querySelector('.govuk-chat-form label');
    var labelFor = label.getAttribute('for');
    var input = document.querySelector('[id=' + labelFor + ']');
    var submitBtn = document.querySelector("input[type='submit']");
    var errorDetected = false;

    submitBtn.addEventListener('click', function(e) {
        var chatInput = document.getElementById("govuk-chat-input");
        var errorMessageContainer = document.querySelector(".govuk-error-message__container");
        errorDetected = checkInputForPII(input.value).indexOf("[redacted]") !== -1 ? true : false;

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
        }
        else if(e.target.className === "govuk-form govuk-chat__feedback-form") {
            var chat = document.querySelector(".govuk-chat-container");
            window.scrollPosition = chat.scrollTop;
        }
    })
    
    document.addEventListener("turbo:submit-end", function(e) {
        document.querySelector(".govuk-chat-loading-indicator").style.display = "none";
    })

    document.addEventListener("turbo:render", function(e) {
        if(newMessageReceived) {
            scrollToLatestMessage();
            newMessageReceived = false
        }
        else {
            scrollToPrevPosition();
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
        hideNotificationMessage();

        for(var i = 0; i < jsEnabled.length; i++) {
            jsEnabled[i].value = true;
        }
    }
};

function hideNotificationMessage() {
    var notificationMessage = document.querySelector(".govuk-notification-banner--success");
    if(notificationMessage) {
        notificationMessage.hidden = true;
    }
}

function focusOnLatestMessage(messages) {
    var latestMessage = messages[messages.length - 1];
    latestMessage.setAttribute("tabindex", -1);
    latestMessage.focus({preventScroll: true});
}

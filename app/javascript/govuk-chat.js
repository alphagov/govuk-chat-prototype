(function initialiseGOVUKChatJS() {
    // Used for debugging purposes
    console.log("GOVUK Chat JS loaded");

    var hasReceivedNewMessage = initialiseMessageState();

    // Set up mutation observer
    var target = document.querySelector("html");
    var config = { childList: true }
    var observer = new MutationObserver(function() {
        if(document.querySelectorAll(".govuk-chat-message").length > 1) {
            var chatContainer = document.querySelector(".govuk-chat-container");
            var messageCount = document.querySelectorAll(".govuk-chat-message").length;
            var latestMessage = document.querySelectorAll(".govuk-chat-message")[(messageCount - 2)];
            var newMessageReceived = hasReceivedNewMessage(messageCount);

            scrollToLatestMessage({
                chatContainer: chatContainer,
                latestMessage:latestMessage,
                newMessageReceived: newMessageReceived
            })
        }
    });

    observer.observe(target, config);
})();

function scrollToLatestMessage(params) {
    var headerHeight = getOuterHeight(document.querySelector(".govuk-header"));
    if(params.latestMessage.getBoundingClientRect().y - headerHeight > 0 && params.newMessageReceived) {
        params.chatContainer.scrollTop = params.latestMessage.getBoundingClientRect().y - headerHeight;
    }
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

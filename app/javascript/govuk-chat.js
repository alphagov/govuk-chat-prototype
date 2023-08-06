(function initialiseGOVUKChatJS() {
    // Used for debugging purposes
    console.log("GOVUK Chat JS loaded");

    var hasReceivedNewMessage = initialiseMessageState();

    // Set up mutation observer
    var target = document.querySelector("html");
    var config = { childList: true }
    var observer = new MutationObserver(function() {
        if(document.querySelector(".govuk-chat-timestamp")) {
            var chatContainer = document.querySelector(".govuk-chat-container");
            var messageCount = document.querySelectorAll(".govuk-chat-timestamp").length;
            var latestMessage = document.querySelectorAll(".govuk-chat-timestamp")[(messageCount - 1)];
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
    if(params.latestMessage.getBoundingClientRect().y - 60 > 0 && params.newMessageReceived) {
        params.chatContainer.scrollTop = params.latestMessage.getBoundingClientRect().y - 60;
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

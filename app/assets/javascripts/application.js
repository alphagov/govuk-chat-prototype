if(document.querySelector(".govuk-chat-container")) {
    var chatContainer = document.querySelector(".govuk-chat-container");
    var latestMessage = document.querySelectorAll(".govuk-chat-timestamp")[(document.querySelectorAll(".govuk-chat-timestamp").length - 1)]

    scrollToLatestMessage({
        chatContainer: chatContainer,
        latestMessage:latestMessage
    })
}

function scrollToLatestMessage(params) {
    params.chatContainer.scrollTop = params.latestMessage.getBoundingClientRect().y - 60;
}

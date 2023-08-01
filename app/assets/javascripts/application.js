if(document.getElementById("govuk-chat")) {
    var chatPane = document.getElementById("govuk-chat");
    var latestMessage = document.querySelectorAll(".govuk-chat-timestamp")[(document.querySelectorAll(".govuk-chat-timestamp").length - 1)]

    scrollToLatestMessage({
        chatPane: chatPane,
        latestMessage:latestMessage
    })
}

function scrollToLatestMessage(params) {
    params.chatPane.scrollTop = params.latestMessage.getBoundingClientRect().y - 60;
}

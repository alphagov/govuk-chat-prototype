if(document.getElementById("govuk-chat")) {
    var chatPane = document.getElementById("govuk-chat");
    scrollToBottom(chatPane)
}

function scrollToBottom(element) {
    element.scrollTop = element.scrollHeight;
}

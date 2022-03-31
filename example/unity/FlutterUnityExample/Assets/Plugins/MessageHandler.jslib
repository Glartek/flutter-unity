mergeInto(LibraryManager.library, {
    SendMessageToWeb: function (str) {
        window.receiveMessageFromUnity(Pointer_stringify(str));
    },
});
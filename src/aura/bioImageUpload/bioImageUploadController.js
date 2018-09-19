({
    doInit: function(cmp, event, helper) {
        console.log('hello world');
    },
    handleUploadFinished: function(cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");

        for (let i = 0; i < uploadedFiles.length; i++) {
            console.log('hello ', uploadedFiles[i]);
        }

        alert("Files uploaded : " + uploadedFiles.length);
    },
})
({
    doInit: function(cmp, event, helper) {
        console.log('hello world');
    },
    handleUploadFinished: function(cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");

        for (let i = 0; i < uploadedFiles.length; i++) {
            console.log('hello ', uploadedFiles[i]);
            var attachedField =  cmp.get('v.AttachedField');
            var objectName = 'Organisation__c';
            var action = cmp.get('c.addFieldTodocument');
            
            action.setParams({
            	
            	recId: uploadedFiles[i],
            	Field: attachedField,
            	strObject: objectName	
            });
            action.setCallback(this, function(resp){
            	let status =  resp.getState();
            	if(status == 'SUCCESS'){
            		alert("Files uploaded : " + uploadedFiles.length);
            	}            
            });
            $A.enqueueAction(action);
        }

        
    },
})
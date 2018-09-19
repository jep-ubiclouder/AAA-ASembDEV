({
    doInit: function(cmp, event, helper) {
        //var curRecord = cmp.get('v.dataRecord');
        //// // console.log(curRecord);
        var cols = cmp.get('v.Colonnes');
        // // console.log(cols);
        var sfid = cmp.get('v.sfId');
        // // console.log(sfid);
        var body = cmp.get('v.body');
        var champs = [];
        for (var i = 0; i < cols.length; i++) {
            champs.push(cols[i].fieldPath);
        }
        // // console.log(champs);
        $A.createComponent('lightning:recordForm', {
                    fields : champs,
                    recordId :  cmp.get("v.sfId" ),
                    objectApiName : cmp.get("v.sfObject"),
                    mode : cmp.get("v.mode"),
                    columns: 2,
                    class : 'slds-p-left_x-small'
                },
                function(newDZ, status, errorMessage) {
                    // // console.log(status);
                    if (cmp.isValid() && status === "SUCCESS") {
                    	var body = cmp.get('v.body');
                        body.push(newDZ);
                        cmp.set("v.body", body);
                    } else if (status === "INCOMPLETE") {
                        // // console.log("No response from server or client is offline.")
                    } else if (status === "ERROR") {
                        // // console.log("Error: " + errorMessage);
                    }
                }
            );
        
    },
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },

    handleSubmit: function(cmp, event, helper) {
        var currentMode = cmp.get('v.mode');
        // // console.log(currentMode);
        if (currentMode == 'view') {
            cmp.set('v.mode', 'edit');
        } else {
            cmp.set('v.mode', 'view')
        }
        var test = cmp.get('v.disabled');
        cmp.set('v.disabled', !test);
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    }
})
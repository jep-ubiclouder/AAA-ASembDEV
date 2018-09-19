({
    doInit: function(cmp, event, helper) {
    	console.log('RECORD ID DE UBORGREFERENCE',cmp.get('v.mainRecordId'));
    
        helper.Init(cmp);
    },
    handleClick: function(cmp, event, helper) {
        var btnName = event.getSource().getLocalId()
        switch (btnName) {
            case "New":
                var RTId = cmp.get('v.RTId');
                // // console.log('RTID', RTId);
                var Key = cmp.get('v.ContactId');
                // // console.log(Key);
                var createAcountContactEvent = $A.get("e.force:createRecord");
                createAcountContactEvent.setParams({
                    "entityApiName": "Organisation_Reference__c",
                    "recordTypeId": RTId,
                    "defaultFieldValues": {
                        "References__c": Key,
                        "Organisation__c": Key
                    }
                });
                createAcountContactEvent.fire();
                break;
            case "Refresh":
                helper.Init(cmp);
                break;
        }
    },
    handleSave: function(cmp, event, helper) {
        var editedRecords = cmp.find("ReferencesRecord").get("v.draftValues");
        if (editedRecords.length > 1) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Info Message',
                message: 'Please modify only ONE value',
                type: 'error'
            });
            toastEvent.fire();
        } else {
            var totalRecordEdited = editedRecords.length;
            var action = cmp.get('c.updateOrgref');
            action.setParams({
                'editedAccountList': editedRecords
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // // console.log('sate after save', state);
                    helper.Init(cmp);

                }
            });
            $A.enqueueAction(action);
        }
    },

    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // // console.log(fieldName, sortDirection);
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },

    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(event.getParam('action'));
        console.log(event.getParam('row'));
        switch (action.name) {
            case 'show_details':

                // alert('Showing Details: ' + JSON.stringify(row));
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": row.Id
                });
                editRecordEvent.fire();
                break;
            case 'delete':
                if (confirm("Are you sure ?")) {
                    var rows = cmp.get('v.mydata');
                    var rowIndex = rows.indexOf(row);
                    // // console.log(rows[rowIndex]);
                    let deleteRow = cmp.get('c.deleteOrgRef');
                    deleteRow.setParams({
                        'idToDelete': rows[rowIndex]['Id']
                    });
                    deleteRow.setCallback(this, function(reponse) {
                        var status = reponse.getState();
                        // // console.log(status);
                        if (status == 'SUCCESS') {
                            // // console.log(reponse.getReturnValue());
                            if (reponse.getReturnValue() == 'OK') {
                                // // console.log('yo');
                                helper.Init(cmp);
                            }
                        }
                    });
                    $A.enqueueAction(deleteRow);

                }
                break;
            case "importImage":
                var curObj = cmp.get('v.curObj');
                var RTName = cmp.get('v.RTName');
                console.log('curObj', curObj);
                console.log("recordId", row.Id);
                // jg
                if (RTName.startsWith('Executive Member') || RTName.startsWith('Executive Board')) {
                    $A.createComponent('c:s3ImgEditorFromOrgRef', {
                            'currentRec': row.Id,                            
                            'mainRecordId' : cmp.get('v.mainRecordId'),
                            'sObjectName': 'Organisation_Reference__c'
                        },
                        function(ImgUploader, status, error) {
                            if (cmp.isValid() && status === "SUCCESS") {
                                var body = cmp.get("v.body");
                                body.push(ImgUploader);
                                cmp.set("v.body", body);
                            }
                        }
                    );
                    // alert('TODO upload Image');
                } else {
                    alert('noImage Needed');
                }
                break;
           case "view_details":
        	   helper.jumpTo(row);
        	   
        	   /*var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": row.Id
                });
                editRecordEvent.fire();*/
                break;
        }
    }
})
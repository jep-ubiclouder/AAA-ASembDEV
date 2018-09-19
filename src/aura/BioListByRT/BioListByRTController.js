({
    doInit: function(cmp, event, helper) {
        helper.Init(cmp);
    },
    handleRender: function(cmp, event, helper) {
        var rendering = cmp.get('v.rendering');
        if (!rendering) {
            cmp.set('v.rendering', true);
            console.log('hello from rendering', rendering);
            //this.doInit(cmp, event, helper);
        }

    },
    handleSave: function(cmp, event, helper) {
        var editedRecords = cmp.find("ReferencesRecord").get("v.draftValues");

        var totalRecordEdited = editedRecords.length;
        if (editedRecords.length > 1) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Info Message',
                message: 'Please modify only ONE value',
                type: 'error'
            });
            toastEvent.fire();
        } else {
            var action = cmp.get('c.updateBioref');
            action.setParams({
                'editedAccountList': editedRecords
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('sate after save', state);
                    helper.Init(cmp);
                }
            });
            $A.enqueueAction(action);
        }
    },

    handleClick: function(cmp, event, helper) {
        var btnName = event.getSource().getLocalId()
        switch (btnName) {
            case "New":
                var RTId = cmp.get('v.RTId');
                console.log('RTID', RTId);
                var Key = cmp.get('v.ContactId');
                console.log(Key);
                var createAcountContactEvent = $A.get("e.force:createRecord");
                createAcountContactEvent.setParams({
                    "entityApiName": "Biography_Reference__c",
                    "recordTypeId": RTId,
                    "defaultFieldValues": {
                        "References__c": Key
                    }
                });
                createAcountContactEvent.fire();
                break;
            case "Refresh":
                console.log('hello handleclick', btnName);
                helper.Init(cmp);
                break;
        }
    },
    handleSaveSuccess: function(cmp, event) {
        /*var Key = cmp.get('v.ContactId');
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": Key
        });
        sObjectEvent.fire();*/
        $A.get('e.force:refreshView').fire();
    },
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(action.name);
        console.log(row.Id, row, row.List_Position__c);

        switch (action.name) {
            case 'move_up':
                var arrData = cmp.get('v.mydata');
                var chosen = row.List_Position__c;
                if (chosen > 0) {
                    arrData[chosen].List_Position__c--;
                    arrData[chosen - 1].List_Position__c++;
                    helper.sortData(cmp, 'List_Position__c', 'asc');
                }
                break;
            case 'move_down':
                var arrData = cmp.get('v.mydata');
                var chosen = row.List_Position__c;
                if (chosen < arrData.length) {
                    arrData[chosen].List_Position__c++;
                    arrData[chosen - 1].List_Position__c--;
                    helper.sortData(cmp, 'List_Position__c', 'asc');
                }

                break;
            case 'show_details':
                cmp.set('v.rendering', false);
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
                    console.log(rows[rowIndex]);
                    let deleteRow = cmp.get('c.deleteBioRef');
                    deleteRow.setParams({
                        'idToDelete': rows[rowIndex]['Id']
                    });
                    deleteRow.setCallback(this, function(reponse) {
                        var status = reponse.getState();
                        console.log(status);
                        if (status == 'SUCCESS') {
                            if (reponse.getReturnValue() == 'OK') {
                                console.log('yo');
                                helper.Init(cmp);
                            }
                        }
                    });
                    $A.enqueueAction(deleteRow);

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
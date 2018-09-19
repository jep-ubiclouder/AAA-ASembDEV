({
    doInit: function(cmp, event, helper) {
        var FSName = cmp.get('v.FS');
        console.log(FSName);
        if (FSName == 'NoFieldSetDefined') {
            return;
        }
        var objName = cmp.get('v.sObjectName');
        var sfId = cmp.get('v.recordId');
        console.log(objName);
        var getFields = cmp.get('c.getFieldsFromFieldSet');
        getFields.setParams({
            'FSName': FSName,
            'objectName': objName
        });
        console.log(getFields);
        getFields.setCallback(this, function(rgetFields) {
            var status = rgetFields.getState();
            console.log(status);
            if (status != 'SUCCESS') {
                return status;
            }
            var data = rgetFields.getReturnValue();
            var fields = [];
            var fsStructure = JSON.parse(data);
            console.log(fsStructure);
            var fsLabel = fsStructure['Label'];
            cmp.set('v.fsLabel',                fsLabel);
            var listFields = fsStructure['Fields'];
            for (var d in listFields) {
                fields.push(listFields[d].fieldPath);
            }
            cmp.set('v.Fields', fields);
            cmp.set('v.Colonnes', listFields);
            console.log(listFields);
            var body = cmp.get("v.body");
            $A.createComponent(
                "c:RecordEdit", {
                    'Colonnes': listFields,
                    'sfId': cmp.get('v.recordId'),
                    'sfObject': cmp.get('v.sObjectName'),
                    'FSName': FSName
                },
                function(newDZ, etat, errorMessage) {
                    if (cmp.isValid() && etat === "SUCCESS") {
                    	var body= cmp.get('v.body');
                    	console.log(body);
                        body.push(newDZ);
                        console.log(body);
                        cmp.set("v.body", body);
                        console.log(body);
                    } else if (etat === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    } else if (etat === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                });
        });
        $A.enqueueAction(getFields);
    },
    handleRowAction: function(cmp, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": cmp.get('v.recordId')
        });
        editRecordEvent.fire();
    }
})
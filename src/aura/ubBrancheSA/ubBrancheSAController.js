({
    doInit: function(cmp, event, helper) {
        // console.log('Hello!');
        let lstRecord = cmp.get("v.listLignes");
        helper.createLightningBC(cmp, lstRecord);

    },
    handleClick: function(cmp, event, helper) {
        let AccId = cmp.get('v.Accid');
        console.log('recId', AccId);
        let IdToDelete = cmp.get('v.myId');
        console.log('IdToDelete', IdToDelete);
        if (confirm("are you sure ?")) {
            var objectName = cmp.get('v.sObjectName');

            console.log('objectName', objectName);
            if (objectName == 'Account') {
               var delBranche = cmp.get('c.deleteBranche');
            } else {
                var delBranche = cmp.get('c.deleteBrancheOrg');
            }

            delBranche.setParams({
                "recId": IdToDelete,
                "AccId": AccId
            });
            delBranche.setCallback(this, function(response) {
                let j = response.getReturnValue();
                console.log(j);
                let sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": j
                })
                sObjectEvent.fire();
                let refresh = $A.get("e.force:refreshView").fire();
                let dismissActionPanel = $A.get("e.force:closeQuickAction").fire();

            });
            $A.enqueueAction(delBranche);
        }
    }
})
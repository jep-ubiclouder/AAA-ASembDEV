({
    doInit: function(cmp, event, helper) {
        var recId = cmp.get('v.recordId');
        console.log('recId', recId);
        if (confirm("are you sure ?")) {
            var delBranche = cmp.get('c.deleteBranche');
            delBranche.setParams({
                "recId": recId
            });
            delBranche.setCallback(this, function(response) {
                var j = response.getReturnValue();
                console.log(j);
                var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": j
                })
                sObjectEvent.fire();
                var refresh = $A.get("e.force:refreshView").fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction").fire();
                
            });
            $A.enqueueAction(delBranche);
        }
    }
})
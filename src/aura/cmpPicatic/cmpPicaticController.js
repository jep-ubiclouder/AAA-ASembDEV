({
	doInit : function(cmp) {
        var recId  = cmp.get("v.recordId");
        var action =  cmp.get("c.getCampaign");
        var workspaceAPI = cmp.find("workspace");

        action.setParams({"recid":recId});
        action.setCallback(this, function(response){
     		var state = response.getState();
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            }
            $A.get("e.force:closeQuickAction").fire();
        });

        $A.enqueueAction(action);
	}
})
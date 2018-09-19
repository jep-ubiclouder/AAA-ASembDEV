({
	doInit : function(cmp, event, helper) {
		var AccId =  cmp.get('v.recordId');
		console.log(AccId);
		var getAS =  cmp.get('c.gLSAOrg');
		getAS.setParams({
			Acc:AccId
		});
		
		getAS.setCallback(this , function(response){helper.processAllSAs(cmp,response)});
		$A.enqueueAction(getAS);
	}
})
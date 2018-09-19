({
	doInit : function(cmp, event, helper) {
		let AccId =  cmp.get('v.recordId');
		console.log(AccId);
		let getAS =  cmp.get('c.gLSAAcc');
		getAS.setParams({
			Acc:AccId
		});
		
		getAS.setCallback(this , function(response){helper.processAllSAs(cmp,response)});
		$A.enqueueAction(getAS);
	}
})
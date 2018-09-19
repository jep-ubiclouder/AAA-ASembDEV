({
	doInit : function(component, event, helper) {
		var getRt=  component.get("c.getFields");
		var contactId =  component.get("v.recordId");
		console.log(contactId);
		getRt.setCallback(this, function(a) {
			var liste = JSON.parse(a.getReturnValue());
			console.log(liste);
		});
		
	}
})
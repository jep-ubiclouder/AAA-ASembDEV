({
	getFSfromRT : function(RT) {
	var mapRT= {
			'Spoken Language References':'FSSpokLang',
			'Honorary Title References' : 'FSHonoTitl',
			'Non-Professional Association References' : 'FSNonpAsso'
	}
		return mapRT[RT];
	},
	getContactId: function (cmp,recordId){
		var getContactIdFromBiography=cmp.get('c.getContactIdFromBiography');
		getContactIdFromBiography.setParams({
			cId :  recordId
		});
		getContactIdFromBiography.setCallback(this, function(resp){
			 var state = resp.getState();
            if (state == 'SUCCESS') {
                return resp.getReturnValue();
               }
               });
		$A.enqueueAction(getContactIdFromBiography);
	}
})
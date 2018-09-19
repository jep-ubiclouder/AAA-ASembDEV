({
    doInit: function(cmp, event, helper) {
        let recId = cmp.get('v.recordId');
        console.log('hello there', recId);


        let getRec = cmp.get('c.getUrl');

        getRec.setParams({
            "recId": recId
        });
        getRec.setCallback(this, function(res) {
            let status = res.getState();
            console.log(status);
            if (status == 'SUCCESS') {
                var rec = JSON.parse(res.getReturnValue());
                console.log(rec);
                cmp.set('v.URL', rec.NEILON__File_Presigned_URL__c);
            }
        });
        $A.enqueueAction(getRec);
    },
    Croppie: function(cmp){
    	var el = cmp.find("my-image");
    	el.croppie()
    }
})
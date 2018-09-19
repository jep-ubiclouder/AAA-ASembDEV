({
    doInit: function(cmp, event, helper) {
    	var recordId = cmp.get('v.recordId');
    	var curObject =  cmp.get('v.sObjectName');
        // enumeration des recordtypes de ElementBio
        var RTname = cmp.get('v.RT');
        var FSName = cmp.get('v.FS');
        if(FSName == 'None'){
        	alert('Please choose a FieldSet!');
        	return;
        }
        let getSite = cmp.get('c.getSiteData');
        getSite.setCallback(this,function(resp){
        	var state = resp.getState();
            if (state == 'SUCCESS') {
            	console.log(resp.getReturnValue());
            	//alert(resp.getReturnValue());
            }
            else{
            	console.log(resp.getState());
            }
        });
        
        $A.enqueueAction(getSite);
        var getRt = cmp.get('c.getBioRecordTypes');
        getRt.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var valeur = JSON.parse(response.getReturnValue());
                console.log(valeur);
                console.log('RTName', RTname);

                cmp.set('v.arrRT', valeur);
                for (var i = 0; i < valeur.length; i++) {
                	console.log(valeur[i]);
                    if (RTname == valeur[i].RTName) {
                        cmp.set('v.RTId', valeur[i].RTId);
                        //console.log(helper.getFSfromRT(valeur[i].RTName));
                        // cmp.set('v.FS', helper.getFSfromRT(valeur[i].RTName));
                        break;
                    }
                }
                $A.createComponent('c:BioListByRT', {
                    'RTName': RTname,
                    "RTId": cmp.get("v.RTId"),
                    "ContactId": recordId,
                    "curObj" : curObject,
                    'FieldSet': FSName
                }, function(newBL, status, error) {
                	 if (cmp.isValid() && status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(newBL);
                        cmp.set("v.body", body);
                    }
                });


            }
        });
        $A.enqueueAction(getRt);
    },
    changeBody: function(cmp, event, helper) {
        var selected = cmp.find('SelectRT').get('v.value');
        console.log(selected);
        var label = cmp.find('SelectRT').get('v.label');
        var contact = cmp.get('v.recordId');
        $A.createComponent(
            "c:BioListByRT", {
                "RTName": label,
                "RTId": selected,
                "Biography__c": contact
            },
            function(newCMP, status, errorMessage) {
                if (cmp.isValid() && status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body = [];
                    body.push(newCMP);
                    cmp.set("v.body", body);
                }
            }
        );
    },
    handleRender: function(cmp, event, helper) {
        /*var rendering = cmp.get('v.rendering');
        if (!rendering) {
            cmp.set('v.rendering', true);*/
            console.log('hello from rendering');
            //this.doInit(cmp, event, helper);
        //}

    },
    handleSaveSuccess: function(cmp, event) {
        console.log('hello  from handlesaveSucceess');
        $A.get('e.force:refreshView').fire();
    },
})
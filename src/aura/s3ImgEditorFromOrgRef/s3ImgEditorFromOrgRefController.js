({
    doInit: function(cmp, event, helper) {
        var mapping = {
            'Profile': {
                'X': 'Profile_Image_Crop_X__c',
                'Y': 'Profile_Image_Crop_Y__c',
                'cWidth': 'Profile_Image_Crop_Width__c',
                'cHeight': 'Profile_Image_Crop_Height__c',
                'thumb': 'Profile_B64data__c',
                'url': 'Profile_Image_URL__c',
                'croppieJSON': 'strImgProfileCroppie__c'
            },
            'Portfolio': {
                'X': 'Portfolio_Image_Crop_X__c',
                'Y': 'Portfolio_Image_Crop_Y__c',
                'cWidth': 'Portfolio_Image_Crop_Width__c',
                'cHeight': 'Portfolio_Image_Crop_Height__c',
                'thumb': 'Portfolio_B64Data__c',
                'url': 'Portfolio_Image_URL__c',
                'croppieJSON': 'strImgPortfolioCroppie__c'
            }
        };
        cmp.set("v.isVisible", true);
        cmp.set('v.fieldMap', mapping);
        let recId = cmp.get('v.currentRec');
        console.log('hello there', recId);
        console.log('Main record ID', cmp.get('v.mainRecordId'));
        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        var imageFieldName = cmp.get('v.ImageFieldName');
        
        let getRec = cmp.get('c.getImageUrl');
        getRec.setParams({
            "recId": recId,
            "sObjectName": "Organisation_Reference__c"
        });
        getRec.setCallback(this, function(res) {
            let status = res.getState();
            console.log(status);
            if (status == 'SUCCESS') {
                var rec = JSON.parse(res.getReturnValue());
                console.log(rec);
                cmp.set('v.currentRecasJSON', res.getReturnValue());
                // cmp.set('v.currentRec', rec);
                if (rec[currentFieldSet['thumb']]) {
                    cmp.set('v.base64Buffer', JSON.parse(rec[currentFieldSet['thumb']]));
                }
                //if (rec.Buiding_Image_Url__c   ) {
                if (rec[currentFieldSet['url']]) {
                    cmp.set('v.URL', rec[currentFieldSet['url']]);
                    console.log(cmp.get('v.URL'));
                    var buffImage = cmp.find("bufferImg").getElement();
                    console.log(buffImage.height);
                    if (rec[currentFieldSet['croppieJSON']]) {
                        cmp.set('v.croppieParameters', rec[currentFieldSet['croppieJSON']]);
                    } else {
                        // helper.Toggle(cmp,event);
                    	console.log('removed by request');
                    }
                }
            }
        });
        $A.enqueueAction(getRec);
    },
    saveCroppieParms: function(cmp, event, helper) {
    	//helper.Toggle(cmp, ev);
        var mapping = cmp.get('v.fieldMap');

        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        var imageFieldName = cmp.get('v.ImageFieldName');

        let cropParams = cmp.get('v.croppieParameters');

        console.log('CropsPArams', cropParams);
        let recId = cmp.get('v.recordId');
        let updRecord = cmp.get('c.updateCroppieParams');
        updRecord.setParams({
            "recId": recId,
            "jsonData": JSON.stringify(cropParams),
            "b64Data": JSON.stringify(cmp.get("v.base64Buffer")),
            'jsonFldName': currentFieldSet['croppieJSON'],
            "b64FldName": currentFieldSet['thumb'],
            "SObjectName": cmp.get('v.sObjectName')
        });
        updRecord.setCallback(this, function(resp) {
            let status = resp.getState();
            console.log(status)
            if (status == "SUCCESS") {
                var editWindow = cmp.find('Result');
                $A.util.toggleClass(editWindow, "toggle");
                let toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Success Message',
                    message: 'Crop Parameters saved !'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(updRecord);
    },
    toggleModal: function(cmp, ev, helper) {
        console.log('helloe from toggle');
        //helper.Toggle(cmp, ev);
        helper.hidePopupHelper(cmp, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(cmp, 'backdrop', 'slds-backdrop--');
        cmp.destroy();
    },
    handleUploadFinished: function(cmp, ev, helper) {
        // alert('One File Uploaded !');
        var uploadedFiles = ev.getParam("files");
        console.log(uploadedFiles[0]);

        // var id=uploadedFiles[0].Id;
        var attachedField = cmp.get('v.ImageFieldName');
        var objectName = 'Organisation_reference__c';
        var action = cmp.get('c.addFieldTodocument');

        action.setParams({
            'recId': uploadedFiles[0].documentId,
            'Field': attachedField,
            'strObject': objectName
        });
        action.setCallback(this, function(resp) {
        	let status = resp.getState();
            console.log('Status from upload', status);
            if (status == 'SUCCESS') {
                helper.resetCroppieparms(cmp);
            } else {
                alert('Something happened!');
            }
        });
        $A.enqueueAction(action);
    }

})
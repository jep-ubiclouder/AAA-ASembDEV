({
    doInit: function(cmp, event, helper) {
        var mapping = {
            'Building': {
                'X': 'Building_Image_Crop_X__c',
                'Y': 'Building_Image_Crop_Y__c',
                'cWidth': 'Building_Image_Crop_Width__c',
                'cHeight': 'Building_Image_Crop_Height__c',
                'thumb': 'BuildingB64data__c',
                'url': 'Buiding_Image_Url__c',
                'croppieJSON': 'strImgBuildingCroppie__c'
            },
            'Logo': {
                'X': 'Logo_Image_Crop_X__c',
                'Y': 'Logo_Image_Crop_Y__c',
                'cWidth': 'Logo_Image_Crop_Width__c',
                'cHeight': 'Logo_Image_Crop_Height__c',
                'thumb': 'Logo_B64Data__c',
                'url': 'Logo_Image_URL__c',
                'croppieJSON': 'strImgLogoCroppie__c'
            }
        };
        cmp.set('v.fieldMap', mapping);
        let recId = cmp.get('v.recordId');
        console.log('hello there', recId);
        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        var imageFieldName = cmp.get('v.ImageFieldName');
        let getRec = cmp.get('c.getImageUrl');
        getRec.setParams({
            "recId": recId,
            "sObjectName": "Organisation__c"
        });
        getRec.setCallback(this, function(res) {
            let status = res.getState();
            console.log(status);
            if (status == 'SUCCESS') {
                var rec = JSON.parse(res.getReturnValue());
                console.log(rec);
                cmp.set('v.currentRecasJSON', res.getReturnValue());
                cmp.set('v.currentRec', rec);
               /* if (rec[currentFieldSet['thumb']]) {
                    cmp.set('v.base64Buffer', JSON.parse(rec[currentFieldSet['thumb']]));
                } */
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
                if (rec[currentFieldSet['thumb']]) {
                    cmp.set('v.base64Buffer', JSON.parse(rec[currentFieldSet['thumb']]));
                }
                else if(rec[currentFieldSet['url']]){
                helper.Toggle(cmp,event);
                }
            }
        });
        $A.enqueueAction(getRec);
    },
    saveCroppieParms: function(cmp, event, helper) {
        var mapping = cmp.get('v.fieldMap');

        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        var imageFieldName = cmp.get('v.ImageFieldName');
        console.log(currentFieldSet);
        let cropParams = cmp.get('v.croppieParameters');

        console.log('CropsPArams', cropParams);
        let recId = cmp.get('v.recordId');

        let startX = cropParams['points'][0];
        let startY = cropParams['points'][1];
        let widthThumb = cropParams['points'][2] -  cropParams['points'][0];
        console.log('widthThumb',widthThumb);
        let cropFields = [ currentFieldSet['X'], currentFieldSet['Y'], currentFieldSet['cWidth'],currentFieldSet['cHeight']];
        console.log('cropFields',cropFields);
        
        let updRecord = cmp.get('c.updateCroppieParams');
        updRecord.setParams({
            "recId": recId,
            "jsonData": JSON.stringify(cropParams),
            "b64Data": JSON.stringify(cmp.get("v.base64Buffer")),
            'jsonFldName': currentFieldSet['croppieJSON'],
            "b64FldName": currentFieldSet['thumb'],
            "SObjectName": cmp.get('v.sObjectName'),
            "startX":startX,
            "startY":startY,
            "widthThumb":widthThumb,
            "cropFields":cropFields
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
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": cmp.get('v.recordId')
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(updRecord);
    },
    toggleModal: function(cmp, ev, helper) {
        console.log('helloe from toggle');
        helper.Toggle(cmp, ev);
    },
    handleUploadFinished: function(cmp, ev, helper) {
        // alert('One File Uploaded !');
        var uploadedFiles = ev.getParam("files");
        console.log(uploadedFiles[0]);

        // var id=uploadedFiles[0].Id;
        var attachedField = cmp.get('v.ImageFieldName');
        var objectName = 'Organisation__c';
        var action = cmp.get('c.addFieldTodocument');
        console.log('attachedField',attachedField);
        action.setParams({
            'recId': uploadedFiles[0].documentId,
            'Field': attachedField,
            'strObject': objectName,
            'OriginRecordId' : cmp.get('v.recordId')
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
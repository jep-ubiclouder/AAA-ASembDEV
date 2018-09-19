({
    Croppie: function(cmp) {
        var mapping = cmp.get('v.fieldMap');

        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        var imageFieldName = cmp.get('v.ImageFieldName');

        // let cropParams = cmp.get('v.croppieParameters');
        var el = cmp.find("my-image").getElement();
        var orgRecord = JSON.parse(cmp.get('v.currentRecasJSON'));
        console.log('orgRecord', orgRecord);
        // var buffImage = new Image({src:cmp.get('v.URL')});
        console.log('Hello from helper croppie: image is', cmp.get('v.URL'));
        let cropH = orgRecord[mapping[imageFieldName]['cHeight']] ? orgRecord[mapping[imageFieldName]['cHeight']] : 1;
        let cropW = orgRecord[mapping[imageFieldName]['cWidth']] ? orgRecord[mapping[imageFieldName]['cWidth']] : 1;
        var MAXSIZE = 150;
        var c = new Croppie(el, {
            viewport: {
                width: MAXSIZE,
                height: MAXSIZE,
                type: 'square'
            },
            boundary: {
                width: 300,
                height: 300 * cropH / cropW
            },
            showZoomer: true,
            enableOrientation: true
        });
        if (cmp.get('v.croppieParameters')) {
            // if(false){
            var cropParams = JSON.parse(cmp.get('v.croppieParameters'));
            cropParams["url"] = cmp.get('v.URL');
            console.log('Crop params', cropParams);
            // if (cropParams) {
            var pts = [];
            for (var i = 0; i < cropParams['points'].length; i++) {
                pts.push(parseInt(cropParams['points'][i]));
            }
            c.bind({
                url: cmp.get('v.URL'),
                points: pts,
                zoom: cropParams['zoom'],
                orientation: cropParams['orientation']
            });
        } else {
            c.bind({
                url: cmp.get('v.URL'),
                zoom: 0.5
            });
        }
        el.addEventListener('update', function(ev) {
            console.log(ev.detail);
            c.result({
                type: 'base64',
                format: 'png'
            }).then(function(resp) {
                cmp.set('v.croppieParameters', ev.detail);
                console.log('hello from promise.then Taille', resp.length);
                cmp.set('v.base64Buffer', '<img src="' + resp + '" height="' + MAXSIZE + '" width="' + MAXSIZE + '" />');
            });
        });
    },
    resetCroppieparms: function(cmp) {
        console.log('hello from helper resetCroppiParms');
        var mapping = cmp.get('v.fieldMap');
        console.log(mapping.toString());
        var currentFieldSet = mapping[cmp.get('v.ImageFieldName')];
        console.log(currentFieldSet['croppieJSON']);
        var imageFieldName = cmp.get('v.ImageFieldName');
        console.log(currentFieldSet['thumb']);
        let cropParams = cmp.get('v.croppieParameters');
        console.log(cropParams.toString());
        let recId = cmp.get('v.currentRec');
        console.log(recId.toString());
        let updRecord = cmp.get('c.resetCroppieParams');
        //console.log();
        
        updRecord.setParams({
            "recId": recId,
            "jsonData": '',
            "b64Data": '',
            'jsonFldName': currentFieldSet['croppieJSON'],
            "b64FldName": currentFieldSet['thumb'],
            "SObjectName": 'Organisation_reference__c'
        });
        updRecord.setCallback(this, function(resp) {
            let status = resp.getState();
            console.log(status)
            if (status == "SUCCESS") {
                // this.Croppie()
                console.log('Reset croppie SUCCESSFUL');
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": cmp.get('v.currentRec')
                });
                if (confirm("One file uploaded\n press any button to refresh the view")) {
                    navEvt.fire();
                } else {
                    navEvt.fire();
                }
            }
        });
        $A.enqueueAction(updRecord);
    },
    Toggle: function(cmp, ev) {
        // from Croppie Documentation
        // Croppie is dependent on it's container being visible when the bind
        // method is called.
        // This can be an issue when your croppie component is inside a modal
        // that isn't shown. Let's take the bootstrap modal for example..
        // If you are having issues getting the correct crop result, and your
        // croppie instance is shown inside of a modal, try taking your croppie
        // out of the modal
        // and see if your issues persist. If they don't, then make sure that
        // your bind method is called after the modal is done animating.
        // Donc nous ne devons initialiser l'outil uniquement quand on affiche
        // la fenetre et non pas dans l'initialisation (c.doInit) !!

        var isVisible = cmp.get("v.isOpen");
        var editWindow = cmp.find('Result');
        $A.util.toggleClass(editWindow, "toggle");

        if (!isVisible) {
            var rec = cmp.get("v.currentRec");
            cmp.set("v.isOpen", true);
            this.Croppie(cmp);
        }
    },
    hidePopupHelper: function(component, componentId, className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal, className + 'hide');
        $A.util.removeClass(modal, className + 'open');
    },
    showPopupHelper: function(component, componentId, className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    }
})
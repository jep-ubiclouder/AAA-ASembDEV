({
    doInit: function(cmp, event, helper) {
        var getCategories = cmp.get('c.getRoots');
        console.log('hello from doInit');
        getCategories.setCallback(this, function(response) {
            var liste = JSON.parse(response.getReturnValue());
            console.log(liste);
            var arbre = {
                '0': {
                    Id: '0',
                    c: [],
                    root: true,
                    col: "",
                    opts: [],
                    selection: 0
                }
            }
            for (var i = 0; i < liste.length; i++) {
                var parent = liste[i].Clef_Parent__c;
                var id = liste[i].Clef_Statec__c;
                var sfId = liste[i].Id;
                if (parent && !arbre[parent]) { // si le parent n'existe pas...	
                    arbre[parent] = { // je créee le noeud
                        Id: parent,
                        c: [],
                        opts: [],
                        selection: 0,
                        sfId: sfId
                    }
                }
                if (!arbre[id]) { // si le noeud du record n'existe pas
                    arbre[id] = {
                        Name: liste[i].Name,
                        Id: id,
                        c: [],
                        Parent: parent,
                        leaf: true,
                        root: false,
                        selection: 0,
                        sfId: sfId,
                        opts: []
                    }
                } else { // le noued existe parce qu'il est un parent
                    arbre[id].Name = liste[i].Name; // je remplis le nom
                    arbre[id].root = false;
                    arbre[id].Parent = parent;
                }
                if (parent && id != parent) {
                    arbre[parent].c.push(arbre[id]);
                }
            }
            console.log(arbre);
            var listeActivites = cmp.get('v.listeActivites');
            listeActivites.push(liste["0"]);

            $A.createComponent('c:CategoryPicker', {
                    'arbre': arbre,
                    'listeGlobale': liste,
                    "root": "0",
                    "listeActivites": listeActivites,
                    "depth": 1
                },
                function(newWidget, status, error) {
                    if (cmp.isValid() && status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(newWidget);
                        cmp.set("v.body", body);
                    }
                }
            );

        });
        $A.enqueueAction(getCategories);
    },
    handleEvent: function(cmp, event) {
        var message = event.getParam('payload');
        console.log(message);
        cmp.set('v.listeActivites', message);
    },
    handleClick: function(cmp, event) {
        var selectedButtonLabel = event.getSource().get("v.label");
        if (selectedButtonLabel == 'Save') {
            var recordId = cmp.get('v.recordId');

            console.log(recordId);
            var listeActivites = cmp.get("v.listeActivites");
            var buffer = [];
            var objectName = cmp.get('v.sObjectName');
            if (objectName === 'Account') {
                var relation = 'Account__c';
            } else {
                var relation = 'Organisation__c';
            }
            for (var i = 1; i < listeActivites.length; i++) {
                var rec = {
                    'Business_Category__c': listeActivites[i].sfId
                };
                rec[relation] = recordId;
                buffer.push(rec);
            }
            console.log(JSON.stringify(buffer));


            console.log('objectName', objectName);
            if (objectName === 'Account') {
                var commitSA = cmp.get('c.commitSA');
            } else {
                var commitSA = cmp.get('c.commitSAOrg');
            }

            commitSA.setParams({
                "laListeenJSON": JSON.stringify(buffer),
                "AccId": recordId
            });
            commitSA.setCallback(this, function(response) {
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The records has been updated successfully."
                });
                toastEvent.fire();
                var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": recordId
                })
                sObjectEvent.fire();
                var refresh = $A.get("e.force:refreshView").fire();
            });
            $A.enqueueAction(commitSA);
            console.log(buffer);
        } else {
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Action Canceled!",
                "message": "No Modifications were made to records"
            });
            toastEvent.fire();
        }
    }
})
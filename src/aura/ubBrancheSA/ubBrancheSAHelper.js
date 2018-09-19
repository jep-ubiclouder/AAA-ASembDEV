({
    createLightningBC: function(cmp, tableauDeRecords) {


        // console.log(tableauDeRecords);
        for (let l in tableauDeRecords) {
            // console.log(l);
            let body = cmp.get('v.body');
            for (let noeud in tableauDeRecords[l]) {
            // console.log(noeud);
            // console.log(tableauDeRecords[l][noeud]);
                $A.createComponent(
                    "lightning:breadcrumb", {
                        'label': tableauDeRecords[l][noeud].Business_Category__r.Libelle__c,
                        'name': tableauDeRecords[l][noeud].Id
                    },
                    function(newDZ, status, errorMessage) {
                        if (cmp.isValid() && status === "SUCCESS") {
                            body.push(newDZ);
                            cmp.set("v.body", body);
                        } else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                        } else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                        }
                    }
                );
            }
        }
    }
})
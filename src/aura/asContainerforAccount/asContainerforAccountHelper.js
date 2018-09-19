({
    processAllSAs: function(cmp, response) {
        var status = response.getState();
        console.log(status);
        if (cmp.isValid() && status === "SUCCESS") {
            var arrSAs = JSON.parse(response.getReturnValue());
            console.log(arrSAs);
            var allNodes = [];
            var byNode = {};
            for (var r in arrSAs) {
                var node = arrSAs[r].Noeud__c;
                if(node){
                	allNodes.push(node);
                	byNode[node] = arrSAs[r];
                }
            }
            var accepted = [];
            var rejected = [];
            for (var i = 0; i < allNodes.length; i++) {
                var node = allNodes[i];
                console.log('NODE',node);
                var parent = node.substr(0, node.length - 1);
                if (rejected.indexOf(node) == -1) {
                    accepted.push(node);
                    if (rejected.indexOf(parent) == -1) {
                        rejected.push(parent)
                    }
                } else {
                    if (rejected.indexOf(parent) == -1) {
                        rejected.push(parent)
                    }
                }
            }
            var listeToSend = []
            for (var j = 0; j < accepted.length; j++) {
                var noeud = accepted[j];
                // console.log(noeud);
                var buff = []
                while (noeud.length >= 2) {
                    // console.log(noeud);
                    if (byNode[noeud] != null) {
                        buff.push({
                            noeud: byNode[noeud]
                        });
                    }
                    noeud = noeud.substr(0, noeud.length - 1);
                }
                listeToSend.push(buff.sort());
            }
            
            for (var rec = 0; rec < listeToSend.length; rec++) {
                // console.log(listeToSend[rec]);
                var body = cmp.get('v.body');
                var recordToDel =listeToSend[rec][0]['noeud'].Id;
                var objectName = cmp.get('v.sObjectName');
                $A.createComponent(
                    'c:ubBrancheSA', {
                        'listLignes': listeToSend[rec].reverse(),
                        'myId' : recordToDel,
                        'Accid' : cmp.get('v.recordId'),
                        'sObjectName':objectName
                        
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

        } else if (status === "INCOMPLETE") {
            console.log("No response from server or client is offline.")
        } else if (status === "ERROR") {
            console.log("Error: " + errorMessage);
        }
    }
})
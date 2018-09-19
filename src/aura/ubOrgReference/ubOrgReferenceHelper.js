({
    sortData: function(cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.mydata", data);
    },
    sortBy: function(field, reverse, primer) {
        var key = primer ?
            function(x) {
                return primer(x[field])
            } :
            function(x) {
                return x[field]
            };
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    Init: function(cmp) {
        var Key = cmp.get('v.ContactId');
        var curObj = cmp.get('v.curObj');
        var FS = cmp.get('v.FieldSet');
        var getEntetesFromFS = cmp.get('c.getOrgFieldsFromFieldSet');
        getEntetesFromFS.setParams({
            'FSName': FS
        });
        getEntetesFromFS.setCallback(this, function(resp) {
            var state = resp.getState();
            console.log(state);
            if (state == 'SUCCESS') {

                let mapTypes = {
                    'double': 'number',
                    'id': 'url',
                    'string': 'text',
                    'boolean': 'boolean',
                    'button': 'button'
                };
                var valeur = JSON.parse(resp.getReturnValue());
                var fldsFromFS = [];
                var fldsToQuery = [];

                for (let i = 0; i < valeur.length; i++) {
                    // console.log(valeur[i]);
                    var edition = false;
                    if (valeur[i].fieldPath == 'List_Position__c') {
                        edition = true;
                        // console.log('valeur[i].fieldPath = lpositio')
                    }
                    var fpToquery = '';
                    if (valeur[i].type == 'reference') {
                        fldsFromFS.push({
                            label: valeur[i].label,
                            fieldName: valeur[i].fieldPath,
                            type: 'button',
                            typeAttributes: {label:'View', name:'view_details',variant:'base'},
                            sortable: false,
                            editable: edition
                        });
                        fpToquery = valeur[i].fieldPath;
                    } else if (valeur[i].type == 'picklist') {
                        fldsFromFS.push({
                            label: valeur[i].label,
                            fieldName: valeur[i].fieldPath,
                            type: mapTypes[valeur[i].type],
                            sortable: false,
                            editable: edition
                        });
                        fpToquery = 'tolabel(' + valeur[i].fieldPath + ')';
                    } else {
                        fldsFromFS.push({
                            label: valeur[i].label,
                            fieldName: valeur[i].fieldPath,
                            type: mapTypes[valeur[i].type],
                            sortable: false,
                            editable: edition
                        });
                        fpToquery = valeur[i].fieldPath;
                    }
                    fldsToQuery.push(fpToquery ? fpToquery : valeur[i].fieldPath);
                }

                let actions = [{
                        label: 'Edit',
                        name: 'show_details'
                    },
                    {
                        label: 'Edit/Upload Image',
                        name: 'importImage'
                    },
                    {
                        label: 'Delete',
                        name: 'delete'
                    }
                ];
                fldsFromFS.push({
                    type: 'action',
                    typeAttributes: {
                        rowActions: actions
                    }
                });
                // console.log(fldsFromFS);
                cmp.set('v.dataTableColumns', fldsFromFS);
                var RTId = cmp.get('v.RTName');
                var getData = cmp.get("c.queryOrgFromFieldset");
                getData.setParams({
                    listeChamps: fldsToQuery,
                    ContactId: Key,
                    RTId: RTId,
                    curObj: curObj
                });
                getData.setCallback(this, function(rGetData) {
                    var status = rGetData.getState();
                    // console.log(status);
                    if (status == 'SUCCESS') {
                        var data = JSON.parse(rGetData.getReturnValue());
                        console.log(data);
                        console.log(fldsFromFS);
                        let toBeDisplayed = [];

                        for (let i = 0; i < data.length; i++) {
                            let record = data[i];
                            let keyNames = Object.keys(record);
                            let transforme = {};
                            for (var kn in keyNames) {
                                let bFound = false;
                                console.log(keyNames[kn]);
                                for (let j = 0; j < fldsFromFS.length; j++) {
                                    if (fldsFromFS[j].fieldName == keyNames[kn] && fldsFromFS[j].type == 'url') {
                                        transforme[keyNames[kn]] =  '/' + record[keyNames[kn]];
                                        bFound = true;
                                    }
                                }
                                if (!bFound) {
                                    transforme[keyNames[kn]] = record[keyNames[kn]];
                                }
                            }
                            toBeDisplayed.push(transforme);
                            console.log(transforme);
                        }
                        cmp.set('v.mydata', toBeDisplayed);
                    }
                });
                $A.enqueueAction(getData);
            }
        });
        $A.enqueueAction(getEntetesFromFS);
    },
    jumpTo : function(row){
    	let goal = row.Biography__c;
    	console.log(row.Biography__c);
    	var navEvt = $A.get("e.force:navigateToSObject");
    	navEvt.setParams({
    		"recordId":goal
    	});
    	navEvt.fire();
    }
})
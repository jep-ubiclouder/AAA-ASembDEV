({
    sortData: function(cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse));
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
        console.log('-----', Key);
        var curObj = cmp.get('v.curObj');
        console.log('-----', curObj);
        var FS = cmp.get('v.FieldSet');
        console.log(FS);
        var getEntetesFromFS = cmp.get('c.getBioFieldsFromFieldSet');
        getEntetesFromFS.setParams({
            'FSName': FS
        });
        console.log(FS);
        getEntetesFromFS.setCallback(this, function(resp) {
            var state = resp.getState();
            console.log(state);
            if (state == 'SUCCESS') {
                var valeur = JSON.parse(resp.getReturnValue());
                console.log(valeur);
                var fldsFromFS = [];
                var fldsToQuery = [];
                let mapTypes = {
                    'string': 'text',
                    'double': 'number',
                    'date': 'date',
                    'boolean': 'boolean',
                    'button': 'button'

                }
                for (let i = 0; i < valeur.length; i++) {
                    let edition = false;
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
                            typeAttributes: {
                                label: 'View',
                                name: 'view_details',
                                variant: 'base'
                            },
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
                var actions = [{
                    label: 'Edit',
                    name: 'show_details'
                }, {
                    label: 'Delete',
                    name: 'delete'
                }];

                fldsFromFS.push({
                    type: 'action',
                    typeAttributes: {
                        rowActions: actions
                    }
                });

                cmp.set('v.dataTableColumns', fldsFromFS);
                var RTId = cmp.get('v.RTName');
                console.log('RTypeId', RTId);

                var getData = cmp.get('c.queryBioFromFieldset');
                getData.setParams({
                    listeChamps: fldsToQuery,
                    ContactId: Key,
                    RTId: RTId,
                    curObj: cmp.get('v.curObj')
                });
                getData.setCallback(this, function(rGetData) {
                    var status = rGetData.getState();
                    console.log(status);
                    if (status == 'SUCCESS') {
                        //                        var data = JSON.parse(rGetData.getReturnValue());
                        //                        console.log(data)
                        //                        cmp.set('v.mydata', data);
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
                                        transforme[keyNames[kn]] = '/' + record[keyNames[kn]];
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
    jumpTo: function(row) {
        let goal = row.Organisation_or_Institution__c;
        console.log(goal);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": goal
        });
        navEvt.fire();
    }
})
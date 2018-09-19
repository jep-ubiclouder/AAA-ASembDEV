({
    doInit: function(cmp, event, helper) {
        var picklist = cmp.get('v.arbre');
        var racine = cmp.get('v.root');
        var sousarbre = picklist[racine].c;
        cmp.set('v.sousarbre', picklist[racine].c);
        var listeActivites = cmp.get('v.listeActivites');
        console.log('current liste Activité', listeActivites);
        var listG = cmp.get('v.listeGlobale');
        var opts = [];
        opts.push({
            class: "optionClass",
            label: '---',
            value: 'None'
        })
        for (var i = 0; i < sousarbre.length; i++) {
            opts.push({
                class: "optionClass",
                label: sousarbre[i].Name,
                value: sousarbre[i].Id
            })
        }
        cmp.find("searchBox").set("v.options", opts);
    },
    changeAct: function(cmp, event, helper) {
        var current = cmp.find("searchBox").get("v.value");
        if (current == 'None') {
            cmp.set('v.curPath', 'Root');
            return;
        }
        var arbre = cmp.get('v.arbre');
        var resultat = [];
        var tmp;
        var truc = 0;
        while (true) {
            resultat.push(arbre[current].Name);
            tmp = arbre[current].Parent;
            current = tmp;
            truc++;
            if (truc > 5 || current == '0') {
                break;
            }
        }
        resultat.reverse();
        current = cmp.find("searchBox").get("v.value");
        cmp.set('v.curPath', resultat);
    },

    chooseCat: function(cmp, event, helper) {
        var racine = cmp.find("searchBox").get("v.value");
        var arbre = cmp.get('v.arbre');
        var liste = cmp.get('v.listeGlobale');
        var listeActivites = cmp.get('v.listeActivites');
        var prof = cmp.get('v.depth');
        console.log(prof);
        if (racine != 'None') {
            listeActivites.splice(prof + 1, listeActivites.length);
            listeActivites[prof] = {
                'sfId': arbre[racine].sfId,
                'Name': arbre[racine].Name,
                'Id': arbre[racine].Id
            };
        } else {
            listeActivites.splice(prof + 1, listeActivites.length);
        }
        // console.log('curent tree',listeActivites);
        var cmpEvt = cmp.getEvent('cmpDispatch');
        cmpEvt.setParams({
            "payload": listeActivites
        });
        cmpEvt.fire();
        if (racine != 'None') {
            cmp.set('v.sousarbre', arbre[racine].c)
            if (arbre[racine].c.length > 0) {
                $A.createComponent('c:CategoryPicker', {
                        'arbre': arbre,
                        'listeGlobale': liste,
                        "root": racine,
                        "listeActivites": listeActivites,
                        "depth": prof + 1
                    },
                    function(newWidget, status, error) {
                        if (cmp.isValid() && status === "SUCCESS") {
                            var body = cmp.get("v.body");
                            body = [];
                            body.push(newWidget);
                            cmp.set("v.body", body);
                        }
                    }
                )
            };
        }
    }
})
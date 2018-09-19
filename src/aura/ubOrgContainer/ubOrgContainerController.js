({
 doInit: function(cmp, event, helper) {
  var recordId = cmp.get('v.recordId');
  console.log(recordId);
  
  var curObject = cmp.get('v.sObjectName');
  var RTname = cmp.get('v.RT');
  var getRt = cmp.get('c.getOrgRecordTypes');
  var FieldSet = cmp.get('v.FS');
  getRt.setCallback(this, function(response) {
   var state = response.getState();
   if (state == 'SUCCESS') {
    var valeur = JSON.parse(response.getReturnValue());
    cmp.set('v.arrRT', valeur);
    for (var i = 0; i < valeur.length; i++) {
     if (RTname == valeur[i].RTName) {
      cmp.set('v.RTId', valeur[i].RTId);
      // console.log(helper.getFSfromRT(valeur[i].RTName));
      break;
     }
    }
    $A.createComponent('c:ubOrgReference', {
     'RTName': RTname,
     "RTId": cmp.get('v.RTId'),
     "ContactId": recordId,
     "curObj": curObject,
     "mainRecordId": cmp.get('v.recordId'),
     'FieldSet': FieldSet
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
  // console.log(selected);
  var label = cmp.find('SelectRT').get('v.label');
  var contact = cmp.get('v.recordId');
  $A.createComponent(
   "c:ubOrgReference", {
    "RTName": label,
    "RTId": selected,
    "mainRecordId": cmp.get('v.recordId'),
    "ContactId": Key
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
 handleSaveSuccess: function(cmp, event) {
  // console.log('hello  from handlesaveSucceess');
  $A.get('e.force:refreshView').fire();
 },
})
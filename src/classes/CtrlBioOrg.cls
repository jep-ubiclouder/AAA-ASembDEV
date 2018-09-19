public with sharing class CtrlBioOrg {
 public class wrapRT {
  public String RTName {
   get;
   set;
  }
  public String RTId {
   get;
   set;
  }
  public wrapRt(String RTId, String RTName) {
   this.RTName = RTName;
   this.RTId = RTId;
  }
 }
 @AuraEnabled
 public static string getBioFieldsFromFieldSet(String FSName) {
  Schema.FieldSet fs1 = Schema.SObjectType.Biography_Reference__c.fieldSets.getMap().get(FSName);
  system.debug(FS1);
  return JSON.Serialize(fs1.getFields());
 	   
 }


@auraEnabled
public static String getSiteData(){
	PageReference pageRef = ApexPages.currentPage();
	
	String baseUrl = pageRef.getUrl();
	system.debug(baseUrl);
	// String path = Site.getPathPrefix();
	// system.debug(path);
	return baseUrl;	
}

@auraEnabled
public static String deleteOrgRef(String idToDelete){
	Organisation_reference__c tobedel = [select id from Organisation_reference__c where id = : idtodelete limit 1];
	if (tobedel != null){
		delete tobedel;
		return 'OK';
	}
	return 'ID Vide';
}
@auraEnabled
public static String deleteBioRef(String idToDelete){
	Biography_reference__c tobedel = [select id from Biography_reference__c where id = : idtodelete limit 1];
	if (tobedel != null){
		delete tobedel;
		return 'OK';
	}
	return 'ID Vide';
}


 @AuraEnabled
 public static string getOrgFieldsFromFieldSet(String FSName) {
  Schema.FieldSet fs1 = Schema.SObjectType.Organisation_Reference__c.fieldSets.getMap().get(FSName);
  //system.debug(FS1);
  return JSON.Serialize(fs1.getFields());
 }
 @AuraEnabled
 public static String queryBioFromFieldset(List < String > listeChamps, String ContactId, String RTId, String curObj) {

  string cId = contactId;
  //system.debug('---- CID ----' + cId);
  /*if(!listeChamps.contains('Id')){
  	listeChamps.add('Id');
  } 
  */
  
  String Query = 'SELECT ';
  For(String c: listeChamps) {
   Query += c + ',';
  }
  string rtytpeId;
  for (RecordTypeInfo info: Biography_Reference__c.SObjectType.getDescribe().getRecordTypeInfos()) {
   if (info.isAvailable()) {
    if (info.getName() == RTId) {
     rtytpeId = info.getRecordTypeId();
     break;
    }
   }
  }
    if (listeChamps.contains('Id')){
    	Query += ' OwnerId FROM Biography_Reference__c where references__c = \'' + cId + '\'';
    }else{
  Query += ' Id FROM Biography_Reference__c where references__c = \'' + cId + '\'';
    }
  if(! Test.isRunningTest()){
  Query += ' AND recordTypeId = \'' + rtytpeId + '\'';
  }
  Query += ' order by List_Position__c'; 

  system.debug(Query);
  return JSON.Serialize(Database.query(query));
 }
 @AuraEnabled
 public static String queryOrgFromFieldset(List < String > listeChamps, String ContactId, String RTId, String curObj) {
  string cId = '';
  cId = contactId;
  String Query = 'SELECT ';
  For(String c: listeChamps) {
   Query += c + ',';
  }
  string rtytpeId;
  for (RecordTypeInfo info: Organisation_Reference__c.SObjectType.getDescribe().getRecordTypeInfos()) {
   if (info.isAvailable()) {
    if (info.getName() == RTId) {
     rtytpeId = info.getRecordTypeId();
     break;
    }
   }
  }
  if (listeChamps.contains('Id')){
  	Query += ' OwnerId FROM Organisation_Reference__c where references__c = \'' + ContactId + '\'';
  }
  else{
  Query += ' Id FROM Organisation_Reference__c where references__c = \'' + ContactId + '\'';
  }
  if(!Test.isRunningTest()){
  Query += ' AND recordTypeId = \'' + rtytpeId + '\'';
  }
  Query += ' order by List_Position__c';
  system.debug(Query);
  
  return JSON.Serialize(Database.query(query));
 }
 /* @auraEnabled
 public static String getContactIdFromBiography(Id cId) {
  Biography__c buff = [select id, contact__r.id from Biography__c where id = : cId limit 1];
  return buff.contact__r.id;
 } */

 @AuraEnabled
 public static string getBioRecordTypes() {
  List < wrapRT > recordTypes = new List < wrapRT > ();
  for (RecordTypeInfo info: Biography_Reference__c.SObjectType.getDescribe().getRecordTypeInfos()) {
   if (info.isAvailable()) {
    recordTypes.add(new wrapRT(info.getRecordTypeId(), info.getName()));
   }
  }
  return JSON.serialize(recordTypes);
 }
 @AuraEnabled
 public static string getOrgRecordTypes() {
  List < wrapRT > recordTypes = new List < wrapRT > ();
  for (RecordTypeInfo info: Organisation_Reference__c.SObjectType.getDescribe().getRecordTypeInfos()) {
   if (info.isAvailable()) {
    recordTypes.add(new wrapRT(info.getRecordTypeId(), info.getName()));
   }
  }
  return JSON.serialize(recordTypes);
 }
 
     @AuraEnabled
    public static boolean updateBioref(List<Biography_reference__c> editedAccountList){
    	system.debug(editedAccountList);
        try{
            update editedAccountList;
            return true;
        } catch(Exception e){
            return false;
        }
    }
         @AuraEnabled
    public static boolean updateOrgref(List<Organisation_reference__c> editedAccountList){
    	system.debug(editedAccountList);
        try{
            update editedAccountList;
            return true;
        } catch(Exception e){
            return false;
        }
    }
}
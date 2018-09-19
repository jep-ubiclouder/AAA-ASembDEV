@isTest(SeeAllData=true)

private class elemBioCTRLTst {   
    @istest 
    static void elemBioCTRLTst () {
        Test.starttest();
        // ctrlElemBio mainCTL  =  new ctrlElemBio()
        
        CtrlBioOrg.getBioRecordTypes();
        CtrlBioOrg.getOrgRecordTypes();
        string orgFSName = 'FS_Employee';
        string bioFSName = 'FS_Honorary_Title';
        string orgRTid =Schema.SObjectType.Organisation_reference__c.getRecordTypeInfosByName().get('Award References').getRecordTypeId();
        string bioRTid =Schema.SObjectType.biography_reference__c.getRecordTypeInfosByName().get('Honorary Title References').getRecordTypeId();
        Organisation__c org = new organisation__c(Name__c='TEST VALUE');
        Biography__c bio = new biography__c();
        
        insert org;
        insert bio;
        
        Organisation_reference__c orgRef = new Organisation_reference__c(references__c =  org.Id,Guide_Drupal_ID__c='123456789',recordtypeId=orgRTid );
        Biography_reference__c bioRef = new biography_reference__c(references__c = bio.Id,Guide_Drupal_ID__c='987654321',recordtypeId=bioRTid); 
        insert orgRef;
        insert bioref;
        string bioId = bioRef.id;
        string orgId = orgRef.id;

        List<String> liste = new List<String>();
        liste.add('Name');
        CtrlBioOrg.getBioFieldsFromFieldSet(bioFSName);
        CtrlBioOrg.getOrgFieldsFromFieldSet(orgFSName);
        CtrlBioOrg.queryBioFromFieldset(liste, bioId, 'Award References', 'placeholder');
        CtrlBioOrg.queryOrgFromFieldset(liste, orgId, 'Honorary Title References', 'placeholder');
        CtrlBioOrg.deleteBioRef(bioId);
        CtrlBioOrg.deleteOrgRef(OrgId);
        }
        }
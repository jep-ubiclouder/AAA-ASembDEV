@isTest
private class triggerTest {
static testMethod void myUnitTest() {
        Test.startTest();
        Organisation__c myOrg =  new Organisation__c (Name__c= 'myorg');
        insert myOrg;
        myOrg.Name__c ='new name';
        update myOrg;
        
        Organisation_reference__c myOrgref = new organisation_reference__c (references__c = myOrg.id, Title__c='my Orgref', List_Position__c = 1);
        Organisation_reference__c myOrgref2 = new organisation_reference__c (references__c = myOrg.id, Title__c='my Orgref', List_Position__c = 0);
        insert myOrgref ;
        insert myOrgref2;
        
        myOrgref.Title__c= 'new name';
        update myOrgref ;
        myOrgref2.List_Position__c = 2;
        update myOrgref2;
        
        biography__c myBio =  new biography__c  (Guide_Drupal_ID__c= 'myorg');
        insert myBio;
        myBio.Guide_Drupal_ID__c='new name';
        update myBio ;
        
        Biography_reference__c myBioref = new Biography_reference__c (references__c = myBio.id, title__c='myref', List_Position__c = 1);
        Biography_reference__c myBioref2 = new Biography_reference__c (references__c = myBio.id, title__c='myref', List_Position__c = 2);
        insert myBioref ;
        myBioref.title__c = 'new name';
        update myBioref ;
        insert myBioref2;
        mybioref2.List_Position__c = 0;
        update myBioref2;
        
        
        delete myBioref2;
        delete myOrgref ;
        delete myBioref ;
        
        delete myBio ;
        delete myOrg;
        }
}
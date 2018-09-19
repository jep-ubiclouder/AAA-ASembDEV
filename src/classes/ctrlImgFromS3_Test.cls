/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ctrlImgFromS3_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        Organisation__c myOrg =  new Organisation__c (Name__c= 'myorg');
        insert myOrg;
        biography__c myBio =  new biography__c  (Guide_Drupal_ID__c= 'myorg');
        insert myBio;
        
        ctrlImgFromS3.getImageUrl(myOrg.Id,'Organisation__c');
        ctrlImgFromS3.getImageUrl(myBio.Id,'biography__c');
        
        
        ContentVersion cv = new ContentVersion(Title='Titre');
        cv.PathOnClient ='test';
		Blob b=Blob.valueOf('Unit Test Attachment Body');
		cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        system.debug(cv);
        ctrlImgFromS3.addFieldTodocument(cv.Id, 'A','Organisation__c');
        // (Id recId, String jsonData, string b64Data, string jsonFldName, string b64FldName, string SObjectName)
        ctrlImgFromS3.updateCroppieParams(myOrg.id,'JSON','AAAA','strImgBuildingCroppie__c','BuildingB64data__c','Organisation__c');
        ctrlImgFromS3.updateCroppieParams(myBio.id,'JSON','AAAA','strImgProfileCroppie__c','Profile_B64data__c','Biography__c');
    }
}
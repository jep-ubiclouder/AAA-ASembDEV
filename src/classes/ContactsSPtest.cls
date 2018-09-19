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
@isTest(SeeAllData=true)
private class ContactsSPtest {

    static testMethod void myUnitTest() {
      test.startTest();
      Id RecordTypeIdSalesCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales campaign').getRecordTypeId();
      system.debug(RecordTypeIdSalesCampaign);
      Campaign myCp =  new Campaign(Name='MaCampagne',recordtypeId = RecordTypeIdSalesCampaign);
      insert myCp;
      
      Sales_Plan__c mySP =  new Sales_Plan__c(Name='mySalesPlan',campaign__c=myCp.Id);
      insert mySP;
      
      contact cont = new contact(Lastname='preis',firstname='jean');
      insert cont;
      
      // string BlobCreator = cont.id+'\r\n';
      
      // Blob csv = blob.valueof(BlobCreator);
      
      PageReference oPage = new PageReference('apex/ubSPUpdateContacts?id='+mySP.Id);
      Test.setCurrentPage(oPage);
      ApexPages.StandardController sc = new ApexPages.StandardController(mySP);
      Ctrl_ContactsSP c = new Ctrl_ContactsSP(sc ); 
      c.ReadFile();
      c.Abandon();
      c.Maj();
      
    }
}
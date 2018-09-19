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
private class CCMFCTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        Id RecordTypeIdSalesCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales campaign').getRecordTypeId();
        system.debug(RecordTypeIdSalesCampaign);
        Campaign myCp =  new Campaign(Name='MaCampagne', recordTypeid = RecordTypeIdSalesCampaign);
        insert myCp;
        
        Sales_Plan__c mySP =  new Sales_Plan__c(Name='mySalesPlan',campaign__c=myCp.Id);
        insert mySP;
        
        Account acc = new Account(Name='Test',Cle_Client_STOCKX__c='99999',Representant_Principal_STX__c='DE',Secteurs_dactivite_GUIDE__c='2-Artisanat',Taux_de_Commission__c=0.2);
        insert acc;
        
        Contact con = new Contact(LastName='Test contact',account=acc,Email='test@example.com',Fonction_Texte__c='Testeur',Magazines_Abonnement__c='CP',Date_de_demande_d_abonnement__c=Date.Today(),Acheteur_Club__c=true,FirstName='jean');
        insert con;
        
        SP_Contact__c  mycontact =  new SP_Contact__c(Sales_Plan__c=mySp.id,contact__c=con.id);
        insert mycontact;
        
        SP_Choix_de_l_Activit__c mySPA  = new SP_Choix_de_l_Activit__c(Sales_Plan__c = mySP.id , Activit__c = '2-Artisanat' );
        insert mySPA;
        
      PageReference PageMAJSA = new PageReference('apex/Ctrl_CSASP?id='+mySP.Id);
      List<Sales_Plan__c> sscParms = new List<Sales_Plan__c>();
      sscParms.add(mySP);
      Test.setCurrentPage(PageMAJSA);
      ApexPages.StandardSetController scPageMAJSA = new ApexPages.StandardSetController(sscParms);
      Ctrl_CSASP ctrlMAJduPopup = new Ctrl_CSASP(scPageMAJSA ); 
      ctrlMAJduPopup.MAJ() ;
      ctrlMAJduPopup.Abandon() ;
        
      ctrlMAJduPopup.getItems();
        
        
        PageReference oPage = new PageReference('/'+mySP.Id);
        system.debug(opage);
        Test.setCurrentPage(oPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(mySP);
        CreateCampaignMembersFromChoices t = new CreateCampaignMembersFromChoices(sc);
        
        
        t.DoIt();
        t.Abandon();
        t.MAJ();
        t.updateIt();
        t.resetIt();
        t.Cloneit();
        
        

    }
}
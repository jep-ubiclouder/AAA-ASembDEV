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
@isTest(SeeAllData=True)
public class ctrlAuraTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
        Business_Category__c BC= new Business_Category__c(Name='yesy', Clef_Parent__c='A',Clef_Statec__c='A', Node__c = 'EA');
        Business_Category__c BC2= new Business_Category__c(Name='noy', Clef_Parent__c='C',Clef_Statec__c='B', Node__c = 'EB');
        Business_Category__c BC3= new Business_Category__c(Name='noyes', Clef_Parent__c='C',Clef_Statec__c='C', Node__c = 'E');
        insert BC;
        insert BC2;
        insert BC3;
        
        Account Acc =  new Account(Name= 'Test', Cle_Client_STOCKX__c='STX9998');
        insert Acc;
        Secteur_Activite__c SA = new Secteur_Activite__c(Business_Category__c = BC.Id, Account__c=Acc.Id);
        insert SA;
        
        
        Organisation__c Org = new organisation__c (Guide_Drupal_ID__c='TESTOUNETTES',Name__c='TESTOUNETTES');
        insert Org;
        Secteur_Activite__c SA2 = new Secteur_Activite__c(Business_Category__c = BC2.Id, Account__c=Acc.Id);
        Secteur_Activite__c SA3 = new Secteur_Activite__c(Business_Category__c = BC2.Id, Account__c=Acc.Id);
        List<Secteur_Activite__c> tabSA = new List<Secteur_Activite__c>();
        tabSA.add(SA2);
        tabSA.add(SA3);  
        String laListeenJSON = json.serialize(tabSA);
        system.debug(laListeenJSON);
        
        
        
        
        String Hello = ctrlAura.getRoots();
        
        String glSA = ctrlAura.gLSA(Acc.id); 
        
        String comm = ctrlAura.commitSA(laListeenJSON, Acc.Id);
        
        String delB =ctrlAura.deleteBranche(SA.id, Acc.Id);
        Secteur_Activite__c SA9 = new Secteur_Activite__c(Business_Category__c = BC.Id, Organisation__c=Org.Id);
        insert SA9;
        Secteur_Activite__c SA10 = new Secteur_Activite__c(Business_Category__c = BC2.Id, Organisation__c=Org.Id);
        Secteur_Activite__c SA11 = new Secteur_Activite__c(Business_Category__c = BC3.Id, Organisation__c=org.Id);
        // List<Secteur_Activite__c> tabSA = new List<Secteur_Activite__c>();
        tabSA = new List<Secteur_Activite__c>();
        tabSA.add(SA10);
        tabSA.add(SA11);  
        laListeenJSON = json.serialize(tabSA);
        
        comm = ctrlAura.commitSAOrg(laListeenJSON, Org.Id);
        
        delB =ctrlAura.deleteBrancheOrg(SA9.id, Org.Id);
        
        // Biography__c Bio = new Biography__c(); 
        // Biography_Reference__c BR = new Biography_Reference__c();
        String BRT = ctrlbioOrg.getBioRecordTypes();
        String ORT = ctrlbioOrg.getOrgRecordTypes();
        
        getBioFS bFS = new getbiofs();
        VisualEditor.DynamicPickListRows bioDPLR =bFS.getValues();

        system.debug(bioDPLR);

        string bioFS = 'FS_Website';
        string bioFields = ctrlBioOrg.getBioFieldsFromFieldSet(bioFS);
        system.debug(bioFields);
        Schema.FieldSet fs1 = Schema.SObjectType.Biography_Reference__c.fieldSets.getMap().get(biofs);
        List<String> bioFieldsToQuery = new List<String>();
		for (Schema.FieldSetMember FSM : Fs1.getFields()){
			bioFieldsToQuery.add(FSM.getFieldPath());
		}
		
        // (List < String > listeChamps, String ContactId, String RTId, String curObj) 
        Biography__c bioRec = new biography__c();
        
        insert bioRec;
        Biography_Reference__c BFRRecord = new Biography_Reference__c(references__c=biorec.id,recordtypeid = Schema.SObjectType.Biography_Reference__c.getRecordTypeInfosByName().get('Honorary Title References').getRecordTypeId());
        insert BFRRecord;
        string bioDataFS = ctrlBioOrg.queryBioFromFieldset(bioFieldsToQuery, bioRec.Id,'Honorary Title References','Biography__c') ;
        
        
        
        bFS.getDefaultValue();
        getOrgFS oFS = new getOrgfs();
        
        ofs.getDefaultValue();
        VisualEditor.DynamicPickListRows orgDPLR = ofs.getValues();

        system.debug(orgDPLR);

        string orgFS = 'FS_Website'; 
        string orgLstFields = ctrlBioOrg.getOrgFieldsFromFieldSet(orgFs); 
        Schema.FieldSet fs2 = Schema.SObjectType.Organisation_Reference__c.fieldSets.getMap().get(orgfs);
        List<String> orgFieldsToQuery = new List<String>();
		for (Schema.FieldSetMember FSM : Fs2.getFields()){
			orgFieldsToQuery.add(FSM.getFieldPath());
		} 
		// (List < String > listeChamps, String ContactId, String RTId, String curObj) 
        Organisation__c orgRec = new Organisation__c(Name__c='Test');
        
        insert orgRec;
        Organisation_Reference__c ORGRecord = new Organisation_Reference__c(references__c=orgRec.id,recordtypeid = Schema.SObjectType.Organisation_Reference__c.getRecordTypeInfosByName().get('Employee References').getRecordTypeId());
        insert ORGRecord;
        string orgDataFS = ctrlBioOrg.queryOrgFromFieldset(orgFieldsToQuery, orgRec.Id,'Employee References','Organisation__c') ;
		
		
        getBioRT bioRT = new getbioRT();
        bioRT.getValues();
        bioRT.getDefaultValue();
        getOrgRT orgRT = new getOrgRT();
        orgRT.getValues();
        orgRT.getDefaultValue();
        
        bioFOFCtrlAura.getFieldsFromFieldSet('Honorary Title References');
        
        orgFOFCtrlAura.getFieldsFromFieldSet('Employee References');
        
        getBioMainFS tstBioMain = new getBioMainFS();
        tstBioMain.getDefaultValue();
        tstBioMain.getValues();
        
        getOrgMainFS tstOrgMain = new getOrgMainFS();
        tstOrgMain.getDefaultValue();
        tstOrgMain.getValues();
        
        
        
        
        test.stopTest();
    }
}
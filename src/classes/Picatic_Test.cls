@isTest


public class Picatic_Test {
    public static testmethod void TestWorking() {
        PageReference pageref;
        Test.startTest();
        user u = [select id, name, contactid, email, profileid from user where contactid!=null limit 1];
        system.debug(u);


        //create account
        Account a = new Account (Name='Test Account',
                                        BillingStreet='2 rue des Joncs', 
                                        BillingCity='Howald', 
                                        BillingState='Luxembourg', 
                                        BillingCountry='Luxembourg', 
                                        BillingPostalCode='L-1818',
                                        Cle_Client_STOCKX__c='C666', 
                                        Montant_Total_facturer_N__c=0, 
                                        Montant_Total_facturer_N_1__c=0,
                                        Membre_du_Club__c = 'Paperjam',
                                        A_facturer_CLUB_N__c=0,
                                        A_facturer_CLUB_N_1__c=0,
                                        A_facturer_DGTL_N__c=0,
                                        A_facturer_DGTL_N_1__c=0,
                                        A_facturer_Dossiers_Dgtx_N__c=0,
                                        A_facturer_Dossiers_Dgtx_N_1__c=0,
                                        A_facturer_Guide_N__c=0,
                                        A_facturer_Guide_N_1__c=0,
                                        A_facturer_OP_N__c=0,
                                        A_facturer_OP_N_1__c=0,
                                        A_facturer_Print_N__c=0,
                                        A_facturer_Print_N_1__c=0,
                                        A_facturer_Sponsoring_N__c=0,
                                        A_facturer_Sponsoring_N_1__c=0,
                                        A_facturer_ARCHI_Print_N__c=0,
                                        A_facturer_ARCHI_Print_N_1__c=0,
                                        A_facturer_CITY_Print_N__c=0,
                                        A_facturer_CITY_Print_N_1__c=0,
                                        A_facturer_DLN_Print_N__c=0,
                                        A_facturer_DLN_Print_N_1__c=0,
                                        A_facturer_FLYDO_Print_N__c=0,
                                        A_facturer_FLYDO_Print_N_1__c=0,
                                        A_facturer_HEX_Print_N__c=0,
                                        A_facturer_HEX_Print_N_1__c=0,
                                        A_facturer_LAND_Print_N__c=0,
                                        A_facturer_LAND_Print_N_1__c=0,
                                        A_facturer_MKR_Print_N__c=0,
                                        A_facturer_MKR_Print_N_1__c=0,
                                        A_facturer_PJ_Print_N__c=0,
                                        A_facturer_PJ_Print_N_1__c=0);
        insert a;
        
        // create contact
        contact c = new contact(firstname = 'testprenom',
                                lastname = 'testnom',
                                accountid = a.id,
                                D_partement_Fonction__c = 'CEO',
                                email = 'test@test.com');
        insert c;
        contact c1 = [select name, id, email, Membre_du_Club__c from contact where id = :c.id];
        system.debug(c1);
        
        Campaign Camp = New campaign(name='test',ClubEventID__c = '1', isActive=true);
        insert camp;
        picatic.exempleaura(camp.id);

        Picatic pica = new picatic();
        system.debug(pageref);
		pageref = Page.GetMember;
        Test.setCurrentPage(pageref);
        system.debug(pageref);
        pageref.getParameters().put('id',camp.id);
		ApexPages.StandardController con = new ApexPages.StandardController(camp);
        system.debug(con);
        Picatic picactrl = new Picatic(con);	
        picactrl.upsertmember();


        Test.stopTest();
    }
}
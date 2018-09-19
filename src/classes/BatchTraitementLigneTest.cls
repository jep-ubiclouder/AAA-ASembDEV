@isTest
Public class BatchTraitementLigneTest {
    Static testMethod void BatchTest() {

        Account AccTest = new Account (Name='Test Account',
                                            BillingStreet='2 rue des Joncs', 
                                            BillingCity='Howald', 
                                            BillingState='Luxembourg', 
                                            BillingCountry='Luxembourg', 
                                            BillingPostalCode='L-1818',
                                            Cle_Client_STOCKX__c='C666', 
                                            Montant_Total_facturer_N__c=0, 
                                            Montant_Total_facturer_N_1__c=0,
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
                                            
        insert Acctest;
        system.debug('*** eric test *** Acctest id = '+Acctest.Id);



        Product2 prod1 = new product2 (name = 'WEBPJ', Family='Digital', Description='paperjam.lu');
        insert prod1;
        Product2 prod2 = new product2 (name = 'DD', Family='Dossier Digitaux', Description='Dossiers Digitaux - Coffee Break');
        insert prod2;
        Product2 prod3 = new product2 (name = 'IND', Family='Guide', Description='PAPERJAM GUIDE', ProductCode='Guide' );
        insert prod3;
        Product2 prod4 = new product2 (name = 'PBC', Family='MemberShip', Description='Paperjam Club');
        insert prod4;
        Product2 prod5 = new product2 (name = 'BUS', Family='OP', Description='Bus - Luxair');
        insert prod5;
        Product2 prod6 = new product2 (name = 'CM', Family='Print', Description='CITY', ProductCode='CM_Print');
        insert prod6;
        Product2 prod7 = new product2 (name = 'SPBC', Family='Sponsoring', Description='Sponsoring PJ Business Club ');
        insert prod7;
        

        date myDate = date.today();
        date Mydate2 = mydate.addyears(-1);

        commandes__c commande1 = new commandes__c(name='1500',Account__c=acctest.id,client_stx__c='C666',commande_stx__c='1500',date_cde__c=mydate);
        insert commande1;
        commandes__c commande2 = new commandes__c(name='1600',Account__c=acctest.id,client_stx__c='C666',commande_stx__c='1600',date_cde__c=mydate);
        insert commande2;

        Lignes_commande__c LCTest1 = new Lignes_commande__c (Name='test1', index_STOCKX__c='1500-1', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='WEBPJ', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest1;
        Lignes_commande__c LCTest2 = new Lignes_commande__c (Name='test2', index_STOCKX__c='1500-2', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='DD', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest2;
        Lignes_commande__c LCTest3 = new Lignes_commande__c (Name='test3', index_STOCKX__c='1500-3', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='IND', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest3;
        Lignes_commande__c LCTest4 = new Lignes_commande__c (Name='test4', index_STOCKX__c='1500-4', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='PBC', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest4;
        Lignes_commande__c LCTest5 = new Lignes_commande__c (Name='test5', index_STOCKX__c='1500-5', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='BUS', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest5;
        Lignes_commande__c LCTest6 = new Lignes_commande__c (Name='test6', index_STOCKX__c='1500-6', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='CM', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest6;
        Lignes_commande__c LCTest7 = new Lignes_commande__c (Name='test7', index_STOCKX__c='1500-7', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='SPBC', commande__c=commande1.id, compte__c=acctest.id); 
        insert  LCTest7;
        Lignes_commande__c LCTest11 = new Lignes_commande__c (Name='test11', index_STOCKX__c='1600-1', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='WEBPJ', commande__c=commande2.id, compte__c=acctest.id); 
        insert  LCTest11;
        Lignes_commande__c LCTest21 = new Lignes_commande__c (Name='test21', index_STOCKX__c='1600-2', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='DD', commande__c=commande2.id, compte__c=acctest.id); 
        insert  LCTest21;
        Lignes_commande__c LCTest31 = new Lignes_commande__c (Name='test31', index_STOCKX__c='1600-3', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='IND', commande__c=commande2.id, compte__c=acctest.id); 
        insert  LCTest31;


        list<lignes_commande__c> newlist = [select id, name from lignes_commande__c ];
        system.debug('*** eric *** ligne size '+newlist.size());





        Test.startTest(); 
        BatchTraitementligne bil = new BatchTraitementligne();
        Database.executeBatch(bil,10);
        

    
        Batchtraitementgroupe BatchIL = new Batchtraitementgroupe();
        Database.executebatch(BatchIL,10);
        Test.stopTest();
    
    }
    
}
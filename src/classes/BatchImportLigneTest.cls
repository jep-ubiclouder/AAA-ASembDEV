@isTest
Public class BatchImportLigneTest {
    Static testMethod void BatchTest() {

        Account AccTest = new Account (Name='Test Account',
                                            BillingStreet='2 rue des Joncs', 
                                            BillingCity='Howald', 
                                            BillingState='Luxembourg', 
                                            BillingCountry='Luxembourg', 
                                            BillingPostalCode='L-1818',
                                            Cle_Client_STOCKX__c='C666');
                                            
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

        Lignes_commande_import__c LCTest1 = new Lignes_commande_import__c (Name='test1', index_STOCKX__c='1500-1', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='WEBPJ'); 
        insert  LCTest1;
        Lignes_commande_import__c LCTest2 = new Lignes_commande_import__c (Name='test2', index_STOCKX__c='1500-2', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='DD'); 
        insert  LCTest2;
        Lignes_commande_import__c LCTest3 = new Lignes_commande_import__c (Name='test3', index_STOCKX__c='1500-3', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='IND'); 
        insert  LCTest3;
        Lignes_commande_import__c LCTest4 = new Lignes_commande_import__c (Name='test4', index_STOCKX__c='1500-4', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='PBC'); 
        insert  LCTest4;
        Lignes_commande_import__c LCTest5 = new Lignes_commande_import__c (Name='test5', index_STOCKX__c='1500-5', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='BUS'); 
        insert  LCTest5;
        Lignes_commande_import__c LCTest6 = new Lignes_commande_import__c (Name='test6', index_STOCKX__c='1500-6', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='CM'); 
        insert  LCTest6;
        Lignes_commande_import__c LCTest7 = new Lignes_commande_import__c (Name='test7', index_STOCKX__c='1500-7', Cle_client_stx__c='C666', commande_stx__c='1500', Brut_Editeur__c=1000, Parution__c=mydate, Magazine__c='SPBC'); 
        insert  LCTest7;
        Lignes_commande_import__c LCTest11 = new Lignes_commande_import__c (Name='test11', index_STOCKX__c='1600-1', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='WEBPJ'); 
        insert  LCTest11;
        Lignes_commande_import__c LCTest21 = new Lignes_commande_import__c (Name='test21', index_STOCKX__c='1600-2', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='DD'); 
        insert  LCTest21;
        Lignes_commande_import__c LCTest31 = new Lignes_commande_import__c (Name='test31', index_STOCKX__c='1600-3', Cle_client_stx__c='C666', commande_stx__c='1600', Brut_Editeur__c=1000, Parution__c=mydate2, Magazine__c='IND'); 
        insert  LCTest31;


        list<Lignes_commande_import__c> newlist = [select id, name from Lignes_commande_import__c ];
        system.debug('*** eric *** ligne size '+newlist.size());


        Batchimportligne bil = new Batchimportligne();
        Test.startTest(); 
            Database.executeBatch(bil,10);
        Test.stopTest();

        Bouton_traitement_ligne objController = new Bouton_traitement_ligne();
        objController.TraitementLigne();



    
    }
    
}
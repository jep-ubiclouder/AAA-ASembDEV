global class BatchImportLigne implements Database.Batchable<sObject>, Database.Stateful {
 
    Private String query; 
    Private Map<string,account> MapAcc= new Map<String,account>();
    Private Map<string,product2> MapProd = new Map<string,product2>();
    Private Map<string,commandes__c> MapComm = new Map<string,commandes__c>();
    Private List<lignes_commande_import__c> LCI = new List<lignes_commande_import__c>();
    Private List<lignes_commande_import__c> LCItodel;

    Private Set<String> anomalie = new set<string>(); // pour le compte rendu email

    Private list<lignes_commande__c> ListCde;
    private list<commandes__c> newComm = new list<commandes__c>();
    Private integer ligne = 0 ;
    
    global BatchImportLigne() {

        //Map des Comptes
        for(account acc :[select id, Cle_Client_STOCKX__c from account where Cle_Client_STOCKX__c !=null ]) {
            MapAcc.put(acc.Cle_Client_STOCKX__c,acc);
        }

        //Map des Commandes
        for(commandes__c com :[select id, name,  Account__c, CLIENT_stx__c, COMMANDE_STX__c, Commercial__c, DATE_CDE__c from commandes__c]) {
            MapComm.put(com.name,com);
        }

        // Map des Produits
        for (product2 prod: [select id, name, Description, Family, ProductCode from Product2]){
            MapProd.put(prod.name, prod);
        }


    }
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Integer count = Limits.getLimitDMLRows() - Limits.getDMLRows();
        count = 154;
        query = 'Select id, name, Article__c, Base_HTVA__c, Brut_Editeur__c, Brut_Total__c, Cle_Client_STX__c, CLIENT_FINAL__c, COMMANDE_STX__c, Commercial__c, DATE_CDE__c, Edition__c, FT__c, Index_STOCKX__c, MAGAZINE__c, NOM__c, NOM2__c, Parution__c, Ligne_OK__c, anomalie__c from lignes_commande_import__c order by anomalie__c desc NULLS FIRST limit :count';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<lignes_commande_import__c> scope) {
        
        Lignes_commande__c newLigne; 
        this.ListCDE = new list<lignes_commande__c> ();
        this.LCItodel = new List<lignes_commande_import__c>();
        newcomm = new list<commandes__c>();

        this.LCI = new List<lignes_commande_import__c>();
        list<lignes_commande_import__c> nocde = new list<lignes_commande_import__c>();
        for (lignes_commande_import__c l :scope) {
            newLigne = new Lignes_commande__c();
            commandes__c c;
            if (MapAcc.containsKey(l.Cle_Client_STX__c)) {
                //l.compte__c = MapAcc.get(l.Cle_Client_STX__c).id;
                // creation d'une commande

                if (MapProd.containsKey(l.magazine__c)) {
                    //l.Produit__c = MapProd.get(l.magazine__c).id;

                    if (MapComm.containsKey(l.COMMANDE_STX__c)) {
                        c = MapComm.get(l.COMMANDE_STX__c);
                        newligne.commande__r = MapComm.get(l.COMMANDE_STX__c);
                        l.Ligne_OK__c = true;
                    } else {
                        // creation d'une commande
                        c = new commandes__c();
                        c.name = l.COMMANDE_STX__c;
                        c.account__c = MapAcc.get(l.Cle_Client_STX__c).id;
                        c.CLIENT_stx__c = l.Cle_Client_STX__c;
                        c.COMMANDE_STX__c = l.COMMANDE_STX__c;
                        c.Commercial__c = l.Commercial__c;
                        c.DATE_CDE__c = l.DATE_CDE__c;
                        newcomm.add(c);
                        MapComm.put(c.name,c);
                    }
                    newLigne.name = l.name ;
                    newligne.commande__r = c;
                    newLigne.Produit__c = MapProd.get(l.magazine__c).id;
                    newLigne.article__c = l.article__c;
                    newLigne.Base_HTVA__c = l.Base_HTVA__c;
                    newLigne.Brut_Editeur__c = l.Brut_Editeur__c;
                    newLigne.Brut_Total__c = l.Brut_Total__c;
                    newLigne.Cle_Client_STX__c = l.Cle_Client_STX__c;
                    newLigne.CLIENT_FINAL__c = l.CLIENT_FINAL__c;
                    newligne.magazine__c = l.magazine__c;
                    newLigne.COMMANDE_STX__c = l.COMMANDE_STX__c;
                    newLigne.Commercial__c = l.Commercial__c;
                    newLigne.Compte__c = MapAcc.get(l.Cle_Client_STX__c).id;
                    newLigne.DATE_CDE__c = l.DATE_CDE__c;
                    newLigne.Edition__c = l.Edition__c;
                    newLigne.FT__c = l.FT__c;
                    newLigne.Index_STOCKX__c = l.Index_STOCKX__c;
                    newLigne.nom__c = l.nom__c;
                    newLigne.nom2__c = l.nom2__c;
                    newLigne.Parution__c = l.Parution__c;
                    ligne = ligne +1;
                    listcde.add(newLigne);
                    lcitodel.add(l);

                } else {
                    // produit (magazine) inconnu
                    l.anomalie__c = 'Le produit ' +l.magazine__c+'  n\'existe pas.';
                    anomalie.add('Le produit ' +l.magazine__c+'  n\'existe pas.');
                }    
                
            } else {
                // compte inconnu
                l.anomalie__c = 'Le compte '+l.Cle_Client_STX__c+ ' n\'existe pas.';
                anomalie.add('Le compte '+l.Cle_Client_STX__c+ ' n\'existe pas.');
            }
            lci.add(l);
        }

        // sauve commande
        Schema.SObjectField SchCommande = commandes__c.Fields.Name;
        list<database.upsertresult> Lr1 = database.upsert(newcomm,Schcommande,false);
        For (database.upsertresult r :Lr1) {
            if (!r.isSuccess()) {
                system.debug(r);
            }
        }
        

        // update id de la commande dans la ligne   
        for (lignes_commande__c c :listcde){
            string idcde = c.commande__r.id;
            //c.commande__r = null;
            c.commande__c= idcde;
        }
        
        // sauve ligne commande
        Schema.SObjectField f2 = lignes_commande__c.Fields.Index_STOCKX__c;
        list<database.upsertresult> srlist2 = database.upsert(listcde,f2,false);
        For (database.upsertresult r :srlist2) {
            if (!r.isSuccess()) {
                system.debug(r);
            }
        }
    
        // sauve import ligne commande avec anomalie
        list<database.upsertresult> resultimport = database.upsert(lci,false);    

        // delete import ligne de commande ok
        database.deleteresult[] resultdelimport = database.delete(lcitodel,false);   
             
    }
 
    global void finish(Database.BatchableContext BC) {
  

  
        //create a mail object to send a single email.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        User u =[select email,name from user where id=: userinfo.getUserId() limit 1];
        //set the email properties
        mail.setToAddresses(new string[] {u.email});
        mail.setSubject('Traitement des lignes de commande');
        String body='';
        body +='Bonjour '+u.name+',';
        if(ligne >0 || anomalie.size()>0) {
            body+='<br/><br/>'+ligne+' lignes ont été traitées avec succès.';
            if (anomalie.size()>0) {
                Body+='<br/><br/>Erreurs rencontrées : '+anomalie.size();
                for (string s :anomalie) {
                    Body+='<br/>'+s;
                }
            }
        } else {
            body+='<br/><br/>Il n\'y avait aucune ligne a traiter cette fois.';
        }
        body+='<br/><br/>Merci,<br/>Le system';
        mail.setHtmlBody(body);
        mail.setPlainTextBody('Le traitement des lignes de commande est terminé.');
        //send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );

    }
}
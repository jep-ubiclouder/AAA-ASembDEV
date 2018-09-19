global class BatchTraitementGroupe implements Database.Batchable<sObject>, Database.Stateful {
 
    global String query; 
    global integer traitement = 0;
    global Map<string,account> MapAccount;
    global list<exception> ListErreur;
    global Map<string,account> MapErreurA;
    global Map<string,Lignes_commande__c> MapErreurL;
    
    global BatchTraitementGroupe() {
        system.debug('constucteur batchtraitmentgroupe');
        // Map des comptes
        ListErreur = new list<exception>();
        MapErreurA = new Map<string,Account>();
        MapErreurL = new Map<string,Lignes_commande__c>();
        MapAccount = new Map<string,Account>();
        for (account a :[select id, BE_N_GROUPE__c, BE_N_1_GROUPE__c, Cle_Client_STOCKX__c, Cle_Client_STX_GROUPE__c from account where cle_client_stockx__c !=null ]) {
            a.BE_N_GROUPE__c = 0;
            a.BE_N_1_GROUPE__c = 0;
            string cle = a.Cle_Client_STOCKX__c.touppercase();
            MapAccount.put(cle,a);
        }
        system.debug(MapAccount.size());
    }
 

    global Database.QueryLocator start(Database.BatchableContext BC) {

        Query ='select id, n__c, n_1__c, brut_editeur__c, cle_client_stx__c, cle_client_stx_groupe__c, Cle_Client_STX_Compte_Parent__c, compte__c, compte__r.Cle_Client_STOCKX__c from lignes_commande__c where n__c = true or n_1__c = true';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<lignes_commande__c> scope) {
        traitement = traitement + scope.size();
        account gr = new account();
        account acc = new account();
        for (lignes_commande__c l :scope) {
                acc = MapAccount.get(l.compte__r.Cle_Client_STOCKX__c.touppercase());
                gr = MapAccount.get(l.Cle_Client_STX_Compte_Parent__c.touppercase());
                try {
                    if (l.n__c) {
                        acc.BE_N_GROUPE__c += l.brut_editeur__c;
                        if (acc != gr ) {
                            gr.BE_N_GROUPE__c  += l.brut_editeur__c;
                        }
                    } else if (l.n_1__c) {
                        acc.BE_N_1_GROUPE__c += l.brut_editeur__c;
                        if (acc != gr ) {
                            gr.BE_N_1_GROUPE__c  += l.brut_editeur__c;
                        }
                    }
                } catch (exception e) {
                }
            }

    }
 
  global void finish(Database.BatchableContext BC) {
    update MapAccount.values();
    //create a mail object to send a single email.
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    User u =[select email,name from user where id=: userinfo.getUserId() limit 1];
    //set the email properties
    mail.setToAddresses(new string[] {u.email});
    mail.setSubject('Traitement des lignes de commande');
    String body='';
    body +='Bonjour '+u.name+',';
    body+='<br/><br/>La mise à jours des groupes est terminée : ';
    body+='<br/>'+traitement+' comptes ont été mis à jour.';

    body+='<br/><br/>Merci,<br/>Le system';
    mail.setHtmlBody(body);
    mail.setPlainTextBody('La mise à jour des groupes est terminée : '+traitement);
    //send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );

  }
 
 
}
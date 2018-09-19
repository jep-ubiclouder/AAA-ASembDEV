global class BatchTraitementLigne implements Database.Batchable<sObject>, Database.Stateful {
 
    global String query; 
    Global integer traitement = 0;
    global BatchTraitementLigne() {}
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Query = 'select id , Cle_Client_STOCKX__c, A_facturer_CLUB_N__c, A_facturer_CLUB_N_1__c, A_facturer_DGTL_N__c, A_facturer_DGTL_N_1__c, A_facturer_Dossiers_Dgtx_N__c, ';
        Query +='A_facturer_Dossiers_Dgtx_N_1__c, A_facturer_Guide_N__c, A_facturer_Guide_N_1__c, A_facturer_OP_N__c, A_facturer_OP_N_1__c, A_facturer_Print_N__c, A_facturer_Print_N_1__c, ';
        Query +='A_facturer_Sponsoring_N__c, A_facturer_Sponsoring_N_1__c, Montant_Total_facturer_N__c, Montant_Total_facturer_N_1__c, ';
        Query +='A_facturer_ARCHI_Print_N__c, A_facturer_ARCHI_Print_N_1__c, A_facturer_CITY_Print_N__c, A_facturer_CITY_Print_N_1__c, A_facturer_DLN_Print_N__c, A_facturer_DLN_Print_N_1__c, ';
        Query +='A_facturer_FLYDO_Print_N__c, A_facturer_FLYDO_Print_N_1__c, A_facturer_HEX_Print_N__c, A_facturer_HEX_Print_N_1__c, A_facturer_LAND_Print_N__c, A_facturer_LAND_Print_N_1__c, ';
        Query +='A_facturer_MKR_Print_N__c, A_facturer_MKR_Print_N_1__c, A_facturer_PJ_Print_N__c, A_facturer_PJ_Print_N_1__c , BE_N_GROUPE__C, BE_N_1_GROUPE__C ';
        
        Query +='from account where Cle_Client_STOCKX__c!=Null and montant_total_N_a_facturer__c>0 ';

        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        traitement = traitement + scope.size();
        List<Account> AccountList = new List<Account>();
        for (Account obj : scope) {
            AccountList.add(obj);
        }
        if (AccountList.size()>0){
            System.enqueueJob(new QueueClass(AccountList));
        }
    }
 
  global void finish(Database.BatchableContext BC) {
    //create a mail object to send a single email.
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    User u =[select email,name from user where id=: userinfo.getUserId() limit 1];
    //set the email properties
    mail.setToAddresses(new string[] {u.email});
    mail.setSubject('Traitement des lignes de commande');
    String body='';
    body +='Hi '+u.name+',';
    body+='<br/><br/>Le traitement des lignes de commande est terminé : ';
    body+='<br/>'+traitement+' comptes ont été mis à jour.';

    body+='<br/><br/>Merci,<br/>Le system';
    mail.setHtmlBody(body);
    mail.setPlainTextBody('Le traitement des lignes de commande est terminé : '+traitement);
    //send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );

  }
 
    public class QueueClass implements Queueable, Database.AllowsCallouts {

        
        Boolean CommExiste;
        String IdComm;
        List<Account> ListAccount;
        List<string> ListClef = new List<String>();

        Map<string,User> MapUser = new Map<string,User>();
        Map<string,product2> MapProduit = new Map<string,product2>();

        List<commandes__c> ListComm =  new List<commandes__c>();
        List<Lignes_Commande__c> ListLigne = new List<Lignes_commande__c>();
        
        public QueueClass(List<Account> SetAcc) {
             
            // ici on extrait et prepare toutes les listes / Maps / set nécessaire au traitement dans execute

            //set d'account 
            this.ListAccount = SetAcc;
            
            //Map des users
            for (user MyUser: [select id, alias from user where IsActive=true]) {
                MapUser.put(MyUser.Alias, MyUser);
            }  

            // Map des Produits
            for (product2 prod: [select id, name, Description, Family, ProductCode from Product2]){
                MapProduit.put(prod.name, prod);
            }
            
            // liste des clefs STX des accounts
            for (Account ThisAcc :this.ListAccount){
                ListClef.add(ThisAcc.Cle_Client_STOCKX__c);
            }

            // liste des commandes existantes pour les accounts 
            this.ListComm = [Select id, name, Account__c, CLIENT_stx__c, Commercial__c, Date_cde__c from commandes__c where CLIENT_stx__c in :ListClef order by CLIENT_stx__c];
            
            // liste des lignes de commandes
            this.ListLigne = [Select id,Cle_Client_STX__c,Index_STOCKX__c,Commande_stx__c,date_cde__c,Commercial__c,magazine__c, produit__c,Brut_Editeur__c, N__c, N_1__c from lignes_commande__c where Cle_Client_STX__c in:ListClef order by Cle_Client_STX__c,Commande__c ASC];
            
        }


        public void execute(QueueableContext context) {
            
            For (Account MyAccount : this.ListAccount){
                MyAccount.A_facturer_CLUB_N__c=0;
                MyAccount.A_facturer_CLUB_N_1__c=0;
                MyAccount.A_facturer_DGTL_N__c=0;
                MyAccount.A_facturer_DGTL_N_1__c=0;
                MyAccount.A_facturer_Dossiers_Dgtx_N__c=0;
                MyAccount.A_facturer_Dossiers_Dgtx_N_1__c=0;
                MyAccount.A_facturer_Guide_N__c=0;
                MyAccount.A_facturer_Guide_N_1__c=0;
                MyAccount.A_facturer_OP_N__c=0;
                MyAccount.A_facturer_OP_N_1__c=0;
                MyAccount.A_facturer_Print_N__c=0;
                MyAccount.A_facturer_Print_N_1__c=0;
                MyAccount.A_facturer_Sponsoring_N__c=0;
                MyAccount.A_facturer_Sponsoring_N_1__c=0;
                MyAccount.Montant_Total_facturer_N__c=0;
                MyAccount.Montant_Total_facturer_N_1__c=0;
                MyAccount.BE_N_GROUPE__c=0;
                MyAccount.BE_N_1_GROUPE__c=0;
                
                MyAccount.A_facturer_ARCHI_Print_N__c=0;
                MyAccount.A_facturer_ARCHI_Print_N_1__c=0;
                MyAccount.A_facturer_CITY_Print_N__c=0;
                MyAccount.A_facturer_CITY_Print_N_1__c=0;
                MyAccount.A_facturer_DLN_Print_N__c=0;
                MyAccount.A_facturer_DLN_Print_N_1__c=0;
                MyAccount.A_facturer_FLYDO_Print_N__c=0;
                MyAccount.A_facturer_FLYDO_Print_N_1__c=0;
                MyAccount.A_facturer_HEX_Print_N__c=0;
                MyAccount.A_facturer_HEX_Print_N_1__c=0;
                MyAccount.A_facturer_LAND_Print_N__c=0;
                MyAccount.A_facturer_LAND_Print_N_1__c=0;
                MyAccount.A_facturer_MKR_Print_N__c=0;
                MyAccount.A_facturer_MKR_Print_N_1__c=0;
                MyAccount.A_facturer_PJ_Print_N__c=0;
                MyAccount.A_facturer_PJ_Print_N_1__c=0;
                
                For (lignes_commande__c MyLigne : this.ListLigne ){

                    if (MyLigne.Cle_Client_STX__c == MyAccount.Cle_Client_STOCKX__c){


                        product2 MyProd = MapProduit.get(MyLigne.magazine__c);

                        //traitement des répartitions
                        // 0 all
                        if (MyLigne.N__c==True){
                            MyAccount.Montant_Total_facturer_N__c += MyLigne.Brut_Editeur__c;
                        } else if (MyLigne.N_1__c==True){
                            MyAccount.Montant_Total_facturer_N_1__c += MyLigne.Brut_Editeur__c;
                        }
                        
                        // 1 digital
                        if (Myprod.Family=='Digital' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_DGTL_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Digital' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_DGTL_N_1__c += MyLigne.Brut_Editeur__c;
                        }                   
                    
                        // 2 Dossier Digitaux
                        if (Myprod.Family=='Dossier Digitaux' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_Dossiers_Dgtx_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Dossier Digitaux' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_Dossiers_Dgtx_N_1__c += MyLigne.Brut_Editeur__c;
                        }                         
                        
                        // 3 Guide
                        if (Myprod.Family=='Guide' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_Guide_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Guide' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_Guide_N_1__c += MyLigne.Brut_Editeur__c;
                        }                   

                        // 4 Membership
                        if (Myprod.Family=='Membership' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_CLUB_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Membership' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_CLUB_N_1__c += MyLigne.Brut_Editeur__c;
                        }                     

                        // 5 OP
                        if (Myprod.Family=='OP' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_OP_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='OP' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_OP_N_1__c += MyLigne.Brut_Editeur__c;
                        }                   
                        
                        // 6 Print
                        if (Myprod.Family=='Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_Print_N__c += MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_Print_N_1__c += MyLigne.Brut_Editeur__c;
                        }                   
    
                        // 7 Sponsoring
                        if (Myprod.Family=='Sponsoring' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_Sponsoring_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.Family=='Sponsoring' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_Sponsoring_N_1__c += MyLigne.Brut_Editeur__c;
                        }   
                        
                        // 8 Archi Print
                        if (Myprod.ProductCode =='AD_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_ARCHI_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='AD_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_ARCHI_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }

                        // 9 City Print
                        if (Myprod.ProductCode =='CM_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_CITY_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='CM_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_CITY_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 10 Delano Print
                        if (Myprod.ProductCode =='DLN_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_DLN_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='DLN_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_DLN_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 11 Flydoscope  Print
                        if (Myprod.ProductCode =='FLYDO_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_FLYDO_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='FLYDO_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_FLYDO_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 12 HEX Print
                        if (Myprod.ProductCode =='HEX_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_HEX_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='HEX_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_HEX_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 13 LAND Print
                        if (Myprod.ProductCode =='LAND_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_LAND_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='LAND_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_LAND_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 14 MKR Print
                        if (Myprod.ProductCode =='MKR_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_MKR_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='MKR_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_MKR_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                        
                        // 15 PJ Print
                        if (Myprod.ProductCode =='PJ_Print' && MyLigne.N__c==True ){
                            MyAccount.A_facturer_PJ_Print_N__c+= MyLigne.Brut_Editeur__c;
                        }else if(Myprod.ProductCode =='PJ_Print' && MyLigne.N_1__c==True ){
                            MyAccount.A_facturer_PJ_Print_N_1__c+= MyLigne.Brut_Editeur__c;
                        }
                                  
                    }
                }
            }
       
        update this.ListAccount;

    } 
 }
 
 
}
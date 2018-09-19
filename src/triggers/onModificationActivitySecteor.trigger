trigger onModificationActivitySecteor on Secteur_Activite__c (before delete, after insert, after update) {
    List<ptEvent__c> todo = new List<ptEvent__c>();
    if (Trigger.isDelete){
    
        for(Secteur_Activite__c o : Trigger.old){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Secteur_Activite__c',Operation__c='D',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( trigger.isUpdate){
        for(Secteur_Activite__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Secteur_Activite__c',Operation__c='U',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( Trigger.isInsert){
        for(Secteur_Activite__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Secteur_Activite__c',Operation__c='I',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }        
        
        
    insert todo;
    }
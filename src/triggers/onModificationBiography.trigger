trigger onModificationBiography on Biography__c (after Update,after Insert,before Delete) {
    List<ptEvent__c> todo = new List<ptEvent__c>();
    if (Trigger.isDelete){
    
        for(Biography__c o : Trigger.old){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Biography__c ',Operation__c='D',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( trigger.isUpdate){
        for(Biography__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Biography__c ',Operation__c='U',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( Trigger.isInsert){
        for(Biography__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Biography__c ',Operation__c='I',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }        
        
        
    insert todo;
    }
trigger onModificationOrganisationRef on Organisation_Reference__c (after Update,after Insert,before Delete) {
    List<ptEvent__c> todo = new List<ptEvent__c>();
    if (Trigger.isDelete){
    reorderReferences reOrder = new reorderReferences(trigger.old,'D');
        for(Organisation_Reference__c o : Trigger.old){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Organisation_Reference__c',Operation__c='D',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( trigger.isUpdate){
     reorderReferences reOrder = new reorderReferences(trigger.old, trigger.new, 'U');
        for(Organisation_Reference__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Organisation_Reference__c',Operation__c='U',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }
    if( Trigger.isInsert){
        system.debug('in Before insert trigger');
        reorderReferences reOrder = new reorderReferences(trigger.old, trigger.new ,'I');
        // system.debug(reOrder);
        for(Organisation_Reference__c o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='Organisation_Reference__c',Operation__c='I',Record_Id__c=o.Id);
            todo.add(tmp);
            }
        }        
        
        
    insert todo;
    }
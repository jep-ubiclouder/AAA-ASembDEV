trigger onFileUpload on ContentDocument (after Insert) {
    List<ptEvent__c> todo = new List<ptEvent__c>();
    if( Trigger.isUpdate){
        for(ContentDocument o : Trigger.new){
            ptEvent__c tmp = new ptEvent__c(Object_Name__c='ContentDocument',Operation__c='I',Record_Id__c=o.Id);
            todo.add(tmp);
            }
            }
            insert todo;
}
public with sharing class ctrlElemBio {
    @Auraenabled
    public static String getRTypes(){
      // je recupère les RT des ElementBiographiques
      list<recordType> Lrt =[select id,name from RecordType where SObjectType ='Element_Bio__c'] ;
      system.debug(Lrt);
      return JSON.serialize(Lrt);
    }
    @Auraenabled
    public static String getElemBio(){
      list<Element_Bio__c> elemBio =  [Select e.Web_URL__c, e.RecordTypeId, e.Name, e.Contact__c From Element_Bio__c e];
      return JSON.serialize(elemBio);
    }
    @AuraEnabled
    public static String getFields() {
      system.debug('hello from getfields');
        return JSON.serialize(SObjectType.Element_Bio__c.FieldSets.getMap());
    }

    /* private Merchandise__c getMerchandise() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Merchandise__c LIMIT 1';
        return Database.query(query);
    } */
}
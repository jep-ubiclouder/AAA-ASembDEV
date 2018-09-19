@isTest 
private class UpdateContactTestClass {
  static testMethod void testUpdateContacts() {
        Test.startTest(); 
        User u = [select Id,ContactId,FirstName from User where ContactId<>'' limit 1]; 

        u.FirstName='Bar'; 
        update u; 

        Test.stopTest(); 

        Contact c = [select FirstName from Contact where Id=:u.ContactId]; 
        System.assertEquals(c.FirstName,u.FirstName); 
    }
}
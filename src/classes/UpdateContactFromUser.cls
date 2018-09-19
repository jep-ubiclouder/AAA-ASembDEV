global class UpdateContactFromUser { 
    
    // It has to be async as setup and non-setup modification cannot be done simultaneously
    @future
    public static void updateContacts(String userId) {
        User u = [select ContactId,isZhaokui__c
                    from User
                    where Id=:userId];

        if (u!=null && u.ContactId!=null) {
            Contact c = new Contact(Id=u.ContactId, User_isZhaokui__c=u.isZhaokui__c);
            update c; 
        }
    }
}
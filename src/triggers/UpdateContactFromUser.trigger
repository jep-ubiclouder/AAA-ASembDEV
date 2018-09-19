trigger UpdateContactFromUser on User (after insert, after update) {
    if (Trigger.new.size()==1) 
    { 
        User u = Trigger.new[0]; 
        if (u.ContactId!=null) { 
            UpdateContactFromUser.updateContacts(u.Id); 
        } 
    } 
}
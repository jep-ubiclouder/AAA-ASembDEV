@RestResource(urlMapping='/IsUserClubMember/*')
global without sharing class Rest_IsUserClubMember {

    @HttpGet
    global static void get()
    {
        string CampaignMsg = 'Campaign exist';
        string UserMsg = 'User exist';
        boolean IsMember = False ;

        String EventId = RestContext.request.params.get('camp');
        String MemberId = RestContext.request.params.get('user');
        List<string> ListEmail = new list<string>();
        list<domain__c> ListDomain = new list<domain__c>();
        user U;

        If (EventId != null ){
                try {
                    Campaign MyCampaign = [select id from Campaign where ClubEventID__c = :EventId];
                } catch (exception e) {
                    CampaignMsg= 'This campaign was not found';
                    system.debug(e);
                }
        } else {
            EventId = '';
            CampaignMsg= 'No Campaign';
        }

        If (MemberId != null ){
                try {
                    U = [select id, email, Email_Club__c, ContactId from user where ContactId = :MemberId or id = :MemberId];
                    system.debug(U);
                    If (U.email != null ) {
                        list<string> parts = U.email.split('@');
                        If (Parts.size() > 1) {
                            ListEmail.add(parts[parts.size()-1]);
                        }
                    }
                    If (U.Email_Club__c != null ) {
                        list<string> parts = U.Email_Club__c.split('@');
                        If (Parts.size() > 1) {
                            ListEmail.add(parts[parts.size()-1]);
                        }
                    }
                } catch(exception e) {
                    UserMsg = 'This User was not found';
                    system.debug(e);
                }
                system.debug(listemail);
                try {
                    ListDomain = [select Name, Account__c, Eligible_Club_Event_Registration__c from domain__c where Eligible_Club_Event_Registration__c = true and Name in :ListEmail ];
                } catch(exception e) {
                    system.debug(e);
                }     
                
                if (ListDomain.size() >0) {
                    IsMember = true ;
                } else {
                    IsMember = false ;
                }
                system.debug(memberid);
                list<contact> contacts = [select account.Membre_du_Club__c from contact where account.Membre_du_Club__c != null and id = :memberID ];
                if (contacts.size()>0){
                    IsMember = true;
                }
        
        }else {
            MemberId = '';
            UserMsg = 'No User';
        }

        try {
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
                gen.writeFieldName('Member');
                gen.writeStartArray();
                    gen.writeStartObject();
                    gen.writeStringField('Campaign', EventId);
                    gen.writeStringField('Campaign Status', CampaignMsg);
                    gen.writeStringField('ID User', MemberId);
                    gen.writeStringField('User Status', UserMsg);
                    gen.writeBooleanField('IsUserClubMember', IsMember);
                    gen.writeEndObject();
                gen.writeEndArray();
            gen.writeEndObject();
            gen.close();
        
            RestContext.Response.addHeader('Content-Type', 'application/json');
            RestContext.Response.ResponseBody = Blob.valueOf(gen.getAsString());
        } catch (exception e) {
            system.debug(e);
        }
    
    
    }
}
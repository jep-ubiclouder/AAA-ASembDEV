@RestResource(urlMapping='/IsUserInvitedForEvent/*')
global without sharing class Rest_IsUserInvitedForEvent {

    @HttpGet
    global static void get()
    {
        string CampaignMsg = 'Campaign exist';
        string UserMsg = 'Contact exist';
        boolean IsMember = false ;
        id MyCampaignId ;
        id MyContactId;
        
         // Get request parameters.
        String EventId = RestContext.request.params.get('camp');
        String MemberId = RestContext.request.params.get('user');
        
        If (EventId != null && EventId !=''){        
            system.debug(EventId);    
            try {
                Campaign MyCampaign = [select id from Campaign where ClubEventID__c = :EventId];
                MyCampaignId = MyCampaign.id;
            } catch (exception e) {
                CampaignMsg= 'This campaign was not found';
                system.debug(e);
            }
        } else {
            EventId = '';
            CampaignMsg= 'No Campaign';
        }
        
        system.debug(MemberId );
        If (MemberId != null ){            
            try {
                User U = [select id, ContactId from user where ContactId = :MemberId or id = :MemberId];
                MyContactId = U.ContactId;
//                Contact C = [select id from Contact where Id = :MemberId];
            } catch(exception e) {
                UserMsg = 'This contact was not found';
                system.debug(e);
            }
        } else {
            MemberId = '';
            UserMsg = 'No User';
        }
                
                
                
        try {
            CampaignMember CM = [select id, CampaignId, ContactId  from CampaignMember where CampaignId = :MyCampaignId and ContactId = :MyContactId and IsInvited__c = True];
            IsMember = true;
        } catch(exception e) {
            IsMember = false;
            system.debug(e);
        }

        //instantiate the generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeFieldName('Member');
            gen.writeStartArray();
                gen.writeStartObject();
                gen.writeStringField('Campaign', EventId);
                gen.writeStringField('Campaign msg', CampaignMsg);
                gen.writeStringField('ID User', MemberId);
                gen.writeStringField('Contact msg', UserMsg);
                gen.writeBooleanField('IsMember', IsMember);
                gen.writeEndObject();
            gen.writeEndArray();
        gen.writeEndObject();
        gen.close();

    
        RestContext.Response.addHeader('Content-Type', 'application/json');
        RestContext.Response.ResponseBody = Blob.valueOf(gen.getAsString());
   
    
    }
}
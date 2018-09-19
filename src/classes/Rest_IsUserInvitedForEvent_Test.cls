@isTest
public class Rest_IsUserInvitedForEvent_Test {
    public static testmethod void TestWorking() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().getHost() + '/IsMember/';
        req.httpMethod = 'GET';

        // camp and user are null
        req.addParameter('camp','');
        req.addParameter('user','');

        RestContext.request = req;
        RestContext.response = res;

        Rest_IsUserInvitedForEvent.get();
        String response = RestContext.response.responseBody.toString();
        System.debug('==========> response = ' + response);

        // camp and user exist
        campaign Mycamp = new campaign(name='campaign test', ClubEventID__c='1');
        insert Mycamp;
        contact Mycont = new contact (lastname = 'test',firstname='contact');
        insert Mycont;
        CampaignMember MyCM = new CampaignMember (contactid=Mycont.id, campaignid=Mycamp.id);
        insert MyCM;
        req.addParameter('camp','1');
        req.addParameter('user',Mycont.id);
        RestContext.request = req;
        RestContext.response = res;

        Rest_IsUserInvitedForEvent.get();
        response = RestContext.response.responseBody.toString();
        System.debug('==========> response = ' + response);




        Test.stopTest();
    }
}
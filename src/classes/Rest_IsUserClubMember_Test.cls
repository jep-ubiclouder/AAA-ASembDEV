@isTest
public class Rest_IsUserClubMember_Test {
    public static testmethod void TestWorking() {
        Test.startTest();         
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = URL.getSalesforceBaseUrl().getHost() + '/IsMember/';
        req.httpMethod = 'GET';

        // camp and user not in request
        //req.addParameter('camp','');
        //req.addParameter('user','');

        RestContext.request = req;
        RestContext.response = res;

        Rest_IsUserClubMember.get();
        String response = RestContext.response.responseBody.toString();
        System.debug('==========> response = ' + response);

        // camp and user not exist
        req.addParameter('camp','test01');
        req.addParameter('user','');
        RestContext.request = req;
        RestContext.response = res;

        Rest_IsUserClubMember.get();
        response = RestContext.response.responseBody.toString();
        System.debug('==========> response = ' + response);



        // camp and user exist
        Account MyAcc = new Account(name='account test', Cle_Client_STOCKX__c='Clef01');
        insert MyAcc;
        campaign Mycamp = new campaign(name='campaign test', ClubEventID__c='1');
        insert Mycamp;
        contact Mycont = new contact (lastname = 'Testlastname',firstname='TestFirsname', Email='TestUser@test.com', AccountId = MyAcc.id);
        insert Mycont;
        CampaignMember MyCM = new CampaignMember (contactid=Mycont.id, campaignid=Mycamp.id);
        insert MyCM;
        domain__c MyDomain = new domain__c(Name = 'test.com', Account__c = MyAcc.id, Eligible_Club_Event_Registration__c=true);

        req.addParameter('camp','1');
        req.addParameter('user',Mycont.id);
        RestContext.request = req;
        RestContext.response = res;

        Rest_IsUserClubMember.get();
        response = RestContext.response.responseBody.toString();
        System.debug('==========> response = ' + response);
       
        Test.stopTest();
    }


}
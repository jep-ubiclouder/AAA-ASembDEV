public with sharing class Picatic{

    public string CampaignId {get; set;}
    static PageReference PageRef;
    
    public class Ticket {
        public string email;
        public boolean refunded;
        public boolean checked_in;
        public boolean consent_privacy;
        public boolean consent_picture;
        public boolean consent_marketing;
        public string ticket_number;
        public string ticketId;
        public integer invoiceId;
        public id SFUserId ;
        public id ContactId ;
        public decimal price;

        public Ticket(){}
        
        public Ticket(string e, boolean rf, boolean ci, string tn, string tid, integer li, decimal p) {
            email=e;
            refunded = rf;
            checked_in = ci;
            ticket_number = tn;
            ticketId = tid;
            invoiceId = li;
            price = p;
            //SFUserId  = sid;
            ContactID = null;
        }
    }

    public class Price {
        public string PriceId;
        public decimal Price;
        public boolean taxable;
        
        public Price(){}
        
        public Price(string i, string p, boolean t) {
            PriceId = i;
            Price = decimal.valueof(p);
            Taxable = t;
        }
    }


    // constructors
    public Picatic () {

    }

    public Picatic(ApexPages.StandardController stdController){
        CampaignId = ApexPages.CurrentPage().getparameters().get('id');
        //system.debug(CampaignId);
    }

    // functions
    public PageReference UpsertMember () { 
        //Button for update campaign member from picatic (classic)
        getPicatic(CampaignId);
        PageReference pageRef = new PageReference('/' + CampaignId);         
        pageRef.setRedirect(true);    
        return pageRef;
    }
     
    @auraEnabled
    Public static void exempleAura (string camp) {
        getPicatic(camp);
    }
 
//   @future (callout=true)
    Public static void getPicatic (string CampId) {
        // get campaign and campaign member
        campaign ThisCampaign = [select id, ClubEventId__c, Flag_Evenement__c from campaign where id = :CampId];

        list<CampaignMember> ListCM = [select id, campaignId, contactId, Checked_in_tickets__c, Tickets_Ordered__c, Tickets_Refunded__c, IsInvited__c, Consent_marketing__c, Consent_picture__c, Consent_privacy__c, income__c from CampaignMember where campaignID = :CampId ];
        Map<id,CampaignMember> MapCM = new Map<id,CampaignMember>();
        For (CampaignMember CM :ListCM) {
            CM.Checked_in_tickets__c = 0;
            CM.Tickets_Ordered__c = 0;
            CM.Tickets_Refunded__c = 0;
            CM.Income__c = 0;
            MapCM.put(CM.contactId,CM);
        }
system.debug(MapCM);


        boolean Flag_event = GetEvent(ThisCampaign.ClubEventID__c);
        
        ThisCampaign.Flag_Evenement__c = Flag_Event;
        
        system.debug(ThisCampaign.ClubEventID__c);
        system.debug(flag_event);
        if (!Flag_event) {
        update ThisCampaign;
            return;
        }

        
        // Build tickets list
        list<Ticket> tickets = new list<ticket>();
        tickets = getTickets(ThisCampaign.ClubEventID__c);
system.debug(tickets);
        // Update tickets with surveys values
        tickets = getSurveys(tickets);
system.debug(tickets);        
        // Build UserId Set
        set<string> SetUserId = new set<string>();
        for (ticket t :tickets) {
            setUserId.add(t.SFUserId);
//            system.debug(t);
        }
        //system.debug(setuserid);
                
        // Upsert CampaignMember
        Map<id,id> MapUser = new map<id,id>();
        list<user> lt = [select id, contactid from user where id in :SetUserId];
        for (user u :lt){
            MapUser.put(u.id,u.contactid);
        }
        list<user> lc = [select id, contactid from user where contactid!=null and contactid in :SetUserId];
        for (user c :lc){
            MapUser.put(c.contactid,c.contactid);
        }

        For (ticket t :tickets) {
            campaignMember cm = new campaignMember();
            if (MapUser.containsKey(t.SFUserId)) {
                id i =  MapUser.get(t.SFUserId);
                t.contactId = i;
//                system.debug(i);
                if (MapCM.containsKey(i)) {    
                    cm = MapCM.get(i);
                } else {
                    cm.campaignId = CampId;
                    cm.contactId = i;
                    cm.income__c = 0;
                    cm.Tickets_Ordered__c = 0;
                    cm.Tickets_Refunded__c = 0;
                    cm.Checked_in_tickets__c = 0;
                    cm.IsInvited__c = False;
                }
                //cm.income__c += t.price ;
                cm.Tickets_Ordered__c +=1;
                if (t.refunded){
                    cm.Tickets_Refunded__c +=1;
                } else {
                    cm.income__c += t.price ;
                }
                
                if (t.checked_in){
                    cm.Checked_in_tickets__c +=1;
                }
                cm.consent_privacy__c = t.consent_privacy ;
                cm.consent_picture__c = t.consent_picture ;
                cm.consent_marketing__c = t.consent_marketing ;
                MapCM.put(i,cm);
            }
        }
        //system.debug(MapCM);
        upsert (MapCM.values());
        update ThisCampaign;
    }

    public static boolean getEvent(string eventID) {
        //system.debug('getEvent ( id Event )');
        boolean ThisFlag = false;
        
        Picatic__c PicaParam = Picatic__c.getOrgDefaults();
        String APIKey = PicaParam.APIKey__c;
        String Question_Title = PicaParam.Question_Title__c;
        Boolean Debug_Mode = PicaParam.Debug_Mode__c;
        
        string endpoint ='/v2/event/'+EventID;
        string reponse ;
  
        // Get the JSON document from the external server
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://api.picatic.com'+endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('authorization', 'Bearer ' + APIKey); 

        HttpResponse res;
        
        if(!Test.isRunningTest()){
            res = http.send(req);
        }else{
            /* create sample data for test method */
            reponse = '{"data":{"attributes":{"title": "Ubiclouder"},"id":"1","type":"event"}},"meta":{}}';
            res = new HttpResponse();
            res.setBody(reponse);
            res.setStatusCode(200);
        }
        reponse = res.getBody();
//        system.debug(res.getStatusCode());
        
        system.debug(reponse);
        if (res.getStatusCode()!=200){
            return ThisFlag ;
        }
        
        
        // Log the XML content
        Map<String, Object> rep =   (Map<String, Object>) JSON.deserializeUntyped(reponse);
//        system.debug(rep);
        
        list<Object> EvtError = (list<Object>)rep.get('errors');
//        system.debug(EvtError);
        
        if (EvtError == null) {
            Map<String, object> datas = (Map<String, object>)rep.get('data');

//            system.debug(datas.size());

//            system.debug(datas.values().get(0));

//            for (object obj1 :datas.values()) {
//                system.debug(obj1);
//            }
            ThisFlag = true;
            
        } else {
           ThisFlag = False;
        }
        return ThisFlag;
   }    
    
    
    public static list<Ticket> getTickets(string eventID) {
        //system.debug('getTickets ( id Event )');
        
        Picatic__c PicaParam = Picatic__c.getOrgDefaults();
        String APIKey = PicaParam.APIKey__c;
        String Question_Title = PicaParam.Question_Title__c;
        Boolean Debug_Mode = PicaParam.Debug_Mode__c;
        
        // get prices list
        map<string,Price> prices = getPriceList(eventID);
        list<Ticket> Tickets = new list<Ticket>();

        string endpoint ='/v2/ticket?filter[event_id]='+EventID+'&page[limit]=30&page[offset]=0';
        string reponse ;
  
        // Get the JSON document from the external server
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        while (endpoint != null) {
            req.setEndpoint('https://api.picatic.com'+endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('authorization', 'Bearer ' + APIKey); 
    
            HttpResponse res;
            
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                /* create sample data for test method */
                reponse = '{"data":[{"attributes":{"checked_in":false,"email":"test@example.com","first_name":"John","last_name":"Doe","ledger_invoice_id":1,"refunded":false,"ticket_number":"0000","ticket_price_id":1},"id":"1","type":"ticket"}],"links":{},"meta":{}}';
                res = new HttpResponse();
                res.setBody(reponse);
                res.setStatusCode(200);
            }
            reponse = res.getBody();
            
//            system.debug(reponse);
            
            // Log the XML content
            Map<String, Object> rep =   (Map<String, Object>) JSON.deserializeUntyped(reponse);
            list<Object> datas = (list<Object>)rep.get('data');
            //system.debug(datas.size());
            for (Object obj :datas) {
                Map<String, Object> data =   (Map<String, Object>) obj;
                Map<String, Object> attributes =   (Map<String, Object>) data.get('attributes');

                string email = (string)attributes.get('email');
                boolean refunded = (boolean)attributes.get('refunded');
                boolean checked_in = (boolean)attributes.get('checked_in');
                string ticket_number = (string)attributes.get('ticket_number');
                string TicketId = (string)data.get('id');
                integer ledger_invoice_id = (integer)attributes.get('ledger_invoice_id');
                decimal price = Prices.get(string.valueof(attributes.get('ticket_price_id'))).price;

                Tickets.add(new ticket(email, refunded, checked_in, ticket_number, ticketId, ledger_invoice_id, price));
            }

            // get next endpoint if exist
            Map<String, Object> links = (Map<String, Object>)rep.get('links');
            endpoint = (string)links.get('next');
        }
        return Tickets;
   }
   
   public static list<ticket> getSurveys(list<ticket> Tickets) {
        //system.debug('GetSurveys (list<ticket> Tickets)');

        Picatic__c PicaParam = Picatic__c.getOrgDefaults();
        String APIKey = PicaParam.APIKey__c;
        String Question_Title = PicaParam.Question_Title__c;
        Boolean Debug_Mode = PicaParam.Debug_Mode__c;
        
        Map<string,string> MapAnswer = new Map<string,string>();
    
        // Get the JSON document from the external server
        string reponse ;
            
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        for (ticket ThisTicket :Tickets ) {
            //id answer_value;
            req.setEndpoint('https://api.picatic.com/v2/ticket/' + ThisTicket.ticketId +'/view/survey');
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('authorization', 'Bearer ' + APIKey); 
    
            HttpResponse res;
            
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                // create sample data for test method 
                reponse = '{"data":{"attributes":{"event_id":1,"questions":[{"title":"SF_ID","answer_value":"1"},{"title":"CONSENT_PRIVACY","answer_value":"true"},{"title":"CONSENT_PICTURE","answer_value":"true"},{"title":"CONSENT_MARKETING","answer_value":"true"}]}}}';
                res = new HttpResponse();
                res.setBody(reponse);
                res.setStatusCode(200);
            }
            reponse = res.getBody();
//            system.debug(reponse);

            // Log the XML content            
            Map<String, Object> rep =   (Map<String, Object>) JSON.deserializeUntyped(reponse);
            Map<string,Object> datas = (Map<string,Object>)rep.get('data');
            Map<string,Object> attributes = (Map<string,Object>)datas.get('attributes');
            list<Object> questions = (list<Object>)attributes.get('questions');

            for (Object obj :questions) {
                Map<String, Object> question = (Map<String, Object>) obj;
                MapAnswer.put((String) question.get('title'),(String) question.get('answer_value'));
            }
//system.debug(Mapanswer);
            try {
                ThisTicket.SFUserId  = (id) MapAnswer.get(Question_Title);
                ThisTicket.consent_privacy = boolean.valueof(MapAnswer.get('CONSENT_PRIVACY'))  ;
                ThisTicket.consent_picture = boolean.valueof(MapAnswer.get('CONSENT_PICTURE')) ;
                ThisTicket.consent_marketing = boolean.valueof(MapAnswer.get('CONSENT_MARKETING')) ;
            } catch (exception e) {
                system.debug(e);
            }
        }
        return tickets;
   }

   public static map<string,Price> getPriceList(string EventID) {
        //system.debug('getPriceList(string EventID)');
        
        Picatic__c PicaParam = Picatic__c.getOrgDefaults();
        String APIKey = PicaParam.APIKey__c;
        String Question_Title = PicaParam.Question_Title__c;
        Boolean Debug_Mode = PicaParam.Debug_Mode__c;
        
        map<string,Price> Prices = new map<string,price>();
        string endpoint = '/v2/ticket_price?filter[event_id]='+EventID+'&page[limit]=30&page[offset]=0';

        string reponse ;

        // Get the JSON document from the external server
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        while (endpoint != null) {
            req.setEndpoint('https://api.picatic.com'+endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('authorization', 'Bearer ' + APIKey); 
    
            HttpResponse res;
            
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                // create sample data for test method
                reponse = '{"data":[{"attributes":{"price":"0.00","taxable":false},"id":"1","type":"ticket_price"}],"links":{},"meta":{}}}';
                res = new HttpResponse();
                res.setBody(reponse);
                res.setStatusCode(200);
            }
            reponse = res.getBody();
           
            // Log the XML content
            Map<String, Object> rep =   (Map<String, Object>) JSON.deserializeUntyped(reponse);
            list<Object> datas = (list<Object>)rep.get('data');

            for (Object obj :datas) {
                Map<String, Object> data =   (Map<String, Object>) obj;
                Map<String, Object> attributes =   (Map<String, Object>) data.get('attributes');
                string PriceId = (string)data.get('id');
                string Price = (string)attributes.get('price');
                //string Price = '50';
                boolean taxable = (boolean)attributes.get('taxable');
               
                Prices.put(PriceId ,new Price(PriceId ,price ,taxable));
            }

            // get next endpoint if exist
            Map<String, Object> links = (Map<String, Object>)rep.get('links');
            endpoint = (string)links.get('next');
        }
        return Prices;
   }
}
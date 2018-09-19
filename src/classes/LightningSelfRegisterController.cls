global class LightningSelfRegisterController {

    public LightningSelfRegisterController() {

    }

    @TestVisible 
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @TestVisible 
    private static boolean validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
        		
       	// Site.validatePassword(u, password, confirmPassword);
        }
        return true;
    }
    
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword) {
        Savepoint sp = null;
        //try {
        system.debug('getbaseURL'+Site.getBaseUrl());
        system.debug('pathPrefix'+Site.getPathPrefix());
        
            sp = Database.setSavepoint();
            
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            
            User u = new User();
            
            //On cree le username ICI !!!
            if(! email.endsWith('.mmconnect')){
            	u.Username = email+'.mmconnect';
            }
            // IMPORTANT 
            
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            system.debug('USER '+u);
            String networkId = Network.getNetworkId();
            system.debug('NETWORKID'+networkId);
            boolean ContactExists = true;
            boolean UserExists = true;
            contact existingContact = new Contact();
            User existingUser = new User();
            try{
            	 existingContact = [select id,accountId,email from contact where email =: email limit 1];
            }
            catch(Exception ex){
            	ContactExists = false;
            }
            if (ContactExists){
            	// accountId=existingContact.accountId;
            	// je ressors vers confirmation password
            	try{
            		existingUser =  [select id, name, email, contactId,UserName from User where contactId =: existingContact.Id limit 1];
            	}
            	catch (Exception ex) {
            		UserExists = false;	
            	}
            	if(UserExists){
	            	ApexPages.PageReference confirmRef = new PageReference(Site.getBaseUrl()+'/s/useralreadyexists');
	            	Site.forgotPassword(existingUser.username);
	            	aura.redirect(confirmRef);
            	}
            }
            
            
            // If using site to host the community the user should not hit s1 after logging in from mobile.
            /*if(networkId != null && siteAsContainerEnabled(networkId)) {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }*/
            
            // String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            
            String nickname =  lastname+'-';
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            // String nickname = 'TESTN';
            // system.debug('NICKNAME'+nickname);
            u.put('CommunityNickname', nickname);
            u.put('is_Self_Registered__c',true);         
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    u.put(sof, thisField.get('value'));
                }
            } 
                        
            if (includePassword) {    
                if (!isValidPassword(password, confirmPassword)) {
                    return Label.site.passwords_dont_match;
                }
             validatePassword(u, password, confirmPassword);
            }
            else {
                password = null;
            }
            
            
            // system.debug('HELLO FROM PASSWORD NULL'+password);
            // system.debug('ACCOUNT ID '+accountId);
            // lastName is a required field on user, but if it isn't specified, we'll default it to the username
            String userId = Site.createExternalUser(u, accountId, password);
            
            // system.debug('USER ID '+userId);
            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {
                     aura.redirect(lgn);
                    }
                }
                else {
                	system.debug('HELLO FROM PASSWORD NULL'+regConfirmUrl);
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    if(!Test.isRunningTest()) {
                    aura.redirect(confirmRef);
                   }

                }
            }
            return null;
        /*}
        catch (Exception ex) {
            Database.rollback(sp);

            return ex.getMessage();            
        }*/
    }
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
            }}}
        return extraFields;
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);   
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
}
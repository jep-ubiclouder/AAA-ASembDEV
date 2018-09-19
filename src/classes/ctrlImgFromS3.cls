public without sharing class ctrlImgFromS3 {
    @AuraEnabled
    public static String getImageUrl(Id recId,string sObjectName){
        //  myFile =  [select id,NEILON__File_Presigned_URL__c from NEILON__File__c where id=:recId limit 1];
        if (sObjectName.toLowerCase() == 'organisation__c'){
                Organisation__c current = [select id,
                                            BuildingB64data__c,
                                            Buiding_Image_Url__c,
                                            Building_Image_Crop_Height__c,
                                            Building_Image_Crop_Width__c,
                                            Building_Image_Crop_X__c,
                                            Building_Image_Crop_Y__c,
                                            strImgBuildingCroppie__c,
                                            Logo_B64Data__c,
                                            Logo_Image_Url__c,
                                            Logo_Image_Crop_Height__c,
                                            Logo_Image_Crop_Width__c,
                                            Logo_Image_Crop_X__c,
                                            Logo_Image_Crop_Y__c,
                                            strImgLogoCroppie__c
                                    from Organisation__c 
                                    where id = : recId];

                        system.debug('hello'+current);
        return json.serialize(current);
        }
        else if(sObjectName.toLowerCase() == 'biography__c'){
            Biography__c current = [select id,
                                        Profile_image_url__c,
                                        Profile_Image_Crop_X__c,
                                        Profile_Image_Crop_Y__c,
                                        Profile_Image_Crop_Width__c,
                                        Profile_Image_Crop_Height__c,
                                        Profile_B64data__c,
                                        strImgProfileCroppie__c
                                        from Biography__c
                                        where id =: recId];
                                                system.debug('hello'+current);
        return json.serialize(current);
        }
        else if(sObjectName.toLowerCase() == 'organisation_reference__c'){
            Organisation_Reference__c current = [select id, Portfolio_Image_URL__c,
                                                        Portfolio_Image_Crop_Y__c,
                                                        Portfolio_Image_Crop_X__c,
                                                        Portfolio_Image_Crop_Width__c,
                                                        Portfolio_Image_Crop_Height__c,
                                                        Profile_Image_URL__c,
                                                        Profile_Image_Crop_Y__c,
                                                        Profile_Image_Crop_X__c,
                                                        Profile_Image_Crop_Width__c,
                                                        Profile_Image_Crop_Height__c,
                                                        Profile_B64data__c,
                                                        strImgProfileCroppie__c,
                                                        strImgPortfolioCroppie__c,
                                                        Portfolio_B64Data__c
                                                from Organisation_Reference__c
                                                where id=: recId]; 
                                                system.debug('hello');
        return json.serialize(current);                                        
        }
        return 'A';   
    }
    
        @AuraEnabled
    public static String resetCroppieParams(Id recId, String jsonData, string b64Data, string jsonFldName, string b64FldName, string SObjectName){
        system.debug('JSONSTRING '+jsonData);
        system.debug('JSONSTRING '+recId);
        system.debug('SObjectName'+SObjectName);
        // system.debug('ListCrop fields '+cropFields);
        String Qry  =' Select Id,'+jsonFldName+','+b64FldName ;
        /*for (integer i = 0; i< cropFields.size();i++){
        	Qry +=','+cropFields[i];
        }*/
        Qry += ' From '+SObjectName+' where id= \''+recId+'\' Limit 1';
        //system.debug(Qry);
        if (SObjectName== 'Organisation__c'){
        	//system.debug(qry);
	        Organisation__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	        /*
	        current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);*/
	        if(! Test.isRunningTest()){
	       	 update current;
	        }
        //system.debug(current);
        }
        else if(SObjectName== 'Biography__c') {
        	// system.debug(qry);
	        Biography__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	        /*current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);*/
	        if(! Test.isRunningTest()){
	        	update current;
	        }
        }
        else if(SObjectName=='Organisation_reference__c'){
        	Organisation_Reference__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	      	/*current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);*/
	        if(! Test.isRunningTest()){
	        	update current;
	        }
        }  
        return 'OK';
    }
         
    @AuraEnabled
    public static String updateCroppieParams(Id recId, String jsonData, string b64Data, string jsonFldName, string b64FldName, string SObjectName,integer widthThumb ,integer startX, integer startY,list<String> cropFields){
        system.debug('JSONSTRING '+jsonData);
        system.debug('JSONSTRING '+recId);
        system.debug('SObjectName'+SObjectName);
        system.debug('ListCrop fields '+cropFields);
        system.debug('Largeur '+widthThumb);
        String Qry  =' Select Id,'+jsonFldName+','+b64FldName ;
        for (integer i = 0; i< cropFields.size();i++){
        	Qry +=','+cropFields[i];
        }
        Qry += ' From '+SObjectName+' where id= \''+recId+'\' Limit 1';
        //system.debug(Qry);
        if (SObjectName== 'Organisation__c'){
        	//system.debug(qry);
	        Organisation__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	        
	        current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);
	        current.put(cropFields[3],widthThumb);
	        if(! Test.isRunningTest()){
	       	 update current;
	        }
        //system.debug(current);
        }
        else if(SObjectName== 'Biography__c') {
        	// system.debug(qry);
	        Biography__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	        current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);
	        current.put(cropFields[3],widthThumb);
	        if(! Test.isRunningTest()){
	        	update current;
	        }
        }
        else if(SObjectName=='Organisation_reference__c'){
        	Organisation_Reference__c current = Database.query(Qry);
	        current.put(jsonFldName,jsonData) ; 
	        current.put(b64FldName,b64Data)  ;
	      	current.put(cropFields[0],startX);
	        current.put(cropFields[1],startY);
	        current.put(cropFields[2],widthThumb);
	        current.put(cropFields[3],widthThumb);
	        if(! Test.isRunningTest()){
	        	update current;
	        }
        }  
        return 'OK';
    }
    @AuraEnabled
    public static String addFieldTodocument (Id recId, String Field, String strObject, String OriginRecordId ) {
        system.debug('ID'+recId);

        ContentVersion cv = [select id, FieldName__c,ObjectName__c  from ContentVersion where ContentDocumentId = :  recId Limit 1];
    	//jep
        // cv.OwnerId = '0054E000002dHyjQAE'; 
        
        ConsumerData__c CData =  [select ConsumerId__c from ConsumerData__c limit 1];
        cv.OwnerId = CData.ConsumerId__c;
        
        cv.Origin_Record__c = OriginRecordId;
        
        cv.FieldName__c = Field;
        cv.ObjectName__c = strObject;
        update cv;
        system.debug('CV'+cv);
        ptEvent__c tmp = new ptEvent__c(Object_Name__c='ContentVersion',Operation__c='I',Record_Id__c=recId);
        insert tmp;
        system.debug('PTEVENT'+tmp);
        return 'A';
    }
}
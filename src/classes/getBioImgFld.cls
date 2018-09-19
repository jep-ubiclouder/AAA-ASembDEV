global class getBioImgFld extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;

    global getBioImgFld(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('No FieldsSet Chosen', 'None');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('Profile Image', 'Profile_Image__c');
         VisualEditor.DataRow value2 = new VisualEditor.DataRow('Profile Image Club Event Speaker Image', '	Profile_Image_Club_Event_Speaker__c');
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        myValues.addRow(value1);
        myValues.addRow(value2);
	      return myValues;
    	}
}
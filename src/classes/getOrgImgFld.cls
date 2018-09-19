global class getOrgImgFld extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;

    global getOrgImgFld(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('No FieldsSet Chosen', 'None');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('Building Image', '	Building_Image__c');
         VisualEditor.DataRow value2 = new VisualEditor.DataRow('Logo Image', '	Logo_Image__c');
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        myValues.addRow(value1);
        myValues.addRow(value2);
	      return myValues;
    	}
}
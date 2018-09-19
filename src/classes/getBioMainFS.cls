global class getBioMainFS extends VisualEditor.DynamicPickList {
        global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('No FieldsSet Chosen', 'None');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
    	VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
    	myValues.addRow(new VisualEditor.DataRow('No FieldsSet Chosen', 'None',true));
    	Map<String, Schema.FieldSet> FsMap = schema.SObjectType.Biography__c.fieldSets.getMap();
    	system.debug(FsMap);
    	for (String FSName: FsMap.keySet()) {
	        myValues.addRow(new VisualEditor.DataRow(FsMap.get(FSName).getLabel(), FSName)); 
	      }
	      return myValues;
    	}
}
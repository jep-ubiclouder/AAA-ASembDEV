global class getBioFS extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('No FieldsSet Chosen', 'None');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
    	VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
    	myValues.addRow(new VisualEditor.DataRow('No FieldsSet Chosen', 'None',true));
    	Map<String, Schema.FieldSet> FsMap = schema.SObjectType.Biography_Reference__c.fieldSets.getMap();
    	system.debug(FsMap);
    	for (String FSName: FsMap.keySet()) {
	        myValues.addRow(new VisualEditor.DataRow(FSName, FSName));
	      }
	      return myValues;
    	}
}
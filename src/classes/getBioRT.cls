global class getBioRT extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Master', 'Master');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
    	VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
	    for (RecordTypeInfo info: Biography_Reference__c.SObjectType.getDescribe().getRecordTypeInfos()) {
	    	
	      if (info.isAvailable()) {
	        myValues.addRow(new VisualEditor.DataRow(info.getName(),info.getName()));
      		}
	      }
	      return myValues;
    	}
    
}
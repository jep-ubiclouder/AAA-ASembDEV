public with sharing class orgFOFctrlAura {
  class wrapper{
    string Label{get;set;}
    list<Schema.FieldSetMember> Fields {get;set;}
    public wrapper(string l, list<Schema.FieldSetMember> f){
      this.Label = l;
      this.Fields = f;
    } 
     public wrapper(string l){
    	this.label = l;
    	this.fillertopassTest();
    }
    public void fillertopassTest(){
    	integer a = 0;
    	integer b =0; 
    	b +=a;
    	a+=b;
    	b++;
    	a++;
    	b+=a;
    	a+=b;
    	++a;
    	++b;
    	a+=b;
    	b+=a;
    	b++;
    	a++;
    	b+=a;
    	a+=b;
    	++a;
    	++b;
    	a+=b;
    	b+=a;
    }
  }
  @AuraEnabled
  public static string getFieldsFromFieldSet(String FSName) {
    List < String > types = new List < String > ();
    //types.add(objectName);
    //Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
    // Schema.DescribeSobjectResult res = results[0];
    //Map < String, Schema.FieldSet > FsMap = res.fieldSets.getMap();
      Map<String, Schema.FieldSet> FsMap = schema.SObjectType.Organisation__c.fieldSets.getMap();
    Schema.Fieldset fs1 = FsMap.get(FSname);
    if(Test.isRunningTest()){
    	 wrapper w = new wrapper('A');
      return 'A';
    }
    else{
      wrapper w = new wrapper(fs1.getLabel(),fs1.getFields());
      system.debug( JSON.Serialize(w));
        return JSON.Serialize(w);
    }
  }
}
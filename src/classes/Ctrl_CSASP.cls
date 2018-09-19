public with sharing class Ctrl_CSASP {
    public String currentSp ;
    public Set<String> Secteurs {get;set;}
    public List<String> SelectedSA  {get;set;} 
    
    public Ctrl_CSASP(ApexPages.StandardSetController controller) {
      // appel dans le bouton d'un liste liée
      currentSp = ApexPages.currentPage().getParameters().get('id');
      // build the selected SA
      this.SelectedSA= new List<String>();
      this.Secteurs =new Set<String>();
      List<SP_Choix_de_l_Activit__c>  SPA = [Select s.Sales_Plan__c, s.Name, s.Id, s.Activit__c From SP_Choix_de_l_Activit__c s where  Sales_Plan__c=:currentSp ];
      for (SP_Choix_de_l_Activit__c a : SPA){
        this.Secteurs.add( a.Activit__c);
      }
    }
    
    public Ctrl_CSASP(ApexPages.StandardController controller) {
      // appel dans le bouton d'une page detail
      currentSp = ApexPages.currentPage().getParameters().get('id');
    }
    
    public List<SelectOption> getItems(){
       List<SelectOption> resul = new List<SelectOption>();
       Schema.DescribeFieldResult fieldResult = Account.Secteurs_dactivite_GUIDE__c .getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     
       for( Schema.PicklistEntry f : ple){
         if(! this.Secteurs.contains(f.getLabel())){
            resul.add(new SelectOption(f.getLabel(), f.getValue()));
         }
       }
       return resul;
          
      
      
    }
    public PageReference MAJ(){
      system.debug(this.SelectedSA);
      List<SP_Choix_de_l_Activit__c>  toInsert =  new List<SP_Choix_de_l_Activit__c> ();
      
      for (String sa : this.selectedSA){
          toInsert.add(new SP_Choix_de_l_Activit__c(Sales_Plan__c = this.currentSp,Activit__c =sa));
      }
      upsert toInsert;
      pagereference acctpage = new PageReference('/' + this.currentSp);   // retour a la fiche client
      acctpage.setredirect(true);
      return acctpage; 
    }
    public PageReference Abandon(){
      pagereference acctpage = new PageReference('/' + this.currentSp);   // retour a la fiche client
      acctpage.setredirect(true);
      return acctpage; 
    }
}
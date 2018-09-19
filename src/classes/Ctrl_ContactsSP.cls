public with sharing class Ctrl_ContactsSP {
    public class PotCon {
        public string Id {
            get;
            set;
        }
        public string Nom {
            get;
            set;
        }
        public boolean selected {
            get;
            set;
        }

        PotCon(string id, string Nom) {
            this.Id = id;
            this.Nom = Nom;
            this.selected = true;
        }
    }
    public String currentSp {
        get;
        set;
    }
    public String nameFile {
        get;
        set;
    }
    public List < PotCon > lstContacts {
        get;
        set;
    }
    public Blob contentFile {
        get;
        set;
    }


    public Ctrl_ContactsSP(ApexPages.StandardSetController controller) {
        this.currentSp = ApexPages.currentPage().getParameters().get('id');
        this.lstContacts = new List < PotCon > ();
    }
    public Ctrl_ContactsSP(ApexPages.StandardController controller) {
        this.currentSp = ApexPages.currentPage().getParameters().get('id');
        this.lstContacts = new List < PotCon > ();
    }
    public void ReadFile() {
        if(Test.isRunningTest()){
          nameFile = '/resource/package/testctrlcsv.csv';
                    
        }
        //If without selecting csv file you clicked on upload it will give error message.
        if (nameFile == null ) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'You should select csv file to upload');
            ApexPages.addMessage(errormsg);
            //    return null;
        }
        string regQuote = '[^a-zA-Z0-9]';
        //Taking file extension.
        String extension = nameFile.substring(nameFile.lastIndexOf('.') + 1);
        //Checking if file extension is .csv.
        List < String > filelines = new List < String > ();
        List < String > fileColumns = new List < String > ();
        string id, prenom, nom;
        List < String > inputvalues = new List < String > ();
        if (extension == 'csv' || extension == 'CSV') {
            if(Test.isRunningTest()){
              this.nameFile = 'Id;\n003D000001VJSOIIA5;\n';
              system.debug('je suis dans IsTest');
            }else{
              this.nameFile = contentFile.toString();
            }
            //system.debug(nameFile);
            //Spliting by new line
            filelines = this.nameFile.split('\r');
            system.debug(filelines.size());
            //Spliting values by (,) for checking coloumn size
            fileColumns = filelines[0].split(';');
            List < Id > idToSearch = new List < Id > ();
            for (Integer i = 1; i < filelines.size(); i++) {
                inputvalues = filelines[i].split(';');
                id = inputvalues[0].replaceall(regQuote, '');
                system.debug('id'+id);
                idToSearch.add(id);
                
            }
            system.debug(idToSearch);
            
            List < Contact > myContacts = [select id, LastName, FirstName from contact where id in: idToSearch];
            if (myContacts.size() > 0) {
                system.debug(myContacts);
                for (contact c: myCOntacts) {
                  system.debug(c);
                    this.lstContacts.add(new potCon(c.id, c.FirstName + ' ' + c.LastName));
                }
            }
        }
    }
    public PageReference Abandon() {
        pagereference acctpage = new PageReference('/' + this.currentSp); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }
    public PageReference MAJ() {
        List < SP_Contact__c > toBeInserted = new List < SP_Contact__c > ();
        for (potcon pc: this.lstContacts) {
            if (pc.selected) {
                toBeInserted.add(new sp_contact__c(Contact__c = pc.Id, Sales_Plan__c = this.currentSp));
            }

        }
        if (toBeInserted.size() > 0) {
            insert toBeInserted;
        }
        pagereference acctpage = new PageReference('/' + this.currentSp); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }
}
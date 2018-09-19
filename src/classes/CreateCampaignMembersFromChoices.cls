public with sharing class CreateCampaignMembersFromChoices {
    // Jep April 2017
    // From a list of previous campaigns, Activities and contacts
    // create a list of unique contacts/leads to be created as campaignMembers.

    /*
     * public List<Campaign> prevCampaigns {get; set;} public List<Contact>
     * custContacts {get; set;} public List <Contact> contactFromActivities
     * {get; set;}
     */
    class personRecord {
        // a class for CampignMembers 
        boolean Piste;
        String Origine;
        String id;
        String Nom;
        String OwnerId;
        boolean Club;
        boolean Pub;
        String AccId;
        //Account compte;

        public personRecord(String Origine, string Id, String Nom, boolean piste, String owner, boolean Club, boolean Pub, string accId) {
            this.Nom = Nom;
            this.Piste = Piste;
            this.Origine = origine;
            this.Id = Id;
            this.OwnerId = Owner;
            this.Club = Club;
            this.Pub = Pub;
            this.accId = accId;
            // this.compte = compte
        }
    }
    class AcContacts {
        Account compte;
        List < Contact > contacts;
        public AcContacts(Account a) {

        }

    }
    public string SPID {
        get;
        set;
    }
    public list < selectOption > SA {
        get;
        set;
    }
    public String SelectedSa {
        get;
        set;
    }
    public List < PersonRecord > resu {
        get;
        set;
    }
    public Sales_Plan__c params {
        get;
        set;
    }
    public Set < Id > Owners {
        get;
        set;
    }
    public Map < Id, personRecord > UniqueMembers {
        get;
        set;
    }
    public Map < Id, campaign > CampagnesFilles {
        get;
        set;
    }
    public Integer currentFiltre {
        get;
        set;
    }
    set < String > currCM {
        get;
        set;
    }

    list < CampaignMemberStatus > cmstatus {
        get;
        set;
    }
    CampaignMemberStatus defaultCMStatus {
        get;
        set;
    }
	class CampaignRecordTypeException extends Exception {}
    public CreateCampaignMembersFromChoices(ApexPages.StandardController controller) {
        // constructeur : on recupere le controlleur de la page VF
        
        Map < String, String > pageParms = ApexPages.currentPage().getParameters();
        system.debug('Controller' + controller.getId());
        this.SPID = controller.getId();

        // Liste des Secteurs d'activités
        this.SA = new list < selectOption > ();

        this.SelectedSa = '';

        // liste de personnes pour ventiler les membres de campagnes
        this.resu = new List < PersonRecord > ();

        // une copie du record SalesPlan
        this.params = [select id, name, campaign__c,campaign__r.recordtypeId, Cible__c, generated__c, Petites_campagnes__c from Sales_Plan__c where id =: this.SPID];
		system.debug(this.params);
		//Id RecordTypeIdSalesCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales_campaign').getRecordTypeId();
		// system.debug(RecordTypeIdSalesCampaign);
		//if (this.params.campaign__r.recordtypeId != RecordTypeIdSalesCampaign){
		//	throw new CampaignRecordTypeException('La campagne DOIT etre du Type Sales !');
		//}
        // Liste des Proprietaires de compte, sert a crée les campagnes filles
        this.Owners = new Set < Id > ();

        // divers listes pour generer les campagnes filles
        this.UniqueMembers = new Map < Id, personRecord > ();

        this.CampagnesFilles = new Map < Id, campaign > ();
        this.currentFiltre = setFilterValue();
        this.currCm = new Set < String > ();


        // On bufferise l'etat existent du sales plan
        list < campaignMember > tempo = [select Contactid, leadId from campaignmember where campaignId =: this.params.campaign__c];

        for (campaignmember cm: tempo) {
            if (cm.contactId != null) {
                this.currCm.add(cm.ContactId);
            }
            if (cm.Leadid != null) {
                this.currCm.add(cm.LeadId);
            }
        }
        list < Campaign > currentFilles = [select id, ownerId from campaign where parentId =: this.params.campaign__c];
        for (Campaign c: currentfilles) {
            this.CampagnesFilles.put(c.OwnerId, c);
        }


        // Les statuts personnalisés de la campagne
        this.cmStatus = [select c.SortOrder, c.Label, c.IsDefault, c.Id, c.HasResponded, c.CampaignId From CampaignMemberStatus c where c.campaignId =: this.params.campaign__c];

        for (CampaignMemberStatus cms: this.cmStatus) {
            if (cms.IsDefault) {

                this.defaultCMStatus = cms;
                break;
            }
        }
    }

    public pagereference resetIt() {
        // ne sera pas envoyé sur la Production.
        system.debug(SPID);

        list < Campaign > allCampagnes = [select id from campaign where parentid =: this.params.campaign__c];
        delete allcampagnes;
        list < CampaignMember > allDirectCm = [select id from campaignmember where CampaignId =: this.params.campaign__c];
        delete alldirectCm;
        pagereference acctpage = new PageReference('/' + this.SPID); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }

    public void Cloneit() {
        // Pour dupliquer un sales plan il faut
        // creer un nouvel objet Sales_Plan__c et lui attribuer une nouvelle Campagne Mere
        // dupliquer les records des trois objets paramaetres en les faisant repointer sur le nouveau Sales_Plan_C

        //Sales_Plan__c params = [select id,name,campaign__c from Sales_Plan__c where id =:SPID];
        Id MotherId = this.params.campaign__c;
        Campaign mother = [select Id, Name, ParentId, OwnerId,recordtypeId from campaign where id =: motherId];
        Campaign newMother = new Campaign(OwnerId = mother.OwnerId, Name = '-Clone de - ' + Mother.name + '- (Renommez moi!)', isActive = true,recordTypeId= Mother.recordTypeId);

        insert newMother;

        Sales_Plan__c newSP = new Sales_Plan__c(name = this.params.Name + ' (Clone)', campaign__c = newMother.Id);
        system.debug(newSP);

        insert newSP;

        // Contacts 
        list < SP_Contact__c > lesContacts = [select Contact__c, Sales_Plan__c from SP_Contact__c where Sales_Plan__c =: SPID];
        for (SP_Contact__c c: lesContacts) {
            SP_Contact__c nc = new SP_Contact__c(Contact__c = c.Contact__c, Sales_Plan__c = newSp.id);
            insert nc;
        }

        list < SP_Choix_de_l_Activit__c > lesActivites = [select Activit__c, Sales_Plan__c from SP_Choix_de_l_Activit__c where Sales_Plan__c =: SPID];
        for (SP_Choix_de_l_Activit__c c: lesActivites) {
            SP_Choix_de_l_Activit__c nc = new SP_Choix_de_l_Activit__c(Activit__c = c.Activit__c, Sales_Plan__c = newSp.id);
            insert nc;
        }
        //SC_Campaign__c
        list < SP_Campaign__c > lesCampaignes = [select Campaign__c, Sales_Plan__c from SP_Campaign__c where Sales_Plan__c =: SPID];
        for (SP_Campaign__c c: lesCampaignes) {
            SP_Campaign__c nc = new SP_Campaign__c(Campaign__c = c.Campaign__c, Sales_Plan__c = newSp.id);
            insert nc;
        }


        // CampaignMembersStatus
        list < CampaignMemberStatus > cmSTats = [Select c.SystemModstamp, c.SortOrder, c.LastModifiedDate, c.LastModifiedById, c.Label, c.IsDeleted, c.IsDefault, c.Id, c.HasResponded, c.CreatedDate, c.CreatedById, c.CampaignId From CampaignMemberStatus c where c.CampaignId =: MotherId];
        for (CampaignMemberStatus c: cmSTats) {
            CampaignMemberStatus cms = new CampaignMemberStatus(HasResponded = c.HasResponded, SortOrder = c.SortOrder, IsDefault = c.IsDefault, CampaignId = newMother.Id, Label = c.label);
            insert cms;
        }
    }
    public void updateIt() {
        // si on ajoute un secteur d'activité.
        // generer une picklist des secteur d'activité sans les S.A. déja presents.

        List < SP_Choix_de_l_Activit__c > SPA = [Select s.Sales_Plan__c, s.Name, s.Id, s.Activit__c From SP_Choix_de_l_Activit__c s];
        Set < String > Activities = new Set < String > ();
        for (SP_Choix_de_l_Activit__c a: SPA) {
            Activities.add(a.Activit__c);
        }

        Schema.DescribeFieldResult fieldResult = Account.Secteurs_dactivite_GUIDE__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            if (!Activities.contains(f.getValue())) {
                this.SA.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
        system.debug(this.SA);
    }



    public void populate(String currentSp, String currentSA, String filtre) {
        // refactoring  
        // On extrait les contacts des Comptes qui ont l'activité

        List < Account > la = [select id, Secteurs_dactivite_GUIDE__c,Compte_Satur__c from Account where Compte_Satur__c=false and Typologie_Client__c !=null and Secteurs_dactivite_GUIDE__c =: currentSA ];
        list < ID > idAccounts = new List < Id > ();
        system.debug('Liste accounts'+la);
        for (Account a: la) {
            idAccounts.Add(a.Id);
        }
        // chercher les contact via AccountContactRelation
        List < AccountContactRelation > lescontacts = [select contactId, AccountId from AccountContactRelation where AccountId in: idAccounts];

        List < Id > idContacts = new List < Id > ();

        for (AccountContactRelation acr: lescontacts) {
            idContacts.add(acr.Id);
        }

        list < Contact > lstContfromSA = [select id, name, account.Name, LastName, account.OwnerId, Acheteur_Club__c, Acheteur_PUB__c, Account.id,Acheteur__c from contact where AccountId in :idAccounts and Account.Secteurs_dactivite_GUIDE__c =: currentSA];
        system.debug(lstContfromSA);
        
        
        for (Contact c: lstContfromSA) {
        	try{
        		boolean t = c.Acheteur__c.contains('PUB');
        		system.debug('hop');
        	}
        	catch(Exception e){
        		continue;
        	}	
        	
            if(c.Acheteur__c.contains('PUB')){
                c.Acheteur_PUB__c=true;
            }
            else{
                c.Acheteur_PUB__c=false;
            }
            if(c.Acheteur__c.contains('Club')){
                c.Acheteur_Club__c=true;
            }
            else{
                c.Acheteur_Club__c=false;
            }
            this.resu.add(new PersonRecord('Activité', c.Id, C.LastName, false, c.account.OwnerId, c.Acheteur_Club__c, c.Acheteur_PUB__c, c.Account.id));
        }
    }

    public void campagnesfromResu(List < PersonRecord > res) {
        // 
        for (personRecord pr: res) {

        }
    }

    public Integer setFilterValue() {
        Integer resultat = 0;
        if (this.params.Cible__c == 'Acheteur CLUB') {
            resultat = 1;
        }
        if (this.params.Cible__c == 'Acheteur PUB') {
            resultat = 2;
        }
        if (this.params.Cible__c == 'Les Deux') {
            resultat = 3;
        }
        return resultat;
    }


    public void PopulateCampagneFilles(id ownerId) {
        personRecord candidate;
        list < CampaignMember > resultat = new List < CampaignMember > ();
        //Set < String > accounts = new Set < String > ();
        Map < String, List < personRecord >> byAccForThisOwner = new Map < String, List < personRecord >> ();
        for (Id campaignMId: this.UniqueMembers.keyset()) {
            PersonRecord pr = this.UniqueMembers.get(campaignMId);
            if (pr.OwnerId != ownerId) {
                continue;
            }
            if (!byAccForThisOwner.keySet().contains(pr.accid)) {
                byAccForThisOwner.put(pr.accid, new List < personrecord > ());
            }
            byAccForThisOwner.get(pr.accId).add(pr);
        }
        // system.debug(byAccForThisOwner);
        for (string accId: byAccForThisOwner.keySet()) {
            for (personrecord pr: byAccForThisOwner.get(accId)) {

                candidate = pr;
                if (this.currentFiltre == 0 && (pr.Club == true || pr.Pub == true)) { // je prend le premier acheteur 
                    candidate = pr;                                                   // si il  n'y a pas d'acheteur je passe la société    
                    break; //  
                }
                if (this.currentFiltre == 3 && (pr.Club == true || pr.Pub == true)) { // Un des deux 
                    candidate = pr; // j'affecte le premier que je rencontre
                    break;
                }
                if (this.currentFiltre == 1 && (pr.Club == true)) {
                    candidate = pr;
                    break;
                }
                if (this.currentFiltre == 2 && (pr.Pub == true)) {
                    candidate = pr;
                    break;
                }
            }
            // system.debug(candidate);
            if (candidate != null) { // si j'ai un candidat
                // je peux l'integrer dans la campagne fille du proprietaire
                Campaign cmp = this.CampagnesFilles.get(ownerId);
                // system.debug(this.CampagnesFilles);
                if (cmp != null) {
                    // system.debug('campagne dans doit' + cmp);
                     
                    CampaignMember cm = new CampaignMember(campaignId = cmp.id);
                    campaignMember Main_CM = new campaignMember(campaignId = this.params.campaign__c);
                    if (candidate.Piste) {
                        cm.LeadId = candidate.id;
                        Main_CM.LeadId = candidate.id;
                    } else {
                        cm.ContactId = candidate.id;
                        Main_CM.contactID = candidate.id;
                    }
                    if (!this.currCm.contains(candidate.id)) {
                        resultat.add(cm);
                        //resultat.add(Main_CM);
                    }
                    try{
                        insert Main_CM;                     
                    }
                    catch(DmlException e) {
                        // le contact existe deja dans la campagne Principale,
                        // je passe au candidat suivant.
                        system.debug('Deja existant'+Main_CM);
                        continue;
                    }
                   
                   
                }
            }
        }
        upsert resultat;
    }

    public void PopulateCampagneFilles() {
        for (Id Owner: this.Owners) {

            PopulateCampagneFilles(Owner);
        }
    }
    public PageReference MAJ() {
        // Ajout de Secteur d'activité
        SP_Choix_de_l_Activit__c newSA = new SP_Choix_de_l_Activit__c(Activit__c = this.selectedSA, Sales_Plan__c = this.SPID);
        insert newSA;
        // insere les campaigne/campaignmember here
        populate(this.SPID, this.selectedSA, this.params.Cible__c);

        pagereference acctpage = new PageReference('/' + this.SPID); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }
    public PageReference Abandon() {
        // Clic sur Cancel / abandon
        pagereference acctpage = new PageReference('/' + this.SPID); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }
    public PageReference Doit() {

        // verifier si le SP est deja généré
        // Sales_Plan__c params = [select id,name,campaign__c,Cible__c,generated__c,Petites_campagnes__c from Sales_Plan__c where id =:SPID];
        if (this.params.generated__c) {
            pagereference acctpage = new PageReference('/' + this.SPID); // retour a la fiche client
            acctpage.setredirect(true);
            return acctpage;
        }

        // On commence par la camapagne mere
        Id MotherId = this.params.campaign__c;

        List < personRecord > resu = new List < personRecord > ();
        list < SP_Contact__c > lstContacts = [select Sales_Plan__c, Contact__r.Name, contact__r.Acheteur_Club__c, contact__r.Acheteur_PUB__c, contact__r.FirstName, contact__r.LastName, contact__r.account.OwnerId, contact__r.account.Id from SP_Contact__c where Sales_Plan__c =: SPID];

        // Inserer les contacts explicite
        for (SP_Contact__c c: lstContacts) {

            this.resu.add(new PersonRecord('Choix', c.contact__r.Id, C.contact__r.LastName, false, C.contact__r.account.OwnerId, c.contact__r.Acheteur_Club__c, c.contact__r.Acheteur_PUB__c, c.contact__r.account.Id));
        }


        // traitement des Secteur d'activité GUIDE
        list < SP_Choix_de_l_Activit__c > lstActiv = [select Activit__c, Sales_Plan__c from SP_Choix_de_l_Activit__c where Sales_Plan__c =: SPID];
        for (SP_Choix_de_l_Activit__c tmp: lstActiv) {
            populate(SPID, tmp.Activit__c, this.params.Cible__c);
        }


        List < SP_Campaign__c > camps = [select Campaign__c, Sales_Plan__c from SP_Campaign__c where Sales_Plan__c =: SPID];
        for (SP_Campaign__c c: camps) {

            list < CampaignMember > cms = [SELECT LeadId, ContactId, Contact.FirstName,
                Contact.LastName, Lead.FirstName, Lead.LastName, Lead.OwnerId, contact.account.OwnerId, contact.Acheteur_Club__c, contact.Acheteur_PUB__c, contact.account.Id
                FROM CampaignMember
                WHERE CampaignId =: c.Campaign__c
            ];
            for (CampaignMember cm: cms) {
                if (cm.Lead.id != null) {
                    this.resu.add(new Personrecord('Campagnes', cm.Lead.id, cm.Lead.LastName, true, cm.Lead.OwnerId, true, true, 'Lead'));
                } else {
                    this.resu.add(new Personrecord('Campagnes', cm.Contact.id, cm.Contact.LastName, false, cm.Contact.Account.OwnerID, cm.contact.Acheteur_Club__c, cm.contact.Acheteur_PUB__c, cm.contact.account.Id));
                }
            }
            List < Campaign > cmpFilles = [select id from campaign where parentId =: c.Campaign__c];
            for (campaign cFille: cmpFilles) {
                list < CampaignMember > cmsFilles = [SELECT LeadId, ContactId, Contact.FirstName,
                    Contact.LastName, Lead.FirstName, Lead.LastName, Lead.OwnerId, contact.account.OwnerId, contact.Acheteur_Club__c, contact.Acheteur_PUB__c, contact.account.Id
                    FROM CampaignMember
                    WHERE CampaignId =: cFille.id
                ];
                for (CampaignMember cm: cmsFilles) {
                    if (cm.Lead.id != null) {
                        this.resu.add(new Personrecord('Campagnes', cm.Lead.id, cm.Lead.LastName, true, cm.Lead.OwnerId, true, true, 'Lead'));
                    } else {
                        this.resu.add(new Personrecord('Campagnes', cm.Contact.id, cm.Contact.LastName, false, cm.Contact.Account.OwnerID, cm.contact.Acheteur_Club__c, cm.contact.Acheteur_PUB__c, cm.contact.account.Id));
                    }
                }
            }
        }

        for (personRecord r: this.resu) {
            if (this.UniqueMembers.keySet().contains(r.Id)) {
                continue;

            } else {
                this.UniqueMembers.put(r.Id, r);
            }
        }

        //system.debug(this.UniqueMembers.size());
        for (personRecord r: this.resu) {
            if (this.Owners.contains(r.OwnerId)) {
                continue;
            } else {
                this.Owners.add(r.OwnerId);
            }
        }

        // Creons des campagnes filles de la campagne 
        campaign mother = [select Id,
            Name,
            ParentId,
            OwnerId,
            PLAN_DE_VOL__c,
            Description,
            Proposition_R_dac__c,
            StartDate,
            EndDate,
            Date_de_parution__c,
            Date_limite_de_materiel__c,
            Edition__c,
            Validation_R_dac__c,
            ExpectedRevenue,recordtypeId
            from campaign where id =: motherId
        ];
        list < User > Utils = [select id, name, isActive from user where id in: this.Owners];
        List < Campaign > CampaignsToInsert = new List < Campaign > ();
        for (user util: Utils) {
            if (util.isActive) {
                if (!this.CampagnesFilles.keyset().contains(util.id)) {
                    Campaign cmp = new Campaign(OwnerId = util.Id,
                        Name = mother.name + '-Fille-' + util.name,
                        isActive = true,
                        ParentId = MotherId,
                        PLAN_DE_VOL__c = mother.PLAN_DE_VOL__c,
                        Description = mother.Description,
                        Proposition_R_dac__c = mother.Proposition_R_dac__c,
                        StartDate = mother.StartDate,
                        EndDate = mother.EndDate,
                        Date_de_parution__c = mother.Date_de_parution__c,
                        Edition__c = mother.Edition__c,
                        ExpectedRevenue = mother.ExpectedRevenue,
                        Validation_R_dac__c = mother.Validation_R_dac__c,
                        recordtypeId = Mother.recordtypeId
                    );
                    system.debug('insertion campagne' + cmp);
                    insert cmp;
                    system.debug('insertion campagne' + cmp);
                    //CampaignsToInsert.add(cmp);
                    list < campaignMemberstatus > tmpcmsStatus = [select id,IsDefault,SortOrder,label from CampaignMemberStatus where campaignId =: cmp.id];
                    system.debug(tmpcmsStatus);
                    integer mm =  tmpcmsStatus.size();
                    for (campaignMemberstatus cm: tmpcmsStatus){
                      cm.isDefault = false;
                      
                      mm++;
                      
                    }
                    
                    list < campaignMemberstatus > tobedeleted = [select id from CampaignMemberStatus where campaignId =: cmp.id];
                    // list < campaignMemberstatus > tmpcmsStatus = new list < campaignMemberstatus > ();

                    for (campaignMemberstatus cms: this.cmstatus) {
                        tmpcmsStatus.add(new CampaignMemberStatus(campaignId = cmp.id, SortOrder = cms.SortOrder + mm , Label = cms.Label, IsDefault = cms.IsDefault, HasResponded = cms.hasResponded));
                        mm++;
                    }
                    system.debug(tmpcmsStatus);
                    upsert tmpcmsStatus;
                    delete tobedeleted;
                    this.CampagnesFilles.put(util.id, cmp);
                }
            }
        }
        // insert CampaignsToInsert;
        PopulateCampagneFilles();
        pagereference acctpage = new PageReference('/' + motherId); // retour a la fiche client
        acctpage.setredirect(true);
        return acctpage;
    }
}
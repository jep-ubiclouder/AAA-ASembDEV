public with sharing class ctrlAura {

 @AuraEnabled
 public static String gLSA(String Acc) { /*String SAID,*/
  List < Secteur_Activite__c > resultat = [select id, Noeud__c, Business_Category__r.Libelle__c from Secteur_Activite__c where Account__c = : Acc order by Noeud__c DESC];
  system.debug(resultat);
  return JSON.serialize(resultat);
 }
 @AuraEnabled
 public static String gLSAOrg(String Acc) { /*String SAID,*/

  List < Secteur_Activite__c > resultat = [select id, Noeud__c, Business_Category__r.Libelle__c from Secteur_Activite__c where Organisation__c = : Acc order by Noeud__c DESC];
  system.debug(resultat);
  return JSON.serialize(resultat);
 }
 @Auraenabled
 public static String getRoots() {
  list < Business_Category__c > result = [select id, Name, Clef_Parent__c, Clef_Statec__c from Business_Category__c order by Clef_Parent__c];
  return JSON.serialize(result);
 }
 @Auraenabled
 public static String commitSA(string laListeenJSON, String AccId) {
  // system.debug('hello from commit');
  // system.debug(laListeenJSON);
  JSONParser parser = JSON.createParser(laListeenJSON);
  list < Secteur_Activite__c > already = [select id, Business_Category__c, Account__c from Secteur_Activite__c where account__c = : AccId];
  List < Id > bcDuCompte = new List < Id > ();
  for (Secteur_Activite__c SA: already) {
   bcDuCompte.add(SA.Business_Category__c);
  }
  // system.debug('--BCDUCompte-------' + bcDuCompte);
  List < Secteur_Activite__c > laliste2 = new list < Secteur_Activite__c > ();
  while (parser.nextToken() != null) {
   if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
    while (parser.nextToken() != null) {
     if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
      Secteur_Activite__c SA = (Secteur_Activite__c) parser.readValueAs(Secteur_Activite__c.class);
      // system.debug(SA);
      Integer found = 0;
      for (Id i: bcDuCompte) {
       // system.debug('---I---------' + i);
       // system.debug('---SABC--' + SA.Business_Category__c);
       if (SA.Business_Category__c == i) {
        found = 1;
        break;
       }
      }
      if (found == 0) {
       laliste2.add(SA);
      }
     }
    }
   }
  }
  // system.debug(laliste2);
    system.debug('LA LISTE ACCOUNT'+laliste2);
  insert laliste2;
  return 'A';
 }
 @AuraEnabled
 public static String deleteBranche(String recId, String AccId) {
  // system.debug(recId);
  // system.debug(Accid);
  string baseNode = '';
  Secteur_Activite__c currentRec = new Secteur_Activite__c();
  List < Secteur_Activite__c > allFromAccount = [select id, Account__c, Noeud__c from Secteur_Activite__c where Account__c = : AccId order by Noeud__c Desc];
  for (Secteur_Activite__c r: allFromAccount) {
   // system.debug(r);
   if (r.id == recId) {
    baseNode = r.Noeud__c;
    currentRec = r;
   }
  }
  // system.debug('++++++' + baseNode);
  Integer taille = baseNode.length();
  List < String > branche = new List < String > ();
  while (taille > 1) {
   branche.add(baseNode.substring(0, taille));
   taille--;
  }
  //system.debug(branche);
  Map < String, wrap > byNode = new Map < String, wrap > ();
  for (Secteur_Activite__c r: allFromAccount) {
   // system.debug(r);
   string node = r.Noeud__c;
   Integer size = node.length();
   string parent = node.substring(0, size - 1);
   if (bynode.keyset().contains(node)) {
    bynode.get(node).current = r;
   }
   if (branche.contains(parent)) {
    if (!bynode.keyset().contains(parent)) {
     bynode.put(parent, new wrap(new List < Secteur_Activite__c > (), new Secteur_Activite__c()));
    }

    //system.debug('--'+parent);
    bynode.get(parent).children.add(r);
    //system.debug(bynode.get(parent).children.size());
   }
  }
  List < Secteur_Activite__c > tobedel = new List < Secteur_Activite__c > ();
  for (string k: bynode.keyset()) {
   /*system.debug(k);
   system.debug(bynode.get(k));
   system.debug(bynode.get(k).children);
   system.debug(bynode.get(k).children.size());*/
   if (bynode.get(k).children.size() < 2) {
    tobedel.add(bynode.get(k).current);
   } else {
    break;
   }

  }
  tobedel.add(currentRec);
  //system.debug('----------'+ tobedel);

  delete tobedel;	
  return AccId;
 }
 @Auraenabled
 public static String commitSAOrg(string laListeenJSON, String AccId) {
  // system.debug('hello from commit');
  // system.debug(laListeenJSON);
  JSONParser parser = JSON.createParser(laListeenJSON);
  list < Secteur_Activite__c > already = [select id, Business_Category__c, Organisation__c from Secteur_Activite__c where Organisation__c = : AccId];
  
  system.debug(already);
  
  List < Id > bcDuCompte = new List < Id > ();
  
  for (Secteur_Activite__c SA: already) {
   bcDuCompte.add(SA.Business_Category__c);
  }
  // system.debug('--BCDUCompte-------' + bcDuCompte);
  List < Secteur_Activite__c > laliste2 = new list < Secteur_Activite__c > ();
  while (parser.nextToken() != null) {
   if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
    while (parser.nextToken() != null) {
     if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
      Secteur_Activite__c SA = (Secteur_Activite__c) parser.readValueAs(Secteur_Activite__c.class);
      // system.debug(SA);
      Integer found = 0;
      for (Id i: bcDuCompte) {
       // system.debug('---I---------' + i);
       // system.debug('---SABC--' + SA.Business_Category__c);
       if (SA.Business_Category__c == i) {
        found = 1;
        break;
       }
      }
      if (found == 0) {
       laliste2.add(SA);
      }
     }
    }
   }
  }
  system.debug('LA LISTE ORG'+laliste2);
  // system.debug(laliste2);
  insert laliste2;
  return 'A';
 }
 @AuraEnabled
 public static String deleteBrancheOrg(String recId, String AccId) {
  // system.debug(recId);
  // system.debug(Accid);
  string baseNode = '';
  Secteur_Activite__c currentRec = new Secteur_Activite__c();
  List < Secteur_Activite__c > allFromAccount = [select id, Organisation__c, Noeud__c from Secteur_Activite__c where Organisation__c = : AccId order by Noeud__c Desc];
  for (Secteur_Activite__c r: allFromAccount) {
   // system.debug(r);
   if (r.id == recId) {
    baseNode = r.Noeud__c;
    currentRec = r;
   }
  }
  // system.debug('++++++' + baseNode);
  Integer taille = baseNode.length();
  List < String > branche = new List < String > ();
  while (taille > 1) {
   branche.add(baseNode.substring(0, taille));
   taille--;
  }
  //system.debug(branche);
  Map < String, wrap > byNode = new Map < String, wrap > ();
  for (Secteur_Activite__c r: allFromAccount) {
   // system.debug(r);
   string node = r.Noeud__c;
   Integer size = node.length();
   string parent = node.substring(0, size - 1);
   if (bynode.keyset().contains(node)) {
    bynode.get(node).current = r;
   }
   if (branche.contains(parent)) {
    if (!bynode.keyset().contains(parent)) {
     bynode.put(parent, new wrap(new List < Secteur_Activite__c > (), new Secteur_Activite__c()));
    }

    //system.debug('--'+parent);
    bynode.get(parent).children.add(r);
    //system.debug(bynode.get(parent).children.size());
   }
  }
  List < Secteur_Activite__c > tobedel = new List < Secteur_Activite__c > ();
  for (string k: bynode.keyset()) {
   /*system.debug(k);
   system.debug(bynode.get(k));
   system.debug(bynode.get(k).children);
   system.debug(bynode.get(k).children.size());*/
   if (bynode.get(k).children.size() < 2) {
    tobedel.add(bynode.get(k).current);
   } else {
    break;
   }

  }
  tobedel.add(currentRec);
  //system.debug('----------'+ tobedel);

  delete tobedel;	
  return AccId;
 }
 
 class wrap {
  List < Secteur_Activite__c > children {
   get;
   set;
  }
  Secteur_Activite__c current {
   get;
   set;
  }
  wrap(List < Secteur_Activite__c > c, Secteur_Activite__c r) {
   this.children = c;
   this.current = r;
  }
 }


}
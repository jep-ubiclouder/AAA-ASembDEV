public with sharing class reorderReferences {
 public List < Biography_Reference__c > oldBR {
  get;
  set;
 }
 public List < Biography_Reference__c > newBR {
  get;
  set;
 }
 public List < Organisation_Reference__c > oldOR {
  get;
  set;
 }
 public List < Organisation_Reference__c > newOR {
  get;
  set;
 }
 public static Boolean bAlready = false;
 public class bioRefSortWrapper implements Comparable {
  public Biography_Reference__c bref;
  public bioRefSortWrapper(Biography_Reference__c bioref) {
   bref = bioref;
  }
  public integer compareTo(Object compareTo) {
   bioRefSortWrapper comparation = (bioRefSortWrapper) compareTo;
   // The return value of 0 indicates that both elements are equal.
   Integer returnValue = 0;
   if (bref.List_position__c > comparation.bref.List_Position__c) {
    // Set return value to a positive value.
    returnValue = 1;
   } else if (bref.List_position__c < comparation.bref.List_Position__c) {
    // Set return value to a negative value.
    returnValue = -1;
   }
   return returnValue;
  }
 }
 public class orgRefSortWrapper implements Comparable {
  public Organisation_Reference__c bref;
  public orgRefSortWrapper(Organisation_Reference__c bioref) {
   bref = bioref;
  }
  public integer compareTo(Object compareTo) {
   orgRefSortWrapper comparation = (orgRefSortWrapper) compareTo;
   // The return value of 0 indicates that both elements are equal.
   Integer returnValue = 0;
   if (bref.List_position__c > comparation.bref.List_Position__c) {
    // Set return value to a positive value.
    returnValue = 1;
   } else if (bref.List_position__c < comparation.bref.List_Position__c) {
    // Set return value to a negative value.
    returnValue = -1;
   }
   return returnValue;
  }
 }

 public reorderReferences(List < Biography_Reference__c > newrec, string operation) {
  if ((!bAlready || Test.isRunningTest()) && operation == 'D') {
   bAlready = true;
   List < Biography_Reference__c > allBR = [select id, List_position__c from Biography_Reference__c where RecordTypeId =: newrec[0].RecordTypeId and References__c =: newrec[0].References__c and id !=: newrec[0].Id order by List_position__c asc];
   system.debug('newrec' + newrec);
   system.debug('all BR' + allBR);
   List < bioRefSortWrapper > toSort = new List < bioRefSortWrapper > ();
   for (Biography_Reference__c br: allBR) {
    toSort.add(new bioRefSortWrapper(br));
   }
   toSort.sort();
   list < Biography_Reference__c > toUpdate = renumeroteBR(toSort);
   update toUpdate;
  }
 }

 public reorderReferences(List < Organisation_Reference__c > newrec, string operation) {
  if ((!bAlready || Test.isRunningTest()) && operation == 'D') {
   bAlready = true;
   List < Organisation_Reference__c > allBR = [select id, List_position__c from Organisation_Reference__c where RecordTypeId =: newrec[0].RecordTypeId and References__c =: newrec[0].References__c  order by List_position__c asc];
   system.debug('newrec' + newrec);
   system.debug('all BR' + allBR);
   List < orgRefSortWrapper > toSort = new List < orgRefSortWrapper > ();
   Integer i = 0;
   for (Organisation_Reference__c br: allBR) {
        if(br.Id != newrec[0].Id){
            br.List_position__c=i;
            toSort.add(new orgRefSortWrapper(br));
            i++;
        }
   }
   toSort.sort();
   list < Organisation_Reference__c > toUpdate = renumeroteOR(toSort);
   update toUpdate;
  }
 }
 public reorderReferences(List < Biography_Reference__c > oldRec, List < Biography_Reference__c > newrec, string operation) {
  system.debug('in Biography Reference');
  if ((!bAlready || Test.isRunningTest())) {
   if (operation == 'U') {
    bAlready = true;
    if (oldrec[0].List_position__c != newrec[0].List_position__c) {
     system.debug('dans reorganisation');
     reorderBR(newrec[0], oldrec[0].List_position__c);
    } else {
     system.debug('pas dans reorganisation');
    }
   } else if (operation == 'I') {
    bAlready = true;
    insertBR(newrec[0]);
   }
  }
 }
 public reorderReferences(List < Organisation_Reference__c > oldRec, List < Organisation_Reference__c > newrec, string operation) {
  system.debug('in Organisation Reference');
  system.debug('newrec'+newrec);
  system.debug('oldrec'+oldrec);
  if ((!bAlready || Test.isRunningTest())) {
   if (operation == 'U') {
    bAlready = true;
    if (oldrec[0].List_position__c != newrec[0].List_position__c) {
     system.debug('dans reorganisation');
     reorderOR(newrec[0], oldrec[0].List_position__c);
    } else {
     system.debug('pas dans reorganisation');
    }
   } else if (operation == 'I') {
    bAlready = true;
    insertOR(newrec[0]);
   }
  }
 }
 list < Biography_Reference__c > renumeroteBR(List < bioRefSortWrapper > toSOrt) {
  list < Biography_Reference__c > toUpdate = new list < Biography_Reference__c > ();
  integer j = 0;
  for (bioRefSortWrapper brSW: toSort) {
   brSW.bref.List_Position__c = j;
   j++;
   toUpdate.add(brSW.bref);
  }
  return toUpdate;
 }
 list < Organisation_Reference__c > renumeroteOR(List < orgRefSortWrapper > toSOrt) {
  list < Organisation_Reference__c > toUpdate = new list < Organisation_Reference__c > ();
  integer j = 0;
  for (orgRefSortWrapper brSW: toSort) {
    system.debug('List Position'+brSW.bref.List_Position__c);
    system.debug('Id '+brSW.bref.Id);   
   brSW.bref.List_Position__c = j;
   j++;
   toUpdate.add(brSW.bref);
  }
  return toUpdate;
 }
 public void reorderOR(Organisation_Reference__c newrec, Decimal oldLP) {
  List < Organisation_Reference__c > allBR = [select id, List_position__c from Organisation_Reference__c where RecordTypeId =: newrec.RecordTypeId and References__c =: newrec.References__c  order by List_position__c asc];
  system.debug('before' + allBR);
  system.debug('oldindex=' + oldlp);
  if (newrec.List_Position__c > oldLP ) {
   for (Organisation_Reference__c br: allBR) {
    if (br.List_position__c <= newrec.List_position__c && br.List_Position__c >= oldLP && br.Id != newrec.id) {
     system.debug(br);
     br.List_position__c -= 1;
    }
   }
  } else {
   for (Organisation_Reference__c br: allBR) {
    if (br.List_position__c >= newrec.List_position__c && br.List_position__c <= oldLP && br.Id != newrec.id) {
     system.debug(br);
     br.List_position__c += 1;
     system.debug(br);
    }
   }
  }
  List < orgRefSortWrapper > toSort = new List < orgRefSortWrapper > ();
  for (Organisation_Reference__c br: allBR) {
   toSort.add(new orgRefSortWrapper(br));
  }
  toSort.sort();
  list < Organisation_Reference__c > toUpdate = renumeroteOR(toSort);
  update toUpdate;
 }
 public void reorderBR(Biography_Reference__c newrec, Decimal oldLP) {
  List < Biography_Reference__c > allBR = [select id, List_position__c from Biography_Reference__c where RecordTypeId =: newrec.RecordTypeId and References__c =: newrec.References__c /*and id !=: newrec.Id*/  order by List_position__c asc];
  system.debug('before' + allBR);
  system.debug('oldindex=' + oldlp);
  if (newrec.List_Position__c > oldLP) {
   for (Biography_Reference__c br: allBR) {
    if (br.List_position__c <= newrec.List_position__c && br.List_Position__c >= oldLP && br.Id != newrec.id) {
     system.debug(br);
     br.List_position__c -= 1;
    }
   }
  } else {
   for (Biography_Reference__c br: allBR) {
    if (br.List_position__c >=newrec.List_position__c && br.List_position__c <= oldLP && br.Id != newrec.id) {
     system.debug(br);
     br.List_position__c += 1;
    }
   }
  }
  List < bioRefSortWrapper > toSort = new List < bioRefSortWrapper > ();
  for (Biography_Reference__c br: allBR) {
   toSort.add(new bioRefSortWrapper(br));
  }
  toSort.sort();
  list < Biography_Reference__c > toUpdate = renumeroteBR(toSort);
  update toUpdate;
 }
 public void insertBR(Biography_reference__c newrec) {
  List < Biography_Reference__c > allBR = [select id, List_position__c from Biography_Reference__c where RecordTypeId =: newrec.RecordTypeId and References__c =: newrec.References__c order by List_position__c asc];
  List < bioRefSortWrapper > toSort = new List < bioRefSortWrapper > ();
  // toSort.add(new bioRefSortWrapper(newrec));
  for (Biography_reference__c br: allBR) {
   if (br.lIst_Position__c >= newrec.List_Position__c && br.Id != newrec.Id) {
    br.list_position__c += 1;
   }
   toSort.add(new bioRefSortWrapper(br));
  }
  toSort.sort();
  // list < Biography_Reference__c > toUpdate = renumeroteBR(toSort);
  update allBR;
 }
 public void insertOR(Organisation_reference__c newrec) {
  system.debug('hello from  insertOR');
  List < Organisation_reference__c > allBR = [select id, List_position__c from Organisation_Reference__c where RecordTypeId =: newrec.RecordTypeId and References__c =: newrec.References__c order by List_position__c asc];
  List < orgRefSortWrapper > toSort = new List < orgRefSortWrapper > ();
  // toSort.add(new orgRefSortWrapper(newrec));
  system.debug(toSort);
  decimal depart =0;
  boolean found =false;
  for (Organisation_reference__c br: allBR) {
   if (br.List_Position__c >= newrec.List_Position__c && br.Id != newrec.Id) {
    if(!found){
        found =true;
        //depart = br.lIst_Position__c+1;
    }
    br.list_position__c += 1;
    
   }
   toSort.add(new orgRefSortWrapper(br));
   system.debug(toSort);
  }
  toSort.sort();
  // list < Organisation_reference__c > toUpdate = renumeroteOR(toSort);
  update allBR;
 }
}
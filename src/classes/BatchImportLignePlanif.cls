//(c) Octobre 2017 by Eric Adam (UBICLOUDER)
// class schedulable
global class BatchImportLignePlanif implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchImportLigne BatchIL = new BatchImportLigne();
      Database.executebatch(BatchIL,10);
   }
}
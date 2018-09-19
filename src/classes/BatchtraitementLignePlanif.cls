//(c) Octobre 2017 by Eric Adam (UBICLOUDER)
// class schedulable
global class BatchtraitementLignePlanif implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchtraitementLigne BatchTL = new BatchtraitementLigne();
      Database.executebatch(BatchTL,10);
   }
}
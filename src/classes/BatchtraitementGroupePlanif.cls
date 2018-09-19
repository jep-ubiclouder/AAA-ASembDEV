//(c) Octobre 2017 by Eric Adam (UBICLOUDER)
// class schedulable
global class BatchtraitementGroupePlanif implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchtraitementGroupe BatchTG = new BatchtraitementGroupe();
      Database.executebatch(BatchTG,10);
   }
}
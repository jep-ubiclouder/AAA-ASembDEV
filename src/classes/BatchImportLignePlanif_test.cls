//(c) Octobre 2017 by Eric Adam (UBICLOUDER)
// class test 
@istest
public class BatchImportLignePlanif_test {
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   public static testMethod void testschedule() {
       Test.StartTest();
       
       BatchImportLignePlanif sh1 = new BatchImportLignePlanif();
       String sch = '0 0 23 * * ?'; 
       system.schedule('Test Import ligne planif', sch, sh1);
   

      Test.stopTest();
   
   
   }
}
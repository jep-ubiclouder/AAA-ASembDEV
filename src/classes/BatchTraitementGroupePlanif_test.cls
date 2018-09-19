//(c) Octobre 2017 by Eric Adam (UBICLOUDER)
// class test 
@istest
public class BatchTraitementGroupePlanif_test {
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   public static testMethod void testschedule() {
       Test.StartTest();
       
       BatchTraitementGroupePlanif sh1 = new BatchTraitementGroupePlanif();
       String sch = '0 0 23 * * ?'; 
       system.schedule('Test Planif traitement groupe', sch, sh1);
   

      Test.stopTest();
   
   
   }
}
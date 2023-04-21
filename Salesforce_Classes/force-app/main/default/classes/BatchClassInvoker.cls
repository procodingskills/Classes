public with sharing class BatchClassInvoker {
   
    public static void AccountBatchServiceVeDefault(){
        AccountBatchServiceV2 obj = new AccountBatchServiceV2();
        Database.executeBatch(obj,2);
    }
    public static void AccountBatchServiceV2(){
        String whereClass = 'WHERE Rating = \'Cold\'';
        AccountBatchServiceV2 obj = new AccountBatchServiceV2(null , whereClass);
        Database.executeBatch(obj,2);
    }
}
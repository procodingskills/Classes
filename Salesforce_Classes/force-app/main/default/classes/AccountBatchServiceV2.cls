public with sharing class AccountBatchServiceV2 implements Database.Batchable<sObject>{
    // How query will be passed 
    // How to control the where class
    // Updatevalue che3cks 
    // Status receiving details
    string query;
    String whereClass;
    List<String> statusUpdate;
    Map<String,String> fieldSets;

    public AccountBatchServiceV2() {
        
    }
    public AccountBatchServiceV2(String query , String whereClass) {
        this.query = query != null ? query : this.query;
        this.whereClass = whereClass != null ? whereClass : this.whereClass;
    }

    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator(query+whereClass);
        
    }
    // Execute Method
    public void execute(Database.BatchableContext context , List<sObject> records){
        // process data updates in this method
        for(sObject record : records){
            for(String field : fieldSets.keyset()){
                record.put(field,record.get(fieldSets.get(field)));
            }
        }
        Database.update(records,false);
       
    }
    // Finish 
    public void finish(Database.BatchableContext context){

    }


    // IIB
    {
        query = SopbjectService.getQuery('Account');
        whereClass = 'WHERE Rating = \'hot\'';
        fieldSets = new Map<String,String>();
        fieldSets.put('Description','Name');
    } 
}
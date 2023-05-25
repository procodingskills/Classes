public with sharing class SearchControll {
    @AuraEnabled
    public static List<Account> searchRecords(String accountName){
        try {
            accountName = '%'+accountName+'%';
            return [SELECT Id , Name , Type FROM Account WHERE Name LIKE : accountName];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> wireMethod(String accountName){
        try {
            return searchRecords(accountName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
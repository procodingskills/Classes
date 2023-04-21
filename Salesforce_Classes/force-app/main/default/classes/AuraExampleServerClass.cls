public with sharing class AuraExampleServerClass {
   
    @AuraEnabled
    public static string getUserName(){
        User usr = [SELECT Id , Name FROM User WHERE Id =: UserInfo.getUserId()];
        return usr.Name;
    }
}
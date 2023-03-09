public with sharing class LWCComponentController {
    @AuraEnabled(cacheable=true)
    public static List<User> userNames(String email){
        List<User> usr = [SELECT Id , Name FROM User WHERE Email =: email ];
       return usr;
    }
}
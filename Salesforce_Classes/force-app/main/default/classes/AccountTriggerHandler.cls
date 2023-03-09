public with sharing class AccountTriggerHandler {
   // static Map<String,String> fieldValidations;
   static List<Trigger_Validations__mdt> fieldValidations;
    public static void run(){
        beforeInsert();
    }
    private static void beforeInsert(){
        for(sObject record : Trigger.new){
           /* if(record.Phone == null || record.Phone == ''){
                record.addError('Phone','Phone number required');
            }
            if(record.Rating == null || record.Rating == ''){
                record.addError('Rating','Phone number required');
            } */
           /* for(String fieldName : fieldValidations.keyset()){
                if(record.get(fieldName) == null || record.get(fieldName) == ''){
                    record.addError(fieldName, fieldValidations.get(fieldName));
                }
            }*/

            for(Trigger_Validations__mdt fieldName : fieldValidations){
                String key = fieldName.Field_Name__r.QualifiedApiName;
                if(fieldName.Is_Required__c){
                    if(record.get(key) == null || record.get(key) == ''){
                        record.addError(key, fieldName.Error_Message__c);
                    }
                }
            }
        }
    }

    static {
       /* fieldValidations = new Map<String,String>{
            'Phone' => 'Phone can not be blank',
            'Rating' => 'Rating is Required for new Accounts'
        }; */

         fieldValidations = [SELECT Id, DeveloperName, QualifiedApiName, sObject_Name__c, Field_Name__c, Is_Required__c, Condition__c, S_No__c,Field_Name__r.Label,Field_Name__r.QualifiedApiName,Error_Message__c FROM Trigger_Validations__mdt WHERE sObject_Name__r.QualifiedApiName = 'Account'];
    }

 
}
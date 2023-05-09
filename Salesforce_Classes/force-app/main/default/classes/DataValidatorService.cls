public with sharing class DataValidatorService {
    private List<MyLearns__Data_Validations__mdt> fieldDetails;
    public DataValidatorService(String objectAPIName) {
        fieldDetails = [SELECT Id,Label,MasterLabel,MyLearns__Error_Message__c,MyLearns__Field_Name__c,MyLearns__Field_Name__r.QualifiedApiName,MyLearns__Sobject_Name__r.QualifiedApiName FROM MyLearns__Data_Validations__mdt WHERE 
        MyLearns__Qualified_Object_API_Name__c =: objectAPIName];
    }
    public void run(){
        for(sObject record : Trigger.new){
            for(MyLearns__Data_Validations__mdt mdtData : fieldDetails ){

               List<MyLearns__Error_Messages__mdt> eerrMsg = [SELECT Id,MyLearns__Data_Validations__c,MyLearns__Field_Name__c,	MyLearns__Sequence__c FROM MyLearns__Error_Messages__mdt WHERE MyLearns__Data_Validations__c = : mdtData.Id];

                string fieldAPIName = mdtData.MyLearns__Field_Name__r.QualifiedApiName;
                String errorMessage = mdtData.MyLearns__Error_Message__c;

               for(MyLearns__Error_Messages__mdt rec : eerrMsg ){
                errorMessage = errorMessage.replace(rec.MyLearns__Sequence__c , (String)record.get(rec.MyLearns__Field_Name__c) == null ? '' : (String)record.get(rec.MyLearns__Field_Name__c));
               }
              
                if(record.get(fieldAPIName) == null || record.get(fieldAPIName) == ''){
                    record.addError(fieldAPIName, errorMessage);
                }
           
            }
        }
    }
}
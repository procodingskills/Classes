public with sharing class SobjectNameService {
    /*
        This approach can only to be implement when objects are less involved in apex execution (Not recommended for heavy duty transaction)
    */
    public static string getSobjectName(Id recordId) {
        return String.valueOf(recordId.getSobjectType());
    }

    /* recommended pattern */
    public static string sobjectName(String recordId){
        String objectName ='';
        // in any recordId what denotes object ? first 3 chars 
        // How can I get the first 3 chars from 18 char long string 
        String recordPrefix = recordId.substring(0,3);
        // Get all sobjects using schema class 
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(Schema.SObjectType objectDetail : gd.values()){
            Schema.DescribeSObjectResult objectResult = objectDetail.getDescribe();
            string keyprefix = objectResult.getKeyPrefix();
            if(recordPrefix ==  keyprefix ){
                objectName = objectResult.getName();
            }
        }
        return objectName;
    }
}
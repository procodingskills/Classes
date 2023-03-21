public with sharing class SopbjectService {
    public static string getQuery(String objectAPIName){
        Schema.SObjectType objectToken = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult fieldResults = objectToken.getDescribe();
        Map<String,Schema.SObjectField> fields = fieldResults.Fields.getMap();
        String query = 'SELECT Id';
        for(String field : fields.keyset()){
            Schema.DescribeFieldResult fieldDetails = fields.get(field).getDescribe();
            if(fieldDetails.isAccessible() && field != 'Id'){
                query += ','+field;
            }
        }
        query += ' FROM '+objectAPIName+' ';
        return query;
    }
}
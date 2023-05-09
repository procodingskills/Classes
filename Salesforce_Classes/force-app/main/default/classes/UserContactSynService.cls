public with sharing class UserContactSynService {
    private static Set<String> fieldChanges;
    static {
        fieldChanges = new Set<String>();
        fieldChanges.add('FirstName');
        fieldChanges.add('LastName');
        fieldChanges.add('Email');
        fieldChanges.add('Title');
        fieldChanges.add('Company');
        
    }
    public static void updateContact(Map<Id,sObject> newRecordMap , Map<Id,sObject> oldRecordMap , String targetObjectApi , String relationshipFieldAPI){
        // What is the relationship between user and Contact when user external --> ContactId
        /*
            If we know the contactId , we can update contacts 
            If we have contact Id can we get related users based on contactId 
        */
        // Map<ContactId,Contact> 
        // Map<ContactId,User>
        Map<Id,sObject> contactIdUserMap = new Map<Id,sObject>();
        for(sObject nRc : newRecordMap.values()){
            // Id key = UserRecord.Id;
            Id key = (Id)nRc.get('Id');
            sObject oRc = oldRecordMap.get(key);
            for(String fieldAPI : fieldChanges){
                Boolean isChanged = false;
                if(nRc.get(fieldAPI) != oRc.get(fieldAPI)){
                    isChanged = true;
                }
                if(isChanged && nRc.get(relationshipFieldAPI) != null ){
                    Id contactId = Id.valueOf(String.valueOf(nRc.get(relationshipFieldAPI)));
                    contactIdUserMap.put(contactId,nRc);
                }
            }
        }
        // query contacts when there is valid external user got updated 
        
        if(contactIdUserMap.keyset().size() > 0 ){
            string subQuery ='';
            for(String fieldName : fieldChanges){
                subQuery = ','+fieldName;
            }
            Map<Id,sObject> contactMap = new Map<id,sObject>();
            Set<Id> contactIds = new Set<Id>();
            contactIds.addAll(contactIdUserMap.keyset());
            List<sObject> records =  Database.query('Select Id'+subQuery+' FROM '+targetObjectApi+' WHERE Id IN: contactIds');
            contactMap.putAll(
                records
                );
            for(sObject contactRecord : contactMap.values()){
                Id contactId = (Id)contactRecord.get('Id');
                sObject userRecord = contactIdUserMap.get(contactId);
                // field value update for the changed field
                for(String fieldName : fieldChanges){
                    contactRecord.put(fieldName , userRecord.get(fieldName));
                }
            }
            update contactMap.values();
        }
    }
}
public with sharing class ContactTrigger {
    // Define your Trigger Context data variables
    private List<Contact> triggerNew;
    private Map<Id,Contact> triggerNewMap;
    private Map<Id,Contact> triggerOldMap;
    // Capture the Current event 
    private System.TriggerOperation currentEvent;
    // intiate the data while typecasting through non-static block
    {
        triggerNew = (List<Contact>)Trigger.new;
        triggerNewMap = (Map<Id,Contact>) Trigger.newMap;
        triggerOldMap = (Map<Id,Contact>) Trigger.oldMap;
        currentEvent = Trigger.operationType;
    }
   
    public static void run(){
        ContactTrigger invoke = new ContactTrigger();
        switch on invoke.currentEvent{
            when BEFORE_INSERT{

            }
            when AFTER_UPDATE{
                invoke.updatePrimaryInfo();
                UserContactSynService.updateContact(invoke.triggerNewMap, invoke.triggerOldMap, 'User', 'MyLearns__External_User__c');
            }
        }
    }

    private void updatePrimaryInfo(){
        // Uncheck the exiting primary contact 
        // Update Account Primary First and Last Names
        //? What is the common relationship between current Primary contact and latest Primary contact --> Account is the common element (AccountId)
        map<Id,Contact> accountNewPrimary = new Map<Id,Contact>(); // Map<AccountId , Contact> 
        Set<Id> contactIds = new Set<Id>();
        for(Contact newRecord : triggerNew){
            Contact oldRecord = triggerOldMap.get(newRecord.Id);
            Boolean isPrimary = newRecord.MyLearns__Is_Primary__c && !oldRecord.MyLearns__Is_Primary__c ? true : false;
            if(isPrimary){
                accountNewPrimary.put(newRecord.AccountId , newRecord);
                contactIds.add(newRecord.Id);
            }
        }
        // Data Conditionavcalidate Check 
        if(accountNewPrimary.keyset().size() > 0){
       List<Contact> contacts = [SELECT Id , MyLearns__Is_Primary__c , AccountId , LastName , Firstname FROM Contact WHERE AccountId IN: accountNewPrimary.keyset() AND MyLearns__Is_Primary__c = TRUE AND Id NOT IN:contactIds];

       List<Account> accountUpdates = new List<Account>();
       for(Contact exitingCon : contacts){
         exitingCon.MyLearns__Is_Primary__c = false;
         Account acc = new Account();
         acc.Id = exitingCon.AccountId;
         acc.MyLearns__Primary_Last_Name__c = accountNewPrimary.get(acc.Id).LastName;
         acc.MyLearns__Primary_First_Name__c = accountNewPrimary.get(acc.Id).FirstName;
         accountUpdates.add(acc);
       }

       if(!contacts.isEmpty() && contacts.size() > 0 ){
        update contacts;
        ApexTriggerController.skipMethods.add('AccountTriggerHandler.validatePrimaryContact()');
        update accountUpdates;
       }
    }
    }
}
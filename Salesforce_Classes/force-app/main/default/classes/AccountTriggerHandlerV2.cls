public class AccountTriggerHandlerV2 {
    private static List<Account> triggerNew;
    private static Map<Id,Account> triggerNewMap; 
    private static Map<Id,Account> triggerOldMap; 
    private static  System.TriggerOperation currentEvent;
    // non-static Block 
    {
        // Trigger.new --> List<Sobject>
        triggerNew = (List<Account>)Trigger.new; 
        triggerNewMap = (Map<Id,Account>) Trigger.newMap;
        triggerOldMap = (Map<Id,Account>) Trigger.oldMap;
        currentEvent = Trigger.operationType;
    }
    public static void run(){
        if(!Trigger.isExecuting){
            throw new CustomValidationException('AccountTriggerHandlerV2 can not be called outside of Trigger Context');
        }
        AccountTriggerHandlerV2 invoke = new AccountTriggerHandlerV2();
        (new DataValidatorService('Account')).run();
        switch on currentEvent{
            
            when BEFORE_INSERT{
               invoke.validateFields();
            }
            when AFTER_INSERT{
                invoke.updateUsers();
               
            }
            when AFTER_UPDATE{
                invoke.validatePrimaryContact();
            }
        }
    }

    private  void validateFields(){
        for(Account record : triggerNew){
            if(record.BillingCountry == null ){
                record.BillingCountry.addError('Billing country is required to save new account ');
            }
        }
    }

    private List<Contact> createContact(){
        List<Contact> contacts = new List<Contact>();
        for(Account record : triggerNew){
            Contact con = new Contact();
            con.LastName = record.MyLearns__Primary_Last_Name__c;
            con.FirstName = record.MyLearns__Primary_First_Name__c;
            con.MyLearns__Is_Primary__c = true;
            con.AccountId = record.Id;
            contacts.add(con);
        }
        if(contacts.size() > 0 ){
            insert contacts;
        }
        return contacts;
    }
    private void updateUsers(){
        User usr = [SELECT Id , MyLearns__Contact_Id__c from User WHERE Email ='stduent@procodingskills.com'];
        for(Contact con : createContact() ){
            usr.MyLearns__Contact_Id__c = con.Id;
        }
        update usr;
    }
    private void validatePrimaryContact(){
        if(ApexTriggerController.skipMethods.contains('AccountTriggerHandler.validatePrimaryContact()')){
            return;
        }
        Set<Id> accountIds = new Set<Id>();
        for(Account newRecord : triggerNew ){
            Account oldRecord = triggerOldMap.get(newRecord.Id);
            // check the first name or Last Name changed on Account
            Boolean isFirstName = ( newRecord.MyLearns__Primary_First_Name__c != oldRecord.MyLearns__Primary_First_Name__c ) ? true : false;
            Boolean isLastName = (newRecord.MyLearns__Primary_Last_Name__c == oldRecord.MyLearns__Primary_Last_Name__c ) ? false : true;
            if(isFirstName || isLastName){
                accountIds.add(newRecord.Id);
            }
        }
        List<Account> accounts = [SELECT Id , MyLearns__Primary_First_Name__c, MyLearns__Primary_Last_Name__c,(
            SELECT Id , FirstName , LastName , MyLearns__Is_Primary__c FROM Contacts ORDER BY MyLearns__Is_Primary__c DESC
        ) FROM Account WHERE Id IN: accountIds ];
        List<Contact> contacts = new List<Contact>();
        for(Account record : accounts ){
            Map<String,Contact> primaryCons = new Map<String,Contact>();
          
            for(Contact con : record.Contacts){
                if(con.MyLearns__Is_Primary__c){
                    con.MyLearns__Is_Primary__c = false;
                    primaryCons.put('Current',con);
                }
                else if(con.FirstName == record.MyLearns__Primary_First_Name__c && con.LastName == record.MyLearns__Primary_Last_Name__c){
                    con.MyLearns__Is_Primary__c = true;
                    primaryCons.put('new',con);
                }
            }
            
            if(primaryCons.get('new') == null ){
                Contact newCon = new Contact();
                newCon.FirstName = record.MyLearns__Primary_First_Name__c;
                newCon.LastName = record.MyLearns__Primary_Last_Name__c;
                newCon.AccountId = record.Id;
                newCon.MyLearns__Is_Primary__c = true;
                contacts.add(newCon);
            }
            contacts.addAll(primaryCons.values());
        }
        if(!contacts.isEmpty() && contacts.size() > 0){
            upsert contacts;
        }
    }

    public AccountTriggerHandlerV2(){
        system.debug('THIS : '+this);
    }
}
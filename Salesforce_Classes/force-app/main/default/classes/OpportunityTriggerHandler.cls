public class OpportunityTriggerHandler {
    static List<Opportunity> newOpps;
    static Map<Id, Opportunity> newMapOpps;
    static Map<Id, Opportunity> oldMapOpps;
    
    static{
        newOpps = (List<Opportunity>) Trigger.new;
        newMapOpps = (Map<Id, Opportunity>) Trigger.newMap;
        oldMapOpps = (Map<Id, Opportunity>) Trigger.oldMap;
    }
    
    public static void run(System.TriggerOperation operationType){
        switch on operationType{
            when AFTER_INSERT{
                afterInsert();
                //afterInsert_noGood();
            }           
            when AFTER_UPDATE{
                afterUpdate();
               
            }
        }
    }
         
     private static void afterInsert()
     {
         /*
        ? Check the Opportunity contact have exiting Primary Contact Details 
        TODO : get the primary contact info and update the Opportunity
        ! If no primary contact update Account with the newly created contact Id
         */

         // TODO : Get AccountIds from Contact details (newContacts || newContactsMap)
         set<Id> conIds = new set<Id>();
         for(Opportunity record : newOpps){
                if(record.Contact__c != null){
                    conIds.add(record.Contact__c);
                }
         }
         
         // Retrived data based on Contact Ids                                            100
         Map<Id,Contact> primaryContacts = new Map<Id,Contact>([SELECT Id , AccountId , Account.Opportunity_Holds__c FROM Contact WHERE Id IN:conIds AND Primary_Contact__c = null ]);

         // update account details 110 + 20
         Map<Id,Account> accounts = new Map<Id,Account>();
         // Process your records
         for(Opportunity record : newOpps){
            if(record.Contact__c != null && primaryContacts.keySet().contains(record.Contact__c)){
                Contact primeContact = primaryContacts.get(record.Contact__c);
                
                Account acc = accounts.get(primeContact.AccountId);
                if(!accounts.keyset().contains(primeContact.AccountId)){
                    acc = new Account();
                    acc.Opportunity_Holds__c = primeContact.Account.Opportunity_Holds__c;
                    accounts.put(primeContact.AccountId,acc);
                }
                if(acc.Opportunity_Holds__c == null ){
                    acc.Opportunity_Holds__c = 0;
                }
                acc.Id = primeContact.AccountId;
                acc.Opportunity_Holds__c = record.Amount + acc.Opportunity_Holds__c;
            }
         }

         if(accounts.keyset().size() > 0 ){
            update accounts.values();
         }


     }

     static void afterInsert_noGood(){
        set<Id> conIds = new set<Id>();
        set<Id> accIds = new set<Id>();
        for(Opportunity record : newOpps){
               if(record.Contact__c != null){
                   conIds.add(record.Contact__c);
               }
               if(record.AccountId != null ){
                    accIds.add(record.AccountId);
               }
        }

        // retrive Contacts 
        Map<Id,Contact> contacts = new Map<Id,Contact>  ( [SELECT Id , Primary_Contact__c FROM contact WHERE Id IN:conIds]);
        Map<Id,Account> accounts = new Map<Id,Account> ([SELECT Id , Opportunity_Holds__c FROM Account WHERE Id IN: accIds ]);

        for(Opportunity record : newOpps){
            Account acc = accounts.get(record.AccountId);
            Contact con = contacts.get(record.Contact__c);
            if(con.Primary_Contact__c == null ){
                if(acc.Opportunity_Holds__c == null ){
                    acc.Opportunity_Holds__c = 0;
                }
                acc.Opportunity_Holds__c = record.Amount + acc.Opportunity_Holds__c; 
            }
        }
        update accounts.values();
     }
    
    private static void afterUpdate()
     {
         /*
          1. Amount can be changed --> adjust the difference amount from old value to new value ( 100 to 47 = amount total + (47 - 100 )
               # Old value is Greater than new value 
                    Old value = 50
                    new Value = 100 
                    Current amount in Account = 200 ==> 250 

                    Arthematic logic : newAmount = 200 + (100 - 50) , 

          2. Contact on Opportunity Might change
          */

          Set<Id> contactIds = new Set<Id>();
          for(Opportunity newRecord : newOpps){
                // Old Opportunity Details from Trigger Context 
                Opportunity oldRecord = oldMapOpps.get(newRecord.Id);
                if(newRecord.Contact__c != oldRecord.Contact__c || newRecord.Amount != oldRecord.Amount){
                    contactIds.add(newRecord.Contact__c);
                    contactIds.add(oldRecord.Contact__c);
                }
            }
                if(contactIds.size() > 0 ){
                    Map<Id,Contact> primaryContacts = new Map<Id,Contact>([SELECT Id , AccountId , Account.Opportunity_Holds__c FROM Contact WHERE Id IN:contactIds AND Primary_Contact__c = null ]); 
                    // collection to update records
                    Map<Id,Account> updateAccounts = new Map<Id,Account>();
                    // Iterate the Opportunity to update amopunt in account 
                    for(Opportunity newRecord : newOpps ){
                        Opportunity oldRecord = oldMapOpps.get(newRecord.Id);
                        Boolean isContactChange = newRecord.Contact__c != oldRecord.Contact__c ? true : false;
                        Boolean isAmountChnage = newRecord.Amount != oldRecord.Amount ? true : false;
                        Contact newprimeContact;
                        Contact oldprimeContact;
                        if(newRecord.Contact__c != null){
                            newprimeContact = primaryContacts.get(newRecord.Contact__c);
                        }
                        if(oldRecord.Contact__c != null){
                            oldprimeContact = primaryContacts.get(oldRecord.Contact__c);
                        }
                        
                        if(isContactChange){
                            Account acc = updateAccounts.get(oldprimeContact.AccountId);
                            if(!updateAccounts.containsKey(oldprimeContact.AccountId)){
                                acc = new Account();
                                acc.Id = oldprimeContact.AccountId;
                                acc.Opportunity_Holds__c = oldprimeContact.Account.Opportunity_Holds__c != null ? oldprimeContact.Account.Opportunity_Holds__c : 0;
                            }
                            acc.Opportunity_Holds__c = acc.Opportunity_Holds__c - oldRecord.Amount;
                            updateAccounts.put(acc.Id , acc);
                        }
                        else if(isAmountChnage){
                            Decimal difference = newRecord.Amount - oldRecord.Amount;
                            Account acc = updateAccounts.get(newprimeContact.AccountId);
                            if( acc == null ){
                                acc = new Account();
                                acc.Id = newprimeContact.AccountId;
                                acc.Opportunity_Holds__c = newprimeContact.Account.Opportunity_Holds__c != null ? newprimeContact.Account.Opportunity_Holds__c : 0;
                            }
                            acc.Opportunity_Holds__c = acc.Opportunity_Holds__c + difference;
                            updateAccounts.put(acc.Id,acc);
                        }

                    }
                    if(updateAccounts.size() > 0 ){
                        update updateAccounts.values();
                    }
                }
          
     }
}
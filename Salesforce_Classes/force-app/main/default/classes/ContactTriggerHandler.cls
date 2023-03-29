public with sharing class ContactTriggerHandler {
  static List<Contact> newContacts;
  static Map<Id, Contact> newContactsMap;
  static Map<Id, Contact> oldContactsMap;
  static Boolean isPrimaryCalculations = true;
  static {
    newContacts = (List<Contact>) Trigger.new;
    newContactsMap = (Map<Id, Contact>) Trigger.newMap;
    oldContactsMap = (Map<Id, Contact>) Trigger.oldMap;
  }

  public static void run(System.TriggerOperation operationType) {
    oldContactsMap = (Map<Id, Contact>) Trigger.oldMap;

    switch on operationType {
      when AFTER_INSERT {
        afterInsert();
      }
      when BEFORE_INSERT {
      }
      when AFTER_UPDATE {
        afterUpdate();
      }
      when BEFORE_UPDATE {
        isDuplicates();
      }
    }
  }

  private static void afterInsert() {
    /*
        ? Check the Account have exiting Primary Contact Details 
        TODO : get the primary contact info and update the Contact
        ! If no primary contact update Account with the newly created contact Id
         */

    // TODO : Get AccountIds from Contact details (newContacts || newContactsMap)
    set<Id> accountIds = new Set<Id>();
    for (Contact record : newContacts) {
      if (record.AccountId != null) {
        accountIds.add(record.AccountId);
      }
    }

    //? Do we have valid accountIds
    Map<Id, Id> primaryContacts = new Map<Id, Id>();
    Map<Id, Account> accountMap;
    if (accountIds.size() > 0) {
      accountMap = new Map<Id, Account>(
        [SELECT Id, Primary_Contact__c FROM Account WHERE Id IN :accountIds]
      );
      for (Account record : accountMap.values()) {
        if (record.Primary_Contact__c != null) {
          primaryContacts.put(record.Id, record.Primary_Contact__c);
        }
      }
    }

    // Iterate the Trigger context data in checking with primaryContacts ( details)
    List<Contact> updateContacts = new List<Contact>();
    List<Account> updateAccounts = new List<Account>();
    for (Contact record : newContacts) {
      if (record.AccountId != null) {
        Id primaryContactId = primaryContacts.get(record.AccountId);
        if (primaryContactId != null) {
          Contact con = new Contact();
          con.Id = record.Id;
          con.Primary_Contact__c = primaryContactId;
          updateContacts.add(con);
        } else {
          Account acc = new Account();
          acc.Id = record.AccountId;
          acc.Primary_Contact__c = record.Id;
          updateAccounts.add(acc);
          primaryContacts.put(record.AccountId, record.Id);
        }
      }
    }

    if (updateAccounts.size() > 0) {
      update updateAccounts;
    }
    if (updateContacts.size() > 0) {
      update updateContacts;
    }
    ChangeDataBackupService.publishDetails(newContacts, 'Insert', 'Contact');
  }

  private static void afterUpdate() {
    /*
         1. Find the contacts having Primay Contact Update
         2. Find the Related Contacts based on the Account Id from the Primary Contact Updated Contact Ids
         3. Update the Primary Contact details on related contact information 
         4. Update Account Details with Primary Contact Info
         */
    if (!isPrimaryCalculations) {
      return;
    }
    isPrimaryCalculations = false;

    Set<Id> contactIds = new Set<Id>();
    Map<Id, Id> accountPrimaryContacts = new Map<Id, Id>();
    //Iterate the List (Trigger Context Trigger.new ) newContacts
    for (Contact record : newContacts) {
      Contact oldRecord = oldContactsMap.get(record.Id);
      Boolean isChanged = (record.Primary_Contact__c !=
        oldRecord.Primary_Contact__c)
        ? true
        : false;
      // DataType variableName = Condition ? condition IF True : Condition if False ( if(condition ? true : false ) )
      Id primaryContactId = record.Primary_Contact__c != null
        ? record.Primary_Contact__c
        : record.Id;
      // find the actual values
      if (isChanged) {
        accountPrimaryContacts.put(record.AccountId, primaryContactId);
        contactIds.add(record.Id);
      }
    }

    if (contactIds.size() > 0) {
      List<Contact> relatedContacts = [
        SELECT Id, AccountId, Primary_Contact__c
        FROM Contact
        WHERE
          AccountId IN :accountPrimaryContacts.keyset()
          AND Id NOT IN :contactIds
      ];

      Map<Id, Account> updateAccounts = new Map<Id, Account>(); // {id = 123 , value : account object},{id =3783 , value : account obje 2 }
      for (Contact record : relatedContacts) {
        Id primaryContactId = accountPrimaryContacts.get(record.AccountId);
        if (updateAccounts.get(record.AccountId) == null) {
          Account acc = new Account();
          acc.Id = record.AccountId;
          acc.Primary_Contact__c = primaryContactId;
          updateAccounts.put(record.AccountId, acc);
        }
        record.Primary_Contact__c = primaryContactId != record.Id
          ? primaryContactId
          : null;
      }

      update updateAccounts.values();
      update relatedContacts;
    }
    ChangeDataBackupService.publishDetails(newContacts, 'Update', 'Contact');
  }

  // Finiding Duplicate based on Email or Phone in contact

  private static void isDuplicates() {
    //oldContactsMap
    // Get all Phone numbers from Trigger Context
    Set<String> phoneNumbers = new Set<String>();
    // Get all emails from Trigger Context
    Set<String> emails = new Set<String>();

    for (Contact record : newContacts) {
      Contact oldRecord = oldContactsMap.get(record.Id);
      if (record.Phone != oldRecord.Phone) {
        phoneNumbers.add(record.Phone);
      }
      if (record.Email != oldRecord.Email) {
        emails.add(record.Email);
      }
    }

    if (!phoneNumbers.isEmpty() || !emails.isEmpty()) {
      Map<String, Contact> contacts = new Map<String, Contact>();
      // Get the exting data contacts matched eaither with Phone or Email
      for (Contact record : [
        SELECT Id, Email, Phone
        FROM Contact
        WHERE Phone IN :phoneNumbers OR Email IN :emails
      ]) {
        // Build the Data Map matched with Phone or Email
        if (record.Phone != null) {
          contacts.put(record.Phone, record);
        }
        if (record.Email != null) {
          contacts.put(record.Email, record);
        }
      }
      if (!contacts.isEmpty()) {
        // Validate the Trigger Context data with Matched data from query
        for (Contact record : newContacts) {
          Contact oldRecord = oldContactsMap.get(record.Id);
          if (
            record.Phone != null &&
            record.phone != oldRecord.Phone &&
            contacts.containsKey(record.Phone)
          ) {
            if (record.Id != contacts.get(record.Phone).Id) {
              if (
               ( newContactsMap.containsKey(contacts.get(record.Phone).Id) &&
                newContactsMap.get(contacts.get(record.Phone).Id).Phone ==
                record.Phone ) || ! newContactsMap.containsKey(contacts.get(record.Phone).Id)
              ) {
                record.Phone.addError(
                  'Phone number already inuse, refer ' +
                  contacts.get(record.Phone).Id
                );
              }
            }
          }
          if (
            record.Email != null &&
            record.Email != oldRecord.Email &&
            contacts.containsKey(record.Email)
          ) {
            if (record.Id != contacts.get(record.Email).Id) {
              if (
                (newContactsMap.containsKey(contacts.get(record.Email).Id) &&
                newContactsMap.get(contacts.get(record.Email).Id).Email ==
                record.Email) || !newContactsMap.containsKey(contacts.get(record.Email).Id)
              ) {
                record.Email.addError(
                  'Email number already inuse, refer ' +
                  contacts.get(record.Email).Id
                );
              }
            }
          }
        }
      }
    }
  }
}
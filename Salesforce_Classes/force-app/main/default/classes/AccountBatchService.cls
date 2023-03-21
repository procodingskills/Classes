public with sharing class AccountBatchService implements Database.Batchable<sObject>,Database.Stateful{
    List<Database.SaveResult> results;

    //Start method
    public Database.QueryLocator start(Database.BatchableContext context){
        String query = 'SELECT Id , Name,Description FROM Account';
        return Database.getQueryLocator(query);
    }
    // Execute Method
    public void execute(Database.BatchableContext context , List<sObject> records){
        // process data updates in this method
        for(sObject record : records){
            record.put('Description' , record.get('Name'));
        }
        results = Database.update(records,false);
       
    }
    // Finish 
    public void finish(Database.BatchableContext context){
        // Iterate through each returned result
        String msg ='';
for (Database.SaveResult sr : results) {
   
    if (sr.isSuccess()) {
       msg = msg+ '-'+sr.getId()+' : Updated<br/>';
        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
    }
    else {
        // Operation failed, so get all errors                

        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Account fields that affected this error: ' + err.getFields());
            msg = msg+ '-'+sr.getId()+' : '+err.getStatusCode()+' : '+err.getMessage()+' : '+ err.getFields()+'<br/>';
        }
    }
   
    }
     // Send emails 
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     mail.setToAddresses(new String[]{'admin@procodingskills.com'});
     mail.setSenderDisplayName('Account Batch Service Results');
     mail.setSubject('Batch Class Updates : Prakash Org');
     mail.setHtmlBody(msg);
     List<Messaging.SingleEmailMessage> emails = new list<Messaging.SingleEmailMessage>();
     emails.add(mail);
     Messaging.sendEmail(emails);
 
    }
    public static void run(){
        AccountBatchService obj = new AccountBatchService();
        Id batchJobId = Database.executeBatch(obj , 100);
    }
}

// SELECT COUNT() FROM ACCOUNT
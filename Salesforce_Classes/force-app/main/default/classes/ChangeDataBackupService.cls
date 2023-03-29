public with sharing class ChangeDataBackupService {
    public ChangeDataBackupService() {

    }

    public static void publishDetails(List<sObject> records , String actionType , String objectAPIName){
        List<ActivityMonitor__e> events = new List<ActivityMonitor__e>();
        for(sObject record : records){
            ActivityMonitor__e event = new ActivityMonitor__e();
            event.Action_Type__c = actionType;
            event.RecordId__c = String.valueOf(record.get('Id'));
            event.UserId__c = String.valueOf(UserInfo.getUserId());
            event.Sobject_Name__c = objectAPIName;
            events.add(event);
        }

        if(events.size() > 0){
            Eventbus.publish(events);
        }
    }

    public static void handleDetails(List<ActivityMonitor__e> events){
        List<Data_Backup__c> backups = new List<Data_Backup__c>();
        map<Id,Data_Backup__c> mapping = new Map<Id,Data_Backup__c>();
      
        List<Attachment> Attachments = new List<Attachment>();
        for(ActivityMonitor__e event : events){
            Data_Backup__c backup = new Data_Backup__c();
            backup.User__c = event.UserId__c;
            backup.Record_Id__c = event.RecordId__c;
            backup.Action_Type__c = event.Action_Type__c;
            Sobject obj = Database.query(SopbjectService.getQuery(event.Sobject_Name__c)+' WHERE Id = \''+ event.RecordId__c+'\'');
            String data = String.valueOf(obj);
            Blob contentData = Blob.valueOf(data);
            Attachment attach = new Attachment();
            attach.Name = backup.Record_Id__c + '-'+backup.User__c+' : '+System.now()+'.JSON';
            attach.Body = contentData;
            attach.ContentType = '.txt';
            attach.ParentId = event.RecordId__c;
            backups.add(backup);
            Attachments.add(attach);
            mapping.put(event.RecordId__c , backup);
           
        }

        Insert backups;
        for(Attachment att : Attachments){
            att.ParentId = mapping.get(att.ParentId).Id;
        }
        Insert Attachments;
    }
}
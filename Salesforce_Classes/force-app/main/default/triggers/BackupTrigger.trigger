trigger BackupTrigger on ActivityMonitor__e (after insert) {
    ChangeDataBackupService.handleDetails(Trigger.new);
}
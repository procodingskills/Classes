trigger ContactTrigger on Contact (after insert , after update,before update) {
    ContactTriggerHandler.run(Trigger.operationType);
}
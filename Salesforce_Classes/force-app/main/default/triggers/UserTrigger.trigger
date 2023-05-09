trigger UserTrigger on User (after update) {
    UserTriggerService.invoke();
}
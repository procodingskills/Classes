public with sharing class ApexTriggerController {
    public static Set<String> skipMethods;
   static {
        skipMethods = new Set<String>();
    }
}
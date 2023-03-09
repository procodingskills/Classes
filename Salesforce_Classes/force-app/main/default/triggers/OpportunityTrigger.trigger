trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    /*
     TODO : Create a New Custom Field in Opportunity {Label : Contact , Type : Lookup to Contact}
     TODO : Create a new Custom Field in Account {Label : Opportunity Holds , Type : Number (10,2) }
     ! Write Trigger on Opportunity to get satisfy the below need
     ? When opportunity contact is a Primary Contact then sum of all Opportunities related to Contact then update value on Account Opportunity Holds
    */
    opportunityTriggerHandler.run(Trigger.operationType);
}
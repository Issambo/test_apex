trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (after insert, after update) {
    
    try{
        Subscriptions.triggerHandler(Trigger.New);
    }
    catch(Exception e){
        Logs.error('ContractEndDateAdapterTrigger','SBQQ__Subscription__c Trigger insert & update', e);
    }

}
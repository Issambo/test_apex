trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (after insert, after update) {
    
    try{
        Subscriptions subscriptions = new Subscriptions((List<SBQQ__Subscription__c>)Trigger.New);
        subscriptions.triggerHandler();
    }
    catch(Exception e){
        Logs.error('ContractEndDateAdapterTrigger','SBQQ__Subscription__c Trigger insert & update', e);
    }

}
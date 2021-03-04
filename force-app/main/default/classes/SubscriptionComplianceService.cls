public with sharing class SubscriptionComplianceService {
    


    public static void setConformite(List<SBQQ__Subscription__c> subList) {
        
        List<SBQQ__Subscription__c> subsToUpdate = new List<SBQQ__Subscription__c>(); 
        Subscriptions subscriptions = new Subscriptions(subList);
        subscriptions.setConformite(subsToUpdate);

        SavePoint sp = Database.setSavePoint();
        try{
            update subsToUpdate;
        }
        catch(Exception e){
            Database.rollback(sp);
            throw e;

        }
	}
}
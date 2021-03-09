public with sharing class SubscriptionComplianceService {
    


    public static void setConformite(List<SBQQ__Subscription__c> subList) {
        
        List<SBQQ__Subscription__c> subsToUpdate = new List<SBQQ__Subscription__c>(); 
        //instanciation de la classe modèle "subscriptions" avec les SBQQ__Subscription du scope à traiter.
        Subscriptions subscriptions = new Subscriptions(subList);
        //évaluation de la conformité de ces SBQQ__Subscription
        subscriptions.setConformite(subsToUpdate);

        //gestion transactionnelle en cas d'echec tu traitement. Rollback alors effectué.
        //Mise en place de ce systeme en prévision d'eventuels ajouts futures d'autre DML.
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
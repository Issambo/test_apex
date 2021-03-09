@isTest
private class SubscriptionComplianceCheckTest {

    //méthode d'initialisation des données de test.
    private static void init(){
        TestDataFactory.createSubscriptions();

    }
    
    //méthode de test des conformité.
    @isTest
    private static void testConformite() {
          
        init();
        
		Test.startTest();
        SubscriptionComplianceCheck batch = new SubscriptionComplianceCheck();
		Database.executeBatch(batch);
		Test.stopTest();
        
        System.assertNotEquals(0, [SELECT Id FROM SBQQ__Subscription__c WHERE Souscription_Conforme__c = true].size());
    }
}
global class SubscriptionComplianceCheck implements Database.Batchable<sObject> {
    
    private String query;


    //initialistaion de la requete du batch
    global SubscriptionComplianceCheck() {
		this.query = '';
        this.query += 'SELECT Id, CompanyAddressCity__c, OrderNumber__c, CompanyAddressCountry__c, CompanyPhone__c, ContactGender__c, ContactLastName__c,';
        this.query +=  'ContactFirstName__c, Companyindustry__c, CompanyName__c, PrintVolume__c, BroadcastSoftware__c, PromoterDescription__c, SBQQ__RequiredById__c,';
        this.query +=  'FlowType__c, BroadcastPartner__c, PostalCode__c, Souscription_Conforme__c, ComplianceProcess__c, Status__c, AccessStoreState__c,';
        this.query +=  'ProductWorkflow__c, AccessUserId__c, KilometerRadius__c, AccessStoreId__c, CompanyAddressStreet__c, CompanyAddressZipcode__c, LeadPhone__c,';
        this.query +=  'ContractEmail__c, CompanySegment__c, CompanySiret__c,';
        //ajout du nouveaux champ pour la partie 4
        this.query +=  'MissingInformations__c';
		this.query += ' FROM SBQQ__Subscription__c';
		this.query += ' WHERE Status__c = ' + '\'' + Sub_Constant.ELEMENTS_MANQUANTS + '\'';
		this.query += ' AND Souscription_Conforme__c = false';
		
	}
    
    //utilisation d'un query locator afin de tenir compte de la possible grosse volumétrie des subscriptions à traiter. en effet les limitations
    // quant au nombre d'elements retournés par la requete (50000) est bypassée.
    global Database.QueryLocator start(Database.BatchableContext cnx) { 
         return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext cnx, List<sObject> scope) {
        try {
            //traitement business englobée dans la classe de service SubscriptionComplianceService 
           SubscriptionComplianceService.setConformite((List<SBQQ__Subscription__c>)scope);
            
        } catch(Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }
    
    global void finish(Database.BatchableContext cnx) {
    }
    

    

}
//classe utilitaire de test permettant d'initier un environnement contenant des données de test
@isTest
public class TestDataFactory {

    //methode utilitaire de création de subscriptions pour les classes de test.
    public static void createSubscriptions(){

        
        Account compte = Account_DataFactory.createAccount('compte_1', '+33 6 00 00 00 00', '37915832200097');
        compte.Segmentation__c = Sub_Constant.SSII;
        compte.CompanyIndustry__c = 'Beauty';
        compte.BillingCountry = 'France';
        compte.BillingCity = 'city';
        compte.BillingState = 'Île-de-France';
        compte.BillingPostalCode = '93600';
        compte.BillingStreet = 'street';
        UPDATE compte;
        Acces_beneficiaire__c benef1 = AccesBeneficiaire_DataFactory.createBeneficiaire('benef_1', compte.Id, 'test1@lbc.fr', Sub_Constant.CREATED);
        benef1.AccessUserId__c = 'OUAH';
        benef1.AccessStoreId__c = 'OUAH';
        benef1.AccessCategory__c = Sub_Constant.MODE;
        benef1.Segmentation__c = Sub_Constant.SSII;
        benef1.AccessSalutation__c = Sub_Constant.MME;
        benef1.AccessFirstname__c = 'Mimmi';
        benef1.AccessLastname__c = 'Montey';
        benef1.AccessAddressStreet__c = '11 nowhere';
        benef1.AccessCategory__c = 'RealEstate';
        benef1.AccessAddressCountry__c = 'FR';
        benef1.AccessAddressCity__c = 'city';
        benef1.AccessAddressZipcode__c = '22000';
        UPDATE benef1;
        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        SBQQ__Subscription__c parent = new SBQQ__Subscription__c(
            SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, 
            ComplianceProcess__c = Sub_Constant.PARENT_BUNDLE);
        INSERT parent;
        SBQQ__Subscription__c immo = new SBQQ__Subscription__c(
            SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.IMMO_NEUF, LeadPhone__c = '+33 6 00 00 00 66',
			ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, FlowType__c = Sub_Constant.MANUEL);
        INSERT immo;
        immo.PromoterDescription__c = 'UBIFLOW4';
        UPDATE immo;
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.BOUTIQUE, 
                                           ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, FlowType__c = 'Manuel', BeneficiaryAccount__c = compte.Id));
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.DIFFUSION_LBC, 
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, BeneficiaryAccount__c = compte.Id,
                                           BroadcastSoftware__c = Sub_Constant.CLOVER, BroadcastPartner__c = Sub_Constant.UBIFLOW, FlowType__c = 'Manuel'));
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.DIFFUSION_AVAL, FlowType__c = 'Manuel',
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, BeneficiaryAccount__c = compte.Id));
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.VISIBILITE_AVAL, FlowType__c = 'Manuel',
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, SBQQ__RequiredById__c = parent.Id, BeneficiaryAccount__c = compte.Id));
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.CREDIT, FlowType__c = 'Manuel',
                                             ProductWorkflow__c = 'yeah',BeneficiaryAccess__c = benef1.Id, BeneficiaryAccount__c = compte.Id));
        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, Status__c = Sub_Constant.ELEMENTS_MANQUANTS, ComplianceProcess__c = Sub_Constant.PUB_LOCAL, OrderNumber__c = '00215',
                                             PostalCode__c = 7500, KilometerRadius__c = '50', PrintVolume__c = 25));
        INSERT subs;

    }

}

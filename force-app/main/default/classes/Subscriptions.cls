public class Subscriptions {
    
    public list<SBQQ__Subscription__c> subscriptions{get; private set;}
    
    public Subscriptions(List<SBQQ__Subscription__c> subList) {
        subscriptions = subList.clone();
        
    }
    // verification de la conformité des souscriptions traitées.
    public void setConformite(List<SBQQ__Subscription__c> subsToUpdate){
        
        
        Boolean complianceProcesssCheck;
        String complianceProcess;
        
        for (SBQQ__Subscription__c sub:subscriptions){
            //gestion du processus IMMO NEUF
            if(sub.ComplianceProcess__c == Sub_Constant.IMMO_NEUF){
                complianceProcesssCheck = (sub.PromoterDescription__c != null && sub.FlowType__c != null && sub.ProductWorkflow__c != null
                                           && sub.ContractEmail__c != null && sub.CompanySiret__c != null && sub.CompanyName__c != null
                                           && sub.CompanyAddressStreet__c != null && sub.CompanyAddressZipcode__c != null && sub.CompanyAddressCity__c != null
                                           && sub.CompanyPhone__c != null && sub.ContactGender__c != null && sub.ContactFirstName__c != null 
                                           && sub.ContactLastName__c != null && sub.LeadPhone__c != null);
            }
            //Gestion du processus PUB
            if(sub.ComplianceProcess__c == Sub_Constant.PUB){
                complianceProcesssCheck = (sub.EffectiveEndDate__c > Date.today());
            }
            
            
            if (complianceProcesssCheck == true){
                sub.Souscription_Conforme__c = true;
                subsToUpdate.add(sub);
                setParentConforme(sub.SBQQ__RequiredById__c, subsToUpdate);
                
            }
            complianceProcesssCheck = false;
        }
        
        if (subsToUpdate.size()>0){
            setMissingInformations(subsToUpdate);            
        }
        
        
    }
    
    
    // le gestionnaire de declencheur pour SBQQ__Subscription__c
    public static void triggerHandler(List<SBQQ__Subscription__c> subs){
        Subscriptions subscriptions = new Subscriptions(subs);
        if (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert){
            subscriptions.onAfterInsert();
        }
        
        if (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate){
            subscriptions.onAfterUpdate();
        }
        
    }
    
    //Traitement pour l'evenement afetr Insert
    private void onAfterInsert(){
        setContractEndDate();
    }
    
    //Traitement pour l'evenement afetr Update
    private void onAfterUpdate(){
        setContractEndDate();
    }
    
    //set la end date des contrats des subscriptions.
    public void setContractEndDate(){
        Set<Id> cons = new Set<Id>();
        Boolean isTerminate;
        Date terminatedDate;
        Date endDate;
        for (SBQQ__Subscription__c sub :subscriptions) {
            cons.add(sub.SBQQ__Contract__c);
        }
        try {
            List<Contract> conts = new List<Contract>();
            for (Contract con : [SELECT Id, EndDate, (SELECT Id, SBQQ__EndDate__c, SBQQ__TerminatedDate__c, SBQQ__Contract__c 
                                                      FROM SBQQ__Subscriptions__r) FROM Contract WHERE Id IN :cons]) {
                                                          system.debug('contrat on :: '+con)   ; 
                                                          isTerminate = true;
                                                          terminatedDate = con.EndDate;
                                                          endDate = con.EndDate;
                                                          
                                                          for (SBQQ__Subscription__c sub : con.SBQQ__Subscriptions__r) {
                                                              if (sub.SBQQ__TerminatedDate__c == null) {
                                                                  isTerminate = false;
                                                              } 
                                                              else if (terminatedDate < sub.SBQQ__TerminatedDate__c) {
                                                                  terminatedDate = sub.SBQQ__TerminatedDate__c;
                                                              }
                                                              if (sub.SBQQ__EndDate__c != null && endDate < sub.SBQQ__EndDate__c) {
                                                                  endDate = sub.SBQQ__EndDate__c;
                                                              }
                                                          }
                                                          
                                                          if (isTerminate) {
                                                              con.EndDate = terminatedDate;
                                                          } 
                                                          else {
                                                              con.EndDate = endDate;
                                                          }
                                                          
                                                          
                                                          conts.add(con);
                                                      }
            
            UPDATE conts;
            
            
        } catch(Exception e) {
            throw e;
            
            
        }
        
        
        
    }
    
    
    
    
    private void setParentConforme(String parentId, List<SBQQ__Subscription__c> subsToUpdate) {
        SBQQ__Subscription__c[] parentSub = [SELECT Id, Souscription_Conforme__c FROM SBQQ__Subscription__c WHERE Status__c = :Sub_Constant.ELEMENTS_MANQUANTS 
                                             AND Souscription_Conforme__c = false AND Id = :parentId];
        if (parentSub.size() > 0) {
            parentSub[0].Souscription_Conforme__c = true;
            subsToUpdate.add(parentSub[0]);
            
        }
        
    }
    //Renseigne les champs vérifiée pour chaque process en cas de non conformité.
    private void setMissingInformations(List<SBQQ__Subscription__c> subs){
        for (SBQQ__Subscription__c sub:subs){
            if (sub.ComplianceProcess__c == Sub_Constant.IMMO_NEUF){
                sub.MissingInformations__c = Sub_Constant.IMMO_NEUF_MISSING;
                
            }
            if (sub.ComplianceProcess__c == Sub_Constant.PUB){
                sub.MissingInformations__c = Sub_Constant.PUB_MISSING;
                
            }
        }
    }
    
    
    
}
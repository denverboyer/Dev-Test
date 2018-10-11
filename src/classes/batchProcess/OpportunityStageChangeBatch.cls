global class OpportunityStageChangeBatch implements Database.Batchable<sObject> {

    private static integer year = 365;
    map<string, integer> limits = new map<string, integer>();
   global Database.QueryLocator start(Database.BatchableContext bc) {
    	Opportunity_Stage_Limit__mdt[] limitList = [SELECT Stage_Name__c,Day_Limit__c FROM Opportunity_Stage_Limit__mdt];
       for(Opportunity_Stage_Limit__mdt mdt: limitList){
           limits.put(mdt.Stage_Name__c, (integer)mdt.Day_Limit__c);
       } 
       return Database.getQueryLocator([SELECT Id,Name,stageChangeDate__c,CurrentStage__c,PreviousStage__c FROM Opportunity]);
   }

   private boolean isOverStageLimit(Opportunity opp){
   		Integer days = limits.get(opp.CurrentStage__c);
        Integer tmp = opp.stageChangeDate__c.date().daysBetween(DateTime.now().date());
        if(tmp >= days){
        	return true;
        }     
   		return false;
   }
   global void execute(Database.BatchableContext bc, List<Opportunity> records){
       List<Opportunity> changedRecords = new List<Opportunity>();
       for(Opportunity opp : records)
        {        
            // Test change date agianst acceptable limits in the 
            // custom setting `Opportunity Stage Limits` 
            if(opp.stageChangeDate__c != null && isOverStageLimit(opp)){
            	opp = stageChangeProcess(opp);
                changedRecords.add(opp);
                system.debug('Updated Opp: ' + opp.Name + ' ID: ' + opp.Id);
            }
        }
        try {
            // Update the Opportunity Records
            update changedRecords;         
        } catch(Exception e) {
            System.debug(e);
        } 
   }    
   
    private Opportunity stageChangeProcess(Opportunity opp){
    	return null;    
    }
   global void finish(Database.BatchableContext bc){
       // execute any post-processing operations
   } 
}
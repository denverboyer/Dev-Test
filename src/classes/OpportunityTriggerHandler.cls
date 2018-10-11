public class OpportunityTriggerHandler extends TriggerHandler {

  private Map<Id, Opportunity> newOppMap;
  private Map<Id, Opportunity> oldOppMap;
  private List<Opportunity> updatedRecords = new List<Opportunity>();
    
  public OpportunityTriggerHandler() {
    this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
    this.oldOppMap = (Map<Id, Opportunity>) Trigger.oldMap;
  }
  
    public Opportunity updateStageData(Opportunity current, Opportunity old, ID index){
  	  Opportunity result = current;
      result.stageChangeDate__c = DateTime.now();
      result.PreviousStage__c = old.CurrentStage__c;
      result.Id = index;
      return result;
  	}
   
    public override void afterUpdate() {
        List<OpportunityMovement__c> newRecords = new List<OpportunityMovement__c>();
        for(ID index: newOppMap.keySet()) {
      		Opportunity current = newOppMap.get(index).clone();
      		Opportunity old = oldOppMap.get(index).clone();
            // Check for opportunity stage changes and if true add new movement record
            if(current.CurrentStage__c != old.CurrentStage__c){
            	newRecords.add(createMovementRecord(current, old, index, newOppMap.get(index).LastModifiedById));
                updatedRecords.add(updateStageData(current, old, index));  
            }
      	}
        try{
        update updatedRecords;
        insert newRecords;
        } catch(Exception e){
            system.debug('Trigger DML Failed' + e.getMessage());
        }
  	}
    public OpportunityMovement__c createMovementRecord(Opportunity current, Opportunity old, Id index, Id LastModifiedById){
    	OpportunityMovement__c newRecord = new OpportunityMovement__c();   
        newRecord.PreviousStage__c = old.CurrentStage__c;
        newRecord.CurrentStage__c = current.CurrentStage__c;
        newRecord.Previous_Stage_Start_Date__c = old.stageChangeDate__c;
        newRecord.Previous_Stage_End_Date__c = DateTime.now();
        newRecord.OwnerId = LastModifiedById;
        newRecord.Opportunity__c = index;
        newRecord.Name = newRecord.PreviousStage__c + ' -> ' + newRecord.CurrentStage__c; 
        return newRecord;
    }
}
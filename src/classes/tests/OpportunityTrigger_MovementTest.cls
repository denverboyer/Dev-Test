@isTest
private class OpportunityTrigger_MovementTest {

    
    @isTest
    public static void MovementTest(){
    	string name = 'Test Record: ' + DateTime.now();
		createRecord(name);
        changeStage('RF1', name);
        testPreviousStage('Qualified', name);
        changeStage('Parked', name);
        testPreviousStage('RF1', name);
        countMovementRecords(2, name);
	}
    
    private static void countMovementRecords(Integer movementRecords, string parentRecord){
        Opportunity testRecord = [select Id,Name from Opportunity where Name = :parentRecord];
        List <OpportunityMovement__c> records = [select Id from OpportunityMovement__c where Opportunity__c = :testRecord.Id];
    	system.assertEquals(movementRecords, records.size());
    }
    
    private static void testPreviousStage(string stage, string name){
    	Opportunity testRecord = [select Name,PreviousStage__c from Opportunity where Name = :name];
        system.assertEquals(stage, testRecord.PreviousStage__c);
    }
    
    private static void createRecord(string name){
        Opportunity testRecord = new Opportunity();
		testRecord.Name = name;
		testRecord.stageChangeDate__c = DateTime.now();
		testRecord.CurrentStage__c = 'Qualified'; 
		testRecord.CloseDate = Date.today() + 5;
		testRecord.StageName = 'Prospecting';
        try{
            insert testRecord;
        }catch (Exception e){
            system.debug(e.getMessage());
        }
    }
    
    private static void changeStage(string stage, string name){
        Opportunity testRecord = [select Name,CurrentStage__c from Opportunity where Name = :name];
        testRecord.CurrentStage__c = stage;
        try{
            update testRecord;
        } catch(Exception e) {
            system.debug(e.getMessage());
        }
	}
}
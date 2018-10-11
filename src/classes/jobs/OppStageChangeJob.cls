global class OppStageChangeJob implements Schedulable {

        global void execute(SchedulableContext ctx) {
        	OpportunityStageChangeBatch ob = new OpportunityStageChangeBatch();
			database.executeBatch(ob);
        }
}
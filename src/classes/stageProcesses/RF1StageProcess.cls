public class RF1StageProcess {

    public static Opportunity execute (Opportunity opp){
        opp.CurrentStage__c = 'Qualified';
        return opp;
    }
}
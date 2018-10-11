public class RFPStageProcess {

    public static Opportunity execute (Opportunity opp){
        opp.CurrentStage__c = 'RF1';
        return opp;
    }
}
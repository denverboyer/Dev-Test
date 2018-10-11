public class StageChangeProcess {

    public static Opportunity execute (Opportunity opp)
    {
        switch on opp.CurrentStage__c {
            when 'Qualified' {
                return QualifiedStageProcess.execute(opp);
            } 
            when 'RF1' {
                return RF1StageProcess.execute(opp);
            }
            when 'RFP' {
                return RFPStageProcess.execute(opp);
            }
            when 'Top 2' {
                return Top2StageProcess.execute(opp);
            }
            when 'Finalized' {
                return FinalizedStageProcess.execute(opp);
            }
            when 'Awarded' {
                return AwardedStageProcess.execute(opp);
            }
            when else {
            	return opp;    
            }
        }
    }
}
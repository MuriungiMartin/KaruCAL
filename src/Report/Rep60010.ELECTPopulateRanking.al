#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60010 "ELECT-Populate Ranking"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Pos;UnknownTable60001)
        {
            DataItemTableView = where("Position Approved"=filter(Yes));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(Cands;UnknownTable60006)
            {
                DataItemLink = "Election Code"=field("Election Code"),"Position Code"=field("Position Code"),"Position Category"=field("Position Category");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Cands.CalcFields("Votes Count");
                    ELECTResultsRankings.Reset;
                    ELECTResultsRankings.SetRange(ELECTResultsRankings."Election Code",Cands."Election Code");
                    ELECTResultsRankings.SetRange(ELECTResultsRankings."Position Code",Cands."Position Code");
                    ELECTResultsRankings.SetRange(ELECTResultsRankings."Candidate No.",Cands."Candidate No.");
                    if ELECTResultsRankings.Find('-') then begin
                        ELECTResultsRankings."Votes Count":=Cands."Votes Count";
                        ELECTResultsRankings.Modify;
                      end else begin
                        ELECTResultsRankings.Init;
                        ELECTResultsRankings."Election Code":=Cands."Election Code";
                        ELECTResultsRankings."Position Code":=Cands."Position Code";
                        ELECTResultsRankings."Candidate No.":=Cands."Candidate No.";
                        ELECTResultsRankings."Votes Count":=Cands."Votes Count";
                        ELECTResultsRankings.Insert;
                        end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ELECTResultsRankings: Record UnknownRecord60010;
}


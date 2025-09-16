#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60020 "ELECT-My Candidateszzz"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(MyCands;UnknownTable60012)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ELECTElectRandomVote.Init;
                ELECTElectRandomVote."Election Code":=MyCands."Election Code";
                ELECTElectRandomVote."Position Code":=MyCands."Position Code";
                ELECTElectRandomVote."Voter No.":=MyCands."Voter No.";
                ELECTElectRandomVote."Candidate No.":=MyCands."Candidate No.";
                if ELECTElectRandomVote.Insert then;
            end;
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
        ELECTElectRandomVote: Record UnknownRecord60015;
}


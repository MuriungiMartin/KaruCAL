#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51419 "ELECT Election Results"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT Election Results.rdlc';

    dataset
    {
        dataitem(UnknownTable61462;UnknownTable61462)
        {
            DataItemTableView = sorting(Election,Position,"Student No.");
            RequestFilterFields = Election,Position;
            column(ReportForNavId_4306; 4306)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(ELECT_Candidate_Election;Election)
            {
            }
            column(ELECT_Candidate_Position;Position)
            {
            }
            column(ELECT_Candidate__Position_Name_;"Position Name")
            {
            }
            column(ELECT_Candidate__Student_No__;"Student No.")
            {
            }
            column(ELECT_Candidate__Student_Name_;"Student Name")
            {
            }
            column(Votes;Votes)
            {
            }
            column(VotesPerc;VotesPerc)
            {
            }
            column(VotesCast;VotesCast)
            {
            }
            column(TurnOut;TurnOut)
            {
            }
            column(Registered;Registered)
            {
            }
            column(ELECT_CandidateCaption;ELECT_CandidateCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ELECT_Candidate_ElectionCaption;FieldCaption(Election))
            {
            }
            column(ELECT_Candidate_PositionCaption;FieldCaption(Position))
            {
            }
            column(ELECT_Candidate__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(ELECT_Candidate__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(VotesCaption;VotesCaptionLbl)
            {
            }
            column(Vote__Caption;Vote__CaptionLbl)
            {
            }
            column(Total_Votes_CastCaption;Total_Votes_CastCaptionLbl)
            {
            }
            column(Total_Registered_VotersCaption;Total_Registered_VotersCaptionLbl)
            {
            }
            column(Percentage_TurnoutCaption;Percentage_TurnoutCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vt.Reset;
                Vt.SetRange(Vt.Election,Election);
                Vt.SetRange(Vt.Position,Position);
                Vt.SetRange(Vt."Candidate No.","Student No.");
                Votes:=Vt.Count;
                Vt.Reset;
                Vt.SetRange(Vt.Election,Election);
                Vt.SetRange(Vt.Position,Position);
                VotesPerc:=(Votes/Vt.Count) * 100;
                
                /*Get the details of the transaction*/
                Student.Reset;
                Student.SetRange(Student."Customer Type",Student."customer type"::Student);
                Registered:=Student.Count;
                
                Vt.Reset;
                Vt.SetRange(Vt.Election,Election);
                Vt.SetRange(Vt.Position,Position);
                VotesCast:=Vt.Count;
                
                TurnOut:=(VotesCast/Registered) * 100;

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Position);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Votes: Integer;
        VotesPerc: Decimal;
        Vt: Record UnknownRecord61464;
        VotesCast: Integer;
        Registered: Integer;
        TurnOut: Decimal;
        Student: Record Customer;
        ELECT_CandidateCaptionLbl: label 'ELECT Candidate';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        VotesCaptionLbl: label 'Votes';
        Vote__CaptionLbl: label 'Vote %';
        Total_Votes_CastCaptionLbl: label 'Total Votes Cast';
        Total_Registered_VotersCaptionLbl: label 'Total Registered Voters';
        Percentage_TurnoutCaptionLbl: label 'Percentage Turnout';
}


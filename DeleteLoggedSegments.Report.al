#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5191 "Delete Logged Segments"
{
    Caption = 'Delete Logged Segments';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Logged Segment";"Logged Segment")
        {
            DataItemTableView = sorting("Entry No.") where(Canceled=const(true));
            RequestFilterFields = "Entry No.","Segment No.";
            column(ReportForNavId_2623; 2623)
            {
            }

            trigger OnAfterGetRecord()
            var
                InteractionLogEntry: Record "Interaction Log Entry";
                CampaignEntry: Record "Campaign Entry";
            begin
                InteractionLogEntry.SetCurrentkey("Logged Segment Entry No.");
                InteractionLogEntry.SetRange("Logged Segment Entry No.","Entry No.");
                InteractionLogEntry.ModifyAll("Logged Segment Entry No.",0,true);
                CampaignEntry.SetCurrentkey("Register No.");
                CampaignEntry.SetRange("Register No.","Entry No.");
                CampaignEntry.ModifyAll("Register No.",0,true);
                NoOfSegments := NoOfSegments + 1;
                Delete(true);
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

    trigger OnPostReport()
    begin
        Message(Text000,NoOfSegments,"Logged Segment".TableCaption);
    end;

    var
        NoOfSegments: Integer;
        Text000: label '%1 %2 has been deleted.';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69159 "FLT-Cue"
{
    PageType = CardPart;
    SourceTable = UnknownTable61822;

    layout
    {
        area(content)
        {
            cuegroup("Registration Statistics")
            {
                Caption = 'Registration Statistics';
                field("New Transport Requisitions";"New Transport Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Transport requisitions';
                    DrillDownPageID = "FLT-Transport Req. List";
                }
                field("Approved Transport Req";"Approved Transport Req")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Transport Requisitions';
                    DrillDownPageID = "FLT-Approved transport Req";
                }
                field("New Safari Notices";"New Safari Notices")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Travel Notices';
                    DrillDownPageID = "FLT-Safari Notices List";
                }
                field(InactiveEmp;"Approved Safari Notices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Travel Notices';
                    DrillDownPageID = "FLT-Posted Safari Notices List";
                }
            }
        }
    }

    actions
    {
    }
}


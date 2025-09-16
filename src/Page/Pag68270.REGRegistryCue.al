#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68270 "REG-Registry Cue"
{
    PageType = CardPart;
    SourceTable = UnknownTable61189;

    layout
    {
        area(content)
        {
            cuegroup(Registry)
            {
                Caption = 'Registry';
                field("New Files";"New Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Files';
                    DrillDownPageID = "REG-Registry Files View";
                }
                field("Active Files";"Active Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Files';
                    DrillDownPageID = "REG-Registry Files View";
                }
                field("Partially Active";"Partially Active")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partially Active Files';
                    DrillDownPageID = "REG-Registry Files View";
                }
                field(BrimgupFiles;"Bring-up Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bring-up Files';
                    DrillDownPageID = "REG-Registry Files View";
                }
                field("Archived Files";"Archived Files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archived Files';
                    DrillDownPageID = "REG-Registry Files View";
                }
            }
            cuegroup("Inbound Mails")
            {
                Caption = 'Inbound Mails';
                field(NewInbound;"New Inbound Mails")
                {
                    ApplicationArea = Basic;
                    Caption = 'New (Inbound)';
                    DrillDownPageID = "REG-Mail Register View";
                }
            }
            cuegroup("Outbound Mails")
            {
                Caption = 'Outbound Mails';
                field(OutboundNew;"New Outbound Mails")
                {
                    ApplicationArea = Basic;
                    Caption = 'New (Outbound)';
                    DrillDownPageID = "REG-Mail Register View";
                }
            }
        }
    }

    actions
    {
    }
}


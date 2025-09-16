#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 743 "VAT Report Setup"
{
    Caption = 'Tax Report Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "VAT Report Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Modify Submitted Reports";"Modify Submitted Reports")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if users can modify tax reports that have been submitted to the tax authorities. If the field is left blank, users must create a corrective or supplementary tax report instead.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number series that will be used for standard tax reports.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 754 "Standard Item Journal"
{
    Caption = 'Standard Item Journal';
    PageType = ListPlus;
    SourceTable = "Standard Item Journal";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the record in the line of the journal.';
                }
            }
            part(StdItemJnlLines;"Standard Item Journal Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Journal Template Name"=field("Journal Template Name"),
                              "Standard Journal Code"=field(Code);
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if xRec.Code = '' then
          SetRange(Code,Code);
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 751 "Standard General Journal"
{
    Caption = 'Standard General Journal';
    PageType = ListPlus;
    SourceTable = "Standard General Journal";

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
                    ToolTip = 'Specifies a code to identify the standard general journal that you are about to save.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a text that indicates the purpose of the standard general journal.';
                }
            }
            part(StdGenJnlLines;"Standard Gen. Journal Subform")
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


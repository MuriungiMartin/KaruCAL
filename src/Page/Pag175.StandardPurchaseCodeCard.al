#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 175 "Standard Purchase Code Card"
{
    Caption = 'Standard Purchase Code Card';
    PageType = ListPlus;
    SourceTable = "Standard Purchase Code";

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
                    ToolTip = 'Specifies a code which identifies this standard purchase code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the standard purchase code.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amounts on the standard purchase lines.';
                }
            }
            part(StdPurchaseLines;"Standard Purchase Code Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Standard Purchase Code"=field(Code);
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
}


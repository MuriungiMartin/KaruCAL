#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10146 "Deposit List"
{
    Caption = 'Deposit List';
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable10140;

    layout
    {
    }

    actions
    {
        area(creation)
        {
            action(Deposit)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Deposit';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page Deposit;
                ToolTip = 'Open the deposit card.';
            }
        }
        area(reporting)
        {
            action("Deposit Test Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Deposit Test Report';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Deposit Test Report";
                ToolTip = 'Verify the result of posting the deposit before you run the Deposit report.';
            }
        }
    }
}


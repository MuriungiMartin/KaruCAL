#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 4 "Payment Terms"
{
    ApplicationArea = Basic;
    Caption = 'Payment Terms';
    PageType = List;
    SourceTable = "Payment Terms";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to identify this set of payment terms.';
                }
                field("Due Date Calculation";"Due Date Calculation")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a formula that determines how to calculate the due date, for example, when you create an invoice.';
                }
                field("Discount Date Calculation";"Discount Date Calculation")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date formula if the payment terms include a possible payment discount.';
                }
                field("Discount %";"Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the percentage of the invoice amount (amount including tax is the default setting) that will constitute a possible payment discount.';
                }
                field("Calc. Pmt. Disc. on Cr. Memos";"Calc. Pmt. Disc. on Cr. Memos")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that a payment discount, cash discount, cash discount date, and due date are calculated on credit memos with these payment terms.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an explanation of the payment terms.';
                }
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
        area(processing)
        {
            action("T&ranslation")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'T&ranslation';
                Image = Translation;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Term Translations";
                RunPageLink = "Payment Term"=field(Code);
                ToolTip = 'View or edit descriptions for each payment method in different languages.';
            }
        }
    }
}


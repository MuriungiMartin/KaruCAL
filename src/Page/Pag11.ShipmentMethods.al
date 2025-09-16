#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 11 "Shipment Methods"
{
    ApplicationArea = Basic;
    Caption = 'Shipment Methods';
    PageType = List;
    SourceTable = "Shipment Method";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code for the shipment method.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the shipment method.';
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
                ApplicationArea = Suite;
                Caption = 'T&ranslation';
                Image = Translation;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Shipment Method Translations";
                RunPageLink = "Shipment Method"=field(Code);
                ToolTip = 'Describe the shipment method in different languages. The translated descriptions appear on quotes, orders, invoices, and credit memos, based on the shipment method code and the language code on the document.';
            }
        }
    }
}


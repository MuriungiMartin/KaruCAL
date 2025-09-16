#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 477 "Currencies for Fin. Chrg Terms"
{
    Caption = 'Currencies for Fin. Chrg Terms';
    DataCaptionFields = "Fin. Charge Terms Code";
    PageType = List;
    SourceTable = "Currency for Fin. Charge Terms";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the currency in which you want to define finance charge terms.';
                }
                field("Additional Fee";"Additional Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a fee amount in foreign currency. The currency of this amount is determined by the currency code.';
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
    }
}


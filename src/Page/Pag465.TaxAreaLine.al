#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 465 "Tax Area Line"
{
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Tax Area Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Tax Jurisdiction Code";"Tax Jurisdiction Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a tax jurisdiction code.';
                }
                field("Jurisdiction Description";"Jurisdiction Description")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the description from the tax jurisdiction table when you enter the tax jurisdiction code.';
                }
                field("Calculation Order";"Calculation Order")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an integer to determine the sequence the program must use when tax is calculated.';
                }
            }
        }
    }

    actions
    {
    }
}


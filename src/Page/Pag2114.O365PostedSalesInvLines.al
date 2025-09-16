#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2114 "O365 Posted Sales Inv. Lines"
{
    Caption = 'Sent Invoice Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the item or service on the line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales lines. It is used to calculate the invoice discount of the sales document.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the item.';
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax % that was used on the sales or purchase lines with this Tax Identifier.';
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group code for the tax-detail entry.';
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total of the amounts in all the amount fields on the invoice, in the currency of the invoice. The amount includes Tax.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price for one unit on the sales line.';
                }
            }
        }
    }

    actions
    {
    }
}


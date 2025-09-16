#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6039 "Service Cr. Memo Lines Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Cr.Memo Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    HideValue = DocumentNoHideValue;
                    Lookup = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the credit memo.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to whom you sent the invoice.';
                    Visible = false;
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to receive the service on the credit memo.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the credit memo line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account, item, resource, or cost on the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the variant set up for the item on the credit memo line.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item on the credit memo line is a nonstock item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of an item, resource, cost, general ledger account, or some descriptive text on the service credit memo line.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, in which the credit memo line was registered.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin from which the service items were shipped.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to the credit memo line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to the credit memo.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, or cost on the credit memo line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of item units, resource hours, general ledger account payments, or cost specified on the credit memo line.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the unit of measure for the item, resource, or cost on the credit memo line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost per unit of item, resource, or cost on this line.';
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the percentage of the discount that was provided on this line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the discount calculated for the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that an invoice discount could be calculated for this line.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice discount amount calculated on the line.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the posted service credit memo.';
                    Visible = false;
                }
                field("Shipment No.";"Shipment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted shipment for this credit memo line.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item linked to this credit memo line.';
                    Visible = false;
                }
                field("Appl.-to Service Entry";"Appl.-to Service Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service ledger entry applied to this service credit memo.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the service credit memo line is applied from.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := IsFirstDocLine;
        DocumentNoHideValue := not IsFirstDocLine;
    end;

    var
        TempServCrMemoLine: Record "Service Cr.Memo Line" temporary;
        [InDataSet]
        StyleIsStrong: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;

    local procedure IsFirstDocLine(): Boolean
    var
        ServCrMemoLine: Record "Service Cr.Memo Line";
    begin
        TempServCrMemoLine.Reset;
        TempServCrMemoLine.CopyFilters(Rec);
        TempServCrMemoLine.SetRange("Document No.","Document No.");
        if not TempServCrMemoLine.FindFirst then begin
          ServCrMemoLine.CopyFilters(Rec);
          ServCrMemoLine.SetRange("Document No.","Document No.");
          if not ServCrMemoLine.FindFirst then
            exit(false);
          TempServCrMemoLine := ServCrMemoLine;
          TempServCrMemoLine.Insert;
        end;
        exit("Line No." = TempServCrMemoLine."Line No.");
    end;
}


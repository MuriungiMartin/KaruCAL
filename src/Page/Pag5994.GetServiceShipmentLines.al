#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5994 "Get Service Shipment Lines"
{
    Caption = 'Get Service Shipment Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Service Shipment Line";

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
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of this shipment.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to whom you send the invoice.';
                    Visible = true;
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items on the service order.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this shipment line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item, general ledger account, resource code, or cost on the line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the variant set up for the item on the service line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of an item, resource, cost, or a standard text on the service line.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the currency code for various amounts on the shipment.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to this shipment line.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code assigned to this shipment line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, general ledger account, or cost on the shipment line.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.';
                }
                field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates how many item units, resource hours, general ledger account payments, or cost on the line have been shipped but not invoiced or consumed.';
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates how many item units, resource hours, general ledger account payments, or costs on the line have been invoiced.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the unit of measure for the item, resource, or cost on the service line.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry to which the items on the line were applied when the shipment was posted.';
                    Visible = false;
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ServiceShptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Service Shipment",ServiceShptHeader);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Item &Tracking Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        ShowItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := IsFirstDocLine;
        DocumentNoHideValue := not IsFirstDocLine;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          OKOnPush;
    end;

    var
        ServiceShptHeader: Record "Service Shipment Header";
        ServiceHeader: Record "Service Header";
        TempServiceShptLine: Record "Service Shipment Line" temporary;
        ServiceGetShpt: Codeunit "Service-Get Shipment";
        [InDataSet]
        StyleIsStrong: Boolean;
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure SetServiceHeader(var ServiceHeader2: Record "Service Header")
    begin
        ServiceHeader.Get(ServiceHeader2."Document Type",ServiceHeader2."No.");
        ServiceHeader.TestField("Document Type",ServiceHeader."document type"::Invoice);
    end;

    local procedure IsFirstDocLine(): Boolean
    var
        ServiceShptLine: Record "Service Shipment Line";
    begin
        TempServiceShptLine.Reset;
        TempServiceShptLine.CopyFilters(Rec);
        TempServiceShptLine.SetRange("Document No.","Document No.");
        if not TempServiceShptLine.FindFirst then begin
          ServiceShptLine.CopyFilters(Rec);
          ServiceShptLine.SetRange("Document No.","Document No.");
          if not ServiceShptLine.FindFirst then
            exit(false);
          TempServiceShptLine := ServiceShptLine;
          TempServiceShptLine.Insert;
        end;
        if "Line No." = TempServiceShptLine."Line No." then
          exit(true);
    end;

    local procedure OKOnPush()
    begin
        GetShipmentLines;
        CurrPage.Close;
    end;


    procedure GetShipmentLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        ServiceGetShpt.SetServiceHeader(ServiceHeader);
        ServiceGetShpt.CreateInvLines(Rec);
    end;
}


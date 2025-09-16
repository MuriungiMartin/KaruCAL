#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5708 "Get Shipment Lines"
{
    Caption = 'Get Shipment Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Shipment Line";

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
                    StyleExpr = 'Strong';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. Shipped Not Invoiced";"Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
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
                        SalesShptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Sales Shipment",SalesShptHeader);
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
                        CurrPage.SaveRecord;
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
        DocumentNoHideValue := false;
        DocumentNoOnFormat;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          CreateLines;
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesHeader: Record "Sales Header";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        SalesGetShpt: Codeunit "Sales-Get Shipment";
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure SetSalesHeader(var SalesHeader2: Record "Sales Header")
    begin
        SalesHeader.Get(SalesHeader2."Document Type",SalesHeader2."No.");
        SalesHeader.TestField("Document Type",SalesHeader."document type"::Invoice);
    end;

    local procedure IsFirstDocLine(): Boolean
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        TempSalesShptLine.Reset;
        TempSalesShptLine.CopyFilters(Rec);
        TempSalesShptLine.SetRange("Document No.","Document No.");
        if not TempSalesShptLine.FindFirst then begin
          SalesShptLine.CopyFilters(Rec);
          SalesShptLine.SetRange("Document No.","Document No.");
          SalesShptLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
          if SalesShptLine.FindFirst then begin
            TempSalesShptLine := SalesShptLine;
            TempSalesShptLine.Insert;
          end;
        end;
        if "Line No." = TempSalesShptLine."Line No." then
          exit(true);
    end;


    procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        SalesGetShpt.SetSalesHeader(SalesHeader);
        SalesGetShpt.CreateInvLines(Rec);
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}


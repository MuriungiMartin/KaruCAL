#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5709 "Get Receipt Lines"
{
    Caption = 'Get Receipt Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Purch. Rcpt. Line";

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
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
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
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. Rcd. Not Invoiced";"Qty. Rcd. Not Invoiced")
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
                        PurchRcptHeader.Get("Document No.");
                        Page.Run(Page::"Posted Purchase Receipt",PurchRcptHeader);
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
        DocumentNoHideValue := false;
        DocumentNoOnFormat;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          CreateLines;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        GetReceipts: Codeunit "Purch.-Get Receipt";
        [InDataSet]
        DocumentNoHideValue: Boolean;


    procedure SetPurchHeader(var PurchHeader2: Record "Purchase Header")
    begin
        PurchHeader.Get(PurchHeader2."Document Type",PurchHeader2."No.");
        PurchHeader.TestField("Document Type",PurchHeader."document type"::Invoice);
    end;

    local procedure IsFirstDocLine(): Boolean
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        TempPurchRcptLine.Reset;
        TempPurchRcptLine.CopyFilters(Rec);
        TempPurchRcptLine.SetRange("Document No.","Document No.");
        if not TempPurchRcptLine.FindFirst then begin
          PurchRcptLine.CopyFilters(Rec);
          PurchRcptLine.SetRange("Document No.","Document No.");
          PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced",'<>0');
          if PurchRcptLine.FindFirst then begin
            TempPurchRcptLine := PurchRcptLine;
            TempPurchRcptLine.Insert;
          end;
        end;
        if "Line No." = TempPurchRcptLine."Line No." then
          exit(true);
    end;

    local procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        GetReceipts.SetPurchHeader(PurchHeader);
        GetReceipts.CreateInvLines(Rec);
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine then
          DocumentNoHideValue := true;
    end;
}


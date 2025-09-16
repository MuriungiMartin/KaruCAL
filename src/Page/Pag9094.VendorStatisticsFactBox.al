#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9094 "Vendor Statistics FactBox"
{
    Caption = 'Vendor Statistics';
    PageType = CardPart;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor No.';
                ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                Visible = ShowVendorNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Balance (LCY)";"Balance (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding tax on all completed purchase invoices and credit memos.';

                trigger OnDrillDown()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    DtldVendLedgEntry.SetRange("Vendor No.","No.");
                    Copyfilter("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Copyfilter("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    Copyfilter("Currency Filter",DtldVendLedgEntry."Currency Code");
                    VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                end;
            }
            field("Outstanding Orders (LCY)";"Outstanding Orders (LCY)")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the sum of outstanding orders (in $) to this vendor.';
            }
            field("Amt. Rcd. Not Invoiced (LCY)";"Amt. Rcd. Not Invoiced (LCY)")
            {
                ApplicationArea = Basic;
                Caption = 'Amt. Rcd. Not Invd. ($)';
                ToolTip = 'Specifies the total invoice amount (in $) for the items you have received but not yet been invoiced for.';
            }
            field("Outstanding Invoices (LCY)";"Outstanding Invoices (LCY)")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the sum of the vendor''s outstanding purchase invoices in $.';
            }
            field(TotalAmountLCY;TotalAmountLCY)
            {
                ApplicationArea = Basic,Suite;
                AutoFormatType = 1;
                Caption = 'Total ($)';
                ToolTip = 'Specifies the payment amount that you owe the vendor for completed purchases plus purchases that are still ongoing.';
            }
            field("Balance Due (LCY)";CalcOverDueBalance)
            {
                ApplicationArea = Basic;
                CaptionClass = FORMAT(STRSUBSTNO(Text000,FORMAT(WORKDATE)));

                trigger OnDrillDown()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    DtldVendLedgEntry.SetFilter("Vendor No.","No.");
                    Copyfilter("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Copyfilter("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    Copyfilter("Currency Filter",DtldVendLedgEntry."Currency Code");
                    VendLedgEntry.DrillDownOnOverdueEntries(DtldVendLedgEntry);
                end;
            }
            field(GetInvoicedPrepmtAmountLCY;GetInvoicedPrepmtAmountLCY)
            {
                ApplicationArea = Basic;
                Caption = 'Invoiced Prepayment Amount ($)';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetAutocalcFields("Balance (LCY)","Outstanding Orders (LCY)","Amt. Rcd. Not Invoiced (LCY)","Outstanding Invoices (LCY)");
        TotalAmountLCY := "Balance (LCY)" + "Outstanding Orders (LCY)" + "Amt. Rcd. Not Invoiced (LCY)" + "Outstanding Invoices (LCY)";
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        TotalAmountLCY := 0;

        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        ShowVendorNo := true;
    end;

    var
        TotalAmountLCY: Decimal;
        Text000: label 'Overdue Amounts ($) as of %1';
        ShowVendorNo: Boolean;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Vendor Card",Rec);
    end;


    procedure SetVendorNoVisibility(Visible: Boolean)
    begin
        ShowVendorNo := Visible;
    end;
}


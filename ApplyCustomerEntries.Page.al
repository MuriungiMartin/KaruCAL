#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 232 "Apply Customer Entries"
{
    Caption = 'Apply Customer Entries';
    DataCaptionFields = "Customer No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("ApplyingCustLedgEntry.""Posting Date""";ApplyingCustLedgEntry."Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the entry to be applied.';
                }
                field("ApplyingCustLedgEntry.""Document Type""";ApplyingCustLedgEntry."Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ToolTip = 'Specifies the document type of the entry to be applied.';
                }
                field("ApplyingCustLedgEntry.""Document No.""";ApplyingCustLedgEntry."Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the document number of the entry to be applied.';
                }
                field(ApplyingCustomerNo;ApplyingCustLedgEntry."Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer No.';
                    Editable = false;
                    ToolTip = 'Specifies the customer number of the entry to be applied.';
                    Visible = false;
                }
                field(ApplyingDescription;ApplyingCustLedgEntry.Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the entry to be applied.';
                    Visible = false;
                }
                field("ApplyingCustLedgEntry.""Currency Code""";ApplyingCustLedgEntry."Currency Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the currency code of the entry to be applied.';
                }
                field("ApplyingCustLedgEntry.Amount";ApplyingCustLedgEntry.Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the entry to be applied.';
                }
                field("ApplyingCustLedgEntry.""Remaining Amount""";ApplyingCustLedgEntry."Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the entry to be applied.';
                }
            }
            repeater(Control1)
            {
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                    Visible = AppliesToIDVisible;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the customer entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entry''s document number.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer account number that the entry is linked to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the customer entry.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Original Amount";"Original Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                    Visible = false;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry has been completely applied.';
                }
                field("CalcApplnRemainingAmount(""Remaining Amount"")";CalcApplnRemainingAmount("Remaining Amount"))
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Remaining Amount';
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Amount to Apply";"Amount to Apply")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount to apply.';

                    trigger OnValidate()
                    begin
                        Codeunit.Run(Codeunit::"Cust. Entry-Edit",Rec);

                        if (xRec."Amount to Apply" = 0) or ("Amount to Apply" = 0) and
                           (ApplnType = Applntype::"Applies-to ID")
                        then
                          SetCustApplId;
                        Get("Entry No.");
                        AmounttoApplyOnAfterValidate;
                    end;
                }
                field("CalcApplnAmounttoApply(""Amount to Apply"")";CalcApplnAmounttoApply("Amount to Apply"))
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Amount to Apply';
                    ToolTip = 'Specifies the amount to apply.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field("Pmt. Disc. Tolerance Date";"Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date the amount in the entry must be paid in order for a payment discount tolerance to be granted.';
                }
                field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.';
                    Visible = false;
                }
                field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the remaining payment discount that is available if the entry is totally applied to within the payment period.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field("CalcApplnRemainingAmount(""Remaining Pmt. Disc. Possible"")";CalcApplnRemainingAmount("Remaining Pmt. Disc. Possible"))
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Pmt. Disc. Possible';
                    ToolTip = 'Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.';
                }
                field("Max. Payment Tolerance";"Max. Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field(Positive;Positive)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the entry to be applied is positive.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the entry.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the entry.';
                }
            }
            group(Control41)
            {
                fixed(Control1903222401)
                {
                    group("Appln. Currency")
                    {
                        Caption = 'Appln. Currency';
                        field(ApplnCurrencyCode;ApplnCurrencyCode)
                        {
                            ApplicationArea = Suite;
                            Editable = false;
                            ShowCaption = false;
                            TableRelation = Currency;
                            ToolTip = 'Specifies the currency code that the amount will be applied in, in case of different currencies.';
                        }
                    }
                    group(Control1903098801)
                    {
                        Caption = 'Amount to Apply';
                        field(AmountToApply;AppliedAmount)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Amount to Apply';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the amounts on all the selected customer ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Pmt. Disc. Amount")
                    {
                        Caption = 'Pmt. Disc. Amount';
                        field("-PmtDiscAmount";-PmtDiscAmount)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Amount';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the payment discount amounts granted on all the selected customer ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group(Rounding)
                    {
                        Caption = 'Rounding';
                        field(ApplnRounding;ApplnRounding)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Rounding';
                            Editable = false;
                            ToolTip = 'Specifies the rounding difference when you apply entries in different currencies to one another. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Applied Amount")
                    {
                        Caption = 'Applied Amount';
                        field(AppliedAmount;AppliedAmount + (-PmtDiscAmount) + ApplnRounding)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Applied Amount';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the amounts in the Amount to Apply field, Pmt. Disc. Amount field, and the Rounding. The amount is in the currency represented by the code in the Currency Code field.';
                        }
                    }
                    group("Available Amount")
                    {
                        Caption = 'Available Amount';
                        field(ApplyingAmount;ApplyingAmount)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Available Amount';
                            Editable = false;
                            ToolTip = 'Specifies the amount of the journal entry, sales credit memo, or current customer ledger entry that you have selected as the applying entry.';
                        }
                    }
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field(ControlBalance;AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies any extra amount that will remain after the application.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903096107;"Customer Ledger Entry FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Entry No."=field("Entry No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Reminder/Fin. Charge Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No."=field("Entry No.");
                    RunPageView = sorting("Customer Entry No.");
                    ToolTip = 'View the reminders and finance charge entries that you have entered for the customer.';
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
                    RunPageOnRec = true;
                    ToolTip = 'View the ledger entries that have been applied to this record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Cust. Ledger Entry No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific customer ledger entry.';
                }
                action("&Navigate")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                    trigger OnAction()
                    begin
                        Navigate.SetDoc("Posting Date","Document No.");
                        Navigate.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Application")
            {
                Caption = '&Application';
                Image = Apply;
                action("Set Applies-to ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Applies-to ID';
                    Image = SelectLineToApply;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Set the Applies-to ID field on the posted entry to automatically be filled in with the document number of the entry in the journal.';

                    trigger OnAction()
                    begin
                        if (CalcType = Calctype::GenJnlLine) and (ApplnType = Applntype::"Applies-to Doc. No.") then
                          Error(CannotSetAppliesToIDErr);

                        SetCustApplId;
                    end;
                }
                action("Post Application")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post Application';
                    Ellipsis = true;
                    Image = PostApplication;
                    ShortCutKey = 'F9';
                    ToolTip = 'Define the document number of the ledger entry to use to perform the application. In addition, you specify the Posting Date for the application.';

                    trigger OnAction()
                    begin
                        PostDirectApplication(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        PostDirectApplication(true);
                    end;
                }
                separator(Action5)
                {
                    Caption = '-';
                }
                action("Show Only Selected Entries to Be Applied")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Only Selected Entries to Be Applied';
                    Image = ShowSelected;
                    ToolTip = 'View the selected ledger entries that will be applied to the specified record.';

                    trigger OnAction()
                    begin
                        ShowAppliedEntries := not ShowAppliedEntries;
                        if ShowAppliedEntries then
                          if CalcType = Calctype::GenJnlLine then
                            SetRange("Applies-to ID",GenJnlLine."Applies-to ID")
                          else begin
                            CustEntryApplID := UserId;
                            if CustEntryApplID = '' then
                              CustEntryApplID := '***';
                            SetRange("Applies-to ID",CustEntryApplID);
                          end
                        else
                          SetRange("Applies-to ID");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ApplnType = Applntype::"Applies-to Doc. No." then
          CalcApplnAmount;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnInit()
    begin
        AppliesToIDVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"Cust. Entry-Edit",Rec);
        if "Applies-to ID" <> xRec."Applies-to ID" then
          CalcApplnAmount;
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        if CalcType = Calctype::Direct then begin
          Cust.Get("Customer No.");
          ApplnCurrencyCode := Cust."Currency Code";
          FindApplyingEntry;
        end;

        AppliesToIDVisible := ApplnType <> Applntype::"Applies-to Doc. No.";

        GLSetup.Get;

        if ApplnType = Applntype::"Applies-to Doc. No." then
          CalcApplnAmount;
        PostingDone := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
        if ApplnType = Applntype::"Applies-to Doc. No." then begin
          if OK and (ApplyingCustLedgEntry."Posting Date" < "Posting Date") then begin
            OK := false;
            Error(
              EarlierPostingDateErr,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
              "Document Type","Document No.");
          end;
          if OK then begin
            if "Amount to Apply" = 0 then
              "Amount to Apply" := "Remaining Amount";
            Codeunit.Run(Codeunit::"Cust. Entry-Edit",Rec);
          end;
        end;
        if (CalcType = Calctype::Direct) and not OK and not PostingDone then begin
          Rec := ApplyingCustLedgEntry;
          "Applying Entry" := false;
          "Applies-to ID" := '';
          "Amount to Apply" := 0;
          Codeunit.Run(Codeunit::"Cust. Entry-Edit",Rec);
        end;
    end;

    var
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        AppliedCustLedgEntry: Record "Cust. Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        SalesHeader: Record "Sales Header";
        ServHeader: Record "Service Header";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TotalServLine: Record "Service Line";
        TotalServLineLCY: Record "Service Line";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        SalesPost: Codeunit "Sales-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Navigate: Page Navigate;
        AppliedAmount: Decimal;
        ApplyingAmount: Decimal;
        PmtDiscAmount: Decimal;
        ApplnDate: Date;
        ApplnCurrencyCode: Code[10];
        ApplnRoundingPrecision: Decimal;
        ApplnRounding: Decimal;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        AmountRoundingPrecision: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        StyleTxt: Text;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        CalcType: Option Direct,GenJnlLine,SalesHeader,ServHeader;
        CustEntryApplID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        Text002: label 'You must select an applying entry before you can post the application.';
        ShowAppliedEntries: Boolean;
        Text003: label 'You must post the application from the window where you entered the applying entry.';
        CannotSetAppliesToIDErr: label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        OK: Boolean;
        EarlierPostingDateErr: label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        PostingDone: Boolean;
        [InDataSet]
        AppliesToIDVisible: Boolean;
        Text012: label 'The application was successfully posted.';
        Text013: label 'The %1 entered must not be before the %1 on the %2.';
        Text019: label 'Post application process has been canceled.';


    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line";ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;

        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then
          ApplyingAmount := GenJnlLine.Amount;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
          ApplyingAmount := -GenJnlLine.Amount;
        ApplnDate := GenJnlLine."Posting Date";
        ApplnCurrencyCode := GenJnlLine."Currency Code";
        CalcType := Calctype::GenJnlLine;

        case ApplnTypeSelect of
          GenJnlLine.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          GenJnlLine.FieldNo("Applies-to ID"):
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;


    procedure SetSales(NewSalesHeader: Record "Sales Header";var NewCustLedgEntry: Record "Cust. Ledger Entry";ApplnTypeSelect: Integer)
    var
        TotalAdjCostLCY: Decimal;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        SalesTaxAmountLine: Record UnknownRecord10011 temporary;
        SalesLine: Record "Sales Line";
    begin
        SalesHeader := NewSalesHeader;
        CopyFilters(NewCustLedgEntry);

        SalesPost.SumSalesLines(
          SalesHeader,0,TotalSalesLine,TotalSalesLineLCY,
          VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

        SalesTaxAmountLine.DeleteAll;
        if SalesHeader."Tax Area Code" <> '' then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          with SalesLine do begin
            SetRange("Document Type",SalesHeader."Document Type");
            SetRange("Document No.",SalesHeader."No.");
            if Find('-') then
              repeat
                if Type <> 0 then
                  SalesTaxCalculate.AddSalesLine(SalesLine);
              until Next = 0;
          end;
          SalesTaxCalculate.EndSalesTaxCalculation(SalesHeader."Posting Date");
          SalesTaxCalculate.GetSalesTaxAmountLineTable(SalesTaxAmountLine);
          TotalSalesLine."Amount Including VAT" := TotalSalesLine."Amount Including VAT" + SalesTaxAmountLine.GetTotalTaxAmount;
        end;

        case SalesHeader."Document Type" of
          SalesHeader."document type"::"Return Order",
          SalesHeader."document type"::"Credit Memo":
            ApplyingAmount := -TotalSalesLine."Amount Including VAT"
          else
            ApplyingAmount := TotalSalesLine."Amount Including VAT";
        end;

        ApplnDate := SalesHeader."Posting Date";
        ApplnCurrencyCode := SalesHeader."Currency Code";
        CalcType := Calctype::SalesHeader;

        case ApplnTypeSelect of
          SalesHeader.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          SalesHeader.FieldNo("Applies-to ID"):
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;


    procedure SetService(NewServHeader: Record "Service Header";var NewCustLedgEntry: Record "Cust. Ledger Entry";ApplnTypeSelect: Integer)
    var
        ServAmountsMgt: Codeunit "Serv-Amounts Mgt.";
        TotalAdjCostLCY: Decimal;
    begin
        ServHeader := NewServHeader;
        CopyFilters(NewCustLedgEntry);

        ServAmountsMgt.SumServiceLines(
          ServHeader,0,TotalServLine,TotalServLineLCY,
          VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

        case ServHeader."Document Type" of
          ServHeader."document type"::"Credit Memo":
            ApplyingAmount := -TotalServLine."Amount Including VAT"
          else
            ApplyingAmount := TotalServLine."Amount Including VAT";
        end;

        ApplnDate := ServHeader."Posting Date";
        ApplnCurrencyCode := ServHeader."Currency Code";
        CalcType := Calctype::ServHeader;

        case ApplnTypeSelect of
          ServHeader.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          ServHeader.FieldNo("Applies-to ID"):
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;


    procedure SetCustLedgEntry(NewCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        Rec := NewCustLedgEntry;
    end;


    procedure SetApplyingCustLedgEntry()
    var
        Customer: Record Customer;
    begin
        case CalcType of
          Calctype::SalesHeader:
            begin
              ApplyingCustLedgEntry."Entry No." := 1;
              ApplyingCustLedgEntry."Posting Date" := SalesHeader."Posting Date";
              if SalesHeader."Document Type" = SalesHeader."document type"::"Return Order" then
                ApplyingCustLedgEntry."Document Type" := SalesHeader."document type"::"Credit Memo"
              else
                ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type";
              ApplyingCustLedgEntry."Document No." := SalesHeader."No.";
              ApplyingCustLedgEntry."Customer No." := SalesHeader."Bill-to Customer No.";
              ApplyingCustLedgEntry.Description := SalesHeader."Posting Description";
              ApplyingCustLedgEntry."Currency Code" := SalesHeader."Currency Code";
              if ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."document type"::"Credit Memo" then  begin
                ApplyingCustLedgEntry.Amount := -TotalSalesLine."Amount Including VAT";
                ApplyingCustLedgEntry."Remaining Amount" := -TotalSalesLine."Amount Including VAT";
              end else begin
                ApplyingCustLedgEntry.Amount := TotalSalesLine."Amount Including VAT";
                ApplyingCustLedgEntry."Remaining Amount" := TotalSalesLine."Amount Including VAT";
              end;
              CalcApplnAmount;
            end;
          Calctype::ServHeader:
            begin
              ApplyingCustLedgEntry."Entry No." := 1;
              ApplyingCustLedgEntry."Posting Date" := ServHeader."Posting Date";
              ApplyingCustLedgEntry."Document Type" := ServHeader."Document Type";
              ApplyingCustLedgEntry."Document No." := ServHeader."No.";
              ApplyingCustLedgEntry."Customer No." := ServHeader."Bill-to Customer No.";
              ApplyingCustLedgEntry.Description := ServHeader."Posting Description";
              ApplyingCustLedgEntry."Currency Code" := ServHeader."Currency Code";
              if ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."document type"::"Credit Memo" then  begin
                ApplyingCustLedgEntry.Amount := -TotalServLine."Amount Including VAT";
                ApplyingCustLedgEntry."Remaining Amount" := -TotalServLine."Amount Including VAT";
              end else begin
                ApplyingCustLedgEntry.Amount := TotalServLine."Amount Including VAT";
                ApplyingCustLedgEntry."Remaining Amount" := TotalServLine."Amount Including VAT";
              end;
              CalcApplnAmount;
            end;
          Calctype::Direct:
            begin
              if "Applying Entry" then begin
                if ApplyingCustLedgEntry."Entry No." <> 0 then
                  CustLedgEntry := ApplyingCustLedgEntry;
                Codeunit.Run(Codeunit::"Cust. Entry-Edit",Rec);
                if "Applies-to ID" = '' then
                  SetCustApplId;
                CalcFields(Amount);
                ApplyingCustLedgEntry := Rec;
                if CustLedgEntry."Entry No." <> 0 then begin
                  Rec := CustLedgEntry;
                  "Applying Entry" := false;
                  SetCustApplId;
                end;
                SetFilter("Entry No.",'<> %1',ApplyingCustLedgEntry."Entry No.");
                ApplyingAmount := ApplyingCustLedgEntry."Remaining Amount";
                ApplnDate := ApplyingCustLedgEntry."Posting Date";
                ApplnCurrencyCode := ApplyingCustLedgEntry."Currency Code";
              end;
              CalcApplnAmount;
            end;
          Calctype::GenJnlLine:
            begin
              ApplyingCustLedgEntry."Entry No." := 1;
              ApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
              ApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
              ApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";
              if GenJnlLine."Bal. Account Type" = GenJnlLine."account type"::Customer then begin
                ApplyingCustLedgEntry."Customer No." := GenJnlLine."Bal. Account No.";
                Customer.Get(ApplyingCustLedgEntry."Customer No.");
                ApplyingCustLedgEntry.Description := Customer.Name;
              end else begin
                ApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
                ApplyingCustLedgEntry.Description := GenJnlLine.Description;
              end;
              ApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
              ApplyingCustLedgEntry.Amount := GenJnlLine.Amount;
              ApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
              CalcApplnAmount;
            end;
        end;
    end;


    procedure SetCustApplId()
    begin
        if (CalcType = Calctype::GenJnlLine) and (ApplyingCustLedgEntry."Posting Date" < "Posting Date") then
          Error(
            EarlierPostingDateErr,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
            "Document Type","Document No.");

        if ApplyingCustLedgEntry."Entry No." <> 0 then
          GenJnlApply.CheckAgainstApplnCurrency(
            ApplnCurrencyCode,"Currency Code",GenJnlLine."account type"::Customer,true);

        CustLedgEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(CustLedgEntry);

        CustEntrySetApplID.SetApplId(CustLedgEntry,ApplyingCustLedgEntry,GetAppliesToID);

        CalcApplnAmount;
    end;

    local procedure GetAppliesToID() AppliesToID: Code[50]
    begin
        case CalcType of
          Calctype::GenJnlLine:
            AppliesToID := GenJnlLine."Applies-to ID";
          Calctype::SalesHeader:
            AppliesToID := SalesHeader."Applies-to ID";
          Calctype::ServHeader:
            AppliesToID := ServHeader."Applies-to ID";
        end;
    end;


    procedure CalcApplnAmount()
    begin
        AppliedAmount := 0;
        PmtDiscAmount := 0;
        DifferentCurrenciesInAppln := false;

        case CalcType of
          Calctype::Direct:
            begin
              FindAmountRounding;
              CustEntryApplID := UserId;
              if CustEntryApplID = '' then
                CustEntryApplID := '***';

              CustLedgEntry := ApplyingCustLedgEntry;

              AppliedCustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
              AppliedCustLedgEntry.SetRange("Customer No.","Customer No.");
              AppliedCustLedgEntry.SetRange(Open,true);
              AppliedCustLedgEntry.SetRange("Applies-to ID",CustEntryApplID);

              if ApplyingCustLedgEntry."Entry No." <> 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                AppliedCustLedgEntry.SetFilter("Entry No.",'<>%1',ApplyingCustLedgEntry."Entry No.");
              end;

              HandlChosenEntries(0,
                CustLedgEntry."Remaining Amount",
                CustLedgEntry."Currency Code",
                CustLedgEntry."Posting Date");
            end;
          Calctype::GenJnlLine:
            begin
              FindAmountRounding;
              if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
                Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line",GenJnlLine);

              case ApplnType of
                Applntype::"Applies-to Doc. No.":
                  begin
                    AppliedCustLedgEntry := Rec;
                    with AppliedCustLedgEntry do begin
                      CalcFields("Remaining Amount");
                      if "Currency Code" <> ApplnCurrencyCode then begin
                        "Remaining Amount" :=
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");
                        "Remaining Pmt. Disc. Possible" :=
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Pmt. Disc. Possible");
                        "Amount to Apply" :=
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            ApplnDate,"Currency Code",ApplnCurrencyCode,"Amount to Apply");
                      end;

                      if "Amount to Apply" <> 0 then
                        AppliedAmount := ROUND("Amount to Apply",AmountRoundingPrecision)
                      else
                        AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

                      if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(
                           GenJnlLine,AppliedCustLedgEntry,0,false) and
                         ((Abs(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                           Abs(AppliedAmount - "Remaining Pmt. Disc. Possible")) or
                          (GenJnlLine.Amount = 0))
                      then
                        PmtDiscAmount := "Remaining Pmt. Disc. Possible";

                      if not DifferentCurrenciesInAppln then
                        DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                    end;
                    CheckRounding;
                  end;
                Applntype::"Applies-to ID":
                  begin
                    GenJnlLine2 := GenJnlLine;
                    AppliedCustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
                    AppliedCustLedgEntry.SetRange("Customer No.",GenJnlLine."Account No.");
                    AppliedCustLedgEntry.SetRange(Open,true);
                    AppliedCustLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");

                    HandlChosenEntries(1,
                      GenJnlLine2.Amount,
                      GenJnlLine2."Currency Code",
                      GenJnlLine2."Posting Date");
                  end;
              end;
            end;
          Calctype::SalesHeader,Calctype::ServHeader:
            begin
              FindAmountRounding;

              case ApplnType of
                Applntype::"Applies-to Doc. No.":
                  begin
                    AppliedCustLedgEntry := Rec;
                    with AppliedCustLedgEntry do begin
                      CalcFields("Remaining Amount");

                      if "Currency Code" <> ApplnCurrencyCode then
                        "Remaining Amount" :=
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");

                      AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

                      if not DifferentCurrenciesInAppln then
                        DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                    end;
                    CheckRounding;
                  end;
                Applntype::"Applies-to ID":
                  begin
                    AppliedCustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
                    if CalcType = Calctype::SalesHeader then
                      AppliedCustLedgEntry.SetRange("Customer No.",SalesHeader."Bill-to Customer No.")
                    else
                      AppliedCustLedgEntry.SetRange("Customer No.",ServHeader."Bill-to Customer No.");
                    AppliedCustLedgEntry.SetRange(Open,true);
                    AppliedCustLedgEntry.SetRange("Applies-to ID",GetAppliesToID);

                    HandlChosenEntries(2,
                      ApplyingAmount,
                      ApplnCurrencyCode,
                      ApplnDate);
                  end;
              end;
            end;
        end;
    end;

    local procedure CalcApplnRemainingAmount(Amount: Decimal): Decimal
    var
        ApplnRemainingAmount: Decimal;
    begin
        ValidExchRate := true;
        if ApplnCurrencyCode = "Currency Code" then
          exit(Amount);

        if ApplnDate = 0D then
          ApplnDate := "Posting Date";
        ApplnRemainingAmount :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate,"Currency Code",ApplnCurrencyCode,Amount,ValidExchRate);
        exit(ApplnRemainingAmount);
    end;

    local procedure CalcApplnAmounttoApply(AmounttoApply: Decimal): Decimal
    var
        ApplnAmounttoApply: Decimal;
    begin
        ValidExchRate := true;

        if ApplnCurrencyCode = "Currency Code" then
          exit(AmounttoApply);

        if ApplnDate = 0D then
          ApplnDate := "Posting Date";
        ApplnAmounttoApply :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate,"Currency Code",ApplnCurrencyCode,AmounttoApply,ValidExchRate);
        exit(ApplnAmounttoApply);
    end;

    local procedure FindAmountRounding()
    begin
        if ApplnCurrencyCode = '' then begin
          Currency.Init;
          Currency.Code := '';
          Currency.InitRoundingPrecision;
        end else
          if ApplnCurrencyCode <> Currency.Code then
            Currency.Get(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    local procedure CheckRounding()
    begin
        ApplnRounding := 0;

        case CalcType of
          Calctype::SalesHeader,Calctype::ServHeader:
            exit;
          Calctype::GenJnlLine:
            if (GenJnlLine."Document Type" <> GenJnlLine."document type"::Payment) and
               (GenJnlLine."Document Type" <> GenJnlLine."document type"::Refund)
            then
              exit;
        end;

        if ApplnCurrencyCode = '' then
          ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
        else begin
          if ApplnCurrencyCode <> "Currency Code" then
            Currency.Get(ApplnCurrencyCode);
          ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        end;

        if (Abs((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) and DifferentCurrenciesInAppln then
          ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    end;


    procedure GetCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        if CalcType = Calctype::Direct then begin
          CustEntryApplID := UserId;
          if CustEntryApplID = '' then
            CustEntryApplID := '***';

          CustLedgEntry.SetCurrentkey("Customer No.","Applies-to ID",Open);
          CustLedgEntry.SetRange("Customer No.","Customer No.");
          CustLedgEntry.SetRange("Applies-to ID",CustEntryApplID);
          CustLedgEntry.SetRange(Open,true);
          CustLedgEntry.SetRange("Applying Entry",true);
          if CustLedgEntry.FindFirst then begin
            CustLedgEntry.CalcFields(Amount,"Remaining Amount");
            ApplyingCustLedgEntry := CustLedgEntry;
            SetFilter("Entry No.",'<>%1',CustLedgEntry."Entry No.");
            ApplyingAmount := CustLedgEntry."Remaining Amount";
            ApplnDate := CustLedgEntry."Posting Date";
            ApplnCurrencyCode := CustLedgEntry."Currency Code";
          end;
          CalcApplnAmount;
        end;
    end;

    local procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,SalesHeader;CurrentAmount: Decimal;CurrencyCode: Code[10];PostingDate: Date)
    var
        AppliedCustLedgEntryTemp: Record "Cust. Ledger Entry" temporary;
        PossiblePmtDisc: Decimal;
        OldPmtDisc: Decimal;
        CorrectionAmount: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
    begin
        if AppliedCustLedgEntry.FindSet(false,false) then begin
          repeat
            AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
            AppliedCustLedgEntryTemp.Insert;
          until AppliedCustLedgEntry.Next = 0;
        end else
          exit;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);

        repeat
          if not FromZeroGenJnl then
            AppliedCustLedgEntryTemp.SetRange(Positive,CurrentAmount < 0);
          if AppliedCustLedgEntryTemp.FindFirst then begin
            ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedCustLedgEntryTemp,PostingDate);

            case Type of
              Type::Direct:
                CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry,AppliedCustLedgEntryTemp,0,false,false);
              Type::GenJnlLine:
                CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine2,AppliedCustLedgEntryTemp,0,false)
              else
                CanUseDisc := false;
            end;

            if CanUseDisc and
               (Abs(AppliedCustLedgEntryTemp."Amount to Apply") >= Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                  AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
            then begin
              if (Abs(CurrentAmount) > Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                    AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
              then begin
                PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                  AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
              end else
                if (Abs(CurrentAmount) = Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                      AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                then begin
                  PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" + PossiblePmtDisc;
                  CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                    AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" - PossiblePmtDisc;
                  PossiblePmtDisc := 0;
                  AppliedAmount := AppliedAmount + CorrectionAmount;
                end else
                  if FromZeroGenJnl then begin
                    PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    CurrentAmount := CurrentAmount +
                      AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  end else begin
                    if (CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" >= 0) <> (CurrentAmount >= 0) then begin
                      PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                      AppliedAmount := AppliedAmount + CorrectionAmount;
                    end;
                    CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                      AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  end;
            end else begin
              if ((CurrentAmount - PossiblePmtDisc + AppliedCustLedgEntryTemp."Amount to Apply") * CurrentAmount) <= 0 then begin
                PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                CurrentAmount := CurrentAmount - PossiblePmtDisc;
                PossiblePmtDisc := 0;
                AppliedAmount := AppliedAmount + CorrectionAmount;
              end;
              CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Amount to Apply";
            end;
          end else begin
            AppliedCustLedgEntryTemp.SetRange(Positive);
            AppliedCustLedgEntryTemp.FindFirst;
            ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedCustLedgEntryTemp,PostingDate);
          end;

          if OldPmtDisc <> PmtDiscAmount then
            AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Remaining Amount"
          else
            AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Amount to Apply";
          OldPmtDisc := PmtDiscAmount;

          if PossiblePmtDisc <> 0 then
            CorrectionAmount := AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Amount to Apply"
          else
            CorrectionAmount := 0;

          if not DifferentCurrenciesInAppln then
            DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntryTemp."Currency Code";

          AppliedCustLedgEntryTemp.Delete;
          AppliedCustLedgEntryTemp.SetRange(Positive);

        until not AppliedCustLedgEntryTemp.FindFirst;
        PmtDiscAmount += PossiblePmtDisc;
        CheckRounding;
    end;

    local procedure AmounttoApplyOnAfterValidate()
    begin
        if ApplnType <> Applntype::"Applies-to Doc. No." then begin
          CalcApplnAmount;
          CurrPage.Update(false);
        end;
    end;

    local procedure RecalcApplnAmount()
    begin
        CurrPage.Update(true);
        CalcApplnAmount;
    end;

    local procedure LookupOKOnPush()
    begin
        OK := true;
    end;

    local procedure PostDirectApplication(PreviewMode: Boolean)
    var
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        ApplicationDate: Date;
        NewApplicationDate: Date;
        NewDocumentNo: Code[20];
    begin
        if CalcType = Calctype::Direct then begin
          if ApplyingCustLedgEntry."Entry No." <> 0 then begin
            Rec := ApplyingCustLedgEntry;
            ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);

            PostApplication.SetValues("Document No.",ApplicationDate);
            if Action::OK = PostApplication.RunModal then begin
              PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
              if NewApplicationDate < ApplicationDate then
                Error(Text013,FieldCaption("Posting Date"),TableCaption);
            end else
              Error(Text019);

            if PreviewMode then
              CustEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
            else
              CustEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);

            if not PreviewMode then begin
              Message(Text012);
              PostingDone := true;
              CurrPage.Close;
            end;
          end else
            Error(Text002);
        end else
          Error(Text003);
    end;

    local procedure ExchangeAmountsOnLedgerEntry(Type: Option Direct,GenJnlLine,SalesHeader;CurrencyCode: Code[10];var CalcCustLedgEntry: Record "Cust. Ledger Entry";PostingDate: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcCustLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
          CalculateCurrency := ApplyingCustLedgEntry."Entry No." <> 0
        else
          CalculateCurrency := true;

        if (CurrencyCode <> CalcCustLedgEntry."Currency Code") and CalculateCurrency then begin
          CalcCustLedgEntry."Remaining Amount" :=
            CurrExchRate.ExchangeAmount(
              CalcCustLedgEntry."Remaining Amount",
              CalcCustLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
          CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
            CurrExchRate.ExchangeAmount(
              CalcCustLedgEntry."Remaining Pmt. Disc. Possible",
              CalcCustLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
          CalcCustLedgEntry."Amount to Apply" :=
            CurrExchRate.ExchangeAmount(
              CalcCustLedgEntry."Amount to Apply",
              CalcCustLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
        end;
    end;
}


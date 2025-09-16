#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 233 "Apply Vendor Entries"
{
    Caption = 'Apply Vendor Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SourceTable = "Vendor Ledger Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("ApplyingVendLedgEntry.""Posting Date""";ApplyingVendLedgEntry."Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Document Type""";ApplyingVendLedgEntry."Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ToolTip = 'Specifies the document type of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Document No.""";ApplyingVendLedgEntry."Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the document number of the entry to be applied.';
                }
                field(ApplyingVendorNo;ApplyingVendLedgEntry."Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor No.';
                    Editable = false;
                    ToolTip = 'Specifies the vendor number of the entry to be applied.';
                    Visible = false;
                }
                field(ApplyingDescription;ApplyingVendLedgEntry.Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the entry to be applied.';
                    Visible = false;
                }
                field("ApplyingVendLedgEntry.""Currency Code""";ApplyingVendLedgEntry."Currency Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the currency code of the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.Amount";ApplyingVendLedgEntry.Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the entry to be applied.';
                }
                field("ApplyingVendLedgEntry.""Remaining Amount""";ApplyingVendLedgEntry."Remaining Amount")
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
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number that was entered on the purchase header or journal line.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
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
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
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
                        Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);

                        if (xRec."Amount to Apply" = 0) or ("Amount to Apply" = 0) and
                           (ApplnType = Applntype::"Applies-to ID")
                        then
                          SetVendApplId;
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
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                    Visible = false;
                }
                field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';

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
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
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
                    group(Control1900545201)
                    {
                        Caption = 'Amount to Apply';
                        field(AmountToApply;AppliedAmount)
                        {
                            ApplicationArea = Basic,Suite;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Amount to Apply';
                            Editable = false;
                            ToolTip = 'Specifies the sum of the amounts on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
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
                            ToolTip = 'Specifies the sum of the payment discount amounts granted on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.';
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
                            ToolTip = 'Specifies the amount of the journal entry, purchase credit memo, or current vendor ledger entry that you have selected as the applying entry.';
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
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
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
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Vendor Ledger Entry No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry.';
                }
                action(Navigate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                    Visible = not IsOfficeAddin;

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
                action(ActionSetAppliesToID)
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

                        SetVendApplId;
                    end;
                }
                action(ActionPostApplication)
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
                separator(Action7)
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
                            VendEntryApplID := UserId;
                            if VendEntryApplID = '' then
                              VendEntryApplID := '***';
                            SetRange("Applies-to ID",VendEntryApplID);
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
        Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);
        if "Applies-to ID" <> xRec."Applies-to ID" then
          CalcApplnAmount;
        exit(false);
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        if CalcType = Calctype::Direct then begin
          Vend.Get("Vendor No.");
          ApplnCurrencyCode := Vend."Currency Code";
          FindApplyingEntry;
        end;

        AppliesToIDVisible := ApplnType <> Applntype::"Applies-to Doc. No.";

        GLSetup.Get;

        if CalcType = Calctype::GenJnlLine then
          CalcApplnAmount;
        PostingDone := false;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
        if ApplnType = Applntype::"Applies-to Doc. No." then begin
          if OK and (ApplyingVendLedgEntry."Posting Date" < "Posting Date") then begin
            OK := false;
            Error(
              EarlierPostingDateErr,ApplyingVendLedgEntry."Document Type",ApplyingVendLedgEntry."Document No.",
              "Document Type","Document No.");
          end;
          if OK then begin
            if "Amount to Apply" = 0 then
              "Amount to Apply" := "Remaining Amount";
            Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);
          end;
        end;

        if CheckActionPerformed then begin
          Rec := ApplyingVendLedgEntry;
          "Applying Entry" := false;
          if AppliesToID = '' then begin
            "Applies-to ID" := '';
            "Amount to Apply" := 0;
          end;
          Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);
        end;
    end;

    var
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Navigate: Page Navigate;
        GenJnlLineApply: Boolean;
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
        CalcType: Option Direct,GenJnlLine,PurchHeader,PV;
        VendEntryApplID: Code[50];
        AppliesToID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        Text002: label 'You must select an applying entry before you can post the application.';
        Text003: label 'You must post the application from the window where you entered the applying entry.';
        CannotSetAppliesToIDErr: label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        ShowAppliedEntries: Boolean;
        OK: Boolean;
        EarlierPostingDateErr: label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        PostingDone: Boolean;
        [InDataSet]
        AppliesToIDVisible: Boolean;
        ActionPerformed: Boolean;
        Text012: label 'The application was successfully posted.';
        Text013: label 'The %1 entered must not be before the %1 on the %2.';
        Text019: label 'Post application process has been canceled.';
        IsOfficeAddin: Boolean;
        PVLine: Record UnknownRecord61705;


    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line";ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;
        GenJnlLineApply := true;

        if GenJnlLine."Account Type" = GenJnlLine."account type"::Vendor then
          ApplyingAmount := GenJnlLine.Amount;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then
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

        SetApplyingVendLedgEntry;
    end;


    procedure SetPurch(NewPurchHeader: Record "Purchase Header";var NewVendLedgEntry: Record "Vendor Ledger Entry";ApplnTypeSelect: Integer)
    var
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        SalesTaxAmountLine: Record UnknownRecord10011 temporary;
        PurchLine: Record "Purchase Line";
    begin
        PurchHeader := NewPurchHeader;
        CopyFilters(NewVendLedgEntry);

        PurchPost.SumPurchLines(
          PurchHeader,0,TotalPurchLine,TotalPurchLineLCY,
          VATAmount,VATAmountText);

        SalesTaxAmountLine.DeleteAll;
        if PurchHeader."Tax Area Code" <> '' then begin
          SalesTaxCalculate.StartSalesTaxCalculation;
          with PurchLine do begin
            SetRange("Document Type",PurchHeader."Document Type");
            SetRange("Document No.",PurchHeader."No.");
            if Find('-') then
              repeat
                if Type <> 0 then
                  SalesTaxCalculate.AddPurchLine(PurchLine);
              until Next = 0;
          end;
          SalesTaxCalculate.EndSalesTaxCalculation(PurchHeader."Posting Date");
          SalesTaxCalculate.GetSalesTaxAmountLineTable(SalesTaxAmountLine);
          TotalPurchLine."Amount Including VAT" := TotalPurchLine."Amount Including VAT" + SalesTaxAmountLine.GetTotalTaxAmount;
        end;

        case PurchHeader."Document Type" of
          PurchHeader."document type"::"Return Order",
          PurchHeader."document type"::"Credit Memo":
            ApplyingAmount := TotalPurchLine."Amount Including VAT"
          else
            ApplyingAmount := -TotalPurchLine."Amount Including VAT";
        end;

        ApplnDate := PurchHeader."Posting Date";
        ApplnCurrencyCode := PurchHeader."Currency Code";
        CalcType := Calctype::PurchHeader;

        case ApplnTypeSelect of
          PurchHeader.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          PurchHeader.FieldNo("Applies-to ID"):
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;


    procedure SetVendLedgEntry(NewVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        Rec := NewVendLedgEntry;
    end;


    procedure SetApplyingVendLedgEntry()
    var
        Vendor: Record Vendor;
    begin
        case CalcType of
          Calctype::PurchHeader:
            begin
              ApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
              if PurchHeader."Document Type" = PurchHeader."document type"::"Return Order" then
                ApplyingVendLedgEntry."Document Type" := PurchHeader."document type"::"Credit Memo"
              else
                ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type";
              ApplyingVendLedgEntry."Document No." := PurchHeader."No.";
              ApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
              ApplyingVendLedgEntry.Description := PurchHeader."Posting Description";
              ApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
              if ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."document type"::"Credit Memo" then  begin
                ApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
                ApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
              end else begin
                ApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
                ApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
              end;
              CalcApplnAmount;
            end;
          Calctype::Direct:
            begin
              if "Applying Entry" then begin
                if ApplyingVendLedgEntry."Entry No." <> 0 then
                  VendLedgEntry := ApplyingVendLedgEntry;
                Codeunit.Run(Codeunit::"Vend. Entry-Edit",Rec);
                if "Applies-to ID" = '' then
                  SetVendApplId;
                CalcFields(Amount);
                ApplyingVendLedgEntry := Rec;
                if VendLedgEntry."Entry No." <> 0 then begin
                  Rec := VendLedgEntry;
                  "Applying Entry" := false;
                  SetVendApplId;
                end;
                SetFilter("Entry No.",'<> %1',ApplyingVendLedgEntry."Entry No.");
                ApplyingAmount := ApplyingVendLedgEntry."Remaining Amount";
                ApplnDate := ApplyingVendLedgEntry."Posting Date";
                ApplnCurrencyCode := ApplyingVendLedgEntry."Currency Code";
              end;
              CalcApplnAmount;
            end;
          Calctype::GenJnlLine:
            begin
              ApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
              ApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
              ApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
              if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then begin
                ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
                Vendor.Get(ApplyingVendLedgEntry."Vendor No.");
                ApplyingVendLedgEntry.Description := Vendor.Name;
              end else begin
                ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
                ApplyingVendLedgEntry.Description := GenJnlLine.Description;
              end;
              ApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
              ApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
              ApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
              CalcApplnAmount;
            end;
        end;
    end;


    procedure SetVendApplId()
    begin
        if (CalcType = Calctype::GenJnlLine) and (ApplyingVendLedgEntry."Posting Date" < "Posting Date") then
          Error(
            EarlierPostingDateErr,ApplyingVendLedgEntry."Document Type",ApplyingVendLedgEntry."Document No.",
            "Document Type","Document No.");

        if ApplyingVendLedgEntry."Entry No." <> 0 then
          GenJnlApply.CheckAgainstApplnCurrency(
            ApplnCurrencyCode,"Currency Code",GenJnlLine."account type"::Vendor,true);

        VendLedgEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(VendLedgEntry);
        if GenJnlLineApply then
          VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,GenJnlLine."Applies-to ID")
        else

        //Added for PV
        if CalcType = Calctype::PV then
          VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,PVLine."Applies-to ID")
        else //Added for PV
          VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,PurchHeader."Applies-to ID");


        ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
        CalcApplnAmount;
    end;

    local procedure CalcApplnAmount()
    begin
        AppliedAmount := 0;
        PmtDiscAmount := 0;
        DifferentCurrenciesInAppln := false;

        case CalcType of
          Calctype::Direct:
            begin
              FindAmountRounding;
              VendEntryApplID := UserId;
              if VendEntryApplID = '' then
                VendEntryApplID := '***';

              VendLedgEntry := ApplyingVendLedgEntry;

              AppliedVendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
              AppliedVendLedgEntry.SetRange("Vendor No.","Vendor No.");
              AppliedVendLedgEntry.SetRange(Open,true);
              if AppliesToID = '' then
                AppliedVendLedgEntry.SetRange("Applies-to ID",VendEntryApplID)
              else
                AppliedVendLedgEntry.SetRange("Applies-to ID",AppliesToID);

              if ApplyingVendLedgEntry."Entry No." <> 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                AppliedVendLedgEntry.SetFilter("Entry No.",'<>%1',VendLedgEntry."Entry No.");
              end;

              HandlChosenEntries(0,
                VendLedgEntry."Remaining Amount",
                VendLedgEntry."Currency Code",
                VendLedgEntry."Posting Date");
            end;
          Calctype::GenJnlLine:
            begin
              FindAmountRounding;
              if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then
                Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line",GenJnlLine);

              case ApplnType of
                Applntype::"Applies-to Doc. No.":
                  begin
                    AppliedVendLedgEntry := Rec;
                    with AppliedVendLedgEntry do begin
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

                      if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
                           GenJnlLine,AppliedVendLedgEntry,0,false) and
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
                    AppliedVendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
                    AppliedVendLedgEntry.SetRange("Vendor No.",GenJnlLine."Account No.");
                    AppliedVendLedgEntry.SetRange(Open,true);
                    AppliedVendLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");

                    HandlChosenEntries(1,
                      GenJnlLine2.Amount,
                      GenJnlLine2."Currency Code",
                      GenJnlLine2."Posting Date");
                  end;
              end;
            end;
          Calctype::PurchHeader:
            begin
              FindAmountRounding;

              case ApplnType of
                Applntype::"Applies-to Doc. No.":
                  begin
                    AppliedVendLedgEntry := Rec;
                    with AppliedVendLedgEntry do begin
                      CalcFields("Remaining Amount");

                      if "Currency Code" <> ApplnCurrencyCode then
                        "Remaining Amount" :=
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");

                      AppliedAmount := AppliedAmount + ROUND("Remaining Amount",AmountRoundingPrecision);

                      if not DifferentCurrenciesInAppln then
                        DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                    end;
                    CheckRounding;
                  end;
                Applntype::"Applies-to ID":
                  with VendLedgEntry do begin
                    AppliedVendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
                    AppliedVendLedgEntry.SetRange("Vendor No.",PurchHeader."Pay-to Vendor No.");
                    AppliedVendLedgEntry.SetRange(Open,true);
                    AppliedVendLedgEntry.SetRange("Applies-to ID",PurchHeader."Applies-to ID");

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
        ApplnAmountToApply: Decimal;
    begin
        ValidExchRate := true;

        if ApplnCurrencyCode = "Currency Code" then
          exit(AmounttoApply);

        if ApplnDate = 0D then
          ApplnDate := "Posting Date";
        ApplnAmountToApply :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate,"Currency Code",ApplnCurrencyCode,AmounttoApply,ValidExchRate);
        exit(ApplnAmountToApply);
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
          Calctype::PurchHeader:
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


    procedure GetVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        if CalcType = Calctype::Direct then begin
          VendEntryApplID := UserId;
          if VendEntryApplID = '' then
            VendEntryApplID := '***';

          VendLedgEntry.SetCurrentkey("Vendor No.","Applies-to ID",Open);
          VendLedgEntry.SetRange("Vendor No.","Vendor No.");
          if AppliesToID = '' then
            VendLedgEntry.SetRange("Applies-to ID",VendEntryApplID)
          else
            VendLedgEntry.SetRange("Applies-to ID",AppliesToID);
          VendLedgEntry.SetRange(Open,true);
          VendLedgEntry.SetRange("Applying Entry",true);
          if VendLedgEntry.FindFirst then begin
            VendLedgEntry.CalcFields(Amount,"Remaining Amount");
            ApplyingVendLedgEntry := VendLedgEntry;
            SetFilter("Entry No.",'<>%1',VendLedgEntry."Entry No.");
            ApplyingAmount := VendLedgEntry."Remaining Amount";
            ApplnDate := VendLedgEntry."Posting Date";
            ApplnCurrencyCode := VendLedgEntry."Currency Code";
          end;
          CalcApplnAmount;
        end;
    end;

    local procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,PurchHeader;CurrentAmount: Decimal;CurrencyCode: Code[10];PostingDate: Date)
    var
        AppliedVendLedgEntryTemp: Record "Vendor Ledger Entry" temporary;
        PossiblePmtdisc: Decimal;
        OldPmtdisc: Decimal;
        CorrectionAmount: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
    begin
        if AppliedVendLedgEntry.FindSet(false,false) then begin
          repeat
            AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
            AppliedVendLedgEntryTemp.Insert;
          until AppliedVendLedgEntry.Next = 0;
        end else
          exit;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);

        repeat
          if not FromZeroGenJnl then
            AppliedVendLedgEntryTemp.SetRange(Positive,CurrentAmount < 0);
          if AppliedVendLedgEntryTemp.FindFirst then begin
            ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedVendLedgEntryTemp,PostingDate);

            case Type of
              Type::Direct:
                CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry,AppliedVendLedgEntryTemp,0,false,false);
              Type::GenJnlLine:
                CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2,AppliedVendLedgEntryTemp,0,false)
              else
                CanUseDisc := false;
            end;

            if CanUseDisc and
               (Abs(AppliedVendLedgEntryTemp."Amount to Apply") >= Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
            then begin
              if (Abs(CurrentAmount) > Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                    AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
              then begin
                PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
              end else
                if (Abs(CurrentAmount) = Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                      AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                then begin
                  PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible" ;
                  CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                    AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  AppliedAmount := AppliedAmount + CorrectionAmount;
                end else
                  if FromZeroGenJnl then begin
                    PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    CurrentAmount := CurrentAmount +
                      AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  end else begin
                    if (CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" <= 0) <> (CurrentAmount <= 0) then begin
                      PmtDiscAmount := PmtDiscAmount + PossiblePmtdisc;
                      AppliedAmount := AppliedAmount + CorrectionAmount;
                    end;
                    CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                      AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    PossiblePmtdisc := AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  end;
            end else begin
              if ((CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply") * CurrentAmount) >= 0 then
                AppliedAmount := AppliedAmount + CorrectionAmount;
              CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply";
            end;
          end else begin
            AppliedVendLedgEntryTemp.SetRange(Positive);
            AppliedVendLedgEntryTemp.FindFirst;
            ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedVendLedgEntryTemp,PostingDate);
          end;

          if OldPmtdisc <> PmtDiscAmount then
            AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Remaining Amount"
          else
            AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Amount to Apply";
          OldPmtdisc := PmtDiscAmount;

          if PossiblePmtdisc <> 0 then
            CorrectionAmount := AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Amount to Apply"
          else
            CorrectionAmount := 0;

          if not DifferentCurrenciesInAppln then
            DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntryTemp."Currency Code";

          AppliedVendLedgEntryTemp.Delete;
          AppliedVendLedgEntryTemp.SetRange(Positive);

        until not AppliedVendLedgEntryTemp.FindFirst;
        PmtDiscAmount += PossiblePmtdisc;
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
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        ApplicationDate: Date;
        NewApplicationDate: Date;
        NewDocumentNo: Code[20];
    begin
        if CalcType = Calctype::Direct then begin
          if ApplyingVendLedgEntry."Entry No." <> 0 then begin
            Rec := ApplyingVendLedgEntry;
            ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);

            PostApplication.SetValues("Document No.",ApplicationDate);
            if Action::OK = PostApplication.RunModal then begin
              PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
              if NewApplicationDate < ApplicationDate then
                Error(Text013,FieldCaption("Posting Date"),TableCaption);
            end else
              Error(Text019);

            if PreviewMode then
              VendEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
            else
              VendEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);

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

    local procedure CheckActionPerformed(): Boolean
    begin
        if ActionPerformed then
          exit(false);
        if (not (CalcType = Calctype::Direct) and not OK and not PostingDone) or
           (ApplnType = Applntype::"Applies-to Doc. No.")
        then
          exit(false);
        exit(CalcType = Calctype::Direct);
    end;


    procedure SetAppliesToID(AppliesToID2: Code[50])
    begin
        AppliesToID := AppliesToID2;
    end;

    local procedure ExchangeAmountsOnLedgerEntry(Type: Option Direct,GenJnlLine,PurchHeader;CurrencyCode: Code[10];var CalcVendLedgEntry: Record "Vendor Ledger Entry";PostingDate: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcVendLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
          CalculateCurrency := ApplyingVendLedgEntry."Entry No." <> 0
        else
          CalculateCurrency := true;

        if (CurrencyCode <> CalcVendLedgEntry."Currency Code") and CalculateCurrency then begin
          CalcVendLedgEntry."Remaining Amount" :=
            CurrExchRate.ExchangeAmount(
              CalcVendLedgEntry."Remaining Amount",
              CalcVendLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
          CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
            CurrExchRate.ExchangeAmount(
              CalcVendLedgEntry."Remaining Pmt. Disc. Possible",
              CalcVendLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
          CalcVendLedgEntry."Amount to Apply" :=
            CurrExchRate.ExchangeAmount(
              CalcVendLedgEntry."Amount to Apply",
              CalcVendLedgEntry."Currency Code",
              CurrencyCode,PostingDate);
        end;
    end;


    procedure "SetPVLine-Delete"(NewPVLine: Record UnknownRecord61705;ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record UnknownRecord61688;
    begin
        PVLine := NewPVLine;

        if PVLine."Account Type" = PVLine."account type"::Vendor then
          ApplyingAmount := PVLine.Amount;
        //IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
          ApplyingAmount := PVLine.Amount;
        //Get Payments Header
        PaymentHeader.Reset;
        PaymentHeader.SetRange(PaymentHeader."No.",NewPVLine.No);
        if PaymentHeader.Find('-') then begin
        ApplnDate := PaymentHeader.Date;
        ApplnCurrencyCode := PaymentHeader."Currency Code";
        CalcType := Calctype::PV;
        end;
        case ApplnTypeSelect of
          NewPVLine.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          NewPVLine.FieldNo("Applies-to ID") :
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;


    procedure SetPVLine(NewPVLine: Record UnknownRecord61705;var NewVendLedgEntry: Record "Vendor Ledger Entry";ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record UnknownRecord61688;
    begin
        PVLine := NewPVLine;
        Rec.CopyFilters(NewVendLedgEntry);

        ApplyingAmount := PVLine.Amount;

        PaymentHeader.Reset;
        PaymentHeader.SetRange(PaymentHeader."No.",NewPVLine.No);

        if PaymentHeader.Find('-') then begin
        ApplnDate := PaymentHeader.Date;
        ApplnCurrencyCode := PaymentHeader."Currency Code";
        CalcType := Calctype::PV;
        end;

        case ApplnTypeSelect of
          NewPVLine.FieldNo("Applies-to Doc. No."):
            ApplnType := Applntype::"Applies-to Doc. No.";
          NewPVLine.FieldNo("Applies-to ID") :
            ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;
}


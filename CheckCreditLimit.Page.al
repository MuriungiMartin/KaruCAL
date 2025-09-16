#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 343 "Check Credit Limit"
{
    Caption = 'Check Credit Limit';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    InstructionalText = 'An action is requested regarding the Credit Limit check.';
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ConfirmationDialog;
    PromotedActionCategories = 'New,Process,Report,Manage,Create';
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            label(Control2)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = FORMAT(STRSUBSTNO(Text000,Heading));
                MultiLine = true;
            }
            field(HideMessage;HideMessage)
            {
                ApplicationArea = Basic;
                Caption = 'Do not show this message again.';
                ToolTip = 'Specifies to no longer show this message when working with this document while the customer is over credit limit';
                Visible = HideMessageVisible;
            }
            part(CreditLimitDetails;"Credit Limit Details")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View details for the selected record.';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistics for credit limit entries.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcCreditLimitLCY;
        CalcOverdueBalanceLCY;

        SetParametersOnDetails;
    end;

    trigger OnOpenPage()
    begin
        Copy(Cust2);
    end;

    var
        Text000: label '%1 Do you still want to record the amount?';
        Text002: label 'The customer''s credit limit has been exceeded.';
        Text003: label 'This customer has an overdue balance.';
        CurrExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ServHeader: Record "Service Header";
        ServLine: Record "Service Line";
        Cust2: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        CustNo: Code[20];
        Heading: Text[250];
        NotificationId: Guid;
        NewOrderAmountLCY: Decimal;
        OldOrderAmountLCY: Decimal;
        OrderAmountThisOrderLCY: Decimal;
        OrderAmountTotalLCY: Decimal;
        CustCreditAmountLCY: Decimal;
        ShippedRetRcdNotIndLCY: Decimal;
        OutstandingRetOrdersLCY: Decimal;
        RcdNotInvdRetOrdersLCY: Decimal;
        Text004: label 'This customer has an overdue balance and the customer''s credit limit has been exceeded.';
        DeltaAmount: Decimal;
        HideMessage: Boolean;
        HideMessageVisible: Boolean;


    procedure GenJnlLineShowWarning(GenJnlLine: Record "Gen. Journal Line"): Boolean
    begin
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);
        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then
          exit(ShowWarning(GenJnlLine."Account No.",GenJnlLine."Amount (LCY)",0,true));
        exit(ShowWarning(GenJnlLine."Bal. Account No.",-GenJnlLine.Amount,0,true));
    end;


    procedure SalesHeaderShowWarning(SalesHeader: Record "Sales Header"): Boolean
    begin
        // Used when additional lines are inserted
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);
        if SalesHeader."Currency Code" = '' then
          NewOrderAmountLCY := SalesHeader."Amount Including VAT"
        else
          NewOrderAmountLCY :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate,SalesHeader."Currency Code",
                SalesHeader."Amount Including VAT",SalesHeader."Currency Factor"));

        if not (SalesHeader."Document Type" in
                [SalesHeader."document type"::Quote,
                 SalesHeader."document type"::Order,
                 SalesHeader."document type"::"Return Order"])
        then
          NewOrderAmountLCY := NewOrderAmountLCY + SalesLineAmount(SalesHeader."Document Type",SalesHeader."No.");
        DeltaAmount := NewOrderAmountLCY;
        exit(ShowWarning(SalesHeader."Bill-to Customer No.",NewOrderAmountLCY,0,true));
    end;


    procedure SalesLineShowWarning(SalesLine: Record "Sales Line"): Boolean
    begin
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);
        if (SalesHeader."Document Type" <> SalesLine."Document Type") or
           (SalesHeader."No." <> SalesLine."Document No.")
        then
          SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");
        NewOrderAmountLCY := SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)";

        if SalesLine.Find then
          OldOrderAmountLCY := SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)"
        else
          OldOrderAmountLCY := 0;

        DeltaAmount := NewOrderAmountLCY - OldOrderAmountLCY;
        NewOrderAmountLCY :=
          DeltaAmount + SalesLineAmount(SalesLine."Document Type",SalesLine."Document No.");

        exit(ShowWarning(SalesHeader."Bill-to Customer No.",NewOrderAmountLCY,OldOrderAmountLCY,false))
    end;


    procedure ServiceHeaderShowWarning(ServHeader: Record "Service Header"): Boolean
    var
        ServSetup: Record "Service Mgt. Setup";
    begin
        ServSetup.Get;
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);

        NewOrderAmountLCY := 0;
        ServLine.Reset;
        ServLine.SetRange("Document Type",ServHeader."Document Type");
        ServLine.SetRange("Document No.",ServHeader."No.");
        if ServLine.FindSet then
          repeat
            if ServHeader."Currency Code" = '' then
              NewOrderAmountLCY := NewOrderAmountLCY + ServLine."Amount Including VAT"
            else
              NewOrderAmountLCY := NewOrderAmountLCY +
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    WorkDate,ServHeader."Currency Code",
                    ServLine."Amount Including VAT",ServHeader."Currency Factor"));
          until ServLine.Next = 0;

        if ServHeader."Document Type" <> ServHeader."document type"::Order then
          NewOrderAmountLCY := NewOrderAmountLCY + ServLineAmount(ServHeader."Document Type",ServHeader."No.",ServLine);
        DeltaAmount := NewOrderAmountLCY;
        exit(ShowWarning(ServHeader."Bill-to Customer No.",NewOrderAmountLCY,0,true));
    end;


    procedure ServiceLineShowWarning(ServLine: Record "Service Line"): Boolean
    begin
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);
        if (ServHeader."Document Type" <> ServLine."Document Type") or
           (ServHeader."No." <> ServLine."Document No.")
        then
          ServHeader.Get(ServLine."Document Type",ServLine."Document No.");
        NewOrderAmountLCY := ServLine."Outstanding Amount (LCY)" + ServLine."Shipped Not Invoiced (LCY)";

        if ServLine.Find then
          OldOrderAmountLCY := ServLine."Outstanding Amount (LCY)" + ServLine."Shipped Not Invoiced (LCY)"
        else
          OldOrderAmountLCY := 0;

        DeltaAmount := NewOrderAmountLCY - OldOrderAmountLCY;
        NewOrderAmountLCY :=
          DeltaAmount + ServLineAmount(ServLine."Document Type",ServLine."Document No.",ServLine);

        exit(ShowWarning(ServHeader."Bill-to Customer No.",NewOrderAmountLCY,OldOrderAmountLCY,false))
    end;


    procedure ServiceContractHeaderShowWarning(ServiceContractHeader: Record "Service Contract Header"): Boolean
    begin
        SalesSetup.Get;
        if SalesSetup."Credit Warnings" =
           SalesSetup."credit warnings"::"No Warning"
        then
          exit(false);
        exit(ShowWarning(ServiceContractHeader."Bill-to Customer No.",0,0,true));
    end;

    local procedure SalesLineAmount(DocType: Integer;DocNo: Code[20]): Decimal
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type",DocType);
        SalesLine.SetRange("Document No.",DocNo);
        SalesLine.CalcSums("Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)");
        exit(SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)");
    end;

    local procedure ServLineAmount(DocType: Integer;DocNo: Code[20];var ServLine2: Record "Service Line"): Decimal
    begin
        ServLine2.Reset;
        ServLine2.SetRange("Document Type",DocType);
        ServLine2.SetRange("Document No.",DocNo);
        ServLine2.CalcSums("Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)");
        exit(ServLine2."Outstanding Amount (LCY)" + ServLine2."Shipped Not Invoiced (LCY)");
    end;

    local procedure ShowWarning(NewCustNo: Code[20];NewOrderAmountLCY2: Decimal;OldOrderAmountLCY2: Decimal;CheckOverDueBalance: Boolean): Boolean
    var
        CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
        ExitValue: Integer;
    begin
        if NewCustNo = '' then
          exit;
        CustNo := NewCustNo;
        NewOrderAmountLCY := NewOrderAmountLCY2;
        OldOrderAmountLCY := OldOrderAmountLCY2;
        Get(CustNo);
        SetRange("No.","No.");
        Cust2.Copy(Rec);

        if (SalesSetup."Credit Warnings" in
            [SalesSetup."credit warnings"::"Both Warnings",
             SalesSetup."credit warnings"::"Credit Limit"]) and
           CustCheckCrLimit.IsCreditLimitNotificationEnabled(Rec)
        then begin
          CalcCreditLimitLCY;
          if (CustCreditAmountLCY > "Credit Limit (LCY)") and ("Credit Limit (LCY)" <> 0) then
            ExitValue := 1;
        end;
        if CheckOverDueBalance and
           (SalesSetup."Credit Warnings" in
            [SalesSetup."credit warnings"::"Both Warnings",
             SalesSetup."credit warnings"::"Overdue Balance"]) and
           CustCheckCrLimit.IsOverdueBalanceNotificationEnabled(Rec)
        then begin
          CalcOverdueBalanceLCY;
          if "Balance Due (LCY)" > 0 then
            ExitValue := ExitValue + 2;
        end;

        if ExitValue > 0 then begin
          case ExitValue of
            1:
              begin
                Heading := Text002;
                NotificationId := CustCheckCrLimit.GetCreditLimitNotificationId;
              end;
            2:
              begin
                Heading := Text003;
                NotificationId := CustCheckCrLimit.GetOverdueBalanceNotificationId;
              end;
            3:
              begin
                Heading := Text004;
                NotificationId := CustCheckCrLimit.GetOverdueBalanceNotificationId;
              end;
          end;
          exit(true);
        end;
    end;

    local procedure CalcCreditLimitLCY()
    begin
        if GetFilter("Date Filter") = '' then
          SetFilter("Date Filter",'..%1',WorkDate);
        CalcFields("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");
        CalcReturnAmounts(OutstandingRetOrdersLCY,RcdNotInvdRetOrdersLCY);

        OrderAmountTotalLCY := CalcTotalOutstandingAmt - OutstandingRetOrdersLCY + DeltaAmount;
        ShippedRetRcdNotIndLCY := "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY;
        if "No." = CustNo then
          OrderAmountThisOrderLCY := NewOrderAmountLCY
        else
          OrderAmountThisOrderLCY := 0;

        CustCreditAmountLCY :=
          "Balance (LCY)" + "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY +
          OrderAmountTotalLCY - GetInvoicedPrepmtAmountLCY;
    end;

    local procedure CalcOverdueBalanceLCY()
    begin
        if GetFilter("Date Filter") = '' then
          SetFilter("Date Filter",'..%1',WorkDate);
        CalcFields("Balance Due (LCY)");
    end;

    local procedure CalcReturnAmounts(var OutstandingRetOrdersLCY2: Decimal;var RcdNotInvdRetOrdersLCY2: Decimal)
    begin
        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Type","Bill-to Customer No.","Currency Code");
        SalesLine.SetRange("Document Type",SalesLine."document type"::"Return Order");
        SalesLine.SetRange("Bill-to Customer No.","No.");
        SalesLine.CalcSums("Outstanding Amount (LCY)","Return Rcd. Not Invd. (LCY)");
        OutstandingRetOrdersLCY2 := SalesLine."Outstanding Amount (LCY)";
        RcdNotInvdRetOrdersLCY2 := SalesLine."Return Rcd. Not Invd. (LCY)";
    end;

    local procedure CalcTotalOutstandingAmt(): Decimal
    var
        SalesLine: Record "Sales Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
    begin
        CalcFields(
          "Outstanding Invoices (LCY)","Outstanding Orders (LCY)","Outstanding Serv.Invoices(LCY)","Outstanding Serv. Orders (LCY)");
        SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        ServOutstandingAmountFromShipment := ServLine.OutstandingInvoiceAmountFromShipment("No.");

        exit(
          "Outstanding Orders (LCY)" + "Outstanding Invoices (LCY)" + "Outstanding Serv. Orders (LCY)" +
          "Outstanding Serv.Invoices(LCY)" - SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment);
    end;


    procedure SetHideMessageVisible(HideMsgVisible: Boolean)
    begin
        HideMessageVisible := HideMsgVisible;
    end;


    procedure SetHideMessage(HideMsg: Boolean)
    begin
        HideMessage := HideMsg;
    end;


    procedure GetHideMessage(): Boolean
    begin
        exit(HideMessage);
    end;


    procedure GetHeading(): Text[250]
    begin
        exit(Heading);
    end;


    procedure GetNotificationId(): Guid
    begin
        exit(NotificationId);
    end;


    procedure PopulateDataOnNotification(CreditLimitNotification: Notification)
    begin
        CurrPage.CreditLimitDetails.Page.SetCustomerNumber("No.");
        SetParametersOnDetails;
        CurrPage.CreditLimitDetails.Page.PopulateDataOnNotification(CreditLimitNotification);
    end;

    local procedure SetParametersOnDetails()
    begin
        CurrPage.CreditLimitDetails.Page.SetOrderAmountTotalLCY(OrderAmountTotalLCY);
        CurrPage.CreditLimitDetails.Page.SetShippedRetRcdNotIndLCY(ShippedRetRcdNotIndLCY);
        CurrPage.CreditLimitDetails.Page.SetOrderAmountThisOrderLCY(OrderAmountThisOrderLCY);
        CurrPage.CreditLimitDetails.Page.SetCustCreditAmountLCY(CustCreditAmountLCY);
    end;
}


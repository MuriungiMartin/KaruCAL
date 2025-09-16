#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 439 "Approvals Management"
{
    Permissions = TableData "Approval Entry"=imd,
                  TableData "Approval Comment Line"=imd,
                  TableData "Posted Approval Entry"=imd,
                  TableData "Posted Approval Comment Line"=imd,
                  TableData "Overdue Approval Entry"=imd;

    trigger OnRun()
    begin
    end;

    var
        AddApproversTemp: Record UnknownRecord465 temporary;
        IsOpenStatusSet: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
        Approvers: Record UnknownRecord465;
        Text001: label '%1 %2 requires further approval.\\Approval request entries have been created.';
        Text002: label '%1 %2 approval request cancelled.';
        Text003: label '%1 %2 has been automatically approved and released.';
        Text004: label 'Approval Setup not found.';
        Text005: label 'User ID %1 does not exist in the User Setup table.';
        Text006: label 'Approver ID %1 does not exist in the User Setup table.';
        Text007: label '%1 for %2  does not exist in the User Setup table.';
        Text008: label 'User ID %1 does not exist in the User Setup table for %2 %3.';
        Text013: label 'Document %1 must be approved and released before you can perform this action.';
        Text010: label 'Approver not found.';
        Text014: label 'The %1 approval entries have now been cancelled.';
        Text015: label 'The %1 %2 does not have any Lines.';
        Text022: label 'There has to be a %1 on %2 %3.';
        Text023: label 'A template with a blank Approval Type or with Limit Type "Credit Limit", must have additional approvers. ';
        Text024: label '%1 are only for purchase request orders.';
        Text025: label '%1 is not a valid limit type for %2 %3.';
        Text026: label '%1 is only a valid limit type for %2.';
        Text027: label 'When Approval Type is blank, additional approvers must be added to the template.';
        Text028: label 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
        Text100: label 'S-QUOTE';
        Text101: label 'Sales Quote Approval';
        Text102: label 'S-ORDER';
        Text103: label 'Sales Order Approval';
        Text104: label 'S-INVOICE';
        Text105: label 'Sales Invoice Approval';
        Text106: label 'S-CREDIT MEMO';
        Text107: label 'Sales Credit Memo Approval';
        Text108: label 'S-RETURN ORDER';
        Text109: label 'Sales Return Order Approval';
        Text110: label 'S-BLANKET ORDER';
        Text111: label 'Sales Blanket Order Approval';
        Text112: label 'P-QUOTE';
        Text113: label 'Purchase Quote Approval';
        Text114: label 'P-ORDER';
        Text115: label 'Purchase Order Approval';
        Text116: label 'P-INVOICE';
        Text117: label 'Purchase Invoice Approval';
        Text118: label 'P-CREDIT MEMO';
        Text119: label 'Purchase Credit Memo Approval';
        Text120: label 'P-RETURN ORDER';
        Text121: label 'Purchase Return Order Approval';
        Text122: label 'P-BLANKET ORDER';
        Text123: label 'Purchase Blanket Order Approval';
        Text124: label 'S-O-CREDITLIMIT';
        Text125: label 'Sales Order Credit Limit Apporval';
        Text126: label 'S-I-CREDITLIMIT';
        Text127: label 'Sales Invoice Credit Limit Apporval';
        Text128: label '%1 %2 has been automatically approved. Status changed to Pending Prepayment.';
        Text129: label 'No Approval Templates are enabled for document type %1.';
        Text130: label 'The approval request cannot be canceled because the order has already been released. To  modify this order, you must reopen it.';
        Text131: label 'Responsibility Center not Specified';


    procedure SendSalesApprovalRequest(var SalesHeader: Record "Sales Header"): Boolean
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
    begin
        TestSetup;
        with SalesHeader do begin
          if Status <> Status::Open then
            exit(false);

          if not ApprovalSetup.Get then
            Error(Text004);

          if not SalesLinesExist then
            Error(Text015,Format("Document Type"),"No.");

          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"Sales Header");
          TemplateRec.SetRange("Document Type","Document Type");
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             SalesHeader.TestField(SalesHeader."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",SalesHeader."Responsibility Center");
          end;
           //End Responsibility Center

          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverSales(SalesHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            FinishApprovalEntrySales(SalesHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,SalesHeader."Document Type",SalesHeader."No.");
              Messagetype::AutomaticRelease:Message(Text003,SalesHeader."Document Type",SalesHeader."No.");
              Messagetype::RequiresApproval: Message(Text001,"Document Type","No.");
            end;
          end else
            Error(StrSubstNo(Text129,SalesHeader."Document Type"));
        end;
    end;


    procedure CancelSalesApprovalRequest(var SalesHeader: Record "Sales Header";ShowMessage: Boolean;ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalSetup: Record UnknownRecord452;
        AppManagement: Codeunit "IC Setup Diagnostics";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;

        if ((SalesHeader.Status = SalesHeader.Status::"Pending Approval") or
                  (SalesHeader.Status = SalesHeader.Status::"Pending Prepayment"))
        then begin

          if not ApprovalSetup.Get then
            Error(Text004);

          with SalesHeader do begin
            ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.");
            ApprovalEntry.SetRange("Table ID",Database::"Sales Header");
            ApprovalEntry.SetRange("Document Type","Document Type");
            ApprovalEntry.SetRange("Document No.","No.");
            ApprovalEntry.SetFilter(Status,'<>%1&<>%2',ApprovalEntry.Status::Rejected,ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
              repeat
                if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                   (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                  SendMail := true;
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;

                ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
                ApprovalEntry."Last Modified By ID" := UserId;
                ApprovalEntry.Modify;
                ApprovalEntry.Validate(Status);
                if ApprovalSetup.Cancellations and ShowMessage and SendMail then begin
                  AppManagement.SendSalesCancellationsMail(SalesHeader,ApprovalEntry);
                  MailCreated := true;
                  SendMail := false;
                end;
              until ApprovalEntry.Next = 0;
              if MailCreated then begin
                AppManagement.SendMail;
                MailCreated := false;
              end;
            end;

            if ManualCancel or (not ManualCancel and not (Status = Status::Released)) then
              Status := Status::Open;
            Modify(true);
          end;
          if ShowMessage then
            Message(Text002,SalesHeader."Document Type",SalesHeader."No.");
        end
        else
          Message(Text130);
    end;


    procedure SendPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header"): Boolean
    var
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
    begin
        TestSetup;
        with PurchaseHeader do begin
          if Status <> Status::Open then
            exit(false);

          if not ApprovalSetup.Get then
            Error(Text004);

          if not PurchLinesExist then
            Error(Text015,Format("Document Type"),"No.");

          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"Purchase Header");
          TemplateRec.SetRange("Document Type","Document Type");
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             PurchaseHeader.TestField(PurchaseHeader."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",PurchaseHeader."Responsibility Center");
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
         // PopullateApprovalSignatures(PurchaseHeader."No.",PurchaseHeader."Document Type",TemplateRec."Approval Code");
            repeat
              if TemplateRec."Limit Type" = TemplateRec."limit type"::"Credit Limits" then begin
                Error(StrSubstNo(Text025,Format(TemplateRec."Limit Type"),Format("Document Type"),
                    "No."));
              end else begin
                if not FindApproverPurchase(PurchaseHeader,ApprovalSetup,TemplateRec) then
                  Error(Text010);
              end;
            until TemplateRec.Next = 0;
            FinishApprovalEntryPurchase(PurchaseHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,PurchaseHeader."Document Type",PurchaseHeader."No.");
              Messagetype::AutomaticRelease:Message(Text003,PurchaseHeader."Document Type",PurchaseHeader."No.");
              Messagetype::RequiresApproval: Message(Text001,"Document Type","No.");
            end;
          end else
            Error(StrSubstNo(Text129,PurchaseHeader."Document Type"));
        end;
    end;


    procedure CancelPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header";ShowMessage: Boolean;ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalSetup: Record UnknownRecord452;
        AppManagement: Codeunit "IC Setup Diagnostics";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if ((PurchaseHeader.Status = PurchaseHeader.Status::"Pending Approval") or
           (PurchaseHeader.Status = PurchaseHeader.Status::"Pending Prepayment"))
        then begin

          if not ApprovalSetup.Get then
            Error(Text004);

          with PurchaseHeader do begin
            ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.");
            ApprovalEntry.SetRange("Table ID",Database::"Purchase Header");
            ApprovalEntry.SetRange("Document Type","Document Type");
            ApprovalEntry.SetRange("Document No.","No.");
            ApprovalEntry.SetFilter(Status,'<>%1&<>%2',ApprovalEntry.Status::Rejected,ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
              repeat
                if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                   (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                   SendMail := true;
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
              //
                ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
                ApprovalEntry."Last Modified By ID" := UserId;
                ApprovalEntry.Modify;
                 ApprovalEntry.Validate(Status);
                if ApprovalSetup.Cancellations and ShowMessage and SendMail then begin
                  AppManagement.SendPurchaseCancellationsMail(PurchaseHeader,ApprovalEntry);
                  MailCreated := true;
                  SendMail := false;
                end;
              until ApprovalEntry.Next = 0;
              if MailCreated then begin
                AppManagement.SendMail;
                MailCreated := false;
              end;
            end;

            if ManualCancel or (not ManualCancel and not (Status = Status::Released)) then
              Status := Status::Open;
            Modify(true);
          end;
          if ShowMessage then
            Message(Text002,PurchaseHeader."Document Type",PurchaseHeader."No.");
        end
        else
          Message(Text130)
    end;


    procedure CheckApprSalesDocument(SalesHeader: Record "Sales Header"): Boolean
    var
        ApprovalTemplate: Record UnknownRecord464;
    begin
        ApprovalTemplate.SetCurrentkey("Table ID","Document Type",Enabled);
        ApprovalTemplate.SetRange("Table ID",Database::"Sales Header");
        ApprovalTemplate.SetRange("Document Type",SalesHeader."Document Type");
        ApprovalTemplate.SetRange(Enabled,true);
        if ApprovalTemplate.Find('-') then
          exit(true)
        else
          exit(false);
    end;


    procedure CheckApprPurchaseDocument(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        ApprovalTemplate: Record UnknownRecord464;
    begin
        ApprovalTemplate.SetCurrentkey("Table ID","Document Type",Enabled);
        ApprovalTemplate.SetRange("Table ID",Database::"Purchase Header");
        ApprovalTemplate.SetRange("Document Type",PurchaseHeader."Document Type");
        ApprovalTemplate.SetRange(Enabled,true);
        if ApprovalTemplate.Find('-') then
          exit(true)
        else
          exit(false);
    end;


    procedure SalesLines(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLines: Record "Sales Line";
    begin
        SalesLines.SetCurrentkey("Document Type","Document No.");
        SalesLines.SetRange("Document Type",SalesHeader."Document Type");
        SalesLines.SetRange("Document No.",SalesHeader."No.");
        if SalesLines.FindSet then begin
          repeat
            if (SalesLines.Quantity <> 0) and (SalesLines."Line Amount" <> 0) then
              exit(true);
          until SalesLines.Next = 0;
        end;
        exit(false);
    end;


    procedure FindApproverSales(SalesHeader: Record "Sales Header";ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        CalcSalesDocAmount(SalesHeader,ApprovalAmount,ApprovalAmountLCY);

        case AppTemplate."Approval Type" of
          AppTemplate."approval type"::"Sales Pers./Purchaser": begin
              if SalesHeader."Salesperson Code" = '' then
                Error(StrSubstNo(Text022,SalesHeader.FieldCaption("Salesperson Code"),
                    Format(SalesHeader."Document Type"),SalesHeader."No."))
              else begin
                case AppTemplate."Limit Type" of
                  AppTemplate."limit type"::"Approval Limits": begin
                      AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                      UserSetup.SetCurrentkey("Salespers./Purch. Code");
                      UserSetup.SetRange("Salespers./Purch. Code",SalesHeader."Salesperson Code");
                      if not UserSetup.Find('-') then
                        Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                          UserSetup."Salespers./Purch. Code")
                      else begin
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                        ApproverId := UserSetup."Approver ID";

                        if not UserSetup."Unlimited Sales Approval" and
                           ((ApprovalAmountLCY > UserSetup."Sales Amount Approval Limit") or
                           (UserSetup."Sales Amount Approval Limit" = 0))
                        then begin
                          UserSetup.Reset;
                          UserSetup.SetCurrentkey("User ID");
                          UserSetup.SetRange("User ID",ApproverId);
                          repeat
                            if not UserSetup.Find('-') then
                              Error(Text006,ApproverId);
                            ApproverId := UserSetup."User ID";
                            MakeApprovalEntry(
                              Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                            UserSetup.SetRange("User ID",UserSetup."Approver ID");
                          until UserSetup."Unlimited Sales Approval" or
                                ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") and
                                (UserSetup."Sales Amount Approval Limit" <> 0)) or
                                (UserSetup."User ID" = UserSetup."Approver ID")
                        end;

                        CheckAddApprovers(AppTemplate);
                        AddApproversTemp.SetCurrentkey("Sequence No.");
                        if AddApproversTemp.Find('-') then repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                          until AddApproversTemp.Next = 0;
                      end;
                    end;

                  AppTemplate."limit type"::"Credit Limits": begin
                      AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                      Cust.Get(SalesHeader."Bill-to Customer No.");
                      AppTemplate.CalcFields("Additional Approvers");
                      if not AppTemplate."Additional Approvers" then
                        Error(Text023)
                      else
                        InsertAddApprovers(AppTemplate);
                      if (AboveCreditLimitAmountLCY > 0) or (Cust."Credit Limit (LCY)" = 0) then begin
                          ApproverId := UserId;
                          MakeApprovalEntry(
                            Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                            ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                            SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                      end else begin
                        UserSetup.SetCurrentkey("Salespers./Purch. Code");
                        UserSetup.SetRange("Salespers./Purch. Code",SalesHeader."Salesperson Code");
                        if not UserSetup.Find('-') then
                          Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                            UserSetup."Salespers./Purch. Code")
                        else begin
                          ApproverId := UserSetup."User ID";
                          MakeApprovalEntry(
                            Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                            ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                            SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);

                          AddApproversTemp.SetCurrentkey("Sequence No.");
                          if AddApproversTemp.Find('-') then begin
                            repeat
                              ApproverId := AddApproversTemp."Approver ID";
                              MakeApprovalEntry(
                                Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                                ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                                SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                            until AddApproversTemp.Next = 0;
                          end;
                        end;
                      end;
                    end;

                  AppTemplate."limit type"::"Request Limits":
                    Error(StrSubstNo(Text024,Format(AppTemplate."Limit Type")));

                  AppTemplate."limit type"::"No Limits": begin
                      AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                      UserSetup.SetCurrentkey("Salespers./Purch. Code");
                      UserSetup.SetRange("Salespers./Purch. Code",SalesHeader."Salesperson Code");
                      if not UserSetup.Find('-') then
                        Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                          UserSetup."Salespers./Purch. Code")
                      else begin
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);

                        CheckAddApprovers(AppTemplate);
                        AddApproversTemp.SetCurrentkey("Sequence No.");
                        if AddApproversTemp.Find('-') then repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                          until AddApproversTemp.Next = 0;
                      end;
                    end;
                end;
              end;
            end;

          AppTemplate."approval type"::Approver: begin
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                    UserSetup.SetRange("User ID",UserId);
                    if not UserSetup.Find('-') then
                      Error(Text005,UserId);
                    ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                    if not UserSetup."Unlimited Sales Approval" and
                       ((ApprovalAmountLCY > UserSetup."Sales Amount Approval Limit") or
                       (UserSetup."Sales Amount Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                      until UserSetup."Unlimited Sales Approval" or
                            ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") and
                            (UserSetup."Sales Amount Approval Limit" <> 0)) or
                            (UserSetup."User ID" = UserSetup."Approver ID");

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
                        MakeApprovalEntry(
                          Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                      until AddApproversTemp.Next = 0;
                  end;

                AppTemplate."limit type"::"Credit Limits": begin
                    AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                    Cust.Get(SalesHeader."Bill-to Customer No.");

                    AppTemplate.CalcFields("Additional Approvers");
                    if not AppTemplate."Additional Approvers" then
                      Error(Text023)
                    else
                      InsertAddApprovers(AppTemplate);
                    if (AboveCreditLimitAmountLCY > 0) or (Cust."Credit Limit (LCY)" = 0) then begin
                      ApproverId := UserId;
                      MakeApprovalEntry(
                        Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                        ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                        SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                    end else begin
                      UserSetup.SetRange("User ID",UserId);
                      if not UserSetup.Find('-') then
                        Error(Text005,UserId);
                      ApproverId := UserSetup."Approver ID";
                      if ApproverId <> '' then
                      //  ApproverId := UserSetup."User ID";
                      MakeApprovalEntry(
                        Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                        ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                        SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);

                      AddApproversTemp.SetCurrentkey("Sequence No.");
                      if AddApproversTemp.Find('-') then begin
                        repeat
                          ApproverId := AddApproversTemp."Approver ID";
                          MakeApprovalEntry(
                            Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Salesperson Code",
                            ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                            SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                        until AddApproversTemp.Next = 0;
                      end;
                    end;
                  end;

                AppTemplate."limit type"::"Request Limits":
                  Error(StrSubstNo(Text024,Format(AppTemplate."Limit Type")));

                AppTemplate."limit type"::"No Limits": begin
                    AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
                    UserSetup.SetRange("User ID",UserId);
                    if not UserSetup.Find('-') then
                      Error(Text005,UserId);
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId <> '' then
                      //ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                  end;
              end;
            end;

          AppTemplate."approval type"::" ": begin
              AboveCreditLimitAmountLCY := CheckCreditLimit(SalesHeader);
              InsertEntries := false;
              Cust.Get(SalesHeader."Bill-to Customer No.");
              if AppTemplate."Limit Type" = AppTemplate."limit type"::"Credit Limits" then begin
                if (AboveCreditLimitAmountLCY > 0) or (Cust."Credit Limit (LCY)" = 0) then begin
                  ApproverId := UserId;
                  MakeApprovalEntry(
                    Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                end else
                  InsertEntries := true;
              end;
              if not (AppTemplate."Limit Type" = AppTemplate."limit type"::"Credit Limits") or InsertEntries then begin
                CheckAddApprovers(AppTemplate);
                AddApproversTemp.SetCurrentkey("Sequence No.");
                if AddApproversTemp.Find('-') then
                  repeat
                    ApproverId := AddApproversTemp."Approver ID";
                    MakeApprovalEntry(
                      Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      SalesHeader."Currency Code",AppTemplate,AboveCreditLimitAmountLCY,0);
                  until AddApproversTemp.Next = 0
                else
                  Error(Text027);
              end;
            end;
        end;

        exit(true);
    end;


    procedure PurchaseLines(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.SetCurrentkey("Document Type","Document No.");
        PurchaseLines.SetRange("Document Type",PurchaseHeader."Document Type");
        PurchaseLines.SetRange("Document No.",PurchaseHeader."No.");
        if PurchaseLines.FindSet then begin
          repeat
            if (PurchaseLines.Quantity <> 0) and (PurchaseLines."Line Amount" <> 0) then
              exit(true);
          until PurchaseLines.Next = 0;
        end;
        exit(false);
    end;


    procedure FindApproverPurchase(PurchaseHeader: Record "Purchase Header";ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        Text001: label 'Maximum Amount Cannot be ZERO for Approver %1';
    begin
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        CalcPurchaseDocAmount(PurchaseHeader,ApprovalAmount,ApprovalAmountLCY);

        case AppTemplate."Approval Type" of
          AppTemplate."approval type"::"Sales Pers./Purchaser": begin
              if PurchaseHeader."Purchaser Code" <> '' then begin
                case AppTemplate."Limit Type" of
                  AppTemplate."limit type"::"Approval Limits": begin
                      UserSetup.SetCurrentkey("Salespers./Purch. Code");
                      UserSetup.SetRange("Salespers./Purch. Code",PurchaseHeader."Purchaser Code");
                      if not UserSetup.Find('-') then
                        Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                          UserSetup."Salespers./Purch. Code")
                      else begin
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',//PurchaseHeader.
        //"Purchaser Code"

                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                        ApproverId := UserSetup."Approver ID";
                        if not UserSetup."Unlimited Purchase Approval" and
                           ((ApprovalAmountLCY > UserSetup."Purchase Amount Approval Limit") or
                           (UserSetup."Purchase Amount Approval Limit" = 0))
                        then begin
                          UserSetup.Reset;
                          UserSetup.SetCurrentkey("User ID");
                          UserSetup.SetRange("User ID",ApproverId);
                          repeat
                            if not UserSetup.Find('-') then
                              Error(Text006,ApproverId);
                            ApproverId := UserSetup."User ID";
                            MakeApprovalEntry(
                              Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              PurchaseHeader."Currency Code",AppTemplate,0,0);
                            UserSetup.SetRange("User ID",UserSetup."Approver ID");
                          until UserSetup."Unlimited Purchase Approval" or
                                ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") and
                                (UserSetup."Purchase Amount Approval Limit" <> 0))or
                                (UserSetup."User ID" = UserSetup."Approver ID")
                        end;
                      end;

                      CheckAddApprovers(AppTemplate);
                      AddApproversTemp.SetCurrentkey("Sequence No.");
                      if AddApproversTemp.Find('-') then repeat
                          ApproverId := AddApproversTemp."Approver ID";
                          MakeApprovalEntry(
                            Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                            ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                            PurchaseHeader."Currency Code",AppTemplate,0,0);
                        until AddApproversTemp.Next = 0;
                    end;

                  AppTemplate."limit type"::"Request Limits": begin
                      if PurchaseHeader."Document Type" <> PurchaseHeader."document type"::Quote then
                        Error(StrSubstNo(Text026,Format(AppTemplate."Limit Type"),Format(PurchaseHeader."document type"::Quote)))
                      else begin
                        UserSetup.SetCurrentkey("Salespers./Purch. Code");
                        UserSetup.SetRange("Salespers./Purch. Code",PurchaseHeader."Purchaser Code");
                        if not UserSetup.Find('-') then
                          Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                            UserSetup."Salespers./Purch. Code");
                        UserSetup.Reset;
                        UserSetup.SetRange("User ID",UserId);
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);

                        if not UserSetup."Unlimited Request Approval" and
                           ((ApprovalAmountLCY > UserSetup."Request Amount Approval Limit") or
                            (UserSetup."Request Amount Approval Limit" = 0))
                        then
                          repeat
                            UserSetup.SetRange("User ID",UserSetup."Approver ID");
                            if not UserSetup.Find('-') then
                              Error(Text005,UserId);
                            ApproverId := UserSetup."User ID";
                            MakeApprovalEntry(
                              Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              PurchaseHeader."Currency Code",AppTemplate,0,0);
                          until UserSetup."Unlimited Request Approval" or
                                ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") and
                                 (UserSetup."Request Amount Approval Limit" <> 0)) or
                                (UserSetup."User ID" = UserSetup."Approver ID");

                        CheckAddApprovers(AppTemplate);
                        AddApproversTemp.SetCurrentkey("Sequence No.");
                        if AddApproversTemp.Find('-') then repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              PurchaseHeader."Currency Code",AppTemplate,0,0);
                          until AddApproversTemp.Next = 0;
                      end;
                    end;

                  AppTemplate."limit type"::"No Limits": begin
                      UserSetup.SetCurrentkey("Salespers./Purch. Code");
                      UserSetup.SetRange("Salespers./Purch. Code",PurchaseHeader."Purchaser Code");
                      if not UserSetup.Find('-') then
                        Error(Text008,UserSetup."User ID",UserSetup.FieldCaption("Salespers./Purch. Code"),
                          UserSetup."Salespers./Purch. Code")
                      else begin
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',//PurchaseHeader.
        //"Purchaser Code"
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);

                        CheckAddApprovers(AppTemplate);
                        AddApproversTemp.SetCurrentkey("Sequence No.");
                        if AddApproversTemp.Find('-') then repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                              ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                              PurchaseHeader."Currency Code",AppTemplate,0,0);
                          until AddApproversTemp.Next = 0;
                      end;
                    end;
                end;
              end;
            end;

          AppTemplate."approval type"::Approver: begin
              UserSetup.SetRange("User ID",UserId);
              if not UserSetup.Find('-') then
                Error(Text005,UserId);

              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      PurchaseHeader."Currency Code",AppTemplate,0,0);
                    if not UserSetup."Unlimited Purchase Approval" and
                       ((ApprovalAmountLCY > UserSetup."Purchase Amount Approval Limit") or
                       (UserSetup."Purchase Amount Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);
                        ApproverId := UserSetup."User ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                      until UserSetup."Unlimited Purchase Approval" or
                            ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") and
                            (UserSetup."Purchase Amount Approval Limit" <> 0)) or
                            (UserSetup."User ID" = UserSetup."Approver ID");

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                      until AddApproversTemp.Next = 0;
                  end;

                AppTemplate."limit type"::"Request Limits": begin
                    if PurchaseHeader."Document Type" <> PurchaseHeader."document type"::Quote then
                      Error(StrSubstNo(Text026,Format(AppTemplate."Limit Type"),Format(PurchaseHeader."document type"::Quote)))
                    else begin
                      UserSetup.SetRange("User ID",UserId);
                      if not UserSetup.Find('-') then
                        Error(Text005,UserId);
                      ApproverId := UserSetup."User ID";
                      MakeApprovalEntry(
                        Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                        ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                        PurchaseHeader."Currency Code",AppTemplate,0,0);
                      if not UserSetup."Unlimited Request Approval" and
                         ((ApprovalAmountLCY > UserSetup."Request Amount Approval Limit") or
                          (UserSetup."Request Amount Approval Limit" = 0))
                      then
                        repeat
                          UserSetup.SetRange("User ID",UserSetup."Approver ID");
                          if not UserSetup.Find('-') then
                            Error(Text005,UserId);
                          ApproverId := UserSetup."User ID";
                          MakeApprovalEntry(
                            Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                            ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                            PurchaseHeader."Currency Code",AppTemplate,0,0);
                        until UserSetup."Unlimited Request Approval" or
                              ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") and
                               (UserSetup."Request Amount Approval Limit" <> 0)) or
                              (UserSetup."User ID" = UserSetup."Approver ID");
                    end;

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                      until AddApproversTemp.Next = 0;
                  end;

                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader."Purchaser Code",
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      PurchaseHeader."Currency Code",AppTemplate,0,0);

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId <> '' then
                     // ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader."Purchaser Code",
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      PurchaseHeader."Currency Code",AppTemplate,0,0);

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                       //Ensure no Maximum Amount is Zero;
                       if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
                        ApproverId := AddApproversTemp."Approver ID";

                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
                        MakeApprovalEntry(
                          Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          PurchaseHeader."Currency Code",AppTemplate,0,0);
                      until AddApproversTemp.Next = 0;
                  end;
                //End Tiered Approval
              end;
            end;

          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  MakeApprovalEntry(
                    Database::"Purchase Header",PurchaseHeader."Document Type",PurchaseHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    PurchaseHeader."Currency Code",AppTemplate,0,0);
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
        end;

        exit(true);
    end;


    procedure MakeApprovalEntry(TableID: Integer;DocType: Integer;DocNo: Code[20];SalespersonPurchaser: Code[10];ApprovalSetup: Record UnknownRecord452;ApproverId: Code[20];ApprovalCode: Code[20];UserSetup: Record "User Setup";ApprovalAmount: Decimal;ApprovalAmountLCY: Decimal;CurrencyCode: Code[10];AppTemplate: Record UnknownRecord464;ExeedAmountLCY: Decimal;MinAmount: Decimal)
    var
        ApprovalEntry: Record "Approval Entry";
        NewSequenceNo: Integer;
        AdditionalGroupapprovers: Record UnknownRecord61240;
        additionalApprovers: Record UnknownRecord465;
    begin

        if ApproverId<>'' then begin
        with ApprovalEntry do begin
          SetRange("Table ID",TableID);
          SetRange("Document Type",DocType);
          SetRange("Document No.",DocNo);
          if Find('+') then
            NewSequenceNo := "Sequence No." + 1
          else
            NewSequenceNo := 1;
          "Table ID" := TableID;
          "Document Type" := DocType;
          "Document No." := DocNo;
          "Salespers./Purch. Code" := SalespersonPurchaser;
          "Sequence No." := NewSequenceNo;
          "Approval Code" := ApprovalCode;
          "Sender ID" := UserId;
          Amount := ApprovalAmount;
          "Amount (LCY)" := ApprovalAmountLCY;
          "Currency Code" := CurrencyCode;
          "Approver ID" := ApproverId;
          if ApproverId = UserId then begin
            Status := Status::Approved;
         end else
            Status := Status::Created;
          "Date-Time Sent for Approval" := CreateDatetime(Today,Time);
          "Last Date-Time Modified" := CreateDatetime(Today,Time);
          "Last Modified By ID" := UserId;
          "Due Date" := CalcDate(ApprovalSetup."Due Date Formula",Today);
          "Approval Type" := AppTemplate."Approval Type";
          "Limit Type" := AppTemplate."Limit Type";
          "Available Credit Limit (LCY)" := ExeedAmountLCY;
          if ExeedAmountLCY>0 then begin
            if ApprovalAmount<ExeedAmountLCY then
              if MinAmount<ApprovalAmount then
          Insert;
              end else begin
          Insert;
                end;
        AdditionalGroupapprovers.Reset;
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Approval Code",ApprovalCode);
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Approval Type",AppTemplate."Approval Type");
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Document Type",DocType);
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Sequence No.",NewSequenceNo);
        if not (AdditionalGroupapprovers.Find('-')) then begin
            Validate(Status);
            end;

          // Polpulate the Signatures Pool ... DEVELOPER: Wanjala M. Tom //
          PopullateApprovalSignatures(DocNo,DocType,ApprovalCode);

        additionalApprovers.Reset;
        additionalApprovers.SetRange(additionalApprovers."Approver ID",ApproverId);
        additionalApprovers.SetRange(additionalApprovers."Approval Code",ApprovalCode);
        additionalApprovers.SetRange(additionalApprovers."Approval Type",AppTemplate."Approval Type");
        additionalApprovers.SetRange(additionalApprovers."Document Type",DocType);
          // Create Group Approvers

        if additionalApprovers.Find('-') then begin
        AdditionalGroupapprovers.Reset;
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Approval Code",ApprovalCode);
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Approval Type",AppTemplate."Approval Type");
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Document Type",DocType);
        AdditionalGroupapprovers.SetRange(AdditionalGroupapprovers."Sequence No.",additionalApprovers."Sequence No.");
        if not (AdditionalGroupapprovers.Find('-')) then exit;
        // If additional Group Approvers Exists then create entries for the same
        repeat
          begin
           /////////////////////////////////////////////////
          "Table ID" := TableID;
          "Document Type" := DocType;
          "Document No." := DocNo;
          "Salespers./Purch. Code" := SalespersonPurchaser;
          "Sequence No." := NewSequenceNo;
          "Approval Code" := ApprovalCode;
          "Sender ID" := UserId;
          Amount := ApprovalAmount;
          "Amount (LCY)" := ApprovalAmountLCY;
          "Currency Code" := CurrencyCode;
          "Approver ID" := AdditionalGroupapprovers."Approver ID";
          if AdditionalGroupapprovers."Approver ID" = UserId then
            Status := Status::Approved
          else
            Status := Status::Created;
          //  ;
          "Date-Time Sent for Approval" := CreateDatetime(Today,Time);
          "Last Date-Time Modified" := CreateDatetime(Today,Time);
          "Last Modified By ID" := UserId;
          "Due Date" := CalcDate(ApprovalSetup."Due Date Formula",Today);
          "Approval Type" := AppTemplate."Approval Type";
          "Limit Type" := AppTemplate."Limit Type";
          "Available Credit Limit (LCY)" := ExeedAmountLCY;

          if AdditionalGroupapprovers."Maximum Amount">0 then begin
            if ApprovalAmount<AdditionalGroupapprovers."Maximum Amount" then
              if AdditionalGroupapprovers."Minimum Amount"<ApprovalAmount then
          Insert;
              end else begin
          Insert;
                end;
             Validate(Status)
           ///////////////////////////////////////////////////
          end;  //2
        until AdditionalGroupapprovers.Next =0;
        end;// 3
        end;
        end;
    end;


    procedure ApproveApprovalRequest(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalSetup: Record UnknownRecord452;
        NextApprovalEntry: Record "Approval Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        ApprovalMgtNotification: Codeunit "IC Setup Diagnostics";
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        LeaveReq2: Record UnknownRecord61125;
        FLTFuelReqHeader: Record UnknownRecord55500;
        FLTMaintenanceReqHeader: Record UnknownRecord55517;
        FINMedicalClaimHeader: Record UnknownRecord90025;
    begin
         if ApprovalEntry."Table ID" <> 0 then begin
          ApprovalEntry.Status := ApprovalEntry.Status::Approved;
          ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
          ApprovalEntry."Last Modified By ID" := UserId;
          ApprovalEntry.Modify;
          ApprovalEntry.Validate(Status);
          //NextApprovalEntry.RESET;
          NextApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.");
          NextApprovalEntry.SetRange("Table ID",ApprovalEntry."Table ID");
          NextApprovalEntry.SetRange("Document Type",ApprovalEntry."Document Type");
          NextApprovalEntry.SetRange("Document No.",ApprovalEntry."Document No.");
          NextApprovalEntry.SetFilter(Status,'%1|%2',NextApprovalEntry.Status::Created,NextApprovalEntry.Status::Open);
          if NextApprovalEntry.Find('-') then begin
            if NextApprovalEntry.Status = NextApprovalEntry.Status::Open then
              exit(false)
            else begin
              NextApprovalEntry.Status := NextApprovalEntry.Status::Open;
        
              NextApprovalEntry."Date-Time Sent for Approval" := CreateDatetime(Today,Time);
              NextApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
              NextApprovalEntry."Last Modified By ID" := UserId;
              NextApprovalEntry.Modify;
              NextApprovalEntry.Validate(NextApprovalEntry.Status);
              if ApprovalSetup.Get then
                if ApprovalSetup.Approvals then begin
                  if ApprovalEntry."Table ID" = Database::"Sales Header" then begin
                    if SalesHeader.Get(NextApprovalEntry."Document Type",NextApprovalEntry."Document No.") then
                      ApprovalMgtNotification.SendSalesApprovalsMail(SalesHeader,NextApprovalEntry);
                  end else
                   //Separate Purchase from other Customized Approval Entries
                   if ApprovalEntry."Table ID" = Database::"Purchase Header" then begin //Added Original Below
                    if PurchaseHeader.Get(NextApprovalEntry."Document Type",NextApprovalEntry."Document No.") then
                      ApprovalMgtNotification.SendPurchaseApprovalsMail(PurchaseHeader,NextApprovalEntry);
                   end else begin//Added
                   if ApprovalEntry."Table ID" = Database::"FIN-Payments Header" then begin //Added Get Payments Header
                    if PaymentHeader.Get(NextApprovalEntry."Document No.") then
                    DocType:=Doctype::"Payment Voucher";
                   end;
        
                   if ApprovalEntry."Table ID" = Database::"FIN-Imprest Header" then begin //Added Get Imprest Header
                    if ImprestHeader.Get(NextApprovalEntry."Document No.") then
                     // ApprovalMgtNotification.SendApprovalsMail(ImprestHeader,NextApprovalEntry);
                      DocType:=Doctype::Imprest;
                   end;
        
                   if ApprovalEntry."Table ID" = Database::"PROC-Store Requistion Header" then begin //Added Get Store Req
                    if SRHeader.Get(NextApprovalEntry."Document No.") then
                     // ApprovalMgtNotification.SendSRequestApprovalsMail(SRHeader,NextApprovalEntry);
                     DocType:=Doctype::Requisition;
                   end;
                   if ApprovalEntry."Table ID" = Database::"FIN-Imprest Surr. Header" then begin //Added Get Imprest surr
                    if ImprestSurr.Get(NextApprovalEntry."Document No.") then
                      //ApprovalMgtNotification.SendImprestSURRApprovalsMail(ImprestSurr,NextApprovalEntry);
                      DocType:=Doctype::ImprestSurrender;
                   end;
        
                   if ApprovalEntry."Table ID" = Database::"FLT-Transport Requisition" then begin //Added Get Transport Req
                    if TransReq.Get(NextApprovalEntry."Document No.") then
                      //ApprovalMgtNotification.SendImprestSURRApprovalsMail(ImprestSurr,NextApprovalEntry);
                      DocType:=Doctype::TR;
                   end;
        
                    if ApprovalEntry."Table ID" = Database::"HRM-Leave Requisition" then begin //Added Leave
                    if LeaveApplic.Get(NextApprovalEntry."Document No.") then
                      ApprovalMgtNotification.SendLeaveApprovalsMail(LeaveApplic,NextApprovalEntry);
                   end;
        
                    if ApprovalEntry."Table ID" = Database::"FLT-Fuel Req. Header" then begin //Fuel Req
                    if FLTFuelReqHeader.Get(NextApprovalEntry."Document No.") then
                      ApprovalMgtNotification.SendFuelApprovalsMail(FLTFuelReqHeader,NextApprovalEntry);
                   end;
        
                    if ApprovalEntry."Table ID" = Database::"FLT-Maintenance Req. Header" then begin //Fuel Req
                    if FLTMaintenanceReqHeader.Get(NextApprovalEntry."Document No.") then
                      ApprovalMgtNotification.SendMaintenanceApprovalsMail(FLTMaintenanceReqHeader,NextApprovalEntry);
                   end;
        
        //            IF ApprovalEntry."Table ID" = DATABASE::"FIN-Medical Claim Header" THEN BEGIN //Medical Claims
        //              CLEAR(FINMedicalClaimHeader);
        //              FINMedicalClaimHeader.RESET;
        //              FINMedicalClaimHeader.SETRANGE("Claim No.",NextApprovalEntry."Document No.");
        //            IF FINMedicalClaimHeader.FIND('-') THEN
        //              ApprovalMgtNotification.SendApprovalsMail(NextApprovalEntry."Document No.",NextApprovalEntry);
        //           END;
        
                   if ApprovalEntry."Table ID" = Database::"FIN-InterBank Transfers" then begin //Added Get Interbank Transfer
                    if InterbankTrans.Get(NextApprovalEntry."Document No.") then
                    DocType:=Doctype::Interbank;
                      //ApprovalMgtNotification.SendInterbankApprovalsMail(InterbankTrans,NextApprovalEntry);
                   end;
                   ApprovalMgtNotification.SendApprovalsMail(NextApprovalEntry."Document No.",DocType,NextApprovalEntry);
                   end; //Added
        
                  end;
              exit(false);
            end;
          end else begin
            if ApprovalEntry."Table ID" = Database::"Sales Header" then begin
              if SalesHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                ReleaseSalesDoc.Run(SalesHeader);
            end else
            //Get the Table ID Here
            if ApprovalEntry."Table ID" = Database::"Purchase Header" then begin //Added
              if PurchaseHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                ReleasePurchaseDoc.Run(PurchaseHeader);
            end else begin //Added
            if ApprovalEntry."Table ID" = Database::"FIN-Payments Header" then begin //Added
               if PaymentHeader.Get(ApprovalEntry."Document No.") then begin
                PaymentHeader.Status:=PaymentHeader.Status::Approved;
                PaymentHeader.Modify;
              end;
            end;
            if ApprovalEntry."Table ID" = Database::"FIN-Imprest Header" then begin //Added
               if ImprestHeader.Get(ApprovalEntry."Document No.") then begin
                ImprestHeader.Status:=ImprestHeader.Status::Approved;
                ImprestHeader.Modify;
              end;
            end;
            if ApprovalEntry."Table ID" = Database::"PROC-Store Requistion Header" then begin //Added
               if SRHeader.Get(ApprovalEntry."Document No.") then begin
                SRHeader.Status:=SRHeader.Status::Released;
                SRHeader.Modify;
              end;
            end;
            if ApprovalEntry."Table ID" = Database::"FIN-Imprest Surr. Header" then begin //Added
               if ImprestSurr.Get(ApprovalEntry."Document No.") then begin
                ImprestSurr.Status:=ImprestSurr.Status::Approved;
                ImprestSurr.Modify;
              end;
            end;
        
            if ApprovalEntry."Table ID" = Database::"FIN-InterBank Transfers" then begin //Added
               if InterbankTrans.Get(ApprovalEntry."Document No.") then begin
                InterbankTrans.Status:=InterbankTrans.Status::Approved;
                InterbankTrans.Modify;
              end;
            end;
        
            if ApprovalEntry."Table ID" = Database::"ACA-Applic. Form Header" then begin //Added
               if ApplicForm.Get(ApprovalEntry."Document No.") then begin
                ApplicForm.Status:=ApplicForm.Status::Approved;
                ApplicForm.Modify;
                ApplicForm.Validate(ApplicForm.Status);
              end;
            end;
        
            if ApprovalEntry."Table ID" = Database::"CAT-Meal Booking Header" then begin //Added
               if Mealbook.Get(ApprovalEntry."Document No.") then begin
                Mealbook.Status:=Mealbook.Status::Approved;
                 Mealbook.Validate(Status);
                Mealbook.Modify;
              end;
            end;
        
        /*
          // Leave Application
            IF ApprovalEntry."Table ID" = DATABASE::"HRM-Leave Requisition" THEN BEGIN //Added
                LeaveReq2.GET(ApprovalEntry."Document No.");
                LeaveReq2.Status:=LeaveReq2.Status::Released; //i.e.Status=5, Approved missing,changed from -> "Pending Approval"
                LeaveReq2.MODIFY;
             // END;
            END;
             */
        // Leave Application
            if ApprovalEntry."Table ID" = Database::"HRM-Leave Requisition" then begin //Added
             LeaveApplic.Reset;
              LeaveApplic.SetRange(LeaveApplic."No.",ApprovalEntry."Document No.");
               if LeaveApplic.Find('-') then begin
                LeaveApplic.Status:=LeaveApplic.Status::Posted;
                LeaveApplic.Validate(LeaveApplic.Status);
                LeaveApplic.Modify;
              end;
            end;
        
        //Maintenance Requisition
            if ApprovalEntry."Table ID" = Database::"FLT-Maintenance Req. Header" then begin //Added
             FLTMaintenanceReqHeader.Reset;
              FLTMaintenanceReqHeader.SetRange("Req. No.",ApprovalEntry."Document No.");
               if FLTMaintenanceReqHeader.Find('-') then begin
                FLTMaintenanceReqHeader.Status:=FLTMaintenanceReqHeader.Status::Approved;
                FLTMaintenanceReqHeader.Validate(FLTMaintenanceReqHeader.Status);
                FLTMaintenanceReqHeader.Modify;
              end;
            end;
        
                       if ApprovalEntry."Table ID" = Database::"FIN-Medical Claim Header" then begin  //Medical Claims
                      Clear(FINMedicalClaimHeader);
                      FINMedicalClaimHeader.Reset;
                      FINMedicalClaimHeader.SetRange("Claim No.",ApprovalEntry."Document No.");
                    if FINMedicalClaimHeader.Find('-') then begin
                FINMedicalClaimHeader.Status:=FINMedicalClaimHeader.Status::Approved;
                FINMedicalClaimHeader.Validate(FINMedicalClaimHeader.Status);
                FINMedicalClaimHeader.Modify;
              end;
            end;
        
           //Fuel Requisition
            if ApprovalEntry."Table ID" = Database::"FLT-Fuel Req. Header" then begin //Added
             FLTFuelReqHeader.Reset;
              FLTFuelReqHeader.SetRange("Req. No.",ApprovalEntry."Document No.");
               if FLTFuelReqHeader.Find('-') then begin
                FLTFuelReqHeader.Status:=FLTFuelReqHeader.Status::Approved;
                FLTFuelReqHeader.Validate(FLTFuelReqHeader.Status);
                FLTFuelReqHeader.Modify;
              end;
            end;
        
            if ApprovalEntry."Table ID" = Database::"FLT-Transport Requisition" then begin //Added
               if TransReq.Get(ApprovalEntry."Document No.") then begin
                TransReq.Status:=TransReq.Status::Approved;
                TransReq.Modify;
              end;
            end;
        
             /*
            IF ApprovalEntry."Table ID" = DATABASE::"Fuel & Maintenance Requisition" THEN BEGIN //Added
               IF FuelReq.GET(ApprovalEntry."Document No.") THEN BEGIN
                FuelReq.Status:=FuelReq.Status::Approved;
                FuelReq.MODIFY;
              END;
            END; */
        
        ApprovalMgtNotification.SendApprovedEmails(ApprovalEntry."Document No.",DocType,ApprovalEntry);
            end; //Added
            exit(true);
          end;
            end;

    end;


    procedure RejectApprovalRequest(ApprovalEntry: Record "Approval Entry")
    var
        ApprovalSetup: Record UnknownRecord452;
        SalesHeader2: Record "Sales Header";
        PurchaseHeader2: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        AppManagement: Codeunit "IC Setup Diagnostics";
        SendMail: Boolean;
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        PuchHead: Record "Purchase Header";
        FINMedicalClaimHeader: Record UnknownRecord90025;
    begin
        if ApprovalEntry."Table ID" <> 0 then begin
          ApprovalSetup.Get;
          ApprovalEntry.Status := ApprovalEntry.Status::Rejected;

          ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
          ApprovalEntry."Last Modified By ID" := UserId;
          ApprovalEntry.Modify;
          ApprovalEntry.Validate(ApprovalEntry.Status);
          if ApprovalSetup.Rejections then
            SendRejectionMail(ApprovalEntry,AppManagement);
          ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.");
          ApprovalEntry.SetRange("Table ID",ApprovalEntry."Table ID");
          ApprovalEntry.SetRange("Document Type",ApprovalEntry."Document Type");
          ApprovalEntry.SetRange("Document No.",ApprovalEntry."Document No.");
          ApprovalEntry.SetFilter(Status,'<>%1&<>%2',ApprovalEntry.Status::Canceled,ApprovalEntry.Status::Rejected);
          if ApprovalEntry.Find('-') then
            repeat
              SendMail := false;
              if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                 (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                SendMail := true;

              ApprovalEntry.Status := ApprovalEntry.Status::Rejected;

              ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
              ApprovalEntry."Last Modified By ID" := UserId;
              ApprovalEntry.Modify;
              ApprovalEntry.Validate(ApprovalEntry.Status);
              if ApprovalSetup.Rejections and SendMail then
                SendRejectionMail(ApprovalEntry,AppManagement);
            until ApprovalEntry.Next = 0;
          if ApprovalSetup.Rejections then
            AppManagement.SendMail;
          if ApprovalEntry."Table ID" = Database::"Sales Header" then begin
            SalesHeader.SetCurrentkey("Document Type","No.");
            SalesHeader.SetRange("Document Type",ApprovalEntry."Document Type");
            SalesHeader.SetRange("No.",ApprovalEntry."Document No.");
            if SalesHeader.Find('-') then
              ReleaseSalesDoc.Reopen(SalesHeader);
          end else begin
           if ApprovalEntry."Table ID" = Database::"Purchase Header" then begin //Added
             PurchaseHeader.SetCurrentkey("Document Type","No.");
             PurchaseHeader.SetRange("Document Type",ApprovalEntry."Document Type");
             PurchaseHeader.SetRange("No.",ApprovalEntry."Document No.");
             if PurchaseHeader.Find('-') then
               ReleasePurchaseDoc.Reopen(PurchaseHeader);
           end else begin  //Added
           if ApprovalEntry."Table ID" = Database::"FIN-Payments Header" then begin //Added
            if PaymentHeader.Get(ApprovalEntry."Document No.") then begin
               PaymentHeader.Status:=PaymentHeader.Status::Pending;
               PaymentHeader.Modify;
            end;
           end;//Added
           if ApprovalEntry."Table ID" = Database::"FIN-Imprest Header" then begin //Added
            if ImprestHeader.Get(ApprovalEntry."Document No.") then begin
               ImprestHeader.Status:=ImprestHeader.Status::Pending;
               ImprestHeader.Modify;
            end;
           end;//Added
           if ApprovalEntry."Table ID" = Database::"PROC-Store Requistion Header" then begin //Added
            if SRHeader.Get(ApprovalEntry."Document No.") then begin
               SRHeader.Status:=SRHeader.Status::"Pending Approval";
               SRHeader.Modify;
            end;
           end;//Added

           if ApprovalEntry."Table ID" = Database::"FIN-Imprest Surr. Header" then begin //Added
            if ImprestSurr.Get(ApprovalEntry."Document No.") then begin
               ImprestSurr.Status:=ImprestSurr.Status::Pending;
               ImprestSurr.Modify;
            end;
           end;//Added

           if ApprovalEntry."Table ID" = Database::"FLT-Transport Requisition" then begin //Added
            if TransReq.Get(ApprovalEntry."Document No.") then begin
               TransReq.Status:=TransReq.Status::Open;
               TransReq.Modify;
            end;
           end;//Added


           if ApprovalEntry."Table ID" = Database::"Purchase Header" then begin //Added
             PuchHead.Reset;
             PuchHead.SetRange("No.",ApprovalEntry."Document No.");
            if PuchHead.Find('-') then begin
               PuchHead.Status:=PuchHead.Status::Open;
               PuchHead.Modify;
            end;
           end;//Added

           if ApprovalEntry."Table ID" = Database::"CAT-Meal Booking Header" then begin //Added
            if Mealbook.Get(ApprovalEntry."Document No.") then begin
               Mealbook.Status:=Mealbook.Status::Rejected;
               Mealbook.Modify;
            end;
           end;//Added

           if ApprovalEntry."Table ID" = Database::"FIN-Medical Claim Header" then begin //Added
             Clear(FINMedicalClaimHeader);
             FINMedicalClaimHeader.Reset;
             FINMedicalClaimHeader.SetRange("Claim No.",ApprovalEntry."Document No.");
            if FINMedicalClaimHeader.Find('-') then begin
               FINMedicalClaimHeader.Status:=FINMedicalClaimHeader.Status::Rejected;
               FINMedicalClaimHeader.Modify;
            end;
           end;//Added



           end; //Added
          end;
        end;
    end;


    procedure DelegateApprovalRequest(ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        ApprovalSetup: Record UnknownRecord452;
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        AppManagement: Codeunit "IC Setup Diagnostics";
        ImprestSurrHeader: Record UnknownRecord61504;
        DocNos: Code[20];
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        PuchHead: Record "Purchase Header";
    begin
        UserSetup.Reset;
        UserSetup.SetRange("User ID",ApprovalEntry."Approver ID");
        if not UserSetup.Find('-') then
          Error(Text005,ApprovalEntry."Approver ID");
        if not ApprovalSetup.Get then
          Error(Text004);

        //IF UserSetup.Substitute <> '' THEN BEGIN
         // UserSetup.RESET;
         // UserSetup.SETRANGE("User ID",UserSetup.Substitute);
         // IF UserSetup.FIND('-') THEN BEGIN
            ApprovalEntry."Last Modified By ID" := UserId;
            ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
            //ApprovalEntry."Approver ID" := UserSetup."User ID";
           ApprovalEntry.Rename(ApprovalEntry."Table ID",ApprovalEntry."Document Type",ApprovalEntry."Document No.",
             ApprovalEntry."Sequence No.",UserSetup.Substitute);

            case ApprovalEntry."Table ID" of
              36:
                begin
                  if ApprovalSetup.Delegations then
                    if SalesHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                      AppManagement.SendSalesDelegationsMail(SalesHeader,ApprovalEntry);
                end;
              38:
                begin
                  if ApprovalSetup.Delegations then
                    if PurchaseHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                      AppManagement.SendPurchaseDelegationsMail(PurchaseHeader,ApprovalEntry);
                end;
              61688:
                begin
                  if ApprovalSetup.Delegations then
                    if PaymentHeader.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::"Payment Voucher";
                     // AppManagement.SendPVDelegationsMail(PaymentHeader,ApprovalEntry);
                end;
             61704:
                begin
                  if ApprovalSetup.Delegations then
                    if ImprestHeader.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::Imprest;
                     // AppManagement.SendImprestDelegationsMail(ImprestHeader,ApprovalEntry);
                end;
             61399:
                begin
                  if ApprovalSetup.Delegations then
                    if SRHeader.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::Requisition;
                    //  AppManagement.SendSRequestDelegationsMail(SRHeader,ApprovalEntry);
                end;
             61504:
                begin
                  if ApprovalSetup.Delegations then
                    if ImprestSurrHeader.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::ImprestSurrender;
                    //  AppManagement.SendImprestSURRDelegationsMail(ImprestSurrHeader,ApprovalEntry);
                end;

             61500:
                begin
                  if ApprovalSetup.Delegations then
                    if InterbankTrans.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::Interbank;
                     // AppManagement.SendInterbankDelegationsMail(InterbankTrans,ApprovalEntry);
                end;

             61500:
                begin
                  if ApprovalSetup.Delegations then
                    if InterbankTrans.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::TR;
                     // AppManagement.SendInterbankDelegationsMail(InterbankTrans,ApprovalEntry);
                end;

             90025:
                begin
                  if ApprovalSetup.Delegations then
                    if InterbankTrans.Get(ApprovalEntry."Document No.") then
                    DocType:=Doctype::TR;
                     // AppManagement.SendInterbankDelegationsMail(InterbankTrans,ApprovalEntry);
                end;

            end;
                Clear(DocNos);
                DocNos:=ApprovalEntry."Document No.";
               AppManagement.SendDelegationsMail(DocNos,DocType,ApprovalEntry);

        //  END;
        //END ELSE
         // ERROR(Text007,UserSetup.FIELDCAPTION(Substitute),UserSetup."User ID");
    end;


    procedure PrePostApprovalCheck(SalesHeader: Record "Sales Header";PurchaseHeader: Record "Purchase Header"): Boolean
    var
        UserSetup: Record "User Setup";
        AppAmountLCY: Decimal;
        AppAmount: Decimal;
    begin
        if SalesHeader."No." <> '' then begin
          if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then begin
            Error(Text013,SalesHeader."No.");
          end else begin
            if not CheckApprSalesDocument(SalesHeader) then
              exit(true)
            else begin
              if (not (SalesHeader.Status = SalesHeader.Status::Released) and
                not (SalesHeader.Status = SalesHeader.Status::"Pending Prepayment"))
              then
                Error(Text013,SalesHeader."No.")
              else
                exit(true);
            end;
          end;
        end else begin
          if PurchaseHeader.Status = PurchaseHeader.Status::"Pending Approval" then begin
            Error(Text013,PurchaseHeader."No.");
          end else begin
            if not CheckApprPurchaseDocument(PurchaseHeader) then
              exit(true)
            else begin
              if (not (PurchaseHeader.Status = PurchaseHeader.Status::Released) and
                not (PurchaseHeader.Status = PurchaseHeader.Status::"Pending Prepayment"))
              then
                Error(Text013,PurchaseHeader."No.")
              else
                exit(true);
            end;
          end;
        end;
    end;


    procedure MoveApprvalEntryToPosted(var ApprovalEntry: Record "Approval Entry";ToTableId: Integer;ToNo: Code[20])
    var
        PostedApprvlEntry: Record "Posted Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
    begin
        with ApprovalEntry do begin
          if Find('-') then
            repeat
              PostedApprvlEntry.Init;
              PostedApprvlEntry.TransferFields(ApprovalEntry);
              PostedApprvlEntry."Table ID" := ToTableId;
              PostedApprvlEntry."Document No." := ToNo;
              PostedApprvlEntry.Insert;
            until Next = 0;
          ApprovalCommentLine.SetRange("Table ID","Table ID");
          ApprovalCommentLine.SetRange("Document Type","Document Type");
          ApprovalCommentLine.SetRange("Document No.","Document No.");
          if ApprovalCommentLine.Find('-') then
            repeat
              PostedApprovalCommentLine.Init;
              PostedApprovalCommentLine.TransferFields(ApprovalCommentLine);
              PostedApprovalCommentLine."Entry No." := 0;
              PostedApprovalCommentLine."Table ID" := ToTableId;
              PostedApprovalCommentLine."Document No." := ToNo;
              PostedApprovalCommentLine.Insert(true);
            until ApprovalCommentLine.Next = 0;
        end;
    end;


    procedure DeleteApprovalEntry(TableId: Integer;DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";DocumentNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID",TableId);
        ApprovalEntry.SetRange("Document Type",DocumentType);
        ApprovalEntry.SetRange("Document No.",DocumentNo);
        DeleteApprovalCommentLine(TableId,DocumentType,DocumentNo);
        if ApprovalEntry.Find('-') then
          ApprovalEntry.DeleteAll;
    end;


    procedure DeleteApprovalCommentLine(TableId: Integer;DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";DocumentNo: Code[20])
    var
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        ApprovalCommentLine.SetRange("Table ID",TableId);
        ApprovalCommentLine.SetRange("Document Type",DocumentType);
        ApprovalCommentLine.SetRange("Document No.",DocumentNo);
        if ApprovalCommentLine.Find('-') then
          ApprovalCommentLine.DeleteAll;
    end;


    procedure DeletePostedApprovalEntry(TableId: Integer;DocumentNo: Code[20])
    var
        PostedApprovalEntry: Record "Posted Approval Entry";
    begin
        PostedApprovalEntry.SetRange("Table ID",TableId);
        PostedApprovalEntry.SetRange("Document No.",DocumentNo);
        DeletePostedApprvlCommentLine(TableId,DocumentNo);
        if PostedApprovalEntry.Find('-') then
          PostedApprovalEntry.DeleteAll;
    end;


    procedure DeletePostedApprvlCommentLine(TableId: Integer;DocumentNo: Code[20])
    var
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
    begin
        PostedApprovalCommentLine.SetRange("Entry No.",TableId);
        PostedApprovalCommentLine.SetRange("Document No.",DocumentNo);
        if PostedApprovalCommentLine.Find('-') then
          PostedApprovalCommentLine.DeleteAll;
    end;


    procedure DisableSalesApproval(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset;
        with SalesHeader do begin
          if Find('-') then
            repeat
              CancelSalesApprovalRequest(SalesHeader,false,false);
            until Next = 0;
        end;
        Message(Text014,SelectStr(1 + DocType,Text028));
    end;


    procedure DisablePurchaseApproval(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset;
        with PurchaseHeader do begin
          SetRange("Document Type",DocType);
          repeat
            CancelPurchaseApprovalRequest(PurchaseHeader,false,false);
          until Next = 0;
        end;
        Message(Text014,SelectStr(1 + DocType,Text028));
    end;


    procedure CalcSalesDocAmount(SalesHeader: Record "Sales Header";var ApprovalAmount: Decimal;var ApprovalAmountLCY: Decimal)
    var
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        TempAmount: array [5] of Decimal;
        VAtText: Text[30];
    begin
        SalesPost.GetSalesLines(SalesHeader,TempSalesLine,0);
        Clear(SalesPost);
        SalesPost.SumSalesLinesTemp(
          SalesHeader,TempSalesLine,0,TotalSalesLine,TotalSalesLineLCY,
          TempAmount[1],VAtText,TempAmount[2],TempAmount[3],TempAmount[4]);
        ApprovalAmount := TotalSalesLine.Amount;
        ApprovalAmountLCY := TotalSalesLineLCY.Amount;
    end;


    procedure CalcPurchaseDocAmount(PurchaseHeader: Record "Purchase Header";var ApprovalAmount: Decimal;var ApprovalAmountLCY: Decimal)
    var
        TempPurchaseLine: Record "Purchase Line" temporary;
        TotalPurchaseLine: Record "Purchase Line";
        TotalPurchaseLineLCY: Record "Purchase Line";
        PurchasePost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    begin
        PurchasePost.GetPurchLines(PurchaseHeader,TempPurchaseLine,0);
        Clear(PurchasePost);
        PurchasePost.SumPurchLinesTemp(
          PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
          TempAmount,VAtText);
        ApprovalAmount := TotalPurchaseLine.Amount;
        ApprovalAmountLCY := TotalPurchaseLineLCY.Amount;
    end;


    procedure InsertAddApprovers(AppTemplate: Record UnknownRecord464)
    var
        AddApprovers: Record UnknownRecord465;
    begin
        Clear(AddApproversTemp);
        AddApprovers.SetCurrentkey("Sequence No.");
        AddApprovers.SetRange("Approval Code",AppTemplate."Approval Code");
        AddApprovers.SetRange("Approval Type",AppTemplate."Approval Type");
        AddApprovers.SetRange("Document Type",AppTemplate."Document Type");
        AddApprovers.SetRange("Limit Type",AppTemplate."Limit Type");
        if AddApprovers.Find('-') then repeat
            AddApproversTemp := AddApprovers;
            AddApproversTemp.Insert;
          until AddApprovers.Next = 0;
    end;


    procedure CheckCreditLimit(SalesHeader: Record "Sales Header"): Decimal
    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
    begin
        //EXIT(SalesInfoPaneMgt.CalcAvailableCredit(SalesHeader."Bill-to Customer No."));
    end;


    procedure CheckAddApprovers(AppTemplate: Record UnknownRecord464)
    begin
        AppTemplate.CalcFields("Additional Approvers");
        if AppTemplate."Additional Approvers" then
          InsertAddApprovers(AppTemplate);
    end;


    procedure SetupDefualtApprovals()
    var
        ApprovalCode: Record UnknownRecord453;
        ApprovalTemplate: Record UnknownRecord464;
        "Object": Record "Object";
    begin
        if not ApprovalCode.FindFirst then begin
          Object.SetRange(Type,Object.Type::Table);
          Object.SetRange(ID,Database::"Sales Header");
          if Object.FindFirst then;
          InsertDefaultApprovalCode(ApprovalCode,Text100,Text101,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text102,Text103,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text104,Text105,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text106,Text107,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text108,Text109,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text110,Text111,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text124,Text125,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text126,Text127,Object.ID,Object.Name);

          Object.SetRange(ID,Database::"Purchase Header");
          if Object.FindFirst then;
          InsertDefaultApprovalCode(ApprovalCode,Text112,Text113,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text114,Text115,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text116,Text117,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text118,Text119,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text120,Text121,Object.ID,Object.Name);
          InsertDefaultApprovalCode(ApprovalCode,Text122,Text123,Object.ID,Object.Name);
        end;

        if not ApprovalTemplate.FindFirst and ApprovalCode.FindFirst then
          repeat
            InsertDefaultApprovalTemplate(ApprovalTemplate,ApprovalCode);
          until ApprovalCode.Next = 0;
    end;


    procedure InsertDefaultApprovalCode(var ApprovalCodeRec: Record UnknownRecord453;ApprovalCode: Code[20];ApprovalName: Text[100];TableId: Integer;Tablename: Text[50])
    begin
        ApprovalCodeRec.Init;
        ApprovalCodeRec.Code := ApprovalCode;
        ApprovalCodeRec.Description := ApprovalName;
        ApprovalCodeRec."Linked To Table Name" := Tablename;
        ApprovalCodeRec."Linked To Table No." := TableId;
        ApprovalCodeRec.Insert;
    end;


    procedure InsertDefaultApprovalTemplate(var ApprovalTemplate: Record UnknownRecord464;ApprovalCode: Record UnknownRecord453)
    begin
        case true of
          ApprovalCode.Code = Text100:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Quote;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text102:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Order;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"Approval Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text104:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Invoice;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text106:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Credit Memo";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text108:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Return Order";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text110:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::" ";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Blanket Order";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text112:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::Approver;
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Quote;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"Request Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text114:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Order;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"Approval Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text116:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Invoice;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text118:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Credit Memo";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text120:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::"Sales Pers./Purchaser";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Return Order";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text122:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::" ";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::"Blanket Order";
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"No Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text124:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::" ";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Order;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"Credit Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
          ApprovalCode.Code = Text126:
            begin
              ApprovalTemplate.Init;
              ApprovalTemplate."Approval Code" := ApprovalCode.Code;
              ApprovalTemplate."Approval Type" := ApprovalTemplate."approval type"::" ";
              ApprovalTemplate."Document Type" := ApprovalTemplate."document type"::Invoice;
              ApprovalTemplate."Limit Type" := ApprovalTemplate."limit type"::"Credit Limits";
              ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
              ApprovalTemplate.Insert;
            end;
        end;
    end;


    procedure TestSalesPrepayment(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLines: Record "Sales Line";
    begin
        SalesLines.SetRange("Document Type",SalesHeader."Document Type");
        SalesLines.SetRange("Document No.",SalesHeader."No.");
        SalesLines.SetFilter("Prepmt. Line Amount",'<>%1',0);
        if SalesLines.Find('-') then begin
          repeat
            if SalesLines."Prepmt. Amt. Inv." <> SalesLines."Prepmt. Line Amount" then
              exit(true);
          until SalesLines.Next = 0;
        end;
    end;


    procedure TestPurchasePrepayment(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.SetRange("Document Type",PurchaseHeader."Document Type");
        PurchaseLines.SetRange("Document No.",PurchaseHeader."No.");
        PurchaseLines.SetFilter("Prepmt. Line Amount",'<>%1',0);
        if PurchaseLines.Find('-') then begin
          repeat
            if PurchaseLines."Prepmt. Amt. Inv." <> PurchaseLines."Prepmt. Line Amount" then
              exit(true);
          until PurchaseLines.Next = 0;
        end;
    end;


    procedure TestSetup()
    var
        ApprovalSetup: Record UnknownRecord452;
    begin
        if not ApprovalSetup.Get then
          Error(Text004);
    end;


    procedure TestSalesPayment(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        EntryFound: Boolean;
    begin
        EntryFound := false;
        SalesSetup.Get;
        if SalesSetup."Check Prepmt. when Posting" then begin
          SalesInvHeader.SetCurrentkey("Prepayment Order No.","Prepayment Invoice");
          SalesInvHeader.SetRange("Prepayment Order No.",SalesHeader."No.");
          SalesInvHeader.SetRange("Prepayment Invoice",true);
          if SalesInvHeader.Find('-') then begin
            repeat
              CustLedgerEntry.SetCurrentkey("Document No.");
              CustLedgerEntry.SetRange("Document Type",CustLedgerEntry."document type"::Invoice);
              CustLedgerEntry.SetRange("Document No.",SalesInvHeader."No.");
              CustLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>%1',0);
              if CustLedgerEntry.Find('-') then
                EntryFound := true;
            until (SalesInvHeader.Next = 0) or (EntryFound);
          end;
        end;
        if EntryFound then
          exit(true)
        else
          exit(false);
    end;


    procedure TestPurchasePayment(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PurchaseInvHeader: Record "Purch. Inv. Header";
        EntryFound: Boolean;
    begin
        EntryFound := false;
        PurchaseSetup.Get;
        if PurchaseSetup."Check Prepmt. when Posting" then begin
          PurchaseInvHeader.SetCurrentkey("Prepayment Order No.","Prepayment Invoice");
          PurchaseInvHeader.SetRange("Prepayment Order No.",PurchaseHeader."No.");
          PurchaseInvHeader.SetRange("Prepayment Invoice",true);
          if PurchaseInvHeader.Find('-') then begin
            repeat
              VendLedgerEntry.SetCurrentkey("Document No.");
              VendLedgerEntry.SetRange("Document Type",VendLedgerEntry."document type"::Invoice);
              VendLedgerEntry.SetRange("Document No.",PurchaseInvHeader."No.");
              VendLedgerEntry.SetFilter("Remaining Amt. (LCY)",'<>%1',0);
              if VendLedgerEntry.Find('-') then
                EntryFound := true;
            until (PurchaseInvHeader.Next = 0) or (EntryFound);
          end;
        end;
        if EntryFound then
          exit(true)
        else
          exit(false);
    end;


    procedure SendRejectionMail(ApprovalEntry: Record "Approval Entry";AppManagement: Codeunit "IC Setup Diagnostics")
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ImprestSurrHeader: Record UnknownRecord61504;
        DocNos: Code[20];
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        PuchHead: Record "Purchase Header";
    begin
        case ApprovalEntry."Table ID" of
          36:
            begin
              if SalesHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                AppManagement.SendSalesRejectionsMail(SalesHeader,ApprovalEntry);
            end;
          38:
            begin
              if PurchaseHeader.Get(ApprovalEntry."Document Type",ApprovalEntry."Document No.") then
                AppManagement.SendPurchaseRejectionsMail(PurchaseHeader,ApprovalEntry);
            end;
        //For Payment Voucher, Imprests ,SRequest,Imprest Surrender
          61688:
           begin
             if PaymentHeader.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::"Payment Voucher";
            //  AppManagement.SendPVRejectionsMail(PaymentHeader,ApprovalEntry);
           end;

         61704:
           begin
             if ImprestHeader.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::Imprest;
              //  AppManagement.SendImprestRejectionsMail(ImprestHeader,ApprovalEntry);
           end;

         61399:
           begin
             if SRHeader.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::Requisition;
                //AppManagement.SendSRequestRejectionsMail(SRHeader,ApprovalEntry);
           end;

         61504:
           begin
             if ImprestSurrHeader.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::ImprestSurrender;
              //  AppManagement.SendImprestSURRRejectionsMail(ImprestSurrHeader,ApprovalEntry);
           end;

        //Interbank Transfer
         61500:
           begin
             if InterbankTrans.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::Interbank;
               // AppManagement.SendInterbankRejectionsMail(InterbankTrans,ApprovalEntry);
           end;

        //Transport Requisition
         61801:
           begin
             if TransReq.Get(ApprovalEntry."Document No.") then
             DocType:=Doctype::TR;
           end;




        end;

                Clear(DocNos);
                DocNos:=ApprovalEntry."Document No.";
               AppManagement.SendRejectionsMail(DocNos,DocType,ApprovalEntry);
    end;


    procedure FinishApprovalEntrySales(SalesHeader: Record "Sales Header";ApprovalSetup: Record UnknownRecord452;var MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
    begin
        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          SetRange("Table ID",Database::"Sales Header");
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;

                Modify;
                Validate(Status);
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  Validate(Status);

                  IsOpenStatusSet := true;
                  if ApprovalSetup.Approvals then
                    ApprovalsMgtNotification.SendSalesApprovalsMail(SalesHeader,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            if TestSalesPrepayment(SalesHeader) and
               (SalesHeader."Document Type" = SalesHeader."document type"::Order) then
              MessageID := Messageid::AutomaticPrePayment
            else
              MessageID := Messageid::AutomaticRelease;
          end else begin
            SalesHeader.Status := SalesHeader.Status::"Pending Approval";
            SalesHeader.Modify(true);
            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure FinishApprovalEntryPurchase(PurchHeader: Record "Purchase Header";ApprovalSetup: Record UnknownRecord452;var MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
    begin
        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          SetRange("Table ID",Database::"Purchase Header");
          SetRange("Document Type",PurchHeader."Document Type");
          SetRange("Document No.",PurchHeader."No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;

                Modify;
                Validate(Status);
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;

                  Modify;
                  Validate(Status);
                  IsOpenStatusSet := true;
                  if ApprovalSetup.Approvals then
                    ApprovalsMgtNotification.SendPurchaseApprovalsMail(PurchHeader,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            if TestPurchasePrepayment(PurchHeader) and
               (PurchHeader."Document Type" = PurchHeader."document type"::Order) then
              MessageID := Messageid::AutomaticPrePayment
            else
              MessageID := Messageid::AutomaticRelease;
          end else begin
            PurchHeader.Status := PurchHeader.Status::"Pending Approval";
            PurchHeader.Modify(true);
            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure PopullateApprovalSignatures(DocNo: Code[20];DocType: Integer;"Approval Code": Code[20])
    var
        SignaturePool: Record UnknownRecord61615;
        Approvers: Record UnknownRecord465;
        TotalRecord: Integer;
    begin
                SignaturePool.Reset;
                SignaturePool.SetRange(SignaturePool."Document Number",DocNo);
               // SignaturePool.SETRANGE(SignaturePool."Document Type",DocType);
                SignaturePool.SetRange(SignaturePool."Approval Code","Approval Code");

        if SignaturePool.Find('-') then SignaturePool.DeleteAll;

        SignaturePool.Reset;
        if SignaturePool.Find('+') then begin
        TotalRecord:=SignaturePool."Line No";
        end else TotalRecord:=0;

        Approvers.Reset;
        Approvers.SetRange(Approvers."Approval Code","Approval Code");
        //Approvers.SETRANGE(Approvers."Document Type",DocType);
        Approvers.SetCurrentkey(Approvers."Sequence No.");

        if Approvers.Find('-') then begin
        repeat
        begin
        TotalRecord:=TotalRecord+1;
        SignaturePool.Init;
        SignaturePool."Line No":=TotalRecord;
        SignaturePool."Document Number":=DocNo;
        SignaturePool."Approver Id":=Approvers."Approver ID";
        SignaturePool."Approval Code":=Approvers."Approval Code";
        SignaturePool."Document Type":=DocType;
        SignaturePool.Insert();
        end;
        until Approvers.Next=0;
        end;
    end;


    procedure FinishApprovalSignaturePoppula(Approvers: Code[20];DocNo: Code[20];ApprovCode: Code[20];DatesApproved: Date)
    var
        ApprovalPool: Record UnknownRecord61615;
        usersetups: Record "User Setup";
        approvalMan: Codeunit "Export F/O Consolidation";
    begin
           ApprovalPool.Reset;
          ApprovalPool.SetRange(ApprovalPool."Approver Id",Approvers);
          ApprovalPool.SetRange(ApprovalPool."Document Number",DocNo);
          ApprovalPool.SetRange(ApprovalPool."Approval Code",ApprovCode);
         // ApprovalPool.SETRANGE(ApprovalPool.Approved,FALSE);
          if ApprovalPool.Find('-') then begin
             usersetups.Reset;
             usersetups.SetRange(usersetups."User ID",Approvers);
             if usersetups.Find('-') then begin
             usersetups.CalcFields(usersetups."User Signature");
             ApprovalPool.Approved:=true;
             ApprovalPool."Approval Date":=DatesApproved;
            // ApprovalPool."Approver Signature":=usersetups."User Signature";
             ApprovalPool."Approver Title":=usersetups."Approval Title";
             ApprovalPool.Modify;
             end;
          end;
    end;


    procedure SendApproval(Table_id: Integer;Doc_No: Code[20];Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";Status: Option Open,"Pending Approval",Cancelled,Approved;ResponsibilityCenter: Code[30];DocAmount: Decimal): Boolean
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;
          if Status <> Status::Open then
          //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');

          if not ApprovalSetup.Get then
            Error(Text004);

            DocType:=Doc_Type;

          TemplateRec.Reset;
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Table_id);
          TemplateRec.SetRange(TemplateRec."Document Type",DocType);

          TemplateRec.SetRange(Enabled,true);
           if ApprovalSetup."Responsibility Center Required" then begin
           //  IF ResponsibilityCenter='' THEN ERROR(Text131);
             TemplateRec.SetRange(TemplateRec."Responsibility Center",ResponsibilityCenter);
          end;
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApprover(Table_id,DocType,Doc_No,ApprovalSetup,TemplateRec,DocAmount) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
                FinishApproval(Table_id,DocType,Doc_No,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,Format(Doc_No));
              Messagetype::AutomaticRelease:Message(Text003,DocType,Format(Doc_No));
              Messagetype::RequiresApproval: Message(Text001,DocType,Doc_No);
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        //END;
    end;


    procedure FindApprover(var Table_id: Integer;var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";var Doc_no: Code[20];var ApprovalSetup: Record UnknownRecord452;var AppTemplate: Record UnknownRecord464;var DocAmounts: Decimal): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        Text001: label 'Maximum Amount Cannot be ZERO for Approver %1';
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
        HRMLeaveRequisition: Record UnknownRecord61125;
        UserSetupReliever: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        NewSequenceNo: Integer;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        //Get the Approval Amount
        ApprovalAmount:=DocAmounts;
        ApprovalAmountLCY:=ApprovalAmount;

        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;

              DocType:=Doc_Type;

        if DocType=Doctype::"Leave Application" then begin
          // Create Releaver Approval Entry
          HRMLeaveRequisition.Reset;
          HRMLeaveRequisition.SetRange("No.",Doc_no);
          if HRMLeaveRequisition.Find('-') then begin
            HRMLeaveRequisition.TestField("Reliever No.");
            UserSetupReliever.Reset;
            UserSetupReliever.SetRange("Staff No",HRMLeaveRequisition."Reliever No.");
            if UserSetupReliever.Find('-') then begin
                      with ApprovalEntry do begin
          SetRange("Table ID",Table_id);
          SetRange("Document Type",DocType);
          SetRange("Document No.",Doc_no);
          if Find('+') then
            NewSequenceNo := "Sequence No." + 1
          else
            NewSequenceNo := 1;
          Init;
          "Table ID" := Table_id;
          "Document Type" := DocType;
          "Document No." := Doc_no;
          "Salespers./Purch. Code" := '';
          "Sequence No." := NewSequenceNo;
          "Approval Code" := AppTemplate."Approval Code";
          "Sender ID" := UserId;
          "Approver ID" := UserSetupReliever."User ID";
          if ApproverId = UserId then begin
            Status := Status::Approved;
         end else
            Status := Status::Created;
          "Date-Time Sent for Approval" := CreateDatetime(Today,Time);
          "Last Date-Time Modified" := CreateDatetime(Today,Time);
          "Last Modified By ID" := UserId;
          "Due Date" := CalcDate(ApprovalSetup."Due Date Formula",Today);
          "Approval Type" := AppTemplate."Approval Type";
          Insert(true);
                      end;
                      end;
                      end;
          end;
        case AppTemplate."Approval Type" of


          AppTemplate."approval type"::Approver: begin
              UserSetup.SetRange("User ID",UserId);
              if not UserSetup.Find('-') then
                Error(Text005,UserId);


              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"No Limits": begin

                    ApproverId := UserSetup."Approver ID";
                    if ApproverId <> '' then
                     // ApproverId := UserSetup."User ID";
                    MakeApprovalEntry(
                      Table_id,DocType,Format(Doc_no),'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0,0);

                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
                       if AddApproversTemp."Limit Type"=AddApproversTemp."limit type"::"Approval Limits" then begin
                    MakeApprovalEntry(
                    Table_id,DocType,Format(Doc_no),'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,AddApproversTemp."Maximum Amount",AddApproversTemp."Minimum Amount");
          end else begin
                  MakeApprovalEntry(
                    Table_id,DocType,Format(Doc_no),'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0,0);
                    end;
                      until AddApproversTemp.Next = 0;
                  end;
              end;
            end;

          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
        if AddApproversTemp."Limit Type"=AddApproversTemp."limit type"::"Approval Limits" then begin
                    MakeApprovalEntry(
                    Table_id,DocType,Format(Doc_no),'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,AddApproversTemp."Maximum Amount",AddApproversTemp."Minimum Amount");
          end else begin
                  MakeApprovalEntry(
                    Table_id,DocType,Format(Doc_no),'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0,0);
                    end;
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
        end;


        exit(true);
    end;


    procedure FinishApproval(var Table_Id: Integer;var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";var Doc_no: Code[20];var ApprovalSetup: Record UnknownRecord452;var MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doc_Type;

          SetRange("Table ID",Table_Id);
          SetRange("Document Type",DocType);
          SetRange("Document No.",Format(Doc_no));
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;

                Modify;
                Validate(Status);
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;

                  Modify;
                  Validate(Status);
                  IsOpenStatusSet := true;
                 // IF ApprovalSetup.Approvals THEN
                    ApprovalsMgtNotification.SendApprovalsMail(Doc_no,Doc_Type,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
           // LeaveAppl.Status := LeaveAppl.Status::Posted;
           // LeaveAppl.VALIDATE(LeaveAppl.Status);
           // LeaveAppl.MODIFY(TRUE);

              MessageID := Messageid::AutomaticRelease;
          end else begin
         // requires Further Approval
          SetPending_Approval(Table_Id,Doc_no);
           MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure CancelApproval(Table_Id: Integer;Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";Doc_no: Code[20];ShowMessage: Boolean;ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalSetup: Record UnknownRecord452;
        AppManagement: Codeunit "IC Setup Diagnostics";
        SendMail: Boolean;
        MailCreated: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;

            DocType:=Doc_Type;

          if not ApprovalSetup.Get then
            Error(Text004);

            ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.");
            ApprovalEntry.SetRange("Table ID",Table_Id);
            ApprovalEntry.SetRange("Document Type",DocType);
            ApprovalEntry.SetRange("Document No.",Format(Doc_no));
            ApprovalEntry.SetFilter(Status,'<>%1&<>%2',ApprovalEntry.Status::Rejected,ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
              repeat
                if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                   (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                  SendMail := true;
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry."Last Date-Time Modified" := CreateDatetime(Today,Time);
                ApprovalEntry."Last Modified By ID" := UserId;
                ApprovalEntry.Modify;
                if ApprovalSetup.Cancellations and ShowMessage and SendMail then begin
                  AppManagement.SendCancellationsMail(Doc_no,Doc_Type,ApprovalEntry);
                  MailCreated := true;
                  SendMail := false;
                end;
              until ApprovalEntry.Next = 0;
              if MailCreated then begin
                AppManagement.SendMail;
                MailCreated := false;
              end;
            end;

            //IF ManualCancel OR (NOT ManualCancel AND NOT (Status = Status::Posted)) THEN
              //Status := Status::Open ;
            //MODIFY(TRUE);
          if ShowMessage then
            Message(Text002,DocType,Format(Doc_no));
        //END
        //ELSE
        //  MESSAGE(Text130);

        // After Cancelling the Approval Request, set the document status back to Open or cancelled
        SetToOpen_Approval(Table_Id,Doc_no);
    end;


    procedure SetPending_Approval(var Table_Id: Integer;var Doc_No: Code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalSetup: Record UnknownRecord452;
        NextApprovalEntry: Record "Approval Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        ApprovalMgtNotification: Codeunit "IC Setup Diagnostics";
        ImprestSurrHeader: Record UnknownRecord61504;
        DocNos: Code[20];
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        PuchHead: Record "Purchase Header";
        FLTFuelReqHeader: Record UnknownRecord55500;
        FLTMaintenanceReqHeader: Record UnknownRecord55517;
        FINMedicalClaimHeader: Record UnknownRecord90025;
    begin

            if Table_Id = Database::"FIN-Payments Header" then begin //Added
               if PaymentHeader.Get(Doc_No) then begin
                PaymentHeader.Status:=PaymentHeader.Status::"Pending Approval";
                PaymentHeader.Modify;
              end;
            end;
            if Table_Id = Database::"FIN-Imprest Header" then begin //Added
               if ImprestHeader.Get(Doc_No) then begin
                ImprestHeader.Status:=ImprestHeader.Status::"Pending Approval";
                ImprestHeader.Modify;
              end;
            end;


            if Table_Id = Database::"Purchase Header" then begin //Added
              PurchaseHeader.Reset;
              PurchaseHeader.SetRange("No.",Doc_No);
               if PurchaseHeader.Find('-') then begin
                PurchaseHeader.Status:=PurchaseHeader.Status::"Pending Approval";
                PurchaseHeader.Modify;
              end;
            end;

            if Table_Id = Database::"FIN-Imprest Header" then begin //Added
               if ImprestHeader.Get(Doc_No) then begin
                ImprestHeader.Status:=ImprestHeader.Status::"Pending Approval";
                ImprestHeader.Modify;
              end;
            end;

            if Table_Id = Database::"PROC-Store Requistion Header" then begin //Added
               if SRHeader.Get(Doc_No) then begin
                SRHeader.Status:=SRHeader.Status::"Pending Approval";
                SRHeader.Modify;
              end;
            end;
            if Table_Id = Database::"FIN-Imprest Surr. Header" then begin //Added
               if ImprestSurr.Get(Doc_No) then begin
                ImprestSurr.Status:=ImprestSurr.Status::"Pending Approval";
                ImprestSurr.Modify;
              end;
            end;

            if Table_Id = Database::"FIN-InterBank Transfers" then begin //Added
               if InterbankTrans.Get(Doc_No) then begin
                InterbankTrans.Status:=InterbankTrans.Status::"Pending Approval";
                InterbankTrans.Modify;
              end;
            end;

            if Table_Id = Database::"ACA-Applic. Form Header" then begin //Added
               if ApplicForm.Get(Doc_No) then begin
                ApplicForm.Status:=ApplicForm.Status::"Pending Approval";
                ApplicForm.Modify;
                ApplicForm.Validate(ApplicForm.Status);
              end;
            end;

            if Table_Id = Database::"CAT-Meal Booking Header" then begin //Added
               if Mealbook.Get(Doc_No) then begin
                Mealbook.Status:=Mealbook.Status::"Pending Approval";
                Mealbook.Modify;
              end;
            end;

            if Table_Id = Database::"FLT-Transport Requisition" then begin //Added
               if TransReq.Get(Doc_No) then begin
                TransReq.Status:=TransReq.Status::"Pending Approval";
                TransReq.Modify;
              end;
            end;

            if Table_Id = Database::"HRM-Leave Requisition" then begin //Added
             LeaveApplic.Reset;
              LeaveApplic.SetRange(LeaveApplic."No.",Doc_No);
               if LeaveApplic.Find('-') then begin
            LeaveApplic.Status := LeaveApplic.Status::"Pending Approval";
            LeaveApplic.Modify(true);
              end;
            end;

            if Table_Id = Database::"FLT-Fuel Req. Header" then begin //Added
             FLTFuelReqHeader.Reset;
              FLTFuelReqHeader.SetRange(FLTFuelReqHeader."Req. No.",Doc_No);
               if FLTFuelReqHeader.Find('-') then begin
            FLTFuelReqHeader.Status := FLTFuelReqHeader.Status::"Pending Approval";
            FLTFuelReqHeader.Modify(true);
              end;
            end;



            if Table_Id = Database::"FLT-Maintenance Req. Header" then begin //Added
             FLTMaintenanceReqHeader.Reset;
              FLTMaintenanceReqHeader.SetRange(FLTMaintenanceReqHeader."Req. No.",Doc_No);
               if FLTMaintenanceReqHeader.Find('-') then begin
            FLTMaintenanceReqHeader.Status := FLTMaintenanceReqHeader.Status::"Pending Approval";
            FLTMaintenanceReqHeader.Modify(true);
              end;
            end;

           if Table_Id = Database::"FIN-Medical Claim Header" then begin //Added
             Clear(FINMedicalClaimHeader);
             FINMedicalClaimHeader.Reset;
             FINMedicalClaimHeader.SetRange("Claim No.",Doc_No);
            if FINMedicalClaimHeader.Find('-') then begin
               FINMedicalClaimHeader.Status:=FINMedicalClaimHeader.Status::"Pending Approval";
               FINMedicalClaimHeader.Modify;
            end;
           end;//Added
    end;


    procedure SetToOpen_Approval(var Table_Id: Integer;var Doc_No: Code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalSetup: Record UnknownRecord452;
        NextApprovalEntry: Record "Approval Entry";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        ApprovalMgtNotification: Codeunit "IC Setup Diagnostics";
        text1001: label 'The Document should be pending Approval';
        ImprestSurrHeader: Record UnknownRecord61504;
        DocNos: Code[20];
        PaymentHeader: Record UnknownRecord61688;
        ImprestHeader: Record UnknownRecord61704;
        SRHeader: Record UnknownRecord61399;
        ImprestSurr: Record UnknownRecord61504;
        InterbankTrans: Record UnknownRecord61500;
        ApplicForm: Record UnknownRecord61358;
        Mealbook: Record UnknownRecord61778;
        LeaveApplic: Record UnknownRecord61125;
        TransReq: Record UnknownRecord61801;
        PuchHead: Record "Purchase Header";
        FLTFuelReqHeader: Record UnknownRecord55500;
        FINMedicalClaimHeader: Record UnknownRecord90025;
    begin
        
            if Table_Id = Database::"FIN-Payments Header" then begin //Added
               if PaymentHeader.Get(Doc_No) then begin
               if PaymentHeader.Status<>PaymentHeader.Status::"Pending Approval" then
               Error(text1001);
                PaymentHeader.Status:=PaymentHeader.Status::Pending;
                PaymentHeader.Modify;
              end;
            end;
        
            if Table_Id = Database::"Purchase Header" then begin //Added
                    PurchaseHeader.Reset;
              PurchaseHeader.SetRange("No.",Doc_No);
               if PurchaseHeader.Find('-') then begin
               if PurchaseHeader.Status<>PurchaseHeader.Status::"Pending Approval" then
               Error(text1001);
                PurchaseHeader.Status:=PurchaseHeader.Status::Open;
                PurchaseHeader.Modify;
              end;
            end;
        
            if Table_Id = Database::"FIN-Imprest Header" then begin //Added
               if ImprestHeader.Get(Doc_No) then begin
               if ImprestHeader.Status<>ImprestHeader.Status::"Pending Approval" then
               Error(text1001);
                ImprestHeader.Status:=ImprestHeader.Status::Pending;
                ImprestHeader.Modify;
              end;
            end;
            if Table_Id = Database::"PROC-Store Requistion Header" then begin //Added
               if SRHeader.Get(Doc_No) then begin
               if SRHeader.Status<>SRHeader.Status::"Pending Approval" then
               Error(text1001);
                SRHeader.Status:=SRHeader.Status::Released;
                SRHeader.Modify;
              end;
            end;
            if Table_Id = Database::"FIN-Imprest Surr. Header" then begin //Added
               if ImprestSurr.Get(Doc_No) then begin
               if ImprestSurr.Status<>ImprestSurr.Status::"Pending Approval" then
               Error(text1001);
                ImprestSurr.Status:=ImprestSurr.Status::Pending;
                ImprestSurr.Modify;
              end;
            end;
        
            if Table_Id = Database::"FIN-InterBank Transfers" then begin //Added
               if InterbankTrans.Get(Doc_No) then begin
               if InterbankTrans.Status<>InterbankTrans.Status::"Pending Approval" then
               Error(text1001);
                InterbankTrans.Status:=InterbankTrans.Status::Pending;
                InterbankTrans.Modify;
              end;
            end;
        
            if Table_Id = Database::"ACA-Applic. Form Header" then begin //Added
               if ApplicForm.Get(Doc_No) then begin
               if ApplicForm.Status<>ApplicForm.Status::"Pending Approval" then
               Error(text1001);
                ApplicForm.Status:=ApplicForm.Status::Open;
                ApplicForm.Modify;
                ApplicForm.Validate(ApplicForm.Status);
              end;
            end;
        
          /*  IF Table_Id = DATABASE::"CAT-Meal Booking Header" THEN BEGIN //Added
              Mealbook.RESET;
              Mealbook.SETRANGE("Booking Id",Doc_No);
               IF Mealbook.FIND('-') THEN BEGIN
              // IF Mealbook.Status<>Mealbook.Status::"Pending Approval" THEN
             //  ERROR(text1001);
                Mealbook.Status:=Mealbook.Status::New;
                Mealbook.MODIFY;
              END;
            END;*/
        
            if Table_Id = Database::"CAT-Meal Booking Header" then begin //Added
               if Mealbook.Get(Doc_No) then begin
               if Mealbook.Status<>Mealbook.Status::"Pending Approval" then
               Error(text1001);
                Mealbook.Status:=Mealbook.Status::New;
                Mealbook.Modify;
              end;
            end;
        
            if Table_Id = Database::"FLT-Transport Requisition" then begin //Added
               if TransReq.Get(Doc_No) then begin
               if TransReq.Status<>TransReq.Status::"Pending Approval" then
               Error(text1001);
                TransReq.Status:=TransReq.Status::Open;
                TransReq.Modify;
              end;
            end;
        
            if Table_Id = Database::"HRM-Leave Requisition" then begin //Added
             LeaveApplic.Reset;
              LeaveApplic.SetRange(LeaveApplic."No.",Doc_No);
               if LeaveApplic.Find('-') then begin
               if LeaveApplic.Status<>LeaveApplic.Status::"Pending Approval" then
               Error(text1001);
            LeaveApplic.Status := LeaveApplic.Status::Open;
            LeaveApplic.Modify(true);
              end;
            end;
        
        
            if Table_Id = Database::"FLT-Fuel Req. Header" then begin //Added
             FLTFuelReqHeader.Reset;
              FLTFuelReqHeader.SetRange(FLTFuelReqHeader."Req. No.",Doc_No);
               if FLTFuelReqHeader.Find('-') then begin
               if FLTFuelReqHeader.Status<>FLTFuelReqHeader.Status::"Pending Approval" then
               Error(text1001);
            FLTFuelReqHeader.Status := FLTFuelReqHeader.Status::New;
            FLTFuelReqHeader.Modify(true);
              end;
            end;
        
        
           if Table_Id = Database::"FIN-Medical Claim Header" then begin //Added
             Clear(FINMedicalClaimHeader);
             FINMedicalClaimHeader.Reset;
             FINMedicalClaimHeader.SetRange("Claim No.",Doc_No);
            if FINMedicalClaimHeader.Find('-') then begin
               FINMedicalClaimHeader.Status:=FINMedicalClaimHeader.Status::New;
               FINMedicalClaimHeader.Modify;
            end;
           end;//Added

    end;


    procedure SendLeaveApprovalRequest(var LeaveReq: Record UnknownRecord61125;var ResponsibilityCenter: Code[30]): Boolean
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
        GenSendNotifications: Codeunit "Gen-Send Notifications";
    begin
        TestSetup;
        with LeaveReq do begin
          if Status <> Status::Open then    //Status should be Pending When Starting
            exit(false);
        
          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
            /*IF NOT SalesLinesExist THEN
               ERROR(Text015,FORMAT('Leave'),"No.");*/
          //Pass the Document Type to Pass
            DocType:=Doctype::"Leave Application";
        
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"HRM-Leave Requisition");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             LeaveReq.TestField(LeaveReq."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",LeaveReq."Responsibility Center");
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverLeave(LeaveReq,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryLeave(LeaveReq,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,LeaveReq."No.");
              Messagetype::AutomaticRelease:Message(Text003,DocType,LeaveReq."No.");
              Messagetype::RequiresApproval: Message(Text001,DocType,"No.");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;
        GenSendNotifications.ReleaverLeaveNotification(LeaveReq."No.");

    end;


    procedure FindApproverLeave(LeaveReq: Record UnknownRecord61125;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[50];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
        Text001: label 'Maximum Amount Cannot be ZERO for Approver %1';
        HRMLeaveRequisition: Record UnknownRecord61125;
        UserSetupReliever: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        NewSequenceNo: Integer;
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        ApprovalAmount:=LeaveReq."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::"Leave Application";
        
        // IF DocType=DocType::"Leave Application" THEN BEGIN
          // Create Releaver Approval Entry
          HRMLeaveRequisition.Reset;
          HRMLeaveRequisition.SetRange("No.",LeaveReq."No.");
          if HRMLeaveRequisition.Find('-') then begin
            HRMLeaveRequisition.TestField("Reliever No.");
            UserSetupReliever.Reset;
            UserSetupReliever.SetRange("Staff No",HRMLeaveRequisition."Reliever No.");
            if UserSetupReliever.Find('-') then begin
        // //            MakeApprovalEntry(
        // //              Table_id,DocType,FORMAT(Doc_no),'',
        // //              ApprovalSetup,UserSetupReliever."User ID",AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
        // //              '',AppTemplate,0,0);
                      with ApprovalEntry do begin
                        Clear(NewSequenceNo);
          SetRange("Table ID",61125);
          SetRange("Document Type",DocType);
          SetRange("Document No.",LeaveReq."No.");
          if Find('+') then
            NewSequenceNo := "Sequence No." + 1
          else
            NewSequenceNo := 1;
          Init;
          "Table ID" := 61125;
          "Document Type" := DocType;
          "Document No." := LeaveReq."No.";
          "Salespers./Purch. Code" := '';
          "Sequence No." := NewSequenceNo;
          "Approval Code" := AppTemplate."Approval Code";
          "Sender ID" := UserId;
          "Approver ID" := UserSetupReliever."User ID";
          if ApproverId = UserId then begin
            Status := Status::Approved;
         end else
            Status := Status::Created;
          "Date-Time Sent for Approval" := CreateDatetime(Today,Time);
          "Last Date-Time Modified" := CreateDatetime(Today,Time);
          "Last Modified By ID" := UserId;
          "Due Date" := CalcDate(ApprovalSetup."Due Date Formula",Today);
          "Approval Type" := AppTemplate."Approval Type";
          Insert(true);
                      end;
                      end;
                      end;
        //  END;
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",LeaveReq."User ID"); //
              if not UserSetup.Find('-') then
                Error(Text005,LeaveReq."User ID");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, LeaveReq."User ID");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, LeaveReq."User ID");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                        MakeApprovalEntry(
                          Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0,0);
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, LeaveReq."User ID");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                         /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                       MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, LeaveReq."User ID");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntry(
                      Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0,0);
        
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                        MakeApprovalEntry(
                          Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0,0);
        
        
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  MakeApprovalEntry(
                    Database::"HRM-Leave Requisition",DocType,LeaveReq."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0,0);
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryLeave(LeaveReq: Record UnknownRecord61125;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::"Leave Application";

          SetRange("Table ID",Database::"HRM-Leave Requisition");
          SetRange("Document Type",DocType);
          SetRange("Document No.",LeaveReq."No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  if ApprovalSetup.Approvals then
                    ApprovalsMgtNotification.SendLeaveApprovalsMail(LeaveReq,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            LeaveReq.Status := LeaveReq.Status::"Pending Approval";
            LeaveReq.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure MakeApprovalEntryOnline(TableID: Integer;DocType: Integer;DocNo: Code[20];SalespersonPurchaser: Code[10];ApprovalSetup: Record UnknownRecord452;ApproverId: Code[50];ApprovalCode: Code[20];UserSetup: Record "User Setup";ApprovalAmount: Decimal;ApprovalAmountLCY: Decimal;CurrencyCode: Code[10];AppTemplate: Record UnknownRecord464;ExeedAmountLCY: Decimal;ExternalUser: Code[100]): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        NewSequenceNo: Integer;
    begin

        with ApprovalEntry do begin
          SetRange("Table ID",TableID);
          SetRange("Document Type",DocType);
          SetRange("Document No.",DocNo);
          if Find('+') then
            NewSequenceNo := "Sequence No." + 1
          else
            NewSequenceNo := 1;
          "Table ID" := TableID;
          if "Table ID"=78002 then
            "Document Type":="document type"::"Special Exam" else
          "Document Type" := DocType;
          "Document No." := DocNo;
          "Salespers./Purch. Code" := SalespersonPurchaser;
          "Sequence No." := NewSequenceNo;
          "Approval Code" := ApprovalCode;
          //"Sender ID" := USERID;
            "Sender ID" := ExternalUser;
          Amount := ApprovalAmount;
          "Amount (LCY)" := ApprovalAmountLCY;
          "Currency Code" := CurrencyCode;
          "Approver ID" := ApproverId;
          if ApproverId = UserId then
            Status := Status::Approved
          else
            Status := Status::Created;
          "Date-Time Sent for Approval" := CreateDatetime(Today,Time);
          "Last Date-Time Modified" := CreateDatetime(Today,Time);
          "Last Modified By ID" := UserId;
          "Due Date" := CalcDate(ApprovalSetup."Due Date Formula",Today);
          "Approval Type" := AppTemplate."Approval Type";
          "Limit Type" := AppTemplate."Limit Type";
          "Available Credit Limit (LCY)" := ExeedAmountLCY;
          Insert;
          // Polpulate the Signatures Pool ... DEVELOPER: Wanjala M. Tom //
          PopullateApprovalSignatures(DocNo,DocType,ApprovalCode);
        end;
    end;


    procedure SendStoreReqApprovalRequest(var StoreHeader: Record UnknownRecord61399;var ResponsibilityCenter: Code[30]): Boolean
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;
        
        with StoreHeader do begin
          if Status <> Status::Open then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);
        
          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
           /* IF NOT StoresLinesExist THEN
               ERROR(Text015,FORMAT('Requisition'),"No.");*/
          //Pass the Document Type to Pass
            DocType:=Doctype::Requisition;
        
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"PROC-Store Requistion Header");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             StoreHeader.TestField(StoreHeader."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",StoreHeader."Responsibility Center");
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverStore(StoreHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryStore(StoreHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,StoreHeader."No.");
              Messagetype::AutomaticRelease:Message(Text003,DocType,StoreHeader."No.");
              Messagetype::RequiresApproval: Message(Text001,DocType,StoreHeader."No.");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;

    end;


    procedure FindApproverStore(StoreHeader: Record UnknownRecord61399;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::Requisition;
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",StoreHeader."User ID"); //
              if not UserSetup.Find('-') then
                Error(Text005,StoreHeader."User ID");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"PROC-Store Requistion Header",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
        
        */
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, StoreHeader."User ID");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryStore(StoreHeader: Record UnknownRecord61399;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::Requisition;

          SetRange("Table ID",Database::"HRM-Leave Requisition");
          SetRange("Document Type",DocType);
          SetRange("Document No.",StoreHeader."No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  //if approvalSetup.Approvals THEN
                  //  ApprovalsMgtNotification.SendLeaveApprovalsMail(LeaveReq,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            StoreHeader.Status := StoreHeader.Status::"Pending Approval";
            // INSERT;
            StoreHeader.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure SendImprestReqApprovalRequest(var ImprestHeader: Record UnknownRecord61704;var ResponsibilityCenter: Code[30])
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;

        with ImprestHeader do begin
          if Status <> Status::Pending then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);

          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
           // IF NOT ImpLinesExist() THEN
             //  ERROR(Text015,FORMAT('Imprest'),"No.");
          //Pass the Document Type to Pass
            DocType:=Doctype::Imprest;

          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"FIN-Imprest Header");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             ImprestHeader.TestField(ImprestHeader."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",ImprestHeader."Responsibility Center");
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverImprest(ImprestHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryImprest(ImprestHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,ImprestHeader."No.");
              Messagetype::AutomaticRelease:Message(Text003,DocType,ImprestHeader."No.");
              Messagetype::RequiresApproval: Message(Text001,DocType,ImprestHeader."No.");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;
    end;


    procedure FindApproverImprest(ImprestHeader: Record UnknownRecord61704;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::Imprest;
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",ImprestHeader."Requested By"); //
              if not UserSetup.Find('-') then
                Error(Text005,ImprestHeader."Requested By");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,LeaveReq."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);*/
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,StoreHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"FIN-Imprest Header",DocType,ImprestHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, ImprestHeader."Requested By");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryImprest(ImprestHeader: Record UnknownRecord61704;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::Imprest;

          SetRange("Table ID",Database::"FIN-Imprest Header");
          SetRange("Document Type",DocType);
          SetRange("Document No.",ImprestHeader."No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  //if approvalSetup.Approvals THEN
                  //  ApprovalsMgtNotification.SendLeaveApprovalsMail(LeaveReq,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            ImprestHeader.Status := ImprestHeader.Status::"Pending Approval";
            ImprestHeader.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure SendTransportApprovalRequest(var TransportHeader: Record UnknownRecord61801;var ResponsibilityCenter: Code[30])
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;

        with TransportHeader do begin
          if Status <> Status::Open then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);

          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
            //IF NOT ImpLinesExist() THEN
             //  ERROR(Text015,FORMAT('Imprest'),"No.");
          //Pass the Document Type to Pass
            DocType:=Doctype::TR;

          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"FLT-Transport Requisition");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             TransportHeader.TestField(TransportHeader."Responsibility Center");
             TemplateRec.SetRange(TemplateRec."Responsibility Center",TransportHeader."Responsibility Center");
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverTransport(TransportHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryTransport(TransportHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,TransportHeader."Transport Requisition No");
              Messagetype::AutomaticRelease:Message(Text003,DocType,TransportHeader."Transport Requisition No");
              Messagetype::RequiresApproval: Message(Text001,DocType,TransportHeader."Transport Requisition No");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;
    end;


    procedure FindApproverTransport(TransportHeader: Record UnknownRecord61801;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::TR;
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",TransportHeader."Requested By"); //
              if not UserSetup.Find('-') then
                Error(Text005,TransportHeader."Requested By");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);*/
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"FLT-Transport Requisition",DocType,TransportHeader."Transport Requisition No",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, TransportHeader."Requested By");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryTransport(TransportHeader: Record UnknownRecord61801;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval): Boolean
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::TR;

          SetRange("Table ID",Database::"FLT-Transport Requisition");
          SetRange("Document Type",DocType);
          SetRange("Document No.",TransportHeader."Transport Requisition No");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  //if approvalSetup.Approvals THEN
                   //ApprovalsMgtNotification.SendtransportMail(TransportHeader,ApprovalEntry);

                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            TransportHeader.Status := TransportHeader.Status::"Pending Approval";
            TransportHeader.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure SendMealsApprovalRequest(var MealHeader: Record UnknownRecord61778)
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;
        
        with MealHeader do begin
          if Status <> Status::New then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);
        
          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
            //IF NOT ImpLinesExist() THEN
             //  ERROR(Text015,FORMAT('Imprest'),"No.");
          //Pass the Document Type to Pass
            DocType:=Doctype::"Meals Bookings";
        
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"CAT-Meal Booking Header");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             /*MealHeader.TESTFIELD(MealHeader."Responsibility Center");
             TemplateRec.SETRANGE(TemplateRec."Responsibility Center",MealHeader."Responsibility Center");*/
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverMeal(MealHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryMeal(MealHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,MealHeader."Booking Id");
              Messagetype::AutomaticRelease:Message(Text003,DocType,MealHeader."Booking Id");
              Messagetype::RequiresApproval: Message(Text001,DocType,MealHeader."Booking Id");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;

    end;


    procedure FindApproverMeal(MealHeader: Record UnknownRecord61778;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::"Meals Bookings";
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",MealHeader."Requested By"); //
              if not UserSetup.Find('-') then
                Error(Text005,MealHeader."Requested By");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);*/
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"CAT-Meal Booking Header",DocType,MealHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, MealHeader."Requested By");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryMeal(MealHeader: Record UnknownRecord61778;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval): Boolean
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::"Meals Bookings";

          SetRange("Table ID",Database::"CAT-Meal Booking Header");
          SetRange("Document Type",DocType);
          SetRange("Document No.",MealHeader."Booking Id");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  //if approvalSetup.Approvals THEN
                  //  ApprovalsMgtNotification.SendLeaveApprovalsMail(LeaveReq,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            MealHeader.Status := MealHeader.Status::"Pending Approval";
            MealHeader.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure SendVenueApprovalRequest(var VenueHeader: Record UnknownRecord77709)
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Venue Booking";
    begin
        TestSetup;
        
        with VenueHeader do begin
          if Status <> Status::New then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);
        
          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
            //IF NOT ImpLinesExist() THEN
             //  ERROR(Text015,FORMAT('Imprest'),"No.");
          //Pass the Document Type to Pass
            DocType:=Doctype::"Venue Booking";
        
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"Gen-Venue Booking");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             /*MealHeader.TESTFIELD(MealHeader."Responsibility Center");
             TemplateRec.SETRANGE(TemplateRec."Responsibility Center",MealHeader."Responsibility Center");*/
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverVenue(VenueHeader,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntryVenue(VenueHeader,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,VenueHeader."Booking Id");
              Messagetype::AutomaticRelease:Message(Text003,DocType,VenueHeader."Booking Id");
              Messagetype::RequiresApproval: Message(Text001,DocType,VenueHeader."Booking Id");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;

    end;


    procedure FindApproverVenue(VenueHeader: Record UnknownRecord77709;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Venue Booking";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::"Venue Booking";
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",VenueHeader."Requested By"); //
              if not UserSetup.Find('-') then
                Error(Text005,VenueHeader."Requested By");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      repeat
                        UserSetup.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetup."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
                      until (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);*/
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"Gen-Venue Booking",DocType,VenueHeader."Booking Id",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, VenueHeader."Requested By");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntryVenue(VenueHeader: Record UnknownRecord77709;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval): Boolean
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Venue Booking";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::"Venue Booking";

          SetRange("Table ID",Database::"Gen-Venue Booking");
          SetRange("Document Type",DocType);
          SetRange("Document No.",VenueHeader."Booking Id");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  if ApprovalSetup.Approvals then
                 ApprovalsMgtNotification.SendVenueApprovalsMail(VenueHeader,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

            VenueHeader.Status := VenueHeader.Status::"Pending Approval";
            VenueHeader.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;


    procedure SendSpecialExamApprovalRequest(var SpecialExam: Record UnknownRecord78002)
    var
        Cust: Record Customer;
        TemplateRec: Record UnknownRecord464;
        ApprovalSetup: Record UnknownRecord452;
        MessageType: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin
        TestSetup;
        
        with SpecialExam do begin
          if "Approval Status" <> "approval status"::Open then    //Status should be Pending When Starting
              //Status should be Pending When Starting
          Error('Error:\  **** Document status must be open ****');
           // EXIT(FALSE);
        
          if not ApprovalSetup.Get then
            Error(Text004);
          //Check Whether Payment Lines Exist
            //IF NOT ImpLinesExist() THEN
             //  ERROR(Text015,FORMAT('Imprest'),"No.");
          //Pass the Document Type to Pass
            DocType:=Doctype::"Special Exam";
        
          TemplateRec.SetCurrentkey("Table ID","Document Type",Enabled);
          TemplateRec.SetRange("Table ID",Database::"Aca-Special Exams Details");
          TemplateRec.SetRange("Document Type",DocType);
          //Add The Responsibility Center When Selecting The Template to use++In case where Diff
          //Responsibility Centers have diff Templates
          if ApprovalSetup."Responsibility Center Required" then begin
             /*MealHeader.TESTFIELD(MealHeader."Responsibility Center");
             TemplateRec.SETRANGE(TemplateRec."Responsibility Center",MealHeader."Responsibility Center");*/
          end;
           //End Responsibility Center
          TemplateRec.SetRange(Enabled,true);
          if TemplateRec.Find('-') then begin
            repeat
              if not FindApproverSpecialExam(SpecialExam,ApprovalSetup,TemplateRec) then
                Error(Text010);
            until TemplateRec.Next = 0;
            //Finish Approval Entries**
               FinishApprovalEntrySpecial(SpecialExam,ApprovalSetup,MessageType);
            case MessageType of
              Messagetype::AutomaticPrePayment:Message(Text128,DocType,SpecialExam."Student No.");
              Messagetype::AutomaticRelease:Message(Text003,DocType,SpecialExam."Student No.");
              Messagetype::RequiresApproval: Message(Text001,DocType,SpecialExam."Student No.");
            end;
          end else
            Error(StrSubstNo(Text129,DocType));
        end;

    end;


    procedure FindApproverSpecialExam(SpecialExam: Record UnknownRecord78002;ApprovalSetup: Record UnknownRecord452;AppTemplate: Record UnknownRecord464): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[20];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
        UserSetupI: Record "User Setup";
    begin
        
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        
        //Get the Approval Amount
        //ApprovalAmount:=StoreHeader."Applied Days";
        //LeaveReq.CALCFIELDS("Amount Surrendered LCY");
        //ApprovalAmountLCY:=PaymentHeader."Amount Surrendered LCY";
        
        //Confirm what this is
        AboveCreditLimitAmountLCY:=0;
        DocType:=Doctype::"Meals Bookings";
        
        case AppTemplate."Approval Type" of
        
          AppTemplate."approval type"::Approver: begin
              //UserSetup.SETRANGE("User ID",USERID); //
              UserSetup.SetRange("User ID",SpecialExam."Created By"); //
              if not UserSetup.Find('-') then
                Error(Text005,SpecialExam."Created By");  //USERID
        
              case AppTemplate."Limit Type" of
                AppTemplate."limit type"::"Approval Limits": begin
                    ApproverId := UserSetup."User ID";
        
                    MakeApprovalEntryOnline(
                      Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, SpecialExam."Created By");
        
                    if not UserSetup."Unlimited ImprestSurr Amt Appr" and
                       ((ApprovalAmountLCY > UserSetup."ImprestSurr Amt Approval Limit") or
                       (UserSetup."ImprestSurr Amt Approval Limit" = 0))
                    then
                      //REPEAT
                      UserSetupI.Reset;
                        UserSetupI.SetRange("User ID",UserSetup."Approver ID");
                        if not UserSetup.Find('-') then
                          Error(Text005,UserId);  //
                        ApproverId := UserSetupI."User ID";
        
                        /*
                        MakeApprovalEntry(
                          DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);
                          */
        
                    MakeApprovalEntryOnline(
                      Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetupI,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0,SpecialExam."Created By");
        
                     // UNTIL (UserSetup."User ID" = UserSetup."Approver ID");
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
                          MakeApprovalEntryOnline(
                      Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, SpecialExam."Created By");
        
                      until AddApproversTemp.Next = 0;
                  end;
              //Request Limits
              //Request limit
                AppTemplate."limit type"::"No Limits": begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
        
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HR Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);
                      */
        
                    MakeApprovalEntryOnline(
                     Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0,SpecialExam."Created By");
        
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        ApproverId := AddApproversTemp."Approver ID";
        
                       MakeApprovalEntryOnline(
                     Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, SpecialExam."Created By");
        
                      until AddApproversTemp.Next = 0;
                  end;
                //Tiered Approval Requests
        
                AppTemplate."limit type"::Tiered: begin
                    ApproverId := UserSetup."Approver ID";
                    if ApproverId = '' then
                      ApproverId := UserSetup."User ID";
                      /*
                    MakeApprovalEntry(
                      DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0);*/
        
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentkey("Sequence No.");
                    if AddApproversTemp.Find('-') then repeat
                        //Ensure no Maximum Amount is Zero;
                        if AddApproversTemp."Maximum Amount"=0 then
                           Error(Text001,AddApproversTemp."Approver ID");
        
                        ApproverId := AddApproversTemp."Approver ID";
                       if ApprovalAmountLCY>=AddApproversTemp."Minimum Amount" then
        
                       /* MakeApprovalEntry(
                          DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                          ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                          '',AppTemplate,0);*/
        
                      MakeApprovalEntryOnline(
                     Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, SpecialExam."Created By");
        
                      until AddApproversTemp.Next = 0;
                  end;
        
                //Tiered Approval Requests
              end;
            end;
        
          AppTemplate."approval type"::" ": begin
              CheckAddApprovers(AppTemplate);
              AddApproversTemp.SetCurrentkey("Sequence No.");
              if AddApproversTemp.Find('-') then
                repeat
                  ApproverId := AddApproversTemp."Approver ID";
                  /*MakeApprovalEntry(
                    DATABASE::"HRM-Leave Requisition",DocType,TransportHeader."No.",'',
                    ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                    '',AppTemplate,0);*/
                    MakeApprovalEntryOnline(
                      Database::"Aca-Special Exams Details",DocType,SpecialExam."Student No.",'',
                      ApprovalSetup,ApproverId,AppTemplate."Approval Code",UserSetup,ApprovalAmount,ApprovalAmountLCY,
                      '',AppTemplate,0, SpecialExam."Created By");
                until AddApproversTemp.Next = 0
              else
                Error(Text027);
            end;
          end;
        
        exit(true);

    end;


    procedure FinishApprovalEntrySpecial(SpecialExam: Record UnknownRecord78002;ApprovalSetup: Record UnknownRecord452;MessageID: Option " ",AutomaticPrePayment,AutomaticRelease,RequiresApproval): Boolean
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim","Special Exam";
    begin

        DocReleased := false;
        with ApprovalEntry do begin
          Init;
          //Get Document Type
            DocType:=Doctype::"Special Exam";

          SetRange("Table ID",Database::"Aca-Special Exams Details");
          SetRange("Document Type",DocType);
          SetRange("Document No.",SpecialExam."Student No.");
          SetRange(Status,Status::Created);
          if FindSet(true,false) then
            repeat
              if "Sender ID" = "Approver ID" then begin
                Status := Status::Approved;
                Modify;
              end else
                if not IsOpenStatusSet then begin
                  Status := Status::Open;
                  Modify;
                  IsOpenStatusSet := true;
                  //if approvalSetup.Approvals THEN
                  //  ApprovalsMgtNotification.SendLeaveApprovalsMail(LeaveReq,ApprovalEntry);
                end;
            until Next = 0;

          if not IsOpenStatusSet then begin
            SetRange(Status);
            FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
          end;

          if DocReleased then begin
            //IF TestSalesPrepayment(SalesHeader) AND
            //   (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            // MessageID := MessageID::AutomaticPrePayment
            // ELSE
              MessageID := Messageid::AutomaticRelease;
          end else begin

           SpecialExam."Approval Status" := SpecialExam."approval status"::Pending;
            SpecialExam.Modify(true);

            MessageID := Messageid::RequiresApproval;
          end;
        end;
    end;
}


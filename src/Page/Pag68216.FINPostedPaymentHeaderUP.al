#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68216 "FIN-Posted Payment Header UP"
{
    // //Use if Cheque is to be Validated
    // Payments.RESET;
    // Payments.SETRANGE(Payments."No.","No.");
    // IF Payments.FINDFIRST THEN
    //   BEGIN
    //     IF Payments."Pay Mode"=Payments."Pay Mode"::Cheque THEN
    //       BEGIN
    //          IF STRLEN(Payments."Cheque No.")<>6 THEN
    //           BEGIN
    //             ERROR ('Invalid Cheque Number Inserted');
    //           END;
    //       END;
    //   END;
    // **************************************************************************************
    // //Use if Paying Bank Account should not be overdrawn
    // 
    // //get the source account balance from the database table
    // BankAcc.RESET;
    // BankAcc.SETRANGE(BankAcc."No.",Payment."Paying Bank Account");
    // BankAcc.SETRANGE(BankAcc."Bank Type",BankAcc."Bank Type"::Cash);
    // IF BankAcc.FINDFIRST THEN
    //   BEGIN
    //     Payments.TESTFIELD(Payments.Date,TODAY);
    //     BankAcc.CALCFIELDS(BankAcc."Balance (LCY)");
    //     "Current Source A/C Bal.":=BankAcc."Balance (LCY)";
    //     IF ("Current Source A/C Bal."-Payment."Total Net Amount")<0 THEN
    //       BEGIN
    //         ERROR('The transaction will result in a negative balance in the BANK ACCOUNT.');
    //       END;
    //   END;

    Caption = 'Posted Payment Voucher';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = UnknownTable61688;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("PV Category";"PV Category")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                }
                field("Apply to Document Type";"Apply to Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Apply to Document No";"Apply to Document No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDimension1CodeEditable;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                    Editable = "Pay ModeEditable";
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency CodeEditable";
                }
                field("Paying Bank Account";"Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    Editable = "Paying Bank AccountEditable";
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment to';
                    Editable = PayeeEditable;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payment Narration";"Payment Narration")
                {
                    ApplicationArea = Basic;
                    Editable = "Payment NarrationEditable";
                }
                field("Reference No.";"Reference No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Imprest No.";"Imprest No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque Type";"Cheque Type")
                {
                    ApplicationArea = Basic;
                    Editable = "Cheque TypeEditable";

                    trigger OnValidate()
                    begin
                          if "Cheque Type"="cheque type"::"Computer Check" then
                              "Cheque No.Editable" :=false
                          else
                              "Cheque No.Editable" :=true;
                    end;
                }
                field("Invoice Currency Code";"Invoice Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Invoice Currency CodeEditable";
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Total Payment Amount";"Total Payment Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total VAT Amount";"Total VAT Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Witholding Tax Amount";"Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Retention Amount";"Total Retention Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total PAYE Amount";"Total PAYE Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("""Total Payment Amount"" -( ""Total Witholding Tax Amount""+""Total Retention Amount"" + ""Total PAYE Amount"")";"Total Payment Amount" -( "Total Witholding Tax Amount"+"Total Retention Amount" + "Total PAYE Amount"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount';
                }
                field("""Total Payment Amount""-( ""Total Witholding Tax Amount""+""Total Retention Amount"" + ""Total PAYE Amount"")";"Total Payment Amount"-( "Total Witholding Tax Amount"+"Total Retention Amount" + "Total PAYE Amount"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount LCY';
                    Editable = false;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/EFT No.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //check if the cheque has been inserted
                        TestField("Paying Bank Account");
                        /*
                        PVHead.RESET;
                        PVHead.SETRANGE(PVHead."Paying Bank Account","Paying Bank Account");
                        PVHead.SETRANGE(PVHead."Pay Mode",PVHead."Pay Mode"::Cheque);
                        IF PVHead.FINDFIRST THEN
                          BEGIN
                            REPEAT
                              IF PVHead."Cheque No."="Cheque No." THEN
                                BEGIN
                                  IF PVHead."No."<>"No." THEN
                                    BEGIN
                                      ERROR('The Cheque Number has already been utilised');
                                    END;
                                END;
                            UNTIL PVHead.NEXT=0;
                          END;
                         */

                    end;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Payment Release DateEditable";
                }
                field("Cheque Printed";"Cheque Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Financial Period";"Financial Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Budgeted Amount";"Budgeted Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Actual Expenditure";"Actual Expenditure")
                {
                    ApplicationArea = Basic;
                }
                field("Committed Amount";"Committed Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Balance";"Budget Balance")
                {
                    ApplicationArea = Basic;
                }
            }
            part(PVLines;"FIN-Payment Lines")
            {
                SubPageLink = No=field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Status=Status::Pending then
                           //ERROR('You cannot Print until the document is released for approval');
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51673,true,true,Rec);
                        Reset;
                    end;
                }
                action("Rectify 0.5%")
                {
                    ApplicationArea = Basic;
                    Visible = Rectified = false;

                    trigger OnAction()
                    begin
                        if Rec.Rectified then
                          Error('PV has already been rectfied');
                        Temp.Get(UserId);

                        JTemplate:=Temp."Payment Journal Template";JBatch:=Temp."Payment Journal Batch";

                        if JTemplate='' then
                          begin
                            Error('Ensure the PV Template is set up in Cash Office Setup');
                          end;
                        if JBatch='' then
                          begin
                            Error('Ensure the PV Batch is set up in the Cash Office Setup')
                          end;
                        PayLine.Reset;
                        PayLine.SetRange(No,Rec."No.");
                        if PayLine.FindSet then begin
                          repeat
                        if PayLine."WHT 2 Code"<>'' then begin
                            TarriffCodes.Reset;
                            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."WHT 2 Code");
                            if TarriffCodes.Find('-') then begin
                            TarriffCodes.TestField(TarriffCodes."G/L Account");
                            LineNo:=LineNo+1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name":=JTemplate;
                            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
                            GenJnlLine."Journal Batch Name":=JBatch;
                            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
                            GenJnlLine."Source Code":='PAYMENTJNL';
                            GenJnlLine."Line No.":=LineNo;
                            GenJnlLine."Posting Date":=Rec."Payment Release Date";
                            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
                            GenJnlLine."Document No.":=PayLine.No;
                            GenJnlLine."External Document No.":=Payments."Cheque No.";
                            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
                            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
                            GenJnlLine.Validate(GenJnlLine."Account No.");
                            GenJnlLine."Currency Code":=Payments."Currency Code";
                            GenJnlLine.Validate(GenJnlLine."Currency Code");
                            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
                            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
                            GenJnlLine."Gen. Bus. Posting Group":='';
                            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
                            GenJnlLine."Gen. Prod. Posting Group":='';
                            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
                            GenJnlLine."VAT Bus. Posting Group":='';
                            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
                            GenJnlLine."VAT Prod. Posting Group":='';
                            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                            GenJnlLine.Amount:=-PayLine."WHT 2 Amount";
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type":=PayLine."Account Type";
                            GenJnlLine."Bal. Account No.":=PayLine."Account No.";
                            GenJnlLine.Description:=CopyStr(PayLine."PAYE Code"+':' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
                            //GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
                            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
                            end;
                            end;
                            until PayLine.Next=0;
                            end;

                        GenJnlLine.Reset;
                                         GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
                                         GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);

                                         Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                                         Post:=false;
                                         Post:=JournlPosted.PostedSuccessfully();
                                         if Post then
                                          begin
                                            if PayLine.FindFirst then
                                              begin
                                                repeat
                                                  PayLine."Date Posted":=Today;
                                                  PayLine."Time Posted":=Time;
                                                  PayLine."Posted By":=UserId;
                                                  PayLine.Status:=PayLine.Status::Posted;
                                                  PayLine.Modify;
                                               until PayLine.Next=0;
                                             end;
                                             end;
                        Rec.Rectified:=true;
                        Rec.Modify();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        /*DateEditable := TRUE;
        PayeeEditable := TRUE;
        ShortcutDimension2CodeEditable := TRUE;
        "Payment NarrationEditable" := TRUE;
        GlobalDimension1CodeEditable := TRUE;
        "Cheque TypeEditable" := TRUE;
        "Pay ModeEditable" := TRUE;
        "Paying Bank AccountEditable" := TRUE;
        "Payment Release DateEditable" := TRUE;
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Payment Type":="payment type"::Normal;

          Rcpt.Reset;
          Rcpt.SetRange(Rcpt.Posted,false);
          Rcpt.SetRange(Rcpt.Cashier,UserId);
          if Rcpt.Count >0 then
            begin
              if Confirm('There are still some unposted payments. Continue?',false)=false then
                begin
                  Error('There are still some unposted payments. Please utilise them first');
                end;
            end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
         "Responsibility Center" := UserMgt.GetPurchasesFilter();
         //Add dimensions if set by default here
         "Global Dimension 1 Code":=UserMgt.GetSetDimensions(UserId,1);
         Validate("Global Dimension 1 Code");
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(UserId,2);
         Validate("Shortcut Dimension 2 Code");
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(UserId,3);
         Validate("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(UserId,4);
         Validate("Shortcut Dimension 4 Code");
         "Responsibility Center":='MAIN';
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;


        //UpdateControls;
    end;

    var
        Text001: label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: label 'Do you want to Void Check No %1';
        Text002: label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
        Rcpt: Record UnknownRecord61688;
        PayLine: Record UnknownRecord61705;
        PVUsers: Record UnknownRecord61711;
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record UnknownRecord61688;
        RecPayTypes: Record UnknownRecord61129;
        TarriffCodes: Record UnknownRecord61716;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord61712;
        LineNo: Integer;
        Temp: Record UnknownRecord61712;
        JTemplate: Code[10];
        JBatch: Code[10];
        PCheck: Codeunit "Post Custom Cust Ledger";
        Post: Boolean;
        strText: Text[100];
        PVHead: Record UnknownRecord61688;
        BankAcc: Record "Bank Account";
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";
        Commitments: Record UnknownRecord61722;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        JournlPosted: Codeunit PostCaferiaBatches;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        DocPrint: Codeunit "Document-Print";
        CheckLedger: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        BankPayment: Record UnknownRecord61174;
        VBank: Record "Vendor Bank Account";
        ImprestHeader: Record UnknownRecord61704;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        ApprovalEntries: Page "Approval Entries";


    procedure PostPaymentVoucher()
    begin

         // DELETE ANY LINE ITEM THAT MAY BE PRESENT
         GenJnlLine.Reset;
         GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
         GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
         if GenJnlLine.Find('+') then
           begin
             LineNo:=GenJnlLine."Line No."+1000;
           end
         else
           begin
             LineNo:=1000;
           end;
         GenJnlLine.DeleteAll;
         GenJnlLine.Reset;

        Payments.Reset;
        Payments.SetRange(Payments."No.","No.");
        if Payments.Find('-') then begin
          PayLine.Reset;
          PayLine.SetRange(PayLine.No,Payments."No.");
          if PayLine.Find('-') then
            begin
              repeat
                PostHeader(Payments);
              until PayLine.Next=0;
            end;

        //Post:=FALSE;
        //Post:=JournlPosted.PostedSuccessfully();
        //IF Post THEN  BEGIN
            Posted:=true;
            Status:=Payments.Status::Posted;
            "Posted By":=UserId;
            "Date Posted":=Today;
            "Time Posted":=Time;
            Modify;

          //Post Reversal Entries for Commitments
          Doc_Type:=Doc_type::"Payment Voucher";
          CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");

          if ImprestHeader.Get("Apply to Document No") then begin
          ImprestHeader.Posted:=true;
          ImprestHeader."Date Posted":=Today;
          ImprestHeader."Time Posted":=Time;
          ImprestHeader."Posted By":=UserId;
          ImprestHeader."Cheque No.":="Cheque No.";
          ImprestHeader.Modify;
          end;
          if PVHead.Get("Apply to Document No") then begin
          PVHead.Posted:=true;
          PVHead."Date Posted":=Today;
          PVHead."Time Posted":=Time;
          PVHead."Posted By":=UserId;
          PVHead.Modify;
          end;
          end;
        //END;
    end;


    procedure PostHeader(var Payment: Record UnknownRecord61688)
    begin

        //IF (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Check") THEN
         //  ERROR('Cheque type has to be specified');

        if Payments."Pay Mode"=Payments."pay mode"::Cheque then begin
            if (Payments."Cheque No."='') and ("Cheque Type"="cheque type"::"Manual Check") then
              begin
                Error('Please ensure that the cheque number is inserted');
              end;
        end;

        if Payments."Pay Mode"=Payments."pay mode"::EFT then
          begin
            if Payments."Cheque No."='' then;
          end;

        if Payments."Pay Mode"=Payments."pay mode"::"Letter of Credit" then
          begin
            if Payments."Cheque No."='' then
              begin
                Error('Please ensure that the Letter of Credit ref no. is entered.');
              end;
          end;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);

          if GenJnlLine.Find('+') then
            begin
              LineNo:=GenJnlLine."Line No."+1000;
            end
          else
            begin
              LineNo:=1000;
            end;


        LineNo:=LineNo+1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name":=JTemplate;
        GenJnlLine.Validate(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name":=JBatch;
        GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No.":=LineNo;
        GenJnlLine."Source Code":='PAYMENTJNL';
        GenJnlLine."Posting Date":=Payment."Payment Release Date";
        if CustomerPayLinesExist then
         GenJnlLine."Document Type":=GenJnlLine."document type"::" "
        else
          GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
        GenJnlLine."Document No.":=Payments."No.";
        GenJnlLine."External Document No.":=Payments."Cheque No.";

        GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No.":=Payments."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code":=Payments."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        Payments.CalcFields(Payments."Total Net Amount");
        GenJnlLine.Amount:=-(Payments."Total Net Amount" );
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Bal. Account No.":='';

        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

        GenJnlLine.Description:=CopyStr('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.Validate(GenJnlLine.Description);

        if "Pay Mode"<>"pay mode"::Cheque then  begin
        GenJnlLine."Bank Payment Type":=GenJnlLine."bank payment type"::" "
        end else begin
        if "Cheque Type"="cheque type"::"Computer Check" then
         GenJnlLine."Bank Payment Type":=GenJnlLine."bank payment type"::"Computer Check"
        else
           GenJnlLine."Bank Payment Type":=GenJnlLine."bank payment type"::" "

        end;
        if GenJnlLine.Amount<>0 then
        GenJnlLine.Insert;

        //Post Other Payment Journal Entries
        PostPV(Payments);
    end;


    procedure GetAppliedEntries(var LineNo: Integer) InvText: Text[100]
    var
        Appl: Record UnknownRecord61728;
    begin

        InvText:='';
        Appl.Reset;
        Appl.SetRange(Appl."Document Type",Appl."document type"::PV);
        Appl.SetRange(Appl."Document No.","No.");
        Appl.SetRange(Appl."Line No.",LineNo);
        if Appl.FindFirst then
          begin
            repeat
              InvText:=CopyStr(InvText + ',' + Appl."Appl. Doc. No",1,50);
            until Appl.Next=0;
          end;
    end;


    procedure InsertApproval()
    var
        Appl: Record UnknownRecord61729;
        LineNo: Integer;
    begin
        LineNo:=0;
        Appl.Reset;
        if Appl.FindLast then
          begin
            LineNo:=Appl."Line No.";
          end;

        LineNo:=LineNo +1;

        Appl.Reset;
        Appl.Init;
          Appl."Line No.":=LineNo;
          Appl."Document Type":=Appl."document type"::Quote;
          Appl."Document No.":="No.";
          Appl."Document Date":=Date;
          Appl."Process Date":=Today;
          Appl."Process Time":=Time;
          Appl."Process User ID":=UserId;
          Appl."Process Name":="Current Status";
          //Appl."Process Machine":=ENVIRON('COMPUTERNAME');
        Appl.Insert;
    end;


    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCSetup: Record UnknownRecord61721;
    begin
         if BCSetup.Get() then  begin
            if not BCSetup.Mandatory then  begin
               Exists:=false;
               exit;
            end;
         end else begin
               Exists:=false;
               exit;
         end;
         Exists:=false;
         PayLine.Reset;
         PayLine.SetRange(PayLine.No,"No.");
         PayLine.SetRange(PayLine.Committed,false);
         PayLine.SetRange(PayLine."Budgetary Control A/C",true);
          if PayLine.Find('-') then
             Exists:=true;
    end;


    procedure CheckPVRequiredItems()
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        PayLine.SetRange(PayLine."Budgetary Control A/C",true);
        if PayLine.Find('-') then begin
        PayLine.TestField(PayLine.Committed,true);
        end;
        
        if Posted then  begin
            Error('The Document has already been posted');
        end;
        
        TestField(Status,Status::Approved);
        TestField("Paying Bank Account");
        TestField("Pay Mode");
        TestField("Payment Release Date");
        //Confirm whether Bank Has the Cash
        if "Pay Mode"="pay mode"::Cash then
        // CheckBudgetAvail.CheckFundsAvailability(Rec);
        
        /*Check if the user has selected all the relevant fields*/
        Temp.Reset;
        if Temp.Get(UserId) then begin
        Temp.TestField(Temp."Payment Journal Template");
        Temp.TestField(Temp."Payment Journal Batch");
        JTemplate:=Temp."Payment Journal Template";
        JBatch:=Temp."Payment Journal Batch";
        end;
        if JTemplate='' then
        begin
          Error('Ensure the PV Template is set up in cash office setup1 ');
        if JBatch='' then
        begin
          Error('Ensure the Batch Template is set up in cash office setup1 ');
        end;
        end;
        
        if ("Pay Mode"="pay mode"::Cheque) and ("Cheque Type"="cheque type"::"Computer Check") then begin
           if not Confirm(Text002,false) then
              Error('You have selected to Abort PV Posting');
        end;
        //Check whether there is any printed cheques and lines not posted
        CheckLedger.Reset;
        CheckLedger.SetRange(CheckLedger."Document No.","No.");
        CheckLedger.SetRange(CheckLedger."Entry Status",CheckLedger."entry status"::Printed);
        if CheckLedger.Find('-') then begin
        //Ask whether to void the printed cheque
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        GenJnlLine.FindFirst;
        if Confirm(Text000,false,CheckLedger."Check No.") then
          CheckManagement.VoidCheck(GenJnlLine)
          else
           Error(Text001,"No.",CheckLedger."Check No.");
        end;

    end;


    procedure PostPV(var Payment: Record UnknownRecord61688)
    begin
        
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,Payments."No.");
        if PayLine.Find('-') then begin
        
        repeat
            strText:=GetAppliedEntries(PayLine."Line No.");
            Payment.TestField(Payment.Payee);
            PayLine.TestField(PayLine.Amount);
            PayLine.TestField(PayLine."Global Dimension 1 Code");
        
            //BANK
            if PayLine."Pay Mode"=PayLine."pay mode"::Cash then begin
              CashierLinks.Reset;
              CashierLinks.SetRange(CashierLinks.User_ID,UserId);
            end;
        
            //CHEQUE
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document No.":=PayLine.No;
            if PayLine."Account Type"=PayLine."account type"::Customer then
            GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine.Description:=CopyStr(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
            GenJnlLine.Payee:=Payment.Payee;
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate("Currency Code");
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
            if PayLine."VAT Code"='' then
              begin
                GenJnlLine.Amount:=PayLine."Net Amount" ;
              end
            else
              begin
                GenJnlLine.Amount:=PayLine."Net Amount";
              end;
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";
        
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
        
            //Post VAT to GL[VAT GL]
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."VAT Code");
            if TarriffCodes.Find('-') then begin
            TarriffCodes.TestField(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."VAT Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
            end;
        
            //POST W/TAX to Respective W/TAX GL Account
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."Withholding Tax Code");
            if TarriffCodes.Find('-') then begin
            TarriffCodes.TestField(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."Withholding Tax Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine.Description:=CopyStr('W/Tax:' + Format(PayLine."Account Name") +'::' + strText,1,50);
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
            end;
        
            //Post PAYE to GL[PAYE GL] -----JOSEH
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."PAYE Code");
            if TarriffCodes.Find('-') then begin
            TarriffCodes.TestField(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."PAYE Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('PAYE:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
            end;
        
        
            //Post VAT Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            if PayLine."VAT Code"='' then
              begin
                GenJnlLine.Amount:=0;
              end
            else
              begin
                GenJnlLine.Amount:=PayLine."VAT Amount";
              end;
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50) ;
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
        
            //Post W/TAX Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=PayLine."Withholding Tax Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('W/Tax:' + strText ,1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
        
            //EFT
            if Payments."Pay Mode"=Payments."pay mode"::EFT then begin
            if PayLine."Account No."<>'' then begin
            BankPayment.Reset;
            BankPayment.SetRange(BankPayment."Doc No","No.");
            if BankPayment.Find('-') then BankPayment.Delete;
            PayLine.TestField(PayLine."Vendor Bank Account");
            BankPayment.Init;
            BankPayment."Doc No":=Rec."No.";
            BankPayment.Payee:=PayLine."Account No.";
            BankPayment.Amount:="Total Payment Amount"-("Total Witholding Tax Amount"+"Total Retention Amount"+"Total VAT Amount");
            BankPayment."Bank A/C No":=PayLine."Vendor Bank Account";
            VBank.Reset;
            VBank.SetRange(VBank."Vendor No.",PayLine."Account No.");
            VBank.SetRange(VBank.Code,PayLine."Vendor Bank Account");
            if VBank.Find('-') then begin
            VBank.TestField(VBank."Bank Branch No.");
            VBank.TestField(VBank."Bank Account No.");
            BankPayment."Bank A/C No":=Format(VBank."Bank Account No.");
            BankPayment."Bank Branch No":=Format(VBank."Bank Branch No.");
            BankPayment."Bank Code":=Format(VBank.Code);
            BankPayment."Bank A/C Name":=VBank.Name
            end;
            BankPayment.Date:=Today;
            BankPayment.Insert;
            end;
            end;
        
            //Post PAYE Balancing Entry Goes to Vendor(Lecturer)----JLL
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
            GenJnlLine.Validate(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=PayLine."PAYE Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('PAYE:' + strText ,1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
        
        
        until PayLine.Next=0;
        
        Commit;
        //Post the Journal Lines
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
           AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances
        
        
        //Before posting if paymode is cheque print the cheque
        if ("Pay Mode"="pay mode"::Cheque) and ("Cheque Type"="cheque type"::"Computer Check") then begin
        DocPrint.PrintCheck(GenJnlLine);
        Codeunit.Run(Codeunit::"Adjust Gen. Journal Balance",GenJnlLine);
        //Confirm Cheque printed //Not necessary.
        end;
        
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
        Post:=false;
        Post:=JournlPosted.PostedSuccessfully();
        if Post then
          begin
            if PayLine.FindFirst then
              begin
                repeat
                  PayLine."Date Posted":=Today;
                  PayLine."Time Posted":=Time;
                  PayLine."Posted By":=UserId;
                  PayLine.Status:=PayLine.Status::Posted;
                  PayLine.Modify;
               until PayLine.Next=0;
             end;
          end;
        
        end;
        /*
        IF PayLine."Document Type"=PayLine."Document Type"::Imprest
        THEN BEGIN
        ImprestHeader.RESET;
        ImprestHeader.SETRANGE(ImprestHeader."No.",PayLine."Document No");
        IF ImprestHeader.FIND('-') THEN BEGIN
        ImprestHeader."Payment Voucher No":=PayLine.No;
        ImprestHeader.Posted:=TRUE;
        ImprestHeader."Date Posted":=TODAY;
        ImprestHeader."Time Posted":=TIME;
        ImprestHeader."Posted By":=USERID;
        ImprestHeader.MODIFY;
        END;
        END;
        
        IF PayLine."Document Type"=PayLine."Document Type"::Claim
        THEN BEGIN
        Payments.RESET;
        Payments.SETRANGE(Payments."No.",PayLine."Document No");
        IF Payments.FIND('-') THEN BEGIN
        Payments.Posted:=TRUE;
        Payments."Date Posted":=TODAY;
        Payments."Time Posted":=TIME;
        Payments."Posted By":=USERID;
        Payments.MODIFY;
        END;
        END;
         */

    end;


    procedure UpdateControls()
    begin
           /*IF Status<>Status::Approved THEN BEGIN
             "Payment Release DateEditable" :=FALSE;
             "Paying Bank AccountEditable" :=FALSE;
             "Pay ModeEditable" :=FALSE;
             "Currency CodeEditable" :=TRUE;
             "Cheque No.Editable" :=FALSE;
             "Cheque TypeEditable" :=FALSE;
             "Invoice Currency CodeEditable" :=TRUE;
           //  CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             "Payment Release DateEditable" :=TRUE;
             "Paying Bank AccountEditable" :=TRUE;
             "Pay ModeEditable" :=TRUE;
             IF "Pay Mode"="Pay Mode"::Cheque THEN
               "Cheque TypeEditable" :=TRUE;
             //CurrForm."Currency Code".EDITABLE:=FALSE;
             IF "Cheque Type"<>"Cheque Type"::"Computer Check" THEN
                 "Cheque No.Editable" :=TRUE;
             "Invoice Currency CodeEditable" :=FALSE;
            // CurrForm.UPDATECONTROLS();
             END;
        
             IF Status=Status::Pending THEN BEGIN
             "Currency CodeEditable" :=TRUE;
             GlobalDimension1CodeEditable :=TRUE;
             "Payment NarrationEditable" :=TRUE;
             ShortcutDimension2CodeEditable :=TRUE;
             PayeeEditable :=TRUE;
            // CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
            // CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
             DateEditable :=TRUE;
            // CurrForm."Serial No".EDITABLE:=TRUE;
            // CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             "Currency CodeEditable" :=FALSE;
             GlobalDimension1CodeEditable :=FALSE;
             "Payment NarrationEditable" :=FALSE;
             ShortcutDimension2CodeEditable :=TRUE;
             PayeeEditable :=TRUE;
            // CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
            // CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
             DateEditable :=FALSE;
           //  CurrForm."Serial No".EDITABLE:=FALSE;
             //CurrForm.UPDATECONTROLS();
                END
               */

    end;


    procedure LinesExists(): Boolean
    var
        PayLines: Record UnknownRecord61705;
    begin
         HasLines:=false;
         PayLines.Reset;
         PayLines.SetRange(PayLines.No,"No.");
          if PayLines.Find('-') then begin
             HasLines:=true;
             exit(HasLines);
          end;
    end;


    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record UnknownRecord61705;
    begin
        AllKeyFieldsEntered:=true;
         PayLines.Reset;
         PayLines.SetRange(PayLines.No,"No.");
          if PayLines.Find('-') then begin
            repeat
             if (PayLines."Account No."='') or (PayLines.Amount<=0) then
             AllKeyFieldsEntered:=false;
            until PayLines.Next=0;
             exit(AllKeyFieldsEntered);
          end;
    end;


    procedure CustomerPayLinesExist(): Boolean
    var
        PayLine: Record UnknownRecord61705;
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        PayLine.SetRange(PayLine."Account Type",PayLine."account type"::Customer);
        exit(PayLine.FindFirst);
    end;


    procedure PopulateCheckJournal(var Payment: Record UnknownRecord61688)
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        if PayLine.Find('-') then begin

        repeat
          //  strText:=GetAppliedEntries(PayLine."Line No.");
            Payment.TestField(Payment.Payee);
            PayLine.TestField(PayLine.Amount);
           // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");

            //BANK
            if PayLine."Pay Mode"<>PayLine."pay mode"::Cheque then;

            //CHEQUE
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":="Payment Release Date";
            GenJnlLine."Document No.":=PayLine.No;
            if PayLine."Account Type"=PayLine."account type"::Customer then
            GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":="Cheque No.";

            GenJnlLine."Currency Code":="Currency Code";
            GenJnlLine.Validate("Currency Code");
            GenJnlLine."Currency Factor":="Currency Factor";
            GenJnlLine.Validate("Currency Factor");
            if PayLine."VAT Code"='' then
              begin
                GenJnlLine.Amount:=PayLine."Net Amount" ;
              end
            else
              begin
                GenJnlLine.Amount:=PayLine."Net Amount";
              end;
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
            GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine."Bal. Account No.":="Paying Bank Account";
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"Bank Account";
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Bank Payment Type":=GenJnlLine."bank payment type"::"Computer Check";
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";
            GenJnlLine.Description:=Payee;
            ///GenJnlLine."Received By":=Payee;
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;


        until PayLine.Next=0;

        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68235 "FIN-Cancelled Payment Vouchers"
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

    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61688;
    SourceTableView = where("Payment Type"=const(Normal),
                            Status=filter(Cancelled));
    UsageCategory = History;

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
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDimension1CodeEditable;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension2CodeEditable;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension3CodeEditable;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = ShortcutDimension4CodeEditable;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency CodeEditable";
                }
                field("Paying Bank Account";"Paying Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                }
                field("Invoice Currency Code";"Invoice Currency Code")
                {
                    ApplicationArea = Basic;
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
                field("""Total Payment Amount"" - ""Total Witholding Tax Amount""";"Total Payment Amount" - "Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount';
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/EFT No.';
                    Editable = "Cheque No.Editable";

                    trigger OnValidate()
                    begin
                        //check if the cheque has been inserted
                        TestField("Paying Bank Account");
                        PVHead.Reset;
                        PVHead.SetRange(PVHead."Paying Bank Account","Paying Bank Account");
                        PVHead.SetRange(PVHead."Pay Mode",PVHead."pay mode"::Cheque);
                        if PVHead.FindFirst then
                          begin
                            repeat
                              if PVHead."Cheque No."="Cheque No." then
                                begin
                                  if PVHead."No."<>"No." then
                                    begin
                                      Error('The Cheque Number has already been utilised');
                                    end;
                                end;
                            until PVHead.Next=0;
                          end;
                    end;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Payment Release DateEditable";
                }
            }
            part(PVLines;"FIN-Payment Lines")
            {
                Editable = false;
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
                action("Post Payment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        CheckPVRequiredItems;
                        PostPaymentVoucher;
                    end;
                }
                separator(Action1102755026)
                {
                }
                action("Send A&pproval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                          Error('There are some lines that have not been committed');

                        //Release the PV for Approval
                        //IF ApprovalMgt.SendPVApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Visible = false;

                    trigger OnAction()
                    begin
                          //IF ApprovalMgt.CancelPVApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1102755009)
                {
                }
                action("Check Budgetary Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budgetary Availability';
                    Visible = false;

                    trigger OnAction()
                    begin
                          //First Check whether other lines are already committed.
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::"Payment Voucher");
                          Commitments.SetRange(Commitments."Document No.","No.");
                          if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?',false)=false then begin exit end;
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::"Payment Voucher");
                          Commitments.SetRange(Commitments."Document No.","No.");
                          Commitments.DeleteAll;
                         end;

                            CheckBudgetAvail.CheckPayments(Rec);
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitment';
                    Visible = false;

                    trigger OnAction()
                    begin
                          if Confirm('Do you Wish to Cancel the Commitment entries for this document',false)=false then begin exit end;

                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::"Payment Voucher");
                          Commitments.SetRange(Commitments."Document No.","No.");
                          Commitments.DeleteAll;

                          PayLine.Reset;
                          PayLine.SetRange(PayLine.No,"No.");
                          if PayLine.Find('-') then begin
                            repeat
                              PayLine.Committed:=false;
                              PayLine.Modify;
                            until PayLine.Next=0;
                          end;
                    end;
                }
                separator(Action1102755033)
                {
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(39005979,true,true,Rec);
                        Reset;
                    end;
                }
                separator(Action1102755015)
                {
                }
                action("Re Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re Open';

                    trigger OnAction()
                    begin
                          if Confirm('Do you really want to re-open the document?') then begin
                           Status:=Status::Pending;
                           Modify;
                           end;
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
        DateEditable := true;
        ShortcutDimension4CodeEditable := true;
        ShortcutDimension3CodeEditable := true;
        PayeeEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
        "Cheque No.Editable" := true;
        "Currency CodeEditable" := true;
        "Payment Release DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Payment Type":="payment type"::Normal;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
         "Responsibility Center" := UserMgt.GetPurchasesFilter();
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;

        UpdateControls;
    end;

    var
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
        CashierLinks: Record UnknownRecord61055;
        LineNo: Integer;
        Temp: Record UnknownRecord61712;
        JTemplate: Code[10];
        JBatch: Code[10];
        PCheck: Codeunit "Post Custom Cust Ledger";
        Post: Boolean;
        strText: Text[100];
        PVHead: Record UnknownRecord61688;
        BankAcc: Record "Bank Account";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";
        Commitments: Record UnknownRecord61722;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        JournlPosted: Codeunit PostCaferiaBatches;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        PayeeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;


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

        Post:=false;
        Post:=JournlPosted.PostedSuccessfully();
        if Post then  begin
            Posted:=true;
            Status:=Payments.Status::Posted;
            "Posted By":=UserId;
            "Date Posted":=Today;
            "Time Posted":=Time;
            Modify;

          //Post Reversal Entries for Commitments
          Doc_Type:=Doc_type::"Payment Voucher";
          CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
          end;
        end;
    end;


    procedure PostHeader(var Payment: Record UnknownRecord61688)
    begin

        if Payments."Pay Mode"=Payments."pay mode"::Cheque then
          begin
            if Payments."Cheque No."='' then
              begin
                Error('Please ensure that the cheque number is inserted');
              end;
          end;

        if Payments."Pay Mode"=Payments."pay mode"::EFT then
          begin
            if Payments."Cheque No."='' then
              begin
                Error ('Please ensure that the EFT number is inserted');
              end;
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
        GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
        GenJnlLine."Document No.":=Payments."No.";
        GenJnlLine."External Document No.":=Payments."Cheque No.";

        GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
        GenJnlLine."Account No.":=Payments."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");

        GenJnlLine."Currency Code":=Payments."Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        Payments.CalcFields(Payments."Total Net Amount",Payments."Total VAT Amount");
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
        GenJnlLine."Bank Payment Type":=GenJnlLine."bank payment type"::" ";

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
    begin
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
        if Posted then  begin
            Error('The Document has already been posted');
        end;
        
        TestField(Status,Status::Approved);
        TestField("Paying Bank Account");
        TestField("Pay Mode");
        TestField("Payment Release Date");
        //Confirm whether Bank Has the Cash
        if "Pay Mode"="pay mode"::Cash then
         CheckBudgetAvail.CheckFundsAvailability(Rec);
        
        /*Check if the user has selected all the relevant fields*/
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
              CashierLinks.SetRange(CashierLinks.UserID,UserId);
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
            GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine.Description:=CopyStr(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
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
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
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


        until PayLine.Next=0;

        //Post the Journal Lines
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

        end;
    end;


    procedure UpdateControls()
    begin
             if Status<>Status::Approved then begin
             "Payment Release DateEditable" :=false;
             //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
             //CurrForm."Pay Mode".EDITABLE:=FALSE;
             "Currency CodeEditable" :=true;
             "Cheque No.Editable" :=false;
            // CurrPage.UpdateControls();
             end else begin
             "Payment Release DateEditable" :=true;
             //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
             //CurrForm."Pay Mode".EDITABLE:=TRUE;
             "Currency CodeEditable" :=false;
             "Cheque No.Editable" :=true;
            // CurrPage.UpdateControls();
             end;

             if Status=Status::Pending then begin
             GlobalDimension1CodeEditable :=true;
             ShortcutDimension2CodeEditable :=true;
             PayeeEditable :=true;
             ShortcutDimension3CodeEditable :=true;
             ShortcutDimension4CodeEditable :=true;
             DateEditable :=true;
             //CurrPage.UpdateControls();
             end else begin
             GlobalDimension1CodeEditable :=false;
             ShortcutDimension2CodeEditable :=false;
             PayeeEditable :=false;
             ShortcutDimension3CodeEditable :=false;
             ShortcutDimension4CodeEditable :=false;
             DateEditable :=false;
            // CurrPage.UpdateControls();
             end
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}


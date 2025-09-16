#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68212 "FIN-Cash Payment Header UP"
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

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61688;
    SourceTableView = where(Posted=const(No),
                            "Payment Type"=const("Petty Cash"),
                            Status=filter(<>Cancelled));

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
                }
                field("PF No";"PF No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        HREmployee.Reset;
                        HREmployee.SetRange(HREmployee."No.","PF No");
                        if HREmployee.Find('-') then begin
                        LecturerName:=HREmployee."First Name"+' '+HREmployee."Middle Name"+' '+HREmployee."Last Name";
                        end;
                    end;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(LecturerName;LecturerName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
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
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Narration";"Payment Narration")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Cheque Type";"Cheque Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No.";"Cheque No.")
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
                field("Total Retention Amount";"Total Retention Amount")
                {
                    ApplicationArea = Basic;
                }
                field("""Total Payment Amount"" - (""Total Witholding Tax Amount""+""Total VAT Amount""+""Total Retention Amount"")";"Total Payment Amount" - ("Total Witholding Tax Amount"+"Total VAT Amount"+"Total Retention Amount"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount';
                }
                field("Total Payment Amount LCY";"Total Payment Amount LCY")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount LCY';
                    Editable = false;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(PVLines;"FIN-Cash Payment Lines UP")
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
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51054,true,true,Rec);
                        Reset;
                    end;
                }
                action("Post Payment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        CheckPVRequiredItems;
                        PostPaymentVoucher;
                    end;
                }
                separator(Action1000000002)
                {
                }
                action("<Action1102755031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        BCSetup: Record UnknownRecord61721;
                    begin
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                           exit;

                            if not AllFieldsEntered then
                             Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');
                          //First Check whether other lines are already committed.
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::PettyCash);
                          Commitments.SetRange(Commitments."Document No.","No.");
                          if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?',false)=false then begin exit end;
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::PettyCash);
                          Commitments.SetRange(Commitments."Document No.","No.");
                          Commitments.DeleteAll;
                         end;

                            CheckBudgetAvail.CheckPayments(Rec);
                    end;
                }
                action("<Action1102755032>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitment';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          if Confirm('Do you Wish to Cancel the Commitment entries for this document',false)=false then begin exit end;

                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::PettyCash);
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Payment Type":="payment type"::"Petty Cash";
         "Pay Mode":="pay mode"::Cash;
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
        ApprovalEntries: Page "Approval Entries";
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
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        LecturerName: Text[80];
        HREmployee: Record UnknownRecord61188;


    procedure UpdateControls()
    var
        PvUser: Record UnknownRecord61711;
    begin
            /* IF Status<>Status::Approved THEN BEGIN
             CurrForm."Payment Release Date".EDITABLE:=FALSE;
             //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
             CurrForm."Currency Code".EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             CurrForm."Payment Release Date".EDITABLE:=TRUE;
             //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
             CurrForm."Currency Code".EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
             END;
        
             IF Status=Status::Pending THEN BEGIN
             CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
             CurrForm.Payee.EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
             CurrForm.Date.EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
             CurrForm.Payee.EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
             CurrForm.Date.EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
             END
        */

    end;


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
        //IF Post THEN  BEGIN
            Posted:=true;
            Status:=Payments.Status::Posted;
            "Posted By":=UserId;
            "Date Posted":=Today;
            "Time Posted":=Time;
            Modify;

          //Post Reversal Entries for Commitments
          Doc_Type:=Doc_type::PettyCash;
          CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
         // END;
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
    var
        BCsetup: Record UnknownRecord61721;
    begin
         if BCsetup.Get() then  begin
            if not BCsetup.Mandatory then  begin
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
        if Posted then  begin
            Error('The Document has already been posted');
        end;
        
        //TESTFIELD(Status,Status::Approved);
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

        //Adjust Gen Jnl Exchange Rate Rounding Balances
           AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances

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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68199 "FIN-Travel Advance Acc. UP"
{
    Caption = 'Imprest Accounting';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61504;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No;No)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Surrender DateEditable";
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Account No.Editable";

                    trigger OnValidate()
                    begin
                        if cust.Get("Account No.") then AccountName:=cust.Name;
                        "Imprest Issue Doc. No":='';

                        if "Account No."='' then AccountName:='';
                    end;
                }
                field(AccountName;AccountName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
                    Editable = "Imprest Issue Doc. NoEditable";
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Imprest Issue Date";"Imprest Issue Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        DimName1:=GetDimensionName("Global Dimension 1 Code",1);
                    end;
                }
                field(DimName1;DimName1)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        DimName2:=GetDimensionName("Shortcut Dimension 2 Code",2);
                    end;
                }
                field(DimName2;DimName2)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = "Responsibility CenterEditable";
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("PV No";"PV No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Financial Period";"Financial Period")
                {
                    ApplicationArea = Basic;
                }
            }
            part(ImprestLines;"FIN-Imprest Surr. Details UP")
            {
                Editable = ImprestLinesEditable;
                SubPageLink = "Surrender Doc No."=field(No);
            }
            label(Control1102758005)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19053222;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    if Status<>Status::Pending then
                    Error('The document has already been processed.');

                    if Amount<0 then
                    Error('Amount cannot be less than zero.');

                    if Amount=0 then
                    Error('Please enter amount.');

                    if Confirm('Are you sure you would like to approve the payment?',false)=true then begin
                    Status:=Status::"2nd Approval";
                    Modify;
                    Message('Document approved successfully.');
                    end;
                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::ImprestSurrender;
                        ApprovalEntries.Setfilters(Database::"FIN-Imprest Surr. Header",DocumentType,No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102756006)
                {
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        Txt0001: label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                    begin

                        //First Check whether all amount entered tally
                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.",No);
                        if ImprestDetails.Find('-') then begin
                        repeat
                          if (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount then
                              Error(Txt0001);

                        until ImprestDetails.Next = 0;
                        end;

                        //Release the ImprestSurrender for Approval
                        // IF ApprovalMgt.SendImprestSURRApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        // IF ApprovalMgt.CancelImprestSUApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    Txt0001: label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                begin
                    
                    
                    
                    TestField(Status,Status::Approved);
                    
                    if Posted then
                    Error('The transaction has already been posted.');
                    
                    //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                    //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                    /*CALCFIELDS("Actual Spent");
                    IF "Actual Spent"=0 THEN
                        IF CONFIRM(Text000,TRUE) THEN
                          UpdateforNoActualSpent
                        ELSE
                           ERROR(Text001);
                     */
                      // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    if GenledSetup.Get then begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",GenledSetup."Surrender Template");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",GenledSetup."Surrender  Batch");
                        GenJnlLine.DeleteAll;
                    end;
                    
                    if DefaultBatch.Get(GenledSetup."Surrender Template",GenledSetup."Surrender  Batch") then begin
                         DefaultBatch.Delete;
                    end;
                    
                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name":=GenledSetup."Surrender Template";
                    DefaultBatch.Name:=GenledSetup."Surrender  Batch";
                    DefaultBatch.Insert;
                    LineNo:=0;
                    
                    ImprestDetails.Reset;
                    ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.",No);
                    if ImprestDetails.Find('-') then begin
                    repeat
                    //Post Surrender Journal
                    //Compare the amount issued =amount on cash reciecied.
                    //Created new field for zero spent
                    //
                    
                    //ImprestDetails.TESTFIELD("Actual Spent");
                    //ImprestDetails.TESTFIELD("Actual Spent");
                    if (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount then
                       Error(Txt0001);
                    
                    TestField("Global Dimension 1 Code");
                    
                    LineNo:=LineNo+1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Source Code":='PAYMENTJNL';
                    GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Account No.":=ImprestDetails."Account No:";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    //Set these fields to blanks
                    GenJnlLine."Posting Date":="Surrender Date";
                    GenJnlLine."Gen. Posting Type":=GenJnlLine."gen. posting type"::" ";
                    GenJnlLine.Validate("Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group":='';
                    GenJnlLine.Validate("Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group":='';
                    GenJnlLine.Validate("Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group":='';
                    GenJnlLine.Validate("VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group":='';
                    GenJnlLine.Validate("VAT Prod. Posting Group");
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=ImprestDetails."Actual Spent";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::Customer;
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.Description:='Imprest Surrendered by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Currency Code":="Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    //Take care of Currency Factor
                      GenJnlLine."Currency Factor":="Currency Factor";
                      GenJnlLine.Validate("Currency Factor");
                    
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                    
                    //Application of Surrender entries
                    if GenJnlLine."Bal. Account Type"=GenJnlLine."bal. account type"::Customer then begin
                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="PV No";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                    GenJnlLine."Applies-to ID":="Apply to ID";
                    
                    end;
                    
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;
                    /*
                    //Post Cash Surrender
                    IF ImprestDetails."Cash Receipt Amount">0 THEN BEGIN
                     IF ImprestDetails."Bank/Petty Cash"='' THEN
                       ERROR('Select a Bank Code where the Cash Surrender will be posted');
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //Set these fields to blanks
                    GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
                    GenJnlLine.VALIDATE("Gen. Posting Type");
                    GenJnlLine."Gen. Bus. Posting Group":='';
                    GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                    GenJnlLine."Gen. Prod. Posting Group":='';
                    GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                    GenJnlLine."VAT Bus. Posting Group":='';
                    GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                    GenJnlLine."VAT Prod. Posting Group":='';
                    GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                    GenJnlLine."Posting Date":="Surrender Date";
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=-ImprestDetails."Cash Receipt Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Currency Code":="Currency Code";
                    GenJnlLine.VALIDATE("Currency Code");
                    //Take care of Currency Factor
                      GenJnlLine."Currency Factor":="Currency Factor";
                      GenJnlLine.VALIDATE("Currency Factor");
                    
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"Bank Account";
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Bank/Petty Cash";
                    GenJnlLine.Description:='Imprest Surrender by staff';
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                    GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                    
                    //Application of Surrender entries
                    IF GenJnlLine."Account Type"=GenJnlLine."Account Type"::Customer THEN BEGIN
                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="PV No";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    GenJnlLine."Applies-to ID":="Apply to ID";
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                    
                    END;
                    END;
                    //End Post Surrender Journal
                     */
                    until ImprestDetails.Next=0;
                    //Post Entries
                      GenJnlLine.Reset;
                      GenJnlLine.SetRange(GenJnlLine."Journal Template Name",GenledSetup."Surrender Template");
                      GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",GenledSetup."Surrender  Batch");
                    //Adjust Gen Jnl Exchange Rate Rounding Balances
                       AdjustGenJnl.Run(GenJnlLine);
                    //End Adjust Gen Jnl Exchange Rate Rounding Balances
                    
                    //GenerateReceipt();
                    
                      Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                    end;
                    
                    //IF JournalPostSuccessful.PostedSuccessfully THEN BEGIN
                        Posted:=true;
                        Status:=Status::Posted;
                        "Date Posted":=Today;
                        "Time Posted":=Time;
                        "Posted By":=UserId;
                        Modify;
                    //Tag the Source Imprest Requisition as Surrendered
                       ImprestReq.Reset;
                       ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
                       if ImprestReq.Find('-') then begin
                         ImprestReq."Surrender Status":=ImprestReq."surrender status"::Full;
                         ImprestReq.Modify;
                       end;
                    
                    //End Tag
                     //Post Committment Reversals
                    Doc_Type:=Doc_type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                    //END;

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Reset;
                    SetFilter(No,No);
                    Report.Run(51078,true,true,Rec);
                    Reset;
                end;
            }
            action("Print Accounting")
            {
                ApplicationArea = Basic;
                Caption = 'Print Accounting';
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if cust.Get("Account No.") then AccountName:=cust.Name;
    end;

    trigger OnInit()
    begin
        ImprestLinesEditable := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Account No.Editable" := true;
        "Surrender DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
           "User ID":=UserId;
          Rcpt.Reset;
          Rcpt.SetRange(Rcpt.Posted,false);
          Rcpt.SetRange(Rcpt.Cashier,UserId);
          if Rcpt.Count >0 then
            begin
              if Confirm('There are still some unposted imprest Surrenders. Continue?',false)=false then
                begin
                  Error('There are still some unposted imprest Surrenders. Please utilise them first');
                end;
            end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
         "Responsibility Center" := UserMgt.GetPurchasesFilter();
    end;

    trigger OnOpenPage()
    begin
        /*IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        AccountName:=GetCustName("Account No.");
        */

    end;

    var
        cust: Record Customer;
        Rcpt: Record UnknownRecord61504;
        ApprovalEntries: Page "Approval Entries";
        RecPayTypes: Record UnknownRecord61129;
        TarriffCodes: Record UnknownRecord61716;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord61712;
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record UnknownRecord61733;
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        ImprestRequestDet: Record UnknownRecord61719;
        GenledSetup: Record UnknownRecord61713;
        ImprestAmt: Decimal;
        DimName1: Text[80];
        DimName2: Text[80];
        CashPaymentLine: Record UnknownRecord61718;
        PaymentLine: Record UnknownRecord61705;
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit PostCaferiaBatches;
        Commitments: Record UnknownRecord61722;
        BCSetup: Record UnknownRecord61721;
        BudgetControl: Codeunit "Procurement Controls Handler";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        ImprestReq: Record UnknownRecord61704;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        Text000: label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: label 'Document Not Posted';
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        ReceiptHeader: Record UnknownRecord61723;
        ImprestSurrHeader: Record UnknownRecord61504;
        RecLine: Record UnknownRecord61717;
        LastNo: Code[20];
        GenSetUp: Record UnknownRecord61713;
        "No. Series Line": Record "No. Series Line";
        BankRec: Record "Bank Account";
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;
        Text19053222: label 'Enter Advance Accounting Details below';


    procedure GetDimensionName(var "Code": Code[20];DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name:='';
        
        GLSetup.Reset;
        GLSetup.Get();
        
        DimVal.Reset;
        DimVal.SetRange(DimVal.Code,Code);
        
        if DimNo=1 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 1 Code"  );
          end
        else if DimNo=2 then
          begin
            DimVal.SetRange(DimVal."Dimension Code",GLSetup."Global Dimension 2 Code");
          end;
        if DimVal.Find('-') then
          begin
            Name:=DimVal.Name;
          end;

    end;


    procedure UpdateControl()
    begin
          if Status<>Status::Pending then begin
           "Surrender DateEditable" :=false;
           "Account No.Editable" :=false;
           "Imprest Issue Doc. NoEditable" :=false;
           "Responsibility CenterEditable" :=false;
           ImprestLinesEditable :=false;
          end else begin
           "Surrender DateEditable" :=true;
           "Account No.Editable" :=true;
           "Imprest Issue Doc. NoEditable" :=true;
           "Responsibility CenterEditable" :=true;
           ImprestLinesEditable :=true;

          end;
    end;


    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Customer;
    begin
        Name:='';
        if Cust.Get(No) then
           Name:=Cust.Name;
           exit(Name);
    end;


    procedure UpdateforNoActualSpent()
    begin
          Posted:=true;
          Status:=Status::Posted;
          "Date Posted":=Today;
          "Time Posted":=Time;
          "Posted By":=UserId;
          Modify;
        //Tag the Source Imprest Requisition as Surrendered
           ImprestReq.Reset;
           ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
           if ImprestReq.Find('-') then begin
             ImprestReq."Surrender Status":=ImprestReq."surrender status"::Full;
             ImprestReq.Modify;
           end;
        //End Tag
        //Post Committment Reversals
        Doc_Type:=Doc_type::Imprest;
        BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
    end;


    procedure CompareAllAmounts()
    begin
    end;


    procedure GenerateReceipt()
    begin
        if ImprestDetails."Cash Receipt Amount"<>0 then
        TestField("Received From");

         if BankRec.Get(ImprestDetails."Bank/Petty Cash") then
         BankRec.TestField(BankRec."Receipt No. Series");

         LastNo:='';
         GenSetUp.Get;
         "No. Series Line".SetRange("No. Series Line"."Series Code",GenSetUp."Receipts No");
         if "No. Series Line".Find('-')  then
           begin
              LastNo:=BankRec."Receipt No. Series"+'-'+IncStr("No. Series Line"."Last No. Used");
             "No. Series Line"."Last No. Used":=IncStr("No. Series Line"."Last No. Used");
             "No. Series Line".Modify;
            end;


             if ImprestDetails."Cash Surrender Amt"<>0 then begin

        ReceiptHeader.Init;
        ReceiptHeader."No.":=LastNo;
        ReceiptHeader.Date:="Surrender Date";
        ReceiptHeader."Global Dimension 1 Code":="Global Dimension 1 Code";
        ReceiptHeader."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        ReceiptHeader.Validate("Global Dimension 1 Code");
        ReceiptHeader.Validate("Shortcut Dimension 2 Code");
        ReceiptHeader.Cashier:=UserId;
        ReceiptHeader."Date Posted":=Today;
        ReceiptHeader."Time Posted":=Time;
        ReceiptHeader.Posted:=true;
        ReceiptHeader."Received From":="Received From";
        ReceiptHeader."Amount Recieved":=ImprestDetails."Cash Receipt Amount";
        ReceiptHeader."Responsibility Center":='CUC';
        ReceiptHeader."Bank Code":=ImprestDetails."Bank/Petty Cash";
        ReceiptHeader."Surrender No":=No;

        if ImprestDetails."Cash Surrender Amt"<>0 then
        ReceiptHeader.Insert;

        RecLine.Init;
        RecLine.No:=LastNo;
        RecLine.Type:='SURRENDER';
        RecLine."Account No.":="Account No.";
        RecLine."Account Name":='Imprest Cash Surrender';
        RecLine.Amount:=ImprestDetails."Cash Receipt Amount";
        RecLine.Validate(RecLine.Amount);
        RecLine."Cheque/Deposit Slip No":=ImprestDetails."Cheque/Deposit Slip No";
        RecLine."Cheque/Deposit Slip Date":=ImprestDetails."Cheque/Deposit Slip Date";
        RecLine."Cheque/Deposit Slip Type":=ImprestDetails."Cheque/Deposit Slip Type";
        RecLine."Cheque/Deposit Slip Bank":=ImprestDetails."Bank/Petty Cash";
        RecLine."Pay Mode":=ImprestDetails."Cash Pay Mode";

        if ImprestDetails."Cash Surrender Amt"<>0 then
        RecLine.Insert;
        end;
    end;
}


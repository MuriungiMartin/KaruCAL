#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68208 "FIN-Imprest Accounting"
{
    ApplicationArea = Basic;
    CardPageID = "FIN-Travel Advance Acc. UP";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61504;
    SourceTableView = where(Status=filter(<>Posted));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Net Amount";"Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No";"Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Date";"Cheque Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Type";"Cheque Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Bank Account";"Paying Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account No";"Bank Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Cashier Bank Account";"Cashier Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Grouping;Grouping)
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Type";"Bank Type")
                {
                    ApplicationArea = Basic;
                }
                field("PV Type";"PV Type")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to ID";"Apply to ID")
                {
                    ApplicationArea = Basic;
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Date";"Imprest Issue Date")
                {
                    ApplicationArea = Basic;
                }
                field(Surrendered;Surrendered)
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
                }
                field("Vote Book";"Vote Book")
                {
                    ApplicationArea = Basic;
                }
                field("Total Allocation";"Total Allocation")
                {
                    ApplicationArea = Basic;
                }
                field("Total Expenditure";"Total Expenditure")
                {
                    ApplicationArea = Basic;
                }
                field("Total Commitments";"Total Commitments")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Balance Less this Entry";"Balance Less this Entry")
                {
                    ApplicationArea = Basic;
                }
                field("Petty Cash";"Petty Cash")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Issue Voucher Type";"Issue Voucher Type")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Surrendered LCY";"Amount Surrendered LCY")
                {
                    ApplicationArea = Basic;
                }
                field("PV No";"PV No")
                {
                    ApplicationArea = Basic;
                }
                field("Print No.";"Print No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Surrender Amt";"Cash Surrender Amt")
                {
                    ApplicationArea = Basic;
                }
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
                separator(Action5)
                {
                }
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        //First Check whether all amount entered tally
                        ImprestDetails.Reset;
                        ImprestDetails.SetRange(ImprestDetails."Surrender Doc No.",No);
                        if ImprestDetails.Find('-') then begin
                        repeat
                          if (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount then
                              Error('Receipt Amount and Imprest Should be equal to Imprest Amount..');

                        until ImprestDetails.Next = 0;
                        end;

                        //Release the Imprest for Approval

                          State:=State::Open;
                         if Status<>Status::Pending then State:=State::"Pending Approval";
                         DocType:=Doctype::ImprestSurrender;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Imprest Surr. Header";
                         if ApprovalMgt.SendApproval(tableNo,Rec.No,DocType,State,Rec."Responsibility Center",0) then;
                         //  IF ApprovalMgt.SendLeaveApprovalRequest(Rec) THEN;
                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                         DocType:=Doctype::ImprestSurrender;
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Imprest Surr. Header";
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec.No,showmessage,ManualCancel) then;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
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
                    
                    //Post Cash Surrender
                    if ImprestDetails."Cash Receipt Amount">0 then begin
                     if ImprestDetails."Bank/Petty Cash"='' then
                       Error('Select a Bank Code where the Cash Surrender will be posted');
                    LineNo:=LineNo+1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."account type"::Customer;
                    GenJnlLine."Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    //Set these fields to blanks
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
                    GenJnlLine."Posting Date":="Surrender Date";
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=-ImprestDetails."Cash Receipt Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Currency Code":="Currency Code";
                    GenJnlLine.Validate("Currency Code");
                    //Take care of Currency Factor
                      GenJnlLine."Currency Factor":="Currency Factor";
                      GenJnlLine.Validate("Currency Factor");
                    
                    GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"Bank Account";
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Bank/Petty Cash";
                    GenJnlLine.Description:='Imprest Surrender by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    //GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    //GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                    GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                    
                    //Application of Surrender entries
                    if GenJnlLine."Account Type"=GenJnlLine."account type"::Customer then begin
                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="PV No";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                    GenJnlLine."Applies-to ID":="Apply to ID";
                    
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;
                    
                    end;
                    end;
                    //End Post Surrender Journal
                    
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
        }
    }

    var
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
}


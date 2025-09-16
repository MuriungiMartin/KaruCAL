#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68214 "FIN-Posted Imprest Surr. UP"
{
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61504;
    SourceTableView = where(Posted=const(Yes));

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
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
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
                    Editable = false;

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
                    Editable = false;

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
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
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
            }
            part(Control1102758004;"FIN-Imprest Surr. Details UP")
            {
                Editable = false;
                SubPageLink = "Surrender Doc No."=field(No);
            }
            label(Control1102758005)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19044471;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin


                    if Posted then
                    Error('The transaction has already been posted.');

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

                    ImprestDetails.TestField("Actual Spent");
                    ImprestDetails.TestField("Actual Spent");
                    TestField("Global Dimension 1 Code");

                    LineNo:=LineNo+1000;
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":=GenledSetup."Surrender Template";
                    GenJnlLine."Journal Batch Name":=GenledSetup."Surrender  Batch";
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
                    GenJnlLine."Account No.":=ImprestDetails."Account No:";
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
                    GenJnlLine.Amount:=ImprestDetails."Actual Spent";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::Customer;
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Imprest Holder";
                    GenJnlLine.Description:='Imprest Surrendered by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

                    //Application of Surrender entries
                    if GenJnlLine."Bal. Account Type"=GenJnlLine."bal. account type"::Customer then begin
                    GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
                    GenJnlLine."Applies-to ID":="Apply to ID";
                    end;

                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;

                    //Post Cash Surrender
                    if ImprestDetails."Cash Surrender Amt">0 then begin
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
                    GenJnlLine.Amount:=-ImprestDetails."Cash Surrender Amt";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"Bank Account";
                    GenJnlLine."Bal. Account No.":=ImprestDetails."Bank/Petty Cash";
                    GenJnlLine.Description:='Imprest Surrender by staff';
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                    GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;

                    end;

                    //End Post Surrender Journal

                    until ImprestDetails.Next=0;
                    //Post Entries
                      GenJnlLine.Reset;
                      GenJnlLine.SetRange(GenJnlLine."Journal Template Name",GenledSetup."Surrender Template");
                      GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",GenledSetup."Surrender  Batch");
                      Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                    end;

                    if JournalPostSuccessful.PostedSuccessfully then begin
                        Posted:=true;
                        Status:=Status::Posted;
                        "Date Posted":=Today;
                        "Time Posted":=Time;
                        "Posted By":=UserId;
                        Modify;

                     //Post Committment Reversals
                    Doc_Type:=Doc_type::Imprest;
                    BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                    end;
                end;
            }
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
            action("...")
            {
                ApplicationArea = Basic;
                Caption = '...';
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if "Imprest Issue Doc. No"='' then
                       Error('Please Select the Imprest Issue Document Number');

                    PaymentLine.Reset;
                    PaymentLine.SetRange(PaymentLine.No,"Imprest Issue Doc. No");
                    Page.RunModal(39006085,PaymentLine);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
           "User ID":=UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
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
        DimName1: Text[60];
        DimName2: Text[60];
        CashPaymentLine: Record UnknownRecord61718;
        PaymentLine: Record UnknownRecord61705;
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit PostCaferiaBatches;
        Commitments: Record UnknownRecord61722;
        BCSetup: Record UnknownRecord61721;
        BudgetControl: Codeunit "Procurement Controls Handler";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        Text19044471: label 'Enter Imprest Surrendered Details below';


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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        DimName1:=GetDimensionName("Global Dimension 1 Code",1);
        DimName2:=GetDimensionName("Shortcut Dimension 2 Code",2);
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68104 "FIN-Posted Staff Claims"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61602;
    SourceTableView = where(Posted=const(Yes),
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
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff No/Name';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                              Validate(Payee);
                    end;
                }
                field(Payee;Payee)
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

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                            Validate("Bank Name");
                    end;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                    Caption = 'Claim Description';
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requestor ID';
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount LCY";"Total Net Amount LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                    Editable = "Payment Release DateEditable";
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                    Editable = "Pay ModeEditable";
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/EFT No.';
                    Editable = "Cheque No.Editable";
                }
            }
            part(PVLines;"FIN-Staff Claim Lines")
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
                action("Post Payment and Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment and Print';
                    Visible = false;

                    trigger OnAction()
                    begin
                             CheckImprestRequiredItems;
                             PostImprest;

                              Reset;
                              SetFilter("No.","No.");
                              Report.Run(39006261,true,true,Rec);
                              Reset;
                    end;
                }
                separator(Action1102755021)
                {
                }
                action("Post Payment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Visible = false;

                    trigger OnAction()
                    begin
                             CheckImprestRequiredItems;
                             PostImprest;
                    end;
                }
                separator(Action1102755026)
                {
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::"Staff Claim";
                        ApprovalEntries.Setfilters(Database::"FIN-Staff Claims Header",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102755009)
                {
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(69272,true,true,Rec);
                        Reset;
                    end;
                }
                separator(Action1102756006)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        
        //check if the documenent has been added while another one is still pending
          /*  TravReqHeader.RESET;
            //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
            TravReqHeader.SETRANGE(TravReqHeader.Cashier,USERID);
            TravReqHeader.SETRANGE(TravReqHeader.Status,Status::Pending);
        
            IF TravReqHeader.COUNT>0 THEN
              BEGIN
                ERROR('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
              END;
        //*********************************END ****************************************//
        
        
        "Payment Type":="payment type"::Imprest;
        "Account Type":="account type"::Customer;*/

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
         /*"Responsibility Center" := UserMgt.GetPurchasesFilter();
         //Add dimensions if set by default here
         "Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
         VALIDATE("Global Dimension 1 Code");
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
         VALIDATE("Shortcut Dimension 2 Code");
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
         VALIDATE("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
         VALIDATE("Shortcut Dimension 4 Code");
        OnAfterGetCurrRecord;
        */

    end;

    trigger OnOpenPage()
    begin
        /*"Currency CodeEditable" := TRUE;
        DateEditable := TRUE;
        ShortcutDimension2CodeEditable := TRUE;
        GlobalDimension1CodeEditable := TRUE;
        "Cheque No.Editable" := TRUE;
        "Pay ModeEditable" := TRUE;
        "Paying Bank AccountEditable" := TRUE;
        "Payment Release DateEditable" := TRUE;
        
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        UpdateControls;*/

    end;

    var
        PayLine: Record UnknownRecord61714;
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
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender;
        HasLines: Boolean;
        ApprovalEntries: Page "Approval Entries";
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Procurement Controls Handler";
        TravReqHeader: Record UnknownRecord61704;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        [InDataSet]
        "Pay ModeEditable": Boolean;
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;


    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record UnknownRecord61721;
    begin
         if BCsetup.Get() then  begin
            if not BCsetup.Mandatory then begin
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


    procedure PostImprest()
    begin

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
            GenJnlLine.DeleteAll;
        end;

        //CREDIT BANK
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Posting Date":="Payment Release Date";
            GenJnlLine."Document No.":="No.";
            GenJnlLine."External Document No.":="Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
            GenJnlLine."Account No.":="Paying Bank Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine.Description:=Purpose;
            CalcFields("Total Net Amount");
            GenJnlLine."Credit Amount":="Total Net Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            //Added for Currency Codes
            GenJnlLine."Currency Code":="Currency Code";
            GenJnlLine.Validate("Currency Code");
            GenJnlLine."Currency Factor":="Currency Factor";
            GenJnlLine.Validate("Currency Factor");
            GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

            if GenJnlLine.Amount<>0 then
              GenJnlLine.Insert;



        //DEBIT RESPECTIVE G/L ACCOUNT(S)
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        if PayLine.Find('-') then begin
        repeat
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Posting Date":="Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."document type"::Invoice;
            GenJnlLine."Document No.":="No.";
            GenJnlLine."External Document No.":="Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":="Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine.Description:=Purpose;
            GenJnlLine."Debit Amount":=PayLine.Amount;
            GenJnlLine.Validate( GenJnlLine."Debit Amount");
            //Added for Currency Codes
            GenJnlLine."Currency Code":="Currency Code";
            GenJnlLine.Validate("Currency Code");
            GenJnlLine."Currency Factor":="Currency Factor";
            GenJnlLine.Validate("Currency Factor");
            GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");

            if GenJnlLine.Amount<>0 then
              GenJnlLine.Insert;

        until PayLine.Next=0
        end;

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);

        Post:= false;
        Post:=JournlPosted.PostedSuccessfully();
        if Post then begin
          Posted:=true;
          "Date Posted":=Today;
          "Time Posted":=Time;
          "Posted By":=UserId;
          Status:=Status::Posted;
          Modify;
        end;
    end;


    procedure CheckImprestRequiredItems()
    begin
        
        TestField("Payment Release Date");
        TestField("Paying Bank Account");
        TestField("Account No.");
        TestField("Account Type","account type"::Customer);
        
        if Posted then begin
            Error('The Document has already been posted');
        end;
        
        TestField(Status,Status::Approved);
        
        /*Check if the user has selected all the relevant fields*/
        
        Temp.Get(UserId);
        JTemplate:=Temp."Claim Template";JBatch:=Temp."Claim  Batch";
        
        if JTemplate='' then  begin
            Error('Ensure the Imprest Template is set up in Cash Office Setup');
        end;
        
        if JBatch='' then begin
            Error('Ensure the Imprest Batch is set up in the Cash Office Setup')
        end;
        
        if not LinesExists then
           Error('There are no Lines created for this Document');

    end;


    procedure UpdateControls()
    begin
             if Status<>Status::Approved then begin
             "Payment Release DateEditable" :=false;
             "Paying Bank AccountEditable" :=false;
             "Pay ModeEditable" :=false;
             //CurrForm."Currency Code".EDITABLE:=FALSE;
             "Cheque No.Editable" :=false;
             CurrPage.UpdateControls();
             end else begin
             "Payment Release DateEditable" :=true;
             "Paying Bank AccountEditable" :=true;
             "Pay ModeEditable" :=true;
             "Cheque No.Editable" :=true;
             //CurrForm."Currency Code".EDITABLE:=TRUE;
             CurrPage.UpdateControls();
             end;

             if Status=Status::Pending then begin
             GlobalDimension1CodeEditable :=true;
             ShortcutDimension2CodeEditable :=true;
             //CurrForm.Payee.EDITABLE:=TRUE;
             ShortcutDimension3CodeEditable :=true;
             ShortcutDimension4CodeEditable :=true;
             DateEditable :=true;
             //CurrForm."Account No.".EDITABLE:=TRUE;
             "Currency CodeEditable" :=true;
             //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
             CurrPage.UpdateControls();
             end else begin
             GlobalDimension1CodeEditable :=false;
             ShortcutDimension2CodeEditable :=false;
             //CurrForm.Payee.EDITABLE:=FALSE;
             ShortcutDimension3CodeEditable :=false;
             ShortcutDimension4CodeEditable :=false;
             DateEditable :=false;
             //CurrForm."Account No.".EDITABLE:=FALSE;
             "Currency CodeEditable" :=false;
             //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
             CurrPage.UpdateControls();
             end
    end;


    procedure LinesExists(): Boolean
    var
        PayLines: Record UnknownRecord61714;
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
        PayLines: Record UnknownRecord61714;
    begin
        AllKeyFieldsEntered:=true;
         PayLines.Reset;
         PayLines.SetRange(PayLines.No,"No.");
          if PayLines.Find('-') then begin
          repeat
             if (PayLines."Account No:"='') or (PayLines.Amount<=0) then
             AllKeyFieldsEntered:=false;
          until PayLines.Next=0;
             exit(AllKeyFieldsEntered);
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}


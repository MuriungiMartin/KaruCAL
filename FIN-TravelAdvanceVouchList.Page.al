#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68266 "FIN-Travel Advance Vouch List"
{
    CardPageID = "FIN-Travel Advance Req. UP";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61704;
    SourceTableView = where(Posted=const(No),
                            Status=filter(<>Cancelled));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
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
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Exchange Rate";"Exchange Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount LCY";"Total Net Amount LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Current Status";"Current Status")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755015;Notes)
            {
            }
            systempart(Control1102755016;MyNotes)
            {
            }
            systempart(Control1102755017;Outlook)
            {
            }
            systempart(Control1102755018;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102755006>")
            {
                Caption = '&Functions';
                action("<Action1102755024>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                             CheckImprestRequiredItems;
                             PostImprest;
                    end;
                }
                separator(Action1102755029)
                {
                }
                action("<Action1102755008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::Imprest;
                        ApprovalEntries.Setfilters(Database::"FIN-Imprest Header",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
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
                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                          if not AllFieldsEntered then
                             Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                          Error('There are some lines that have not been committed');

                        //Release the Imprest for Approval

                          State:=State::Open;
                         if Status<>Status::Pending then State:=State::"Pending Approval";
                         DocType:=Doctype::"Staff Advance";
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Imprest Header";
                         if ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',0) then;
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
                         DocType:=Doctype::"Staff Advance";
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Imprest Header";
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) then;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1102755025)
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

                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                          if not AllFieldsEntered then
                             Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

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

                            CheckBudgetAvail.CheckImprest(Rec);
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
                separator(Action1102755022)
                {
                }
                action("<Action1102755010>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                         if Status<>Status::Approved then
                            Error('You can only print after the document is Approved');
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(39005984,true,true,Rec);
                        Reset;
                    end;
                }
                separator(Action1102755020)
                {
                }
                action("<Action1102756007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: label 'Are you sure you want to Cancel this Document?';
                        Text001: label 'You have selected not to Cancel this Document';
                    begin
                        TestField(Status,Status::Approved);
                        if Confirm(Text000,true) then  begin
                         //Post Committment Reversals
                        Doc_Type:=Doc_type::Imprest;
                        BudgetControl.ReverseEntries(Doc_Type,"No.");
                        Status:=Status::Cancelled;
                        Modify;
                        end else
                          Error(Text001);
                    end;
                }
            }
        }
    }

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
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        BudgetControl: Codeunit "Procurement Controls Handler";
        ImprestHdr: Record UnknownRecord61704;
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
        GenJnlLine."Account Type":=GenJnlLine."account type"::Customer;
        GenJnlLine."Account No.":="Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description:='Imprest: '+"Account No."+':'+Payee;
        CalcFields("Total Net Amount");
        GenJnlLine.Amount:="Total Net Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No.":="Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        GenJnlLine."Currency Code":="Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor":="Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        */
        GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
        if GenJnlLine.Amount<>0 then
        GenJnlLine.Insert;
        
        
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
        JTemplate:=Temp."Imprest Template";JBatch:=Temp."Imprest  Batch";
        
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
             CurrPage.Update;
             end else begin
             "Payment Release DateEditable" :=true;
             "Paying Bank AccountEditable" :=true;
             "Pay ModeEditable" :=true;
             "Cheque No.Editable" :=true;
             //CurrForm."Currency Code".EDITABLE:=TRUE;
             CurrPage.Update;
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
             CurrPage.Update;
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
             CurrPage.Update;
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


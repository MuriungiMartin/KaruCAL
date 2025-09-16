#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68225 "FIN-Payment Header"
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

    Caption = 'Payment Voucher';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = UnknownTable61688;
    SourceTableView = where(Posted=const(No),
                            "Payment Type"=const(Normal),
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
                    Importance = Promoted;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                    Importance = Promoted;
                }
                field("PV Category";"PV Category")
                {
                    ApplicationArea = Basic;
                }
                field("Direct Expense";"Direct Expense")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Printed";"Cheque Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDimension1CodeEditable;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
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
                    Caption = 'Description';
                    Editable = false;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                    Editable = PaymodeEditable;
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency CodeEditable";
                }
                field("Apply to Document Type";"Apply to Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to Document No";"Apply to Document No")
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
                    Editable = true;
                    Importance = Promoted;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Narration";"Payment Narration")
                {
                    ApplicationArea = Basic;
                    Editable = "Payment NarrationEditable";
                    Importance = Promoted;
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Name";"Vendor Name")
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
                    Visible = false;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepared By';
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Net Amount';
                    Editable = false;
                    Importance = Promoted;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Payment Release DateEditable";
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
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
                action(postPv)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Post PV Entries
                        Rec.TestField("PV Category");
                        CurrPage.SaveRecord;
                        CheckPVRequiredItems(Rec);
                        PostPaymentVoucher(Rec);
                    end;
                }
                separator(Action44)
                {
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Approvalentries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::"Payment Voucher";
                        Approvalentries.Setfilters(Database::"FIN-Payments Header",DocumentType,"No.");
                        Approvalentries.Run;
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
                              TestField(Status,Status::Pending);
                        //Ensure No Items That should be committed that are not
                        //IF LinesCommitmentStatus THEN
                         // ERROR('Please Check the Budget before you Proceed');
                        //VarVariant := Rec;
                        //IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                         // CustomApprovals.OnSendDocForApproval(VarVariant);
                        //Release the PV for Approval
                         State:=State::Open;
                         if Status<>Status::Pending then State:=State::"Pending Approval";
                         DocType:=Doctype::"Payment Voucher";
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Payments Header";
                         if ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,Rec."Responsibility Center",0) then;
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
                         DocType:=Doctype::"Payment Voucher";
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-Payments Header";
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) then;
                    end;
                }
                separator(Action40)
                {
                }
                action(CheckBudget)
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
                           //Ensure only Pending Documents are commited
                          TestField(Status,Status::"Pending Approval");

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

                            CheckBudgetAvail.CheckPayments(Rec);
                    end;
                }
                action(CancelBudget)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                           //Ensure only Pending Documents are commited
                          TestField(Status,Status::"Pending Approval");

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
                separator(Action37)
                {
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        /* IF Status<>Status::Approved THEN
                            ERROR('You can only print a Payment Voucher after it is fully Approved');
                        
                               */
                        
                        if Status=Status::Pending then
                           Error('You cannot Print until the document is sent for approval');
                        Reset;
                        SetFilter("No.","No.");
                        if Rec."Direct Expense"=true then begin
                        Report.Run(51055,true,true,Rec);
                        end else
                        if Rec."PV Category"=Rec."pv category"::"Part-time Pay" then begin
                        Report.Run(51054,true,true,Rec);
                        end   else if "PV Category"=Rec."pv category"::"Normal PV" then begin
                        Report.Run(50892,true,true,Rec);
                        end   else if "PV Category"=Rec."pv category"::"Medical Claims" then begin
                        Report.Run(50892,true,true,Rec);
                        end;
                        
                        
                        CurrPage.Update;
                        CurrPage.SaveRecord;

                    end;
                }
                action(Print2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Noraml Pv';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /* IF Status<>Status::Approved THEN
                            ERROR('You can only print a Payment Voucher after it is fully Approved');
                        
                               */
                        
                        if Status=Status::Pending then
                           Error('You cannot Print until the document is sent for approval');
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51055,true,true,Rec);
                        Reset;
                        
                        CurrPage.Update;
                        CurrPage.SaveRecord;

                    end;
                }
                action(Bank_Letter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Letter';

                    trigger OnAction()
                    var
                        FilterbyPayline: Record UnknownRecord61497;
                    begin
                        /*IF Status=Status::Pending THEN
                           ERROR('You cannot Print until the document is released for approval');
                        FilterbyPayline.RESET;
                        FilterbyPayline.SETFILTER(FilterbyPayline.No,"No.");
                        //REPORT.RUN(39006007,TRUE,TRUE,FilterbyPayline);
                        RESET;*/

                    end;
                }
                separator(Action34)
                {
                }
                action(CanelDoc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: label 'Are you sure you want to cancel this Document?';
                        Text001: label 'You have selected not to Cancel the Document';
                    begin
                        TestField(Status,Status::Approved);
                        if Confirm(Text000,true) then  begin
                        //Post Reversal Entries for Commitments
                        Doc_Type:=Doc_type::"Payment Voucher";
                        CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
                        Status:=Status::Cancelled;
                        Modify;
                        end else
                          Error(Text001);
                    end;
                }
                action(ShowInvDet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Invoice Details';
                    Enabled = false;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        if PurchInvHeader.Get(CurrPage.PVLines.Page.GetDocNo) then begin
                         Page.RunModal(138,PurchInvHeader)
                        end else
                        begin
                          Message('not found')
                        end;
                    end;
                }
            }
            group("Cheque Printing")
            {
                Caption = 'Cheque Printing';
                action("P&review Check")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&review Check';
                    RunObject = Page "Check Preview";
                    Visible = true;

                    trigger OnAction()
                    begin

                        ImprestHeader.Reset;
                        ImprestHeader.SetFilter("No.","Apply to Document No");
                        Report.Run(39005666,true,true,ImprestHeader);
                        //RESET;
                    end;
                }
                action(GenerateCheck)
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate Check';
                    Image = PrintCheck;

                    trigger OnAction()
                    begin
                        CheckPVRequiredItems(Rec);
                         // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                         GenJnlLine.Reset;
                         GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
                         GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
                         if GenJnlLine.Find('+') then
                         GenJnlLine.DeleteAll;
                         GenJnlLine.Reset;

                        PopulateCheckJournal(Payments);
                        GenSetup.Get;
                        GenSetup."Cheque Bank":="Paying Bank Account";
                        GenSetup.Modify;


                        // UPDATE CHEQUE NO
                        if BankAcc.Get("Paying Bank Account") then begin
                        "Cheque No.":=IncStr(BankAcc."Last Check No.");
                        "Cheque Printed":=true;
                        "Payment Release Date":=Today;
                        //MODIFY;
                        end;
                        //REPORT.RUN(1401,TRUE,TRUE);
                    end;
                }
                action(PrintCheck)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Cheque';

                    trigger OnAction()
                    begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange("Journal Template Name",JTemplate);
                        GenJnlLine.SetRange("Journal Batch Name",JBatch);
                        if GenJnlLine.Find('-') then
                        Report.Run(1401,true,true,GenJnlLine);
                    end;
                }
                action(VoidCheck)
                {
                    ApplicationArea = Basic;
                    Caption = 'Void Check';
                    Image = VoidCheck;

                    trigger OnAction()
                    begin
                        GenJnlLine.Reset;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
                        if GenJnlLine.Find('+') then begin
                        GenJnlLine.TestField(GenJnlLine."Bank Payment Type",GenJnlLine."bank payment type"::"Computer Check");
                        GenJnlLine.TestField("Check Printed",true);
                        if Confirm(Text000,false,"Cheque No.") then
                          CheckManagement.VoidCheck(GenJnlLine);
                          "Cheque No.":='';
                          "Cheque Printed":=false;
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
        PVLinesEditable := true;
        DateEditable := true;
        PayeeEditable := true;
        ShortcutDimension2CodeEditable := true;
        "Payment NarrationEditable" := true;
        GlobalDimension1CodeEditable := true;
        "Currency CodeEditable" := false;
        "Invoice Currency CodeEditable" := true;
        "Cheque TypeEditable" := true;
        "Payment Release DateEditable" := true;
        "Cheque No.Editable" := true;
         PaymodeEditable:=true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        "Payment Type":="payment type"::Normal;

          rcpt.Reset;
          rcpt.SetRange(rcpt.Posted,false);
          rcpt.SetRange(rcpt.Cashier,UserId);
          if rcpt.Count >0 then
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
        /* "Global Dimension 1 Code":=UserMgt.GetSetDimensions(USERID,1);
         VALIDATE("Global Dimension 1 Code");
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(USERID,2);
         VALIDATE("Shortcut Dimension 2 Code");
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(USERID,3);
         VALIDATE("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(USERID,4);
         VALIDATE("Shortcut Dimension 4 Code");
         "Responsibility Center":='MAIN';*/
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
        Text001: label 'This Document no %1 has printed Cheque No %2 which will have to be voided first before reposting.';
        Text000: label 'Do you want to Void Check No %1';
        Text002: label 'You have selected post and generate a computer cheque ensure that your cheque printer is ready do you want to continue?';
        rcpt: Record UnknownRecord61688;
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
        [InDataSet]
        "Cheque No.Editable": Boolean;
        [InDataSet]
        "Payment Release DateEditable": Boolean;
        [InDataSet]
        "Cheque TypeEditable": Boolean;
        [InDataSet]
        "Invoice Currency CodeEditable": Boolean;
        [InDataSet]
        "Currency CodeEditable": Boolean;
        [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        [InDataSet]
        "Payment NarrationEditable": Boolean;
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
        [InDataSet]
        PVLinesEditable: Boolean;
        PayingBankAccountEditable: Boolean;
        ImprestHeader: Record UnknownRecord61704;
        PaymodeEditable: Boolean;
        PurchInvHeader: Record "Purch. Inv. Header";
        ApprovalEntries: Page "Approval Entries";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        GenSetup: Record "General Ledger Setup";
        Payments3: Record UnknownRecord61688;


    procedure PostPaymentVoucher(rec: Record UnknownRecord61688)
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
          //END;
        end;
    end;


    procedure PostHeader(var Payment: Record UnknownRecord61688)
    begin
        
        //IF (Payments."Pay Mode"=Payments."Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Computer Check") THEN
         //  ERROR('Cheque type has to be specified');
        /*
        IF Payments."Pay Mode"=Payments."Pay Mode"::Cheque THEN BEGIN
            IF (Payments."Cheque No."='') AND ("Cheque Type"="Cheque Type"::"2") THEN
              BEGIN
                ERROR('Please ensure that the cheque number is inserted');
              END;
        END;
        
        IF Payments."Pay Mode"=Payments."Pay Mode"::EFT THEN
          BEGIN
            IF Payments."Cheque No."='' THEN;
          END;
        
        IF Payments."Pay Mode"=Payments."Pay Mode"::"Letter of Credit" THEN
          BEGIN
            IF Payments."Cheque No."='' THEN
              BEGIN
                ERROR('Please ensure that the Letter of Credit ref no. is entered.');
              END;
          END;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
        
          IF GenJnlLine.FIND('+') THEN
            BEGIN
              LineNo:=GenJnlLine."Line No."+1000;
            END
          ELSE
            BEGIN
              LineNo:=1000;
            END;
        
        
        LineNo:=LineNo+1000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name":=JTemplate;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
        GenJnlLine."Journal Batch Name":=JBatch;
        GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
        GenJnlLine."Line No.":=LineNo;
        GenJnlLine."Source Code":='PAYMENTJNL';
        GenJnlLine."Posting Date":=Payment."Payment Release Date";
        IF CustomerPayLinesExist THEN
         GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
        ELSE
          GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No.":=Payments."No.";
        GenJnlLine."External Document No.":=Payments."Cheque No.";
        
        GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No.":=Payments."Paying Bank Account";
        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
        
        GenJnlLine."Currency Code":=Payments."Currency Code";
        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
        Payments.CALCFIELDS(Payments."Total Net Amount");
        GenJnlLine.Amount:=-(Payments."Total Net Amount" );
        GenJnlLine.VALIDATE(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No.":='';
        
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
        GenJnlLine.Description:=COPYSTR('Pay To:' + Payments.Payee,1,50);
        GenJnlLine.VALIDATE(GenJnlLine.Description);
        
        IF "Pay Mode"<>"Pay Mode"::Cheque THEN  BEGIN
        GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        END ELSE BEGIN
        IF "Cheque Type"="Cheque Type"::"Manual Check" THEN
         GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::"Computer Check"
        ELSE
           GenJnlLine."Bank Payment Type":=GenJnlLine."Bank Payment Type"::" "
        
        END;
        IF GenJnlLine.Amount<>0 THEN
        GenJnlLine.INSERT;
        
        //Post Other Payment Journal Entries
        PostPV(Payments);
        */ /////////////////////////////////////////////////// From John
        
        if (Payments."Pay Mode"=Payments."pay mode"::Cheque) and ("Cheque Type"="cheque type"::" ") then
           Error('Cheque type has to be specified');
        
        if Payments."Pay Mode"=Payments."pay mode"::Cheque then begin
            if (Payments."Cheque No."='') and ("Cheque Type"="cheque type"::"Manual Check") then
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
          //CurrFactor
          GenJnlLine."Currency Factor":=Payments."Currency Factor";
          GenJnlLine.Validate("Currency Factor");
        
        Payments.CalcFields(Payments."Total Net Amount",Payments."Total VAT Amount");
        GenJnlLine.Amount:=-(Payments."Total Net Amount" );
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Bal. Account No.":='';
        
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
        
        GenJnlLine.Description:=CopyStr("Payment Narration",1,50);//COPYSTR('Pay To:' + Payments.Payee,1,50);
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


    procedure CheckPVRequiredItems(rec: Record UnknownRecord61688)
    begin
        if Posted then  begin
            Error('The Document has already been posted');
        end;
        
        TestField(Status,Status::Approved);
        TestField("Paying Bank Account");
        TestField("Pay Mode");
        TestField("Payment Release Date");
        //Confirm whether Bank Has the Cash
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
         CheckBudgetAvail.CheckFundsAvailability(Rec);*/
        
         //Confirm Payment Release Date is today);
        /*IF "Pay Mode"="Pay Mode"::Cash THEN
          TESTFIELD("Payment Release Date",WORKDATE);*/
        
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
        if ("Pay Mode"="pay mode"::Cheque) and ("Cheque No."='') then
            Error('Kindly specify the Cheque No');
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
    var
        StaffClaim: Record UnknownRecord61602;
        PayReqHeader: Record UnknownRecord61688;
    begin
         /*
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No,Payments."No.");
        IF PayLine.FIND('-') THEN BEGIN
        
        REPEAT
            strText:=GetAppliedEntries(PayLine."Line No.");
            Payment.TESTFIELD(Payment.Payee);
            PayLine.TESTFIELD(PayLine.Amount);
            PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");
        
            //BANK
            IF PayLine."Pay Mode"=PayLine."Pay Mode"::Cash THEN BEGIN
              CashierLinks.RESET;
              CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
            END;
        
            //CHEQUE
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document No.":=PayLine.No;
            IF PayLine."Account Type"=PayLine."Account Type"::Customer THEN
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
            ELSE
              GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
            GenJnlLine.Payee:=Payment.Payee;
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE("Currency Code");
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.VALIDATE("Currency Factor");
            IF PayLine."VAT Code"='' THEN
              BEGIN
                GenJnlLine.Amount:=PayLine."Net Amount" ;
              END
            ELSE
              BEGIN
                GenJnlLine.Amount:=PayLine."Net Amount";
              END;
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."VAT Prod. Posting Group":=PayLine."VAT Prod. Posting Group";
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Applies-to Doc. No.";
            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Applies-to ID";
        
            IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
        
            //Post VAT to GL[VAT GL]
            TarriffCodes.RESET;
            TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."VAT Code");
            IF TarriffCodes.FIND('-') THEN BEGIN
            //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."VAT Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
            END;
        
            //POST W/TAX to Respective W/TAX GL Account
            TarriffCodes.RESET;
            TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."Withholding Tax Code");
            IF TarriffCodes.FIND('-') THEN BEGIN
            //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."Withholding Tax Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine.Description:=COPYSTR('W/Tax:' + FORMAT(PayLine."Account Name") +'::' + strText,1,50);
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            IF GenJnlLine.Amount<>0 THEN
            GenJnlLine.INSERT;
            END;
        
            //Post PAYE to GL[PAYE GL] -----JOSEH
            TarriffCodes.RESET;
            TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."PAYE Code");
            IF TarriffCodes.FIND('-') THEN BEGIN
            //TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."PAYE Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('PAYE:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
            END;
        
        
            //Post VAT Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            IF PayLine."VAT Code"='' THEN
              BEGIN
                GenJnlLine.Amount:=0;
              END
            ELSE
              BEGIN
                GenJnlLine.Amount:=PayLine."VAT Amount";
              END;
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50) ;
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            IF GenJnlLine.Amount<>0 THEN
            GenJnlLine.INSERT;
        
            //Post W/TAX Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=PayLine."Withholding Tax Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('W/Tax:' + strText ,1,50);
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            IF GenJnlLine.Amount<>0 THEN
            GenJnlLine.INSERT;
        
        
            //EFT
            IF Payments."Pay Mode"=Payments."Pay Mode"::EFT THEN BEGIN
            IF PayLine."Account No."<>'' THEN BEGIN
            BankPayment.RESET;
            BankPayment.SETRANGE(BankPayment."Doc No","No.");
            IF BankPayment.FIND('-') THEN BankPayment.DELETE;
            PayLine.TESTFIELD(PayLine."Vendor Bank Account");
            BankPayment.INIT;
            BankPayment."Doc No":=Rec."No.";
            BankPayment.Payee:=PayLine."Account No.";
            BankPayment.Amount:="Total Payment Amount"-("Total Witholding Tax Amount"+"Total Retention Amount"+"Total VAT Amount");
            BankPayment."Bank A/C No":=PayLine."Vendor Bank Account";
            VBank.RESET;
            VBank.SETRANGE(VBank."Vendor No.",PayLine."Account No.");
            VBank.SETRANGE(VBank.Code,PayLine."Vendor Bank Account");
            IF VBank.FIND('-') THEN BEGIN
            VBank.TESTFIELD(VBank."Bank Branch No.");
            VBank.TESTFIELD(VBank."Bank Account No.");
            BankPayment."Bank A/C No":=FORMAT(VBank."Bank Account No.");
            BankPayment."Bank Branch No":=FORMAT(VBank."Bank Branch No.");
            BankPayment."Bank Code":=FORMAT(VBank.Code);
            BankPayment."Bank A/C Name":=VBank.Name
            END;
            BankPayment.Date:=TODAY;
            BankPayment.INSERT;
            END;
            END;
        
            //Post PAYE Balancing Entry Goes to Vendor(Lecturer)----JLL
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=PayLine."PAYE Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('PAYE:' + strText ,1,50);
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            IF GenJnlLine.Amount<>0 THEN
            GenJnlLine.INSERT;
        
        
        UNTIL PayLine.NEXT=0;
        
        COMMIT;
        //Post the Journal Lines
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
           AdjustGenJnl.RUN(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances
        
        
        //Before posting if paymode is cheque print the cheque
        IF ("Pay Mode"="Pay Mode"::Cheque) AND ("Cheque Type"="Cheque Type"::"Manual Check") THEN BEGIN
        DocPrint.PrintCheck(GenJnlLine);
        CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance",GenJnlLine);
        //Confirm Cheque printed //Not necessary.
        END;
        
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
        Post:=FALSE;
        Post:=JournlPosted.PostedSuccessfully();
        IF Post THEN
          BEGIN
            IF PayLine.FINDFIRST THEN
              BEGIN
                REPEAT
                  PayLine."Date Posted":=TODAY;
                  PayLine."Time Posted":=TIME;
                  PayLine."Posted By":=USERID;
                  PayLine.Status:=PayLine.Status::Posted;
                  PayLine.MODIFY;
               UNTIL PayLine.NEXT=0;
             END;
          END;
        
        END;
        
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
        
        
        */ ///////////////////////////////////////////////////// From JM
        PayLine.Reset;
        PayLine.SetRange(PayLine.No,Payments."No.");
        if PayLine.Find('-') then begin
        
        repeat
            strText:=GetAppliedEntries(PayLine."Line No.");
            Payment.TestField(Payment.Payee);
            PayLine.TestField(PayLine.Amount);
           // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");
        
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
           // GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if CustomerPayLinesExist then
             GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine.Description:=CopyStr("Payment Narration",1,50);
        //    GenJnlLine.Description:=COPYSTR(PayLine."Transaction Name" + ':' + Payment.Payee,1,50);
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
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
               /*
            //Post VAT to GL[VAT GL]
            TarriffCodes.RESET;
            TarriffCodes.SETRANGE(TarriffCodes.Code,PayLine."VAT Code");
            IF TarriffCodes.FIND('-') THEN BEGIN
            TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
            LineNo:=LineNo+1000;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.VALIDATE(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            IF CustomerPayLinesExist THEN
             GenJnlLine."Document Type":=GenJnlLine."Document Type"::" "
            ELSE
             GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.VALIDATE("Currency Factor");
        
            GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Posting Type");
            GenJnlLine."Gen. Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Bus. Posting Group");
            GenJnlLine."Gen. Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."Gen. Prod. Posting Group");
            GenJnlLine."VAT Bus. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Bus. Posting Group");
            GenJnlLine."VAT Prod. Posting Group":='';
            GenJnlLine.VALIDATE(GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.Amount:=-PayLine."VAT Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=COPYSTR('VAT:' + FORMAT(PayLine."Account Type") + '::' + FORMAT(PayLine."Account Name"),1,50);
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            IF GenJnlLine.Amount<>0 THEN GenJnlLine.INSERT;
            END;
        
                */
        
        ///////////////Post VAT WITHHELD////////////////////////////////////////////////////
        
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
            GenJnlLine.Amount:=-PayLine."VAT Withheld Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
        
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
            end;
        
        ////////////////////////////END VAT WITHHELD to GL//////////////////////////////////////////////
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."VAT Code");
            if TarriffCodes.Find('-') then begin
           // TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
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
            //GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
            //GenJnlLine."Bal. Account Type":=GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            //GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
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
            GenJnlLine.Amount:=PayLine."VAT Withheld Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr('VAT WITHHELD:' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if GenJnlLine.Amount<>0 then GenJnlLine.Insert;
            end;
        
        ////////////////////END BALANCING VAT WITHHELD/////////////////////////////////////////////////////////////
        
        
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
             if CustomerPayLinesExist then
              GenJnlLine."Document Type":=GenJnlLine."document type"::" "
             else
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
        
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
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
            end;
            //Post Levy
            TarriffCodes.Reset;
            TarriffCodes.SetRange(TarriffCodes.Code,PayLine."levy Code");
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
            GenJnlLine.Amount:=-PayLine."Levy Amount";
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
            //post levy end
        
        ////Post WT2
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
        
        ///////////////Post P.A.Y.E////////////////////////////////////////////////////
        
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
            GenJnlLine.Description:=CopyStr(PayLine."PAYE Code"+':' + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50);
            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
            GenJnlLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
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
            if CustomerPayLinesExist then
             GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
        
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
            GenJnlLine.Description:=CopyStr(PayLine."PAYE Code"+ Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50) ;
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
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
            // If Housing Levy, create a GL Entry here
            /////////////////////// ***************************************/////////////////
        
            //Post GL for Housing Levy
            if PayLine."VAT Code" = 'HSE LEVY' then begin
              LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            if CustomerPayLinesExist then
             GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
              GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No.":=TarriffCodes."G/L Account";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
        
                    GenJnlLine.Amount:=-PayLine."VAT Amount";
                    GenJnlLine."Debit Amount" :=PayLine."VAT Amount";
            GenJnlLine.Validate(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type":=GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No.":='';
            GenJnlLine.Description:=CopyStr(PayLine."VAT Code" + Format(PayLine."Account Type") + '::' + Format(PayLine."Account Name"),1,50) ;
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
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
        
            if GenJnlLine.Amount<>0 then begin
            GenJnlLine.Insert;
            end;
            end;
            ////***********************************************************************************\\\\\
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
            if CustomerPayLinesExist then
             GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
             GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
        
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
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
            if GenJnlLine.Amount<>0 then
            GenJnlLine.Insert;
            //Post P.A.YE Balancing Entry Goes to Vendor
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":=Payment."Payment Release Date";
            if CustomerPayLinesExist then
             GenJnlLine."Document Type":=GenJnlLine."document type"::" "
            else
             GenJnlLine."Document Type":=GenJnlLine."document type"::Payment;
            GenJnlLine."Document No.":=PayLine.No;
            GenJnlLine."External Document No.":=Payments."Cheque No.";
            GenJnlLine."Account Type":=PayLine."Account Type";
            GenJnlLine."Account No.":=PayLine."Account No.";
            GenJnlLine.Validate(GenJnlLine."Account No.");
            GenJnlLine."Currency Code":=Payments."Currency Code";
            GenJnlLine.Validate(GenJnlLine."Currency Code");
            //CurrFactor
            GenJnlLine."Currency Factor":=Payments."Currency Factor";
            GenJnlLine.Validate("Currency Factor");
        
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
            GenJnlLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3,PayLine."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4,PayLine."Shortcut Dimension 4 Code");
            GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
            GenJnlLine."Applies-to Doc. No.":=PayLine."Apply to";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID":=PayLine."Apply to ID";
            GenJnlLine."PartTime Claim":= PayLine."PartTime Claim";
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
          //update creation doc as posted
        /* IF StaffClaim.GET("Creation Doc No.") THEN
            BEGIN
              StaffClaim."Date Posted":=TODAY;
              StaffClaim."Time Posted":=TIME;
              StaffClaim."Posted By":=USERID;
              StaffClaim.Status:=Status::Posted;
              StaffClaim.Posted:=TRUE;
              StaffClaim.MODIFY;
            END;
          IF AdvanceHeader.GET("Creation Doc No.") THEN
            BEGIN
              AdvanceHeader."Date Posted":=TODAY;
              AdvanceHeader."Time Posted":=TIME;
              AdvanceHeader."Posted By":=USERID;
              AdvanceHeader.Status:=Status::Posted;
              AdvanceHeader.Posted:=TRUE;
              AdvanceHeader.MODIFY;
            END;
          IF PayReqHeader.GET("Creation Doc No.") THEN
            BEGIN
              PayReqHeader."Date Posted":=TODAY;
              PayReqHeader."Time Posted":=TIME;
              PayReqHeader."Posted By":=USERID;
              PayReqHeader.Status:=Status::Posted;
              PayReqHeader.Posted:=TRUE;
              PayReqHeader.MODIFY;
            END; */
          end;
        
        end;

    end;


    procedure UpdateControls()
    begin
             if Status<>Status::Approved then begin
             "Payment Release DateEditable" :=false;
             PayingBankAccountEditable:=false;
             //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
             //CurrForm."Pay Mode".EDITABLE:=FALSE;
             //CurrForm."Currency Code".EDITABLE:=FALSE;
             "Currency CodeEditable":=false;
             "Cheque No.Editable" :=false;
             "Cheque TypeEditable" :=false;
              PaymodeEditable:=false;
             "Invoice Currency CodeEditable" :=true;
             end else begin
             "Payment Release DateEditable" :=true;
              PaymodeEditable:=true;
             PayingBankAccountEditable:=true;
             //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
             //CurrForm."Pay Mode".EDITABLE:=TRUE;
             if "Pay Mode"="pay mode"::Cheque then
               "Cheque TypeEditable" :=true;
             //CurrForm."Currency Code".EDITABLE:=FALSE;
             if "Cheque Type"<>"cheque type"::"Computer Check" then
                 "Cheque No.Editable" :=true;
             "Invoice Currency CodeEditable" :=false;


             end;


             if Status=Status::Pending then begin
             "Currency CodeEditable" :=false;
             GlobalDimension1CodeEditable :=true;
             "Payment NarrationEditable" :=true;
             ShortcutDimension2CodeEditable :=true;
             PayeeEditable :=true;
             ShortcutDimension3CodeEditable :=true;
             ShortcutDimension4CodeEditable :=true;
             DateEditable :=true;
             PVLinesEditable :=true;


             end else begin
             "Currency CodeEditable" :=false;
             GlobalDimension1CodeEditable :=false;
             "Payment NarrationEditable" :=false;
             ShortcutDimension2CodeEditable :=false;
             PayeeEditable :=false;
             ShortcutDimension3CodeEditable :=false;
             ShortcutDimension4CodeEditable :=false;
             DateEditable :=false;
             PVLinesEditable :=false;



             end
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
    var
        checkAmount: Decimal;
    begin
        Payments3.Reset;
        Payments3.SetRange("No.",Payment."No.");
        if Payments3.Find('-') then begin

          end;
          Clear(checkAmount);

        PayLine.Reset;
        PayLine.SetRange(PayLine.No,"No.");
        if PayLine.Find('-') then begin
        repeat
          checkAmount:=checkAmount+PayLine."Net Amount";
          //  strText:=GetAppliedEntries(PayLine."Line No.");
            //Payment.TESTFIELD(Payment.Payee);
           // PayLine.TESTFIELD(PayLine.Amount);
           // PayLine.TESTFIELD(PayLine."Global Dimension 1 Code");
            //BANK
           // IF PayLine."Pay Mode"<>PayLine."Pay Mode"::Cheque THEN;
            //CHEQUE
        until PayLine.Next=0;
        end;

        if checkAmount<>0 then begin
            LineNo:=LineNo+1000;
            GenJnlLine.Init;
            GenJnlLine."Journal Template Name":=JTemplate;
            GenJnlLine.Validate(GenJnlLine."Journal Template Name");
            GenJnlLine."Journal Batch Name":=JBatch;
            GenJnlLine.Validate(GenJnlLine."Journal Batch Name");
            GenJnlLine."Source Code":='PAYMENTJNL';
            GenJnlLine."Line No.":=LineNo;
            GenJnlLine."Posting Date":="Payment Release Date";
            GenJnlLine."Document No.":=Payment."No.";
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
           // IF PayLine."VAT Code"='' THEN
           //   BEGIN
           //     GenJnlLine.Amount:=PayLine."Net Amount" ;
           //   END
          //  ELSE
           //   BEGIN
                GenJnlLine.Amount:=checkAmount;
            //  END;
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
              GenJnlLine.Insert;
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68287 "FIN-Staff Advance Surr. List"
{
    ApplicationArea = Basic;
    CardPageID = "FIN-Staff Advance Accounting";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61199;
    SourceTableView = where(Status=filter(<>Cancelled),
                            Posted=const(No));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Issue Doc. No";"Imprest Issue Doc. No")
                {
                    ApplicationArea = Basic;
                }
                field("Surrender Date";"Surrender Date")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
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
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Surrendered;Surrendered)
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
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin

                        DocumentType:=Documenttype::AdvanceSurrender;
                        ApprovalEntries.Setfilters(Database::"FIN-Staff Advance Surr. Header",DocumentType,No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action13)
                {
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Txt0001: label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                    begin
                        TestField(Status,Status::Approved);
                        TestField("Surrender Posting Date");
                        
                        
                        if Posted then
                        Error('The transaction has already been posted.');
                         /*
                         //Ensure actual spent does not exceed the amount on original document
                          CALCFIELDS("Actual Spent","Cash Receipt Amount") ;
                           IF "Actual Spent"+"Cash Receipt Amount" > Amount THEN
                              ERROR('The actual Amount spent should not exceed the amount issued ');
                           */
                        //Get the Cash office user template
                        Temp.Get(UserId);
                        SurrBatch:=Temp."Advance Surr Batch";
                        SurrTemplate:=Temp."Advance Surr Template";
                        
                        
                        //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                        //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                        CalcFields("Actual Spent");
                        if "Actual Spent"=0 then
                            if Confirm(Text000,true) then
                              UpdateforNoActualSpent
                            else
                               Error(Text001);
                        
                          // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                        if GenledSetup.Get then begin
                            GenJnlLine.Reset;
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name",SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",SurrBatch);
                            GenJnlLine.DeleteAll;
                        end;
                        
                        if DefaultBatch.Get(SurrTemplate,SurrBatch) then begin
                             DefaultBatch.Delete;
                        end;
                        
                        DefaultBatch.Reset;
                        DefaultBatch."Journal Template Name":=SurrTemplate;
                        DefaultBatch.Name:=SurrBatch;
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
                        /*
                        IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                           ERROR(Txt0001);
                               */
                        TestField("Global Dimension 1 Code");
                        
                        
                        LineNo:=LineNo+1000;
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name":=SurrTemplate;
                        GenJnlLine."Journal Batch Name":=SurrBatch;
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":='PAYMENTJNL';
                        GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
                        GenJnlLine."Account No.":=ImprestDetails."Account No:";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        //Set these fields to blanks
                        GenJnlLine."Posting Date":="Surrender Posting Date";
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
                        GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                        //GenJnlLine.Description:='Advance Surrendered by staff';
                        GenJnlLine.Description:='Advance Surrender: '+"Account No."+':'+Payee;
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
                        /*
                        //Post Cash Surrender
                        IF ImprestDetails."Cash Surrender Amt">0 THEN BEGIN
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
                        GenJnlLine."Posting Date":="Surrender Posting Date";
                        GenJnlLine."Document No.":=No;
                        GenJnlLine.Amount:=-ImprestDetails."Cash Surrender Amt";
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
                        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                        GenJnlLine."Applies-to ID":=ImprestDetails."Imprest Holder";
                        IF GenJnlLine.Amount<>0 THEN
                        GenJnlLine.INSERT;
                        
                        END;
                         */
                        //End Post Surrender Journal
                        
                        until ImprestDetails.Next=0;
                        //Post Entries
                          GenJnlLine.Reset;
                          GenJnlLine.SetRange(GenJnlLine."Journal Template Name",SurrTemplate);
                          GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",SurrBatch);
                        //Adjust Gen Jnl Exchange Rate Rounding Balances
                           AdjustGenJnl.Run(GenJnlLine);
                        //End Adjust Gen Jnl Exchange Rate Rounding Balances
                        
                          Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                        end;
                        
                        if JournalPostSuccessful.PostedSuccessfully then begin
                            Posted:=true;
                            Status:=Status::Posted;
                            "Date Posted":=Today;
                            "Time Posted":=Time;
                            "Posted By":=UserId;
                            Modify;
                            //kate
                        //Create Entries for the Overspent Figures
                            CalcFields("Difference Owed");
                            if "Difference Owed">0 then begin
                              Payline.SetFilter("Surrender Doc No.",No);
                              Payline.SetFilter("Difference Owed",'>%1',0);
                           //   CreateOverSpentBatch;
                            end;
                        //Create Entries for the Overspent Figures
                        
                        //Tag the Source Imprest Requisition as Surrendered
                           ImprestReq.Reset;
                           ImprestReq.SetRange(ImprestReq."No.","Imprest Issue Doc. No");
                           if ImprestReq.Find('-') then begin
                             ImprestReq."Surrender Status":=ImprestReq."surrender status"::Full;
                             ImprestReq.Modify;
                           end;
                        
                        //End Tag
                         //Post Committment Reversals
                        Doc_Type:=Doc_type::StaffSurrender;
                        BudgetControl.ReverseEntries(Doc_Type,No);
                        end;

                    end;
                }
                separator(Action11)
                {
                }
                action("Check Budgetary Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                         //Ensure actual spent does not exceed the amount on original document
                          CalcFields("Actual Spent","Cash Receipt Amount") ;
                           if "Actual Spent"+"Cash Receipt Amount" > Amount then
                              Error('The actual Amount spent should not exceed the amount issued ');

                          //Post Committment Reversals of the Staff Advance if it had not been reversed
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type",Commitments."document type"::StaffAdvance);
                            Commitments.SetRange(Commitments."Document No.","Imprest Issue Doc. No");
                            Commitments.SetRange(Commitments.Committed,false);
                              if not Commitments.Find('-') then begin
                               Doc_Type:=Doc_type::StaffAdvance;
                               BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                              end;

                           //First Check whether other lines are already committed.
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::StaffSurrender);
                          Commitments.SetRange(Commitments."Document No.",No);
                          if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?',false)=false then begin exit end;
                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::StaffSurrender);
                          Commitments.SetRange(Commitments."Document No.",No);
                          Commitments.DeleteAll;
                         end;

                             //Check the Budget here
                            CheckBudgetAvail.CheckStaffAdvSurr(Rec);
                    end;
                }
                action("Cancel Budgetary Allocation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budgetary Allocation';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          if Confirm('Do you Wish to Cancel the Commitment entries for this document',false)=false then begin exit end;

                          Commitments.Reset;
                          Commitments.SetRange(Commitments."Document Type",Commitments."document type"::StaffSurrender);
                          Commitments.SetRange(Commitments."Document No.",No);
                          Commitments.DeleteAll;

                          Payline.Reset;
                          Payline.SetRange(Payline."Surrender Doc No.",No);
                          if Payline.Find('-') then begin
                            repeat
                              Payline.Committed:=false;
                              Payline.Modify;
                            until Payline.Next=0;
                          end;
                    end;
                }
                separator(Action8)
                {
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        Txt0001: label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                    begin
                          /*
                          //Ensure actual spent does not exceed the amount on original document
                          CALCFIELDS("Actual Spent","Cash Receipt Amount") ;
                           IF "Actual Spent"+"Cash Receipt Amount" > Amount THEN
                              ERROR('The actual Amount spent should not exceed the amount issued ');
                        
                        
                        //First Check whether all amount entered tally
                        ImprestDetails.RESET;
                        ImprestDetails.SETRANGE(ImprestDetails."Surrender Doc No.",No);
                        IF ImprestDetails.FIND('-') THEN BEGIN
                        REPEAT
                          IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                              ERROR(Txt0001);
                        
                        UNTIL ImprestDetails.NEXT = 0;
                        END;
                        */
                        //Ensure No Items That should be committed that are not
                        //IF LinesCommitmentStatus THEN
                         // ERROR('There are some lines that have not been committed');
                        
                        //Release the ImprestSurrender for Approval
                         State:=State::Open;
                         if Status<>Status::Pending then State:=State::"Pending Approval";
                         DocType:=Doctype::"Staff Advance Accounting";
                         Clear(tableNo);
                         tableNo:=39005640;
                         if ApprovalMgt.SendApproval(tableNo,Rec.No,DocType,State,'',0) then;

                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                         DocType:=Doctype::"Staff Advance Accounting";
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=39005640;
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec.No,showmessage,ManualCancel) then;
                    end;
                }
                separator(Action5)
                {
                }
                action("Cancel Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Post Committment Reversals
                        TestField(Status,Status::Approved);
                        if Confirm(Text002,true) then begin
                          Doc_Type:=Doc_type::Imprest;
                          BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
                          Status:=Status::Cancelled;
                          Modify;
                        end;
                    end;
                }
                separator(Action3)
                {
                }
                action("Open for OverExpenditure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Open for OverExpenditure';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                           //Opening should only be for Pending Documents
                            TestField(Status,Status::Pending);
                            //Open for Overexpenditure
                           "Allow Overexpenditure":=true;
                           "Open for Overexpenditure by":=UserId;
                           "Date opened for OvExpenditure":=Today;
                            Modify;
                           //Open lines
                            Payline.Reset;
                            Payline.SetRange(Payline."Surrender Doc No.",No);
                            if Payline.Find('-') then begin
                              repeat
                                 Payline."Allow Overexpenditure":=true;
                                 Payline."Open for Overexpenditure by":=UserId;
                                 Payline."Date opened for OvExpenditure":=Today;
                                 Payline.Modify;
                              until Payline.Next=0;
                            end;
                           //End open for Overexpenditure
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetFilter(No,No);
                    Report.Run(39005917,true,true,Rec);
                    Reset;
                end;
            }
        }
    }

    var
        Text000: label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: label 'Document Not Posted';
        Text002: label 'Are you sure you want to Cancel this Document?';
        Text19053222: label 'Enter Advance Accounting Details below';
        showmessage: Boolean;
        ManualCancel: Boolean;
        State: Option Open,"Pending Approval",Cancelled,Approved;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
        tableNo: Integer;
        RecPayTypes: Record UnknownRecord61129;
        TarriffCodes: Record UnknownRecord61716;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord61712;
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record UnknownRecord61203;
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        ImprestRequestDet: Record UnknownRecord61719;
        GenledSetup: Record UnknownRecord61713;
        ImprestAmt: Decimal;
        DimName1: Text[60];
        DimName2: Text[60];
        CashPaymentLine: Record UnknownRecord61718;
        PaymentLine: Record UnknownRecord61198;
        CurrSurrDocNo: Code[20];
        JournalPostSuccessful: Codeunit PostCaferiaBatches;
        Commitments: Record UnknownRecord61722;
        BCSetup: Record UnknownRecord61721;
        BudgetControl: Codeunit "Procurement Controls Handler";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record UnknownRecord61197;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        TravAccHeader: Record UnknownRecord61199;
        CheckBudgetAvail: Codeunit "Procurement Controls Handler";
        Payline: Record UnknownRecord61203;
        Temp: Record UnknownRecord61712;
        SurrBatch: Code[10];
        SurrTemplate: Code[10];
        [InDataSet]
        "Surrender DateEditable": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;
        [InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Surrender Posting DateEditable": Boolean;
        [InDataSet]
        ImprestLinesEditable: Boolean;


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
        Doc_Type:=Doc_type::StaffSurrender;
        BudgetControl.ReverseEntries(Doc_Type,"Imprest Issue Doc. No");
    end;


    procedure CompareAllAmounts()
    begin
    end;


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
          Payline.Reset;
          Payline.SetRange(Payline."Surrender Doc No.",No);
          Payline.SetRange(Payline.Committed,false);
          Payline.SetRange(Payline."Budgetary Control A/C",true);
           if Payline.Find('-') then
              Exists:=true;
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68236 "FIN-Bank & Cash Transfer Req."
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancel,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61500;
    SourceTableView = where(Posted=const(No),
                            Status=filter(<>Cancelled));

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
                    Editable = false;
                    Enabled = true;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                label(Control1102758030)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19025618;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Receiving Transfer Type";"Receiving Transfer Type")
                {
                    ApplicationArea = Basic;
                    Editable = ReceivingTransferTypeEditable;
                }
                field("Reciept Responsibility Center";"Reciept Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = RecieptResponsibilityCenterEdi;
                }
                field("Receipt Resp Centre";"Receipt Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Account";"Receiving Account")
                {
                    ApplicationArea = Basic;
                    Editable = "Receiving AccountEditable";

                    trigger OnValidate()
                    begin
                        ReceivingAccountOnAfterValidat;
                    end;
                }
                field("Receiving Bank Account Name";"Receiving Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Currency Code Destination";"Currency Code Destination")
                {
                    ApplicationArea = Basic;
                }
                field("Amount 2";"Amount 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    Editable = "Amount 2Editable";
                }
                field("Exch. Rate Destination";"Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                    HideValue = true;
                    Visible = "Exch. Rate DestinationVisible";
                }
                field("Request Amt LCY";"Request Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = RemarksEditable;
                }
                label(Control1102758029)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19044997;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Source Transfer Type";"Source Transfer Type")
                {
                    ApplicationArea = Basic;
                    Editable = "Source Transfer TypeEditable";
                }
                field("Sending Responsibility Center";"Sending Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = SendingResponsibilityCenterEdi;
                }
                field("Sending Resp Centre";"Sending Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Account";"Paying Account")
                {
                    ApplicationArea = Basic;
                    Editable = "Paying AccountEditable";

                    trigger OnValidate()
                    begin
                        PayingAccountOnAfterValidate;
                    end;
                }
                field("Paying  Bank Account Name";"Paying  Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Currency Code Source";"Currency Code Source")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = AmountEditable;
                }
                field("Pay Amt LCY";"Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Source";"Exch. Rate Source")
                {
                    ApplicationArea = Basic;
                    Visible = "Exch. Rate sourceVisible";
                }
                field("External Doc No.";"External Doc No.")
                {
                    ApplicationArea = Basic;
                    Editable = "External Doc No.Editable";
                }
                field("Transfer Release Date";"Transfer Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Transfer Release DateEditable";
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

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank;
                    begin
                        DocumentType:=Documenttype::Interbank;
                        ApprovalEntries.Setfilters(Database::"FIN-InterBank Transfers",DocumentType,No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102756004)
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
                           TestField("Request Amt LCY");

                        //Release the Imprest for Approval

                          State:=State::Open;
                         if Status<>Status::Pending then State:=State::"Pending Approval";
                         DocType:=Doctype::Interbank;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-InterBank Transfers";
                         if ApprovalMgt.SendApproval(tableNo,No,DocType,State,'',0) then;
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
                         DocType:=Doctype::Interbank;
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=Database::"FIN-InterBank Transfers";
                          if ApprovalMgt.CancelApproval(tableNo,DocType,No,showmessage,ManualCancel) then;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1102756011)
                {
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
                          SetRange(No,No);
                          Report.Run(39006009,true,true,Rec);
                          Reset;
                    end;
                }
                action("Cancel Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Document';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: label 'Are you sure you want to Cancel this Document?';
                        Text001: label 'You have selected not to Cancel this Document';
                    begin
                        TestField(Status,Status::Approved);
                        if Confirm(Text000,true) then  begin
                        Status:=Status::Cancelled;
                        "Cancelled By":=UserId;
                        "Date Cancelled":=Today;
                        "Time Cancelled":=Time;
                        Modify;
                        end else
                          Error(Text001);
                    end;
                }
            }
            action("&Post")
            {
                ApplicationArea = Basic;
                Caption = '&Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TempBatch.Reset;
                    TempBatch.SetRange(TempBatch.User_ID,UserId);
                    if TempBatch.Find('-') then  begin
                        "Inter Bank Template Name":=TempBatch."Inter Bank Template Name";
                        "Inter Bank Journal Batch":=TempBatch."Inter Bank Batch Name";
                    end;
                    
                    TestField(Status,Status::Approved);
                    TestField("Transfer Release Date");
                    
                    //Check whether the two LCY amounts are same
                    if "Request Amt LCY" <>"Pay Amt LCY" then
                       Error('The [Requested Amount in LCY: %1] should be same as the [Paid Amount in LCY: %2]',"Request Amt LCY" ,"Pay Amt LCY");
                    
                    //get the source account balance from the database table
                    BankAcc.Reset;
                    BankAcc.SetRange(BankAcc."No.","Paying Account");
                    BankAcc.SetRange(BankAcc."Bank Type",BankAcc."bank type"::Cash);
                    if BankAcc.FindFirst then
                      begin
                          BankAcc.CalcFields(BankAcc.Balance );
                        "Current Source A/C Bal.":=BankAcc.Balance ;
                        if ("Current Source A/C Bal."-Amount)<0 then
                          begin
                            Error('The transaction will result in a negative balance in a CASH ACCOUNT.');
                          end;
                      end;
                    if Amount=0 then
                      begin
                        Error('Please ensure Amount to Transfer is entered');
                      end;
                    /*Check if the user's batch has any records within it*/
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name","Inter Bank Template Name");
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name","Inter Bank Journal Batch");
                    GenJnlLine.DeleteAll;
                    
                    LineNo:=1000;
                    /*Insert the new lines to be updated*/
                    GenJnlLine.Init;
                      /*Insert the lines*/
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Source Code":='PAYMENTJNL';
                        GenJnlLine."Journal Template Name":="Inter Bank Template Name";
                        GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
                        GenJnlLine."Posting Date":="Transfer Release Date";
                        GenJnlLine."Document No.":=No;
                        if "Receiving Transfer Type"="receiving transfer type"::"Intra-Company" then
                          begin
                            GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
                          end
                        else if "Receiving Transfer Type"="receiving transfer type"::"Inter-Company" then
                          begin
                            GenJnlLine."Account Type":=GenJnlLine."account type"::"IC Partner";
                          end;
                        GenJnlLine."Account No.":="Receiving Account";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + Format(No);
                        GenJnlLine."Shortcut Dimension 1 Code":="Receiving Depot Code";
                        GenJnlLine."Shortcut Dimension 2 Code":="Receiving Department Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code1");
                        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code1");
                        GenJnlLine."External Document No.":="External Doc No.";
                        GenJnlLine.Description:=Remarks;
                        if Remarks='' then begin GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + Format(No); end;
                        GenJnlLine."Currency Code":="Currency Code Destination";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        if "Currency Code Destination"<>'' then
                          begin
                            GenJnlLine."Currency Factor":="Exch. Rate Destination";//"Reciprical 2";
                            GenJnlLine.Validate(GenJnlLine."Currency Factor");
                          end;
                        GenJnlLine.Amount:="Amount 2";
                        GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine.Insert;
                    
                    
                    GenJnlLine.Init;
                      /*Insert the lines*/
                        GenJnlLine."Line No.":=LineNo + 1;
                        GenJnlLine."Source Code":='PAYMENTJNL';
                        GenJnlLine."Journal Template Name":="Inter Bank Template Name";
                        GenJnlLine."Journal Batch Name":="Inter Bank Journal Batch";
                        GenJnlLine."Posting Date":="Transfer Release Date";
                        GenJnlLine."Document No.":=No;
                        if "Source Transfer Type"="source transfer type"::"Intra-Company" then
                          begin
                            GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
                          end
                        else if "Source Transfer Type"="source transfer type"::"Inter-Company" then
                          begin
                            GenJnlLine."Account Type":=GenJnlLine."account type"::"IC Partner";
                          end;
                    
                    
                        GenJnlLine."Account No.":="Paying Account";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code":="Source Depot Code";
                        GenJnlLine."Shortcut Dimension 2 Code":="Source Department Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                        GenJnlLine."External Document No.":="External Doc No.";
                        GenJnlLine.Description:=Remarks;
                        if Remarks='' then begin GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + Format(No); end;
                        GenJnlLine."Currency Code":="Currency Code Source";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        if "Currency Code Source"<>'' then
                          begin
                            GenJnlLine."Currency Factor":="Exch. Rate Source";//"Reciprical 1";
                            GenJnlLine.Validate(GenJnlLine."Currency Factor");
                          end;
                        GenJnlLine.Amount:=-Amount;
                        GenJnlLine.Validate(GenJnlLine.Amount);
                    GenJnlLine.Insert;
                    Post:=false;
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                    Post:=JournalPostedSuccessfully.PostedSuccessfully();
                    
                    if Post then begin
                        Posted:=true;
                        "Date Posted":=Today;
                        "Time Posted":=Time;
                        "Posted By":=UserId;
                        Modify;
                        Message('The Journal Has Been Posted Successfully');
                    end;

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
         /*
        IF "Currency Code Source"<>'' THEN
          BEGIN
        
            "Exch. Rate SourceVisible":=TRUE;
          END
        ELSE
          BEGIN
            "Exch. Rate SourceVisible":=FALSE;
           END;
        
        IF "Currency Code Destination"<>'' THEN
          BEGIN
            "Exch. Rate DestinationVisible":=TRUE;
          END
        ELSE
          BEGIN
            "Exch. Rate DestinationVisible":=FALSE;
          END;
        */
        UpdateControl;

    end;

    trigger OnInit()
    begin
        "Transfer Release DateEditable" := true;
        "External Doc No.Editable" := true;
        "Exch. Rate SourceEditable" := true;
        AmountEditable := true;
        "Paying AccountEditable" := true;
        SendingResponsibilityCenterEdi := true;
        "Source Transfer TypeEditable" := true;
        "Exch. Rate DestinationEditable" := true;
        RemarksEditable := true;
        "Amount 2Editable" := true;
        "Receiving AccountEditable" := true;
        RecieptResponsibilityCenterEdi := true;
        ReceivingTransferTypeEditable := true;
        DateEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Date:=Today;
        "Inter Bank Template Name":=JTemplate;
        "Inter Bank Journal Batch":=JBatch;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
          "Reciept Responsibility Center" := UserMgt.GetPurchasesFilter();
          //VALIDATE( "Reciept Responsibility Center");
          Status:=Status::Pending;
          "Created By":=UserId;

        UpdateControl;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Reciept Responsibility Center",UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;


        TempBatch.Reset;

        TempBatch.SetRange(TempBatch.User_ID,UserId);
        if TempBatch.Find('-') then
          begin
            JTemplate:=TempBatch."Inter Bank Template Name";
            JBatch:=TempBatch."Inter Bank Batch Name";
          end;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TempBatch: Record UnknownRecord61712;
        JTemplate: Code[20];
        JBatch: Code[20];
        PCheck: Codeunit "Post Custom Cust Ledger";
        Post: Boolean;
        BankAcc: Record "Bank Account";
        RegNo: Integer;
        FromNo: Integer;
        ToNo: Integer;
        RegMgt: Codeunit "Registration Payment Process";
        JournalPostedSuccessfully: Codeunit PostCaferiaBatches;
        RespCenter: Record UnknownRecord61695;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        [InDataSet]
        "Exch. Rate DestinationVisible": Boolean;
        [InDataSet]
        "Exch. Rate SourceVisible": Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        ReceivingTransferTypeEditable: Boolean;
        [InDataSet]
        RecieptResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Receiving AccountEditable": Boolean;
        [InDataSet]
        "Amount 2Editable": Boolean;
        [InDataSet]
        RemarksEditable: Boolean;
        [InDataSet]
        "Exch. Rate DestinationEditable": Boolean;
        [InDataSet]
        "Source Transfer TypeEditable": Boolean;
        [InDataSet]
        SendingResponsibilityCenterEdi: Boolean;
        [InDataSet]
        "Paying AccountEditable": Boolean;
        [InDataSet]
        AmountEditable: Boolean;
        [InDataSet]
        "Exch. Rate SourceEditable": Boolean;
        [InDataSet]
        "External Doc No.Editable": Boolean;
        [InDataSet]
        "Transfer Release DateEditable": Boolean;
        Text19025618: label 'Requesting Details';
        Text19044997: label 'Source Details';
        ApprovalEntries: Page "Approval Entries";


    procedure GetDimensionName(var "Code": Code[20];DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        Text000: label 'Are you sure you want to Cancel this Document?';
        Text001: label 'You have selected not to Cancel this Document';
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
           DateEditable :=false;
           ReceivingTransferTypeEditable :=false;
           RecieptResponsibilityCenterEdi :=false;
           "Receiving AccountEditable" :=false;
           "Amount 2Editable" :=false;
           RemarksEditable :=false;
           "Exch. Rate DestinationEditable" :=false;

        end else begin
           DateEditable :=true;
           ReceivingTransferTypeEditable :=true;
           RecieptResponsibilityCenterEdi :=true;
           "Receiving AccountEditable" :=true;
           "Amount 2Editable" :=true;
           RemarksEditable :=true;
           "Exch. Rate DestinationEditable" :=true;


        end;

        if Status=Status::Approved then begin
           "Source Transfer TypeEditable" :=true;
           SendingResponsibilityCenterEdi :=true;
           "Paying AccountEditable" :=true;
           AmountEditable :=true;
           "Paying AccountEditable" :=true;
           "Exch. Rate SourceEditable" :=true;
           "External Doc No.Editable" :=true;
           "Transfer Release DateEditable" :=true;
        end else begin
           "Source Transfer TypeEditable" :=false;
           SendingResponsibilityCenterEdi :=false;
           AmountEditable :=false;
           "Paying AccountEditable" :=false;
           "Exch. Rate SourceEditable" :=false;
           "External Doc No.Editable" :=false;
           "Transfer Release DateEditable" :=false;
        end;
    end;

    local procedure ReceivingAccountOnAfterValidat()
    begin
        /*//check if the currency code field has been filled in
            "Exch. Rate DestinationVisible" :=FALSE;
        IF "Currency Code Destination"<>'' THEN
          BEGIN
            "Exch. Rate DestinationVisible" :=TRUE;
          END;
         */

    end;

    local procedure PayingAccountOnAfterValidate()
    begin
        /*//check if the currency code field has been filled in
            "Exch. Rate SourceVisible" :=FALSE;
        IF "Currency Code Source"<>'' THEN
          BEGIN
            "Exch. Rate SourceVisible" :=TRUE;
          END;
         */

    end;
}


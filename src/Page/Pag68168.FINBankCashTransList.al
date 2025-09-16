#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68168 "FIN-Bank & Cash Trans. List"
{
    CardPageID = "FIN-Bank & Cash Transfer Req.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancel,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61500;
    SourceTableView = where(Posted=const(No),
                            Status=filter(<>Cancelled));

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
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Account";"Receiving Account")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Bank Account Name";"Receiving Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code Source";"Currency Code Source")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Source";"Exch. Rate Source")
                {
                    ApplicationArea = Basic;
                }
                field("Request Amt LCY";"Request Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Account";"Paying Account")
                {
                    ApplicationArea = Basic;
                }
                field("Paying  Bank Account Name";"Paying  Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code Destination";"Currency Code Destination")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Destination";"Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Amt LCY";"Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755017;Notes)
            {
            }
            systempart(Control1102755018;MyNotes)
            {
            }
            systempart(Control1102755019;Outlook)
            {
            }
            systempart(Control1102755020;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102756002>")
            {
                Caption = 'Functions';
                action("<Action1102756003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank;
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::Interbank;
                        ApprovalEntries.Setfilters(Database::"FIN-InterBank Transfers",DocumentType,No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102755027)
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
                separator(Action1102755024)
                {
                }
                action("<Action1102756012>")
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
                action("<Action1102756018>")
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
            action("<Action1102758002>")
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
        //check if the currency code field has been filled in
            "Exch. Rate DestinationVisible" :=false;
        if "Currency Code Destination"<>'' then
          begin
            "Exch. Rate DestinationVisible" :=true;
          end;
    end;

    local procedure PayingAccountOnAfterValidate()
    begin
        //check if the currency code field has been filled in
            "Exch. Rate SourceVisible" :=false;
        if "Currency Code Source"<>'' then
          begin
            "Exch. Rate SourceVisible" :=true;
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if "Currency Code Source"<>'' then
          begin
            "Exch. Rate SourceVisible" :=true;
          end
        else
          begin
            "Exch. Rate SourceVisible" :=false;
          end;

        if "Currency Code Destination"<>'' then
          begin
            "Exch. Rate DestinationVisible" :=true;
          end
        else
          begin
            "Exch. Rate DestinationVisible" :=false;
          end;

        UpdateControl;
    end;
}


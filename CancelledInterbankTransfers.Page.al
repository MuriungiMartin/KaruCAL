#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50561 "Cancelled Interbank Transfers"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "HMS-Medical Conditions";
    SourceTableView = where(Status=const(Cancelled));

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
                    Editable = true;
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
                }
                field("Reciept Responsibility Center";"Reciept Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                label(Control1102758029)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19044997;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Receipt Resp Centre";"Receipt Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Account";"Receiving Account")
                {
                    ApplicationArea = Basic;

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
                }
                field("Request Amt LCY";"Request Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Source Transfer Type";"Source Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Sending Responsibility Center";"Sending Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Sending Resp Centre";"Sending Resp Centre")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Account";"Paying Account")
                {
                    ApplicationArea = Basic;

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
                }
                field("Pay Amt LCY";"Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Exch. Rate Destination";"Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                    Visible = "Exch. Rate DestinationVisible";
                }
                field("Exch. Rate Source";"Exch. Rate Source")
                {
                    ApplicationArea = Basic;
                    Visible = "Exch. Rate SourceVisible";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Post")
            {
                ApplicationArea = Basic;
                Caption = '&Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    
                    TestField(Status,Status::Approved);
                    
                    //Check whether the two LCY amounts are same
                    if "Request Amt LCY" <>"Pay Amt LCY" then
                       Error('The [Requested Amount in LCY] should be same as the [Paid Amount in LCY]');
                    //get the source account balance from the database table
                    BankAcc.Reset;
                    BankAcc.SetRange(BankAcc."No.","Paying Account");
                    BankAcc.SetRange(BankAcc."Bank Type",BankAcc."bank type"::Cash);
                    if BankAcc.FindFirst then
                      begin
                        BankAcc.CalcFields(BankAcc."Balance (LCY)");
                        "Current Source A/C Bal.":=BankAcc."Balance (LCY)";
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
                        GenJnlLine."Posting Date":=Date;
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
                    
                        GenJnlLine.Description:=Remarks;
                        if Remarks='' then begin GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + Format(No); end;
                        GenJnlLine."Currency Code":="Currency Code Destination";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        if "Currency Code Destination"<>'' then
                          begin
                            GenJnlLine."Currency Factor":="Reciprical 2";
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
                        GenJnlLine."Posting Date":=Date;
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
                    
                        GenJnlLine.Description:=Remarks;
                        if Remarks='' then begin GenJnlLine.Description:='Inter-Bank Transfer Ref No:' + Format(No); end;
                        GenJnlLine."Currency Code":="Currency Code Source";
                        GenJnlLine.Validate(GenJnlLine."Currency Code");
                        if "Currency Code Source"<>'' then
                          begin
                            GenJnlLine."Currency Factor":="Reciprical 1";
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
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Visible = false;

                    trigger OnAction()
                    var
                        DocumentType: Option Interbank;
                    begin
                        DocumentType:=Documenttype::Interbank;
                        ApprovalEntries.Setfilters(Database::"InterBank Transfers",DocumentType,No);
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102756004)
                {
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = Print;

                    trigger OnAction()
                    begin
                          Reset;
                          SetRange(No,No);
                          Report.Run(50699,true,true,Rec);
                          Reset;
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
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Reciept Responsibility Center",UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
        
        
        TempBatch.Reset;
        
        TempBatch.SetRange(TempBatch.UserID,UserId);
        if TempBatch.Find('-') then
          begin
            JTemplate:=TempBatch."Inter Bank Template Name";
            JBatch:=TempBatch."Inter Bank Batch Name";
          end;
        
        /*Check if the user has the batches selected*/
        if (JTemplate='') or (JBatch='') then
          begin
            Error('Please ensure you are setup as an interbank transfer user');
          end;
        
         /*
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Reciept Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
           //Reciept Responsibility Center
           */

    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TempBatch: Record UnknownRecord60242;
        JTemplate: Code[20];
        JBatch: Code[20];
        PCheck: Codeunit UnknownCodeunit50485;
        Post: Boolean;
        BankAcc: Record "Bank Account";
        RegNo: Integer;
        FromNo: Integer;
        ToNo: Integer;
        RegMgt: Codeunit UnknownCodeunit50476;
        JournalPostedSuccessfully: Codeunit UnknownCodeunit50488;
        RespCenter: Record UnknownRecord60213;
        UserMgt: Codeunit UnknownCodeunit50489;
        [InDataSet]
        "Exch. Rate DestinationVisible": Boolean;
        [InDataSet]
        "Exch. Rate SourceVisible": Boolean;
        Text19025618: label 'Requesting Details';
        Text19044997: label 'Source Details';
        ApprovalEntries: Page "Approval Entries";


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


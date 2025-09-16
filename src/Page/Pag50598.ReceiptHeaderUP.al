#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50598 "Receipt Header UP"
{
    Caption = 'Receipt';
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable60255;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipt Date';
                    Editable = true;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deposit Date';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        FunctionName:='';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.",1);
                        DimVal.SetRange(DimVal.Code,"Global Dimension 1 Code");
                        if DimVal.Find('-') then
                          begin
                            FunctionName:=DimVal.Name;
                          end;
                    end;
                }
                field(FunctionName;FunctionName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        BudgetCenterName:='';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.",2);
                        DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
                        if DimVal.Find('-') then
                          begin
                            BudgetCenterName:=DimVal.Name;
                          end;
                    end;
                }
                field(BudgetCenterName;BudgetCenterName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Amount Recieved";"Amount Recieved")
                {
                    ApplicationArea = Basic;
                }
                field("Received From";"Received From")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Imprest No";"Imprest No")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000000;"PRL-NSSF")
            {
                SubPageLink = No=field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                begin
                    //IF Posted=FALSE THEN ERROR('Post the receipt before printing.');
                    Reset;
                      SetFilter("No.","No.");
                      Report.Run(52015,true,true,Rec);
                    Reset;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Check Post Dated
                    if CheckPostDated then
                       Error('One of the Receipt Lines is Post Dated');

                    //Post the transaction into the database
                    PerformPost();

                        Cashier:=UserId;
                        //"Bank Code":=USetup."Default Receipts Bank";
                        Posted:=true;
                        "Date Posted":=Today;
                        "Time Posted":=Time;
                        "Posted By":=UserId;
                         Modify;

                    if Posted=true then  begin
                    Rcpt.Reset;
                    Rcpt.SetFilter(Rcpt."No.","No.");
                    //REPORT.RUN(50978,FALSE,FALSE,Rcpt);

                    end;
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
        //********************************JACK**********************************//
          Rcpt.Reset;
          Rcpt.SetRange(Rcpt.Posted,false);
          Rcpt.SetRange(Rcpt."Created By",UserId);
          if Rcpt.Count >0 then
            begin
              if Confirm('There are still some unposted receipts. Continue?',false)=false then
                begin
                  Error('There are still some unposted receipts. Please utilise them first');
                end;
            end;
        //********************************END **********************************//
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter();
         //Add dimensions if set by default here
         "Global Dimension 1 Code":=UserMgt.GetSetDimensions(UserId,1);
         "Shortcut Dimension 2 Code":=UserMgt.GetSetDimensions(UserId,2);
         "Shortcut Dimension 3 Code":=UserMgt.GetSetDimensions(UserId,3);
         Validate("Shortcut Dimension 3 Code");
         "Shortcut Dimension 4 Code":=UserMgt.GetSetDimensions(UserId,4);
         Validate("Shortcut Dimension 4 Code");
         Date:=Today;
         "Global Dimension 1 Code":='MAIN';
         "Responsibility Center":='MAIN';
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        
        UserSetup.Reset;
        
        if UserSetup.Get(UserId) then
          begin
            JTemplate:=UserSetup."Receipt Journal Template";JBatch:=UserSetup."Receipt Journal Batch";
          end;
        if (JTemplate='') or (JBatch='') then
          begin
            Error('Please contact the system administrator to be setup as a receipting user');
          end;
        if UserSetup."Default Receipts Bank"='' then;
        SetFilter(Status,' ');
        
        //***************************JACK***************************//
         // SETRANGE("Created By",USERID);
         /*
        IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetSalesFilter());
          FILTERGROUP(0);
        END;
         */
        //***************************END ***************************//

    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record UnknownRecord60249;
        tAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        FunctionName: Text[100];
        BudgetCenterName: Text[100];
        BankName: Text[100];
        Rcpt: Record UnknownRecord60255;
        RcptNo: Code[20];
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        UserSetup: Record UnknownRecord60242;
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        BAmount: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        PCheck: Codeunit UnknownCodeunit50485;
        Post: Boolean;
        USetup: Record UnknownRecord60242;
        RegMgt: Codeunit UnknownCodeunit50476;
        RegisterNumber: Integer;
        FromNumber: Integer;
        ToNumber: Integer;
        StrInvoices: Text[250];
        Appl: Record UnknownRecord60260;
        UserMgt: Codeunit UnknownCodeunit50489;
        JournalPosted: Codeunit UnknownCodeunit50488;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        IsCashAccount: Boolean;


    procedure PerformPost()
    begin
        //get all the invoices that have been paid for using the receipt
        StrInvoices:='';
        Appl.Reset;
        Appl.SetRange(Appl."Document Type",Appl."document type"::Receipt);
        Appl.SetRange(Appl."Document No.","No.");
        if Appl.FindFirst then
          begin
            repeat
              StrInvoices:=StrInvoices + ',' + Appl."Appl. Doc. No";
            until Appl.Next=0;
          end;
        
        //Cater for Cash Accounts
        IsCashAccount:=false;
        BankAcc.Reset;
        if BankAcc.Get("Bank Code") then begin
        if BankAcc."Bank Type"=BankAcc."bank type"::Cash then
          IsCashAccount:=true;
        end;
        
         if IsCashAccount then
           TestField(Date,WorkDate);
        //End Cater for Cash Account
        
        
        USetup.Reset;
        USetup.SetRange(USetup.UserID,UserId);
        if USetup.FindFirst then
          begin
            if USetup."Receipt Journal Template"='' then
              begin
                Error('Please ensure that the Administrator sets you up as a cashier');
              end;
            if USetup."Receipt Journal Batch"='' then
              begin
                Error('Please ensure that the Administrator sets you up as a cashier');
              end;
            if USetup."Default Receipts Bank"='' then;
          end
        else
          begin
            Error('Please ensure that the Administrator sets you up as a cashier');
          end;
        
        
        //check if the receipt has any post dated cheques.
        //check if the amounts are similar
        
        CalcFields("Total Amount");
        if "Total Amount"<>"Amount Recieved" then
          begin
            Error('Please note that the Total Amount and the Amount Received Must be the same');
          end;
        
        //if any then the amount to be posted must be less the post dated amount
        if Posted=true then
          begin
            Error('A Transaction Posted cannot be posted again');
          end;
        
        //check if the person received from has been selected
        TestField(Date);
        TestField("Bank Code");
        TestField("Global Dimension 1 Code");
        TestField("Shortcut Dimension 2 Code");
        TestField("Received From");
        /*Check if the amount received is equal to the total amount*/
        tAmount:=0;
        
        //Check Bank
        CheckBnkCurrency("Bank Code","Currency Code");
        
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No,"No.");
        if ReceiptLine.Find('-') then
          begin
            repeat
              if ReceiptLine."Pay Mode"=ReceiptLine."pay mode"::" " then
                 Error('Paymode is Mandatory on the Receipt Line');
        
               if ReceiptLine."Pay Mode"=ReceiptLine."pay mode"::"Deposit Slip" then
                begin
                  if ReceiptLine."Cheque/Deposit Slip No"='' then
                    begin
                      Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                  if ReceiptLine."Cheque/Deposit Slip Date"=0D then
                    begin
                      Error('The Cheque/Deposit Date must be inserted');
                    end;
                  if ReceiptLine."Transaction No."='' then
                    begin
                      Error('Please ensure that the Transaction Number is inserted');
                    end;
                  if ReceiptLine.Type='' then
                       Error('Please ensure that the Receipt Type is inserted');
        
                end;
        
              if ReceiptLine."Pay Mode"=ReceiptLine."pay mode"::Cheque then
                begin
                  if ReceiptLine."Cheque/Deposit Slip No"='' then
                    begin
                      Error('The Cheque/Deposit Slip No must be inserted');
                    end;
                  if ReceiptLine."Cheque/Deposit Slip Date"=0D then
                    begin
                      Error('The Cheque/Deposit Date must be inserted');
                    end;
                  if ReceiptLine."Pay Mode"=ReceiptLine."pay mode"::Cheque then
                    begin
                      if StrLen(ReceiptLine."Cheque/Deposit Slip No")<>6 then
                        begin
                          Error ('Invalid Cheque Number inserted');
                        end;
                    end;
                end;
              tAmount:=tAmount + ReceiptLine.Amount;
            until ReceiptLine.Next=0;
          end;
        
        
        
        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        GenJnlLine.DeleteAll;
        
          if DefaultBatch.Get(JTemplate,JBatch) then
           DefaultBatch.Delete;
        
          DefaultBatch.Reset;
          DefaultBatch."Journal Template Name":=JTemplate;
          DefaultBatch.Name:=JBatch;
          DefaultBatch.Insert;
        
        /*Insert the bank transaction*/
        if BAmount<tAmount then begin
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name":=JTemplate;
        GenJnlLine."Journal Batch Name":=JBatch;
        GenJnlLine."Source Code":='CASHRECJNL';
        GenJnlLine."Line No.":=1;
        GenJnlLine."Posting Date":="Document Date";
        GenJnlLine."Document No.":="No.";
        GenJnlLine."External Document No.":=ReceiptLine."Cheque/Deposit Slip No";
        GenJnlLine."Document Date":="Document Date";
        GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
        
        GenJnlLine."Account No.":="Bank Code";//USetup."Default Receipts Bank";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine."Currency Code":="Currency Code";
        GenJnlLine.Validate(GenJnlLine."Currency Code");
        GenJnlLine.Amount:=(tAmount);
        GenJnlLine.Validate(GenJnlLine.Amount);
        
        GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
        GenJnlLine.Description:="Received From";
        GenJnlLine.Validate(GenJnlLine.Description);
        if GenJnlLine.Amount<>0 then
        GenJnlLine.Insert;
        
        
        
        
        //insert the transaction lines into the database
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No,"No.");
        ReceiptLine.SetRange(ReceiptLine.Posted,false);
        
        if ReceiptLine.Find('-') then
        
          begin
            repeat
                    if ReceiptLine.Amount=0 then Error('Please enter amount.');
        
                    if ReceiptLine.Amount<0 then Error('Amount cannot be less than zero.');
        
                    ReceiptLine.TestField(ReceiptLine."Global Dimension 1 Code");
        
                    ReceiptLine.TestField(ReceiptLine."Shortcut Dimension 2 Code");
        
                    //get the last line number from the general journal line
                    GLine.Reset;
        
        
                    GLine.SetRange(GLine."Journal Template Name",JTemplate);
                    GLine.SetRange(GLine."Journal Batch Name",JBatch);
                        LineNo:=0;
                    if GLine.Find('+') then begin LineNo:=GLine."Line No."; end;
                        LineNo:=LineNo + 1;
                    if ReceiptLine."Pay Mode"<>ReceiptLine."pay mode"::Cheque then
                      begin
                          GenJnlLine.Init;
                          GenJnlLine."Journal Template Name":=JTemplate;
                          GenJnlLine."Journal Batch Name":=JBatch;
                          GenJnlLine."Source Code":='CASHRECJNL';
                          GenJnlLine."Line No.":=LineNo;
                          GenJnlLine."Posting Date":=Date;
                          GenJnlLine."Document No.":=ReceiptLine.No;
                          GenJnlLine."Document Date":="Document Date";
                          if ReceiptLine."Customer Payment On Account" then
                            begin
                              /*SRSetup.GET();
                              GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                              GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";*/
        
                              GenJnlLine."Account Type":=ReceiptLine."Account Type";
                              GenJnlLine."Account No.":=ReceiptLine."Account No.";
        
                            end
                          else
                            begin
                              GenJnlLine."Account Type":=ReceiptLine."Account Type";
                              GenJnlLine."Account No.":=ReceiptLine."Account No.";
                            end;
                          GenJnlLine.Validate(GenJnlLine."Account No.");
                          GenJnlLine."External Document No.":=ReceiptLine."Cheque/Deposit Slip No";
                          GenJnlLine."Currency Code":="Currency Code";
                          GenJnlLine.Validate(GenJnlLine."Currency Code");
        
                          GenJnlLine.Amount:=-ReceiptLine.Amount;
                          GenJnlLine.Validate(GenJnlLine.Amount);
        
                          if ReceiptLine."Customer Payment On Account"=false then
                            begin
                              //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                              GenJnlLine."Applies-to Doc. No.":=ReceiptLine."Applies-to Doc. No.";
                              GenJnlLine.Validate("Applies-to Doc. No.");
                              GenJnlLine."Applies-to ID":=ReceiptLine."Applies-to ID";
                              GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                            end;
        
                          GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                          GenJnlLine.Description:=CopyStr(ReceiptLine."Account Name" + ':' + Format(ReceiptLine."Pay Mode") +
                            ' Invoices:' + StrInvoices,1,50);
                          GenJnlLine."Shortcut Dimension 1 Code":=ReceiptLine."Global Dimension 1 Code";
                          GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                          GenJnlLine."Shortcut Dimension 2 Code":=ReceiptLine."Shortcut Dimension 2 Code";
                          GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                          GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                          GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
                          if GenJnlLine.Amount <>0 then GenJnlLine.Insert;
                      end
                    else if ReceiptLine."Pay Mode"=ReceiptLine."pay mode"::Cheque then
                      begin
                        if ReceiptLine."Cheque/Deposit Slip Date"<=Today then
                          begin
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name":=JTemplate;
                            GenJnlLine."Journal Batch Name":=JBatch;
                            GenJnlLine."Source Code":='CASHRECJNL';
                            GenJnlLine."Line No.":=LineNo;
                            GenJnlLine."Posting Date":=Date;
                            GenJnlLine."Document No.":=ReceiptLine.No;
                            GenJnlLine."Document Date":="Document Date";
                            if ReceiptLine."Customer Payment On Account" then
                              begin
                                SRSetup.Get();
                                GenJnlLine."Account Type":=GenJnlLine."account type"::"G/L Account";
                                GenJnlLine."Account No.":=SRSetup."Receivable Batch Account";
                              end
                            else
                              begin
                                GenJnlLine."Account Type":=ReceiptLine."Account Type";
                                GenJnlLine."Account No.":=ReceiptLine."Account No.";
                              end;
                            GenJnlLine.Validate(GenJnlLine."Account No.");
                            GenJnlLine."External Document No.":=ReceiptLine."Cheque/Deposit Slip No";
                            GenJnlLine."Currency Code":="Currency Code";
                            GenJnlLine.Validate(GenJnlLine."Currency Code");
        
                            GenJnlLine.Amount:=-ReceiptLine.Amount;
                            GenJnlLine.Validate(GenJnlLine.Amount);
        
                            if ReceiptLine."Customer Payment On Account"=false then
                              begin
                                //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                GenJnlLine."Applies-to Doc. No.":=ReceiptLine."Applies-to Doc. No.";
                                GenJnlLine.Validate("Applies-to Doc. No.");
                                GenJnlLine."Applies-to ID":=ReceiptLine."Applies-to ID";
                                GenJnlLine.Validate(GenJnlLine."Applies-to ID");
                              end;
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                            GenJnlLine.Description:=CopyStr(ReceiptLine."Account Name" + ':' + Format(ReceiptLine."Pay Mode")
                            + ' Invoices:' + StrInvoices,1,50);
                            GenJnlLine."Shortcut Dimension 1 Code":=ReceiptLine."Global Dimension 1 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code":=ReceiptLine."Shortcut Dimension 2 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
        
                            if GenJnlLine.Amount <>0 then GenJnlLine.Insert;
                          end;
                      end;
            until ReceiptLine.Next=0;
          end;
        
        /*Post the transactions*/
        Post:=false;
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name",JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
           AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances
        
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
        if JournalPosted.PostedSuccessfully then begin
        //Update Header
            Cashier:=UserId;
            //"Bank Code":=USetup."Default Receipts Bank";
            Posted:=true;
            "Date Posted":=Today;
            "Time Posted":=Time;
            "Posted By":=UserId;
             Modify;
        //Update Lines
              ReceiptLine.Reset;
              ReceiptLine.SetRange(ReceiptLine.No,"No.");
              ReceiptLine.SetRange(ReceiptLine.Posted,false);
              if ReceiptLine.Find('-') then begin
                  repeat
                  ReceiptLine.Posted:=true;
                  ReceiptLine."Date Posted":=Today;
                  ReceiptLine."Time Posted":=Time;
                  ReceiptLine."Posted By":=UserId;
                  ReceiptLine.Modify;
                  until ReceiptLine.Next=0;
              end;
        
          Message('Receipt Posted Successfully');
        
        end;
        end;

    end;


    procedure PerformPostLine()
    begin
    end;


    procedure CheckPostDated() Exists: Boolean
    begin
        //get the sum total of the post dated cheques is any
        //reset the bank amount first
        Exists:=false;
        BAmount:=0;
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No,"No.");
        ReceiptLine.SetRange(ReceiptLine."Pay Mode",ReceiptLine."pay mode"::Cheque);
        if ReceiptLine.Find('-') then
          begin
            repeat
              if ReceiptLine."Cheque/Deposit Slip Date"> Today then
                begin
                  Exists:=true;
                  exit;
                   //cheque is post dated
                   // BAmount:=BAmount + ReceiptLine.Amount;
                end;
            until ReceiptLine.Next=0;
          end;
    end;


    procedure CheckBnkCurrency(BankAcc: Code[20];CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
           BankAcct.Reset;
           BankAcct.SetRange(BankAcct."No.",BankAcc);
           if BankAcct.Find('-') then begin
              if BankAcct."Currency Code"<>CurrCode then begin
               if BankAcct."Currency Code"='' then
                 Error('This bank [%1:- %2] can only transact in LOCAL Currency',BankAcct."No.",BankAcct.Name)
                 else
                   Error('This bank [%1:- %2] can only transact in %3',BankAcct."No.",BankAcct.Name,BankAcct."Currency Code");
              end;
           end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        FunctionName:='';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.",1);
        DimVal.SetRange(DimVal.Code,"Global Dimension 1 Code");
        if DimVal.Find('-') then
          begin
            FunctionName:=DimVal.Name;
          end;
        BudgetCenterName:='';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.",2);
        DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
        if DimVal.Find('-') then
          begin
            BudgetCenterName:=DimVal.Name;
          end;
        BankName:='';
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.","Bank Code");
        if BankAcc.Find('-') then
          begin
            BankName:=BankAcc.Name;
          end;
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69091 "CAT-Unposted Cafeteria Recpts"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61783;
    SourceTableView = where(Status=filter(Printed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recept Total";"Recept Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cancel Reason";"Cancel Reason")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(User;User)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cafeteria Section";"Cafeteria Section")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Selection)
            {
                Caption = 'Selection';
                action(SelectAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select All';
                    Image = SelectLineToApply;
                    Promoted = true;

                    trigger OnAction()
                    begin

                        Receipts.Reset;
                        Receipts.CopyFilters(Rec);
                        Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);

                        if Confirm('Select All?',true)=true then
                        begin
                        if Receipts.Find('-') then
                          begin
                            repeat
                              begin
                                Receipts.Select:=true;
                                Receipts.Modify;
                              end;
                              until Receipts.Next=0;
                          end;
                        end;
                        CurrPage.Update;
                    end;
                }
                action(UnselectAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unsellect All';
                    Image = CalculateShipment;
                    Promoted = true;

                    trigger OnAction()
                    begin


                        Receipts.Reset;
                        Receipts.CopyFilters(Rec);
                        Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
                        if Confirm('UnSelect All?',true)=true then
                        begin
                        if Receipts.Find('-') then
                          begin
                            repeat
                              begin
                                Receipts.Select:=false;
                                Receipts.Modify;
                              end;
                              until Receipts.Next=0;
                          end;
                        end;
                        CurrPage.Update;
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Post_Selected)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Selected';
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    begin
                         // Get The Last GL Entry
                        //IF PeriodPostingto=0D THEN ERROR('Please select The Month in which the Credit Receipts will be Posted');
                        if Confirm('Post this this Receipts?',false)=false then exit;
                        
                            Receipts.Reset;
                            Receipts.CopyFilters(Rec);
                            Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
                            Receipts.SetRange(Receipts.Select,true);
                        
                             if Receipts.Find('-') then begin
                            repeat
                            begin
                              if Receipts."Transaction Type"=Receipts."transaction type"::CREDIT then
                                if Receipts."Employee No"='' then
                                  Error('Credit Receipts can''t be Posted without EMPLOYEE Numbers. Please uncheck such Receipts.');
                            end;
                            until  Receipts.Next = 0;
                            end;
                        
                            if Receipts.Find('-') then
                              begin
                              end
                            else begin
                              Error('Select Receipts to Post.')
                            end;
                        
                                  if "GL Entry".Find('-') then
                                    begin
                                    if "GL Entry".FindLast() then
                                      begin
                                        "Last Entry":="GL Entry"."Entry No."
                                      end
                                    end;
                         // Populate The Journal and post
                                  Post();
                           // Check If Posted
                                  /*IF "GL Entry".FIND('-') THEN
                                    BEGIN
                                    IF "GL Entry".FINDLAST() THEN
                                      BEGIN
                                        IF "GL Entry"."Entry No." <> "Last Entry" THEN
                                           BEGIN
                                             Approve(Receipts);
                                           END;
                                      END
                                    END;   */

                    end;
                }
                action(Cancel_Selected)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Selected';
                    Image = CancelLine;
                    Promoted = true;

                    trigger OnAction()
                    begin

                        Receipts.Reset;
                        Receipts.CopyFilters(Rec);
                        Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
                        Receipts.SetRange(Receipts.Select,true);

                        if not Receipts.Find('-') then
                          Error('No lines Selected!');

                        if Confirm('Cancel Selected?',true)=true then
                        begin
                        if Receipts.Find('-') then
                          begin
                            repeat
                              begin
                              if Receipts."Cancel Reason"='' then Error('Provide the Cancel Reason for all Cancelled Receipts.');
                                Receipts.Status:=Receipts.Status::Canceled;
                                Receipts.Modify;
                                receiptLines.Reset;
                                receiptLines.SetRange(receiptLines."Receipt No.",Receipts."Receipt No.");
                                if receiptLines.Find('-') then begin
                                  repeat
                                    begin
                        mealJournEntries.Reset;
                        mealJournEntries.SetRange(mealJournEntries."Meal Code",receiptLines."Meal Code");
                        mealJournEntries.SetRange(mealJournEntries."Receipt No.",Receipts."Receipt No.");
                        if mealJournEntries.Find('-') then begin
                        mealJournEntries.Delete;
                        end;
                        //  mealJournEntries.Template:='CAFE_INVENTORY';
                        //  mealJournEntries.Batch:='ADJUSTMENT';
                        //  mealJournEntries."Meal Code":=receiptLines."Meal Code";
                        //  mealJournEntries."Posting Date":=receiptLines.Date;
                        //  mealJournEntries."Line No.":=receiptLines."Line No.";
                        //  mealJournEntries."Cafeteria Section":=receiptLines."Cafeteria Section";
                        //  mealJournEntries."Transaction Type":=mealJournEntries."Transaction Type"::"Positive Adjustment";
                        //  mealJournEntries.Quantity:=receiptLines.Quantity;
                        //  mealJournEntries."User Id":=receiptLines.User;
                        //  mealJournEntries."Unit Price":=receiptLines."Unit Price";
                        //  mealJournEntries."Line Amount":=receiptLines."Total Amount";
                        //  mealJournEntries."Meal Description":=receiptLines."Meal Descption";
                        //  mealJournEntries.Source:=mealJournEntries.Source::Cancellation;
                        //mealJournEntries.INSERT;
                                    end;
                                  until receiptLines.Next=0;
                                end;
                              end;
                              until Receipts.Next=0;
                          end;
                        end;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        mealJournEntries: Record UnknownRecord61788;
        receiptLines: Record UnknownRecord61775;
        studrecords: Record Customer;
        recounts: Integer;
        StudBal: Decimal;
        studcafeentries: Record UnknownRecord61763;
        cafestudLedgers: Record UnknownRecord61764;
        Receipts: Record UnknownRecord61783;
        Customer: Record Customer;
        CustLedger: Record "Detailed Cust. Ledg. Entry";
        Bal: Decimal;
        GenLine: Record "Gen. Journal Line";
        GenSetUp: Record "General Ledger Setup";
        SalesLine: Record UnknownRecord61158;
        "Line No": Integer;
        "GL Entry": Record "G/L Entry";
        "Last Entry": Integer;
        BankLedger: Record "Bank Account Ledger Entry";
        CashLine: Record UnknownRecord61775;
        Amt: Decimal;
        ReceiptRec: Record UnknownRecord61783;
        Revenue: Record UnknownRecord61777;
        lines: Integer;
        premployeeTrans: Record UnknownRecord61091;
        prPayPeriod: Record UnknownRecord61081;
        PeriodPostingto: Date;
        genledgeSetup: Record "General Ledger Setup";
        cafesalesacc: Code[20];


    procedure Post()
    begin
        
        // Validate Fields
        genledgeSetup.Reset;
        if genledgeSetup.Find('-') then begin
          // Find the Cafe Sales Account
        end;
        
          TestField("Receipt No.");
         // TESTFIELD("Customer Name");
          TestField("Receipt Date");
          TestField(Department);
          TestField("Cashier Bank");
          /*IF "Cashier Bank"="Paying Bank Account" THEN
          BEGIN
            ERROR('Customer Bank Account No. Can Not be The Same As Receiving Bank Account No.')
          END; */
            Receipts.Reset;
            Receipts.CopyFilters(Rec);
            Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
            Receipts.SetRange(Receipts.Select,true);
            if Receipts.Find('-') then
              begin
              end
            else begin
              Error('Select Receipts to Post.')
            end;
        
           GenSetUp.Get();
        
           GenLine.SetRange(GenLine."Journal Template Name",GenSetUp."Cash Template");
           GenLine.SetRange(GenLine."Journal Batch Name",GenSetUp."Cash Batch") ;
        
          // Clear The Batch
            if GenLine.Find('-') then
             begin
               repeat
                 GenLine.Delete;
                 until GenLine.Next=0;
             end;
         // Populate The Journal
            "Line No":=100000;
              Receipts.Reset;
              Receipts.CopyFilters(Rec);
              Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
              Receipts.SetRange(Receipts.Select,true);
               if Receipts.Find('-') then
               begin
               repeat
                receiptLines.Reset;
                receiptLines.SetRange(receiptLines."Receipt No.",Receipts."Receipt No.");
                if receiptLines.Find('-') then begin
                  repeat
                    begin
        /*mealJournEntries.INIT;
          mealJournEntries.Template:='CAFE_INVENTORY';
          mealJournEntries.Batch:='ADJUSTMENT';
          mealJournEntries."Meal Code":=receiptLines."Meal Code";
          mealJournEntries."Posting Date":=receiptLines.Date;
          mealJournEntries."Line No.":=receiptLines."Line No.";
          mealJournEntries."Cafeteria Section":=receiptLines."Cafeteria Section";
          mealJournEntries."Transaction Type":=mealJournEntries."Transaction Type"::"Positive Adjustment";
          mealJournEntries.Quantity:=receiptLines.Quantity*(-1);
          mealJournEntries."User Id":=receiptLines.User;
          mealJournEntries."Unit Price":=receiptLines."Unit Price";
          mealJournEntries."Line Amount":=receiptLines."Total Amount";
          mealJournEntries."Meal Description":=receiptLines."Meal Descption";
          mealJournEntries.Source:=mealJournEntries.Source::Sales;
        mealJournEntries.INSERT; */
                    end;
                  until receiptLines.Next=0;
                end;
        
        // if this Receipt was on credit, then fetch the employee then
        //Add him this on then transactions or create one for the same.
        
        /* IF Receipts."Transaction Type"=Receipts."Transaction Type"::CREDIT THEN
            IF Receipts."Employee No"<>'' THEN BEGIN
          prPayPeriod.RESET;
          prPayPeriod.SETRANGE(prPayPeriod."Date Opened",PeriodPostingto);
          IF prPayPeriod.FIND('-') THEN
            BEGIN
              premployeeTrans.RESET;
              premployeeTrans.SETRANGE(premployeeTrans."Employee Code",Receipts."Employee No");
              premployeeTrans.SETRANGE(premployeeTrans."Period Month",prPayPeriod."Period Month");
              premployeeTrans.SETRANGE(premployeeTrans."Period Year",prPayPeriod."Period Year");
              premployeeTrans.SETRANGE(premployeeTrans."Transaction Code",'120');
              IF premployeeTrans.FIND('-') THEN
                BEGIN
                Receipts.CALCFIELDS(Receipts."Recept Total");
                 premployeeTrans.Amount:=premployeeTrans.Amount+Receipts."Recept Total";
                 premployeeTrans.MODIFY;
                END ELSE BEGIN // insert the Cafeteria Transaction into the payroll for the Employee
                premployeeTrans.INIT;
                premployeeTrans."Employee Code":=Receipts."Employee No";
                premployeeTrans."Transaction Code":='120';
                premployeeTrans."Period Month":=prPayPeriod."Period Month";
                premployeeTrans."Period Year":=prPayPeriod."Period Year";
                premployeeTrans."Payroll Period":=prPayPeriod."Date Opened";
                premployeeTrans."Transaction Name":='CAFETERIA';
                Receipts.CALCFIELDS(Receipts."Recept Total");
                premployeeTrans.Amount:=Receipts."Recept Total";
                premployeeTrans.INSERT();
                END;
            END;
            END; */
        
          if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
        
        with Revenue do
          begin
          Revenue.Reset;
          Revenue.SetRange(Revenue."Posting Date",Receipts."Receipt Date");
         // Revenue.SETRANGE(Revenue."MAN CASH",Receipts.Sections);
        
        Receipts.CalcFields(Receipts."Recept Total");
        if Revenue.Find('-') then begin
        if Receipts.Sections='Students' then begin
            if Receipts."Transaction Type"=Receipts."transaction type"::CASH then
            Revenue."CAFE CASH":=Revenue."CAFE CASH"+Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::CREDIT then
            Revenue."CAFE CREDIT":=Revenue."CAFE CREDIT"+Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::"ADVANCE PAYMENT" then
            Revenue."CAFE ADVANCE":=Revenue."CAFE ADVANCE"+Receipts."Recept Total";
            Revenue."CAFE TOTAL":=Revenue."CAFE TOTAL"+Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Revenue."GRAND TOTAL"+Receipts."Recept Total";
            Revenue.Modify
         end else if Receipts.Sections='Staff' then  begin
            if Receipts."Transaction Type"=Receipts."transaction type"::CASH then
            Revenue."MAN CASH":=Revenue."MAN CASH"+Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::CREDIT then
            Revenue."MAN CREDIT":=Revenue."MAN CREDIT"+Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::"ADVANCE PAYMENT" then
            Revenue."MAN ADVANCE":=Revenue."MAN ADVANCE"+Receipts."Recept Total";
            Revenue."MAN TOTAL":=Revenue."MAN TOTAL"+Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Revenue."GRAND TOTAL"+Receipts."Recept Total";
            Revenue.Modify
         end;
        end else begin
        if Receipts.Sections='Students' then begin
        if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
            Revenue.Reset;
            if Revenue.Find('-') then begin
             if Revenue.Count = 0 then lines:=0 else lines:=Revenue.Count; end else lines:=0;
            Revenue.Init();
            lines:=Revenue.Count+1;
            Revenue.Counts:=lines;
            Revenue."Posted By":=UserId;
            Revenue."Posting Date":=Receipts."Receipt Date";//Receipts."Posted Date";
            if Receipts."Transaction Type"=Receipts."transaction type"::CASH then
            Revenue."CAFE CASH":=Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::CREDIT then
            Revenue."CAFE CREDIT":=Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::"ADVANCE PAYMENT" then
            Revenue."CAFE ADVANCE":=Receipts."Recept Total";
            Revenue."CAFE TOTAL":=Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Receipts."Recept Total";
            Revenue.Insert(true);
            end;
         end else if Receipts.Sections='Staff' then  begin
         if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
            Revenue.Reset;
            if Revenue.Find('-') then begin
             if Revenue.Count = 0 then lines:=0 else lines:=Revenue.Count; end else lines:=0;
            lines:=Revenue.Count+1;
            Revenue.Init();
            Revenue.Counts:=lines;
            Revenue."Posted By":=UserId;
            Revenue."Posting Date":=Receipts."Receipt Date";//Receipts."Posted Date";
            if Receipts."Transaction Type"=Receipts."transaction type"::CASH then
            Revenue."MAN CASH":=Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::CREDIT then
            Revenue."MAN CREDIT":=Receipts."Recept Total"
            else if Receipts."Transaction Type"=Receipts."transaction type"::"ADVANCE PAYMENT" then
            Revenue."MAN ADVANCE":=Receipts."Recept Total";
            Revenue."MAN TOTAL":=Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Receipts."Recept Total";
            Revenue.Insert(true);
        end;
        end;
        
        end; // ELSE IF Receipts."Transaction Type"=Receipts."Transaction Type"::"ADVANCE PAYMENT" THEN
        end;
        
          end;
          if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
                   "Line No":="Line No"+1000000;
                   GenLine.Init();
                   GenLine."Posting Date":=Today;//Receipts."Posted Date";
                   GenLine."Document No.":=Receipts."Receipt No.";
                   GenLine."Transaction Type":=GenLine."transaction type"::Cafeteria;
                   Receipts.CalcFields(Receipts."Recept Total");
                   end;
                 // IF "Transaction Type" = Receipts."Transaction Type"::CASH THEN
                  //  ELSE GenLine."Account No.":='61027';
                   if "Transaction Type" = Receipts."transaction type"::CASH then begin
                   Receipts.CalcFields(Receipts."Recept Total");
                   GenLine.Description:='Cafeteria Cash Receipts';
                   GenLine."Journal Template Name":=GenSetUp."Cash Template";
                   GenLine."Journal Batch Name":=GenSetUp."Cash Batch";
                   GenLine."Source Code":='CAFECASH';
                   GenLine."Account Type":=GenLine."account type"::"G/L Account";
                     GenLine."Account No.":=genledgeSetup."Cafeteria Sales Account";
                  // Receipts.CALCFIELDS(Receipts."Recept Total");
                  // GenLine."Credit Amount":=Receipts."Recept Total";
                   GenLine."Bal. Account Type":=GenLine."bal. account type"::"Bank Account";
                   GenLine."Bal. Account No.":=Receipts."Cashier Bank";
                  // GenLine.VALIDATE(GenLine."Credit Amount");
                   GenLine."Line No.":="Line No";
                   GenLine."Shortcut Dimension 1 Code":="Campus Code";
                   GenLine."Shortcut Dimension 2 Code":=Department;
                   GenLine.Validate(GenLine."Shortcut Dimension 1 Code");
                   GenLine.Validate(GenLine."Shortcut Dimension 2 Code");
                   GenLine.Amount:=-Receipts."Recept Total";
                   GenLine.Validate(GenLine.Amount);
        
                    end else if  "Transaction Type" = Receipts."transaction type"::CREDIT  then begin
                    Receipts.CalcFields(Receipts."Recept Total");
                   GenLine.Description:='Cafeteria Credit Sales';
                   GenLine."Journal Template Name":=GenSetUp."Cash Template";
                   GenLine."Journal Batch Name":=GenSetUp."Cash Batch";
                   GenLine."Source Code":='CAFECREDIT';
                   GenLine."Account Type":=GenLine."account type"::"G/L Account";
                   GenLine."Account No.":=genledgeSetup."Cafeteria Credit Sales Account";
                   GenLine."Bal. Account Type":=GenLine."bal. account type"::Customer;
                   GenLine."Bal. Account No.":=Receipts."Employee No";
                   GenLine.Validate(GenLine."Bal. Account No.");
                   GenLine."Line No.":="Line No";
                   GenLine."Shortcut Dimension 1 Code":="Campus Code";
                   GenLine."Shortcut Dimension 2 Code":=Department;
                   GenLine.Validate(GenLine."Shortcut Dimension 1 Code");
                   GenLine.Validate(GenLine."Shortcut Dimension 2 Code");
                   GenLine.Amount:=-Receipts."Recept Total";
                   GenLine.Validate(GenLine.Amount);
                    end else if  "Transaction Type" = Receipts."transaction type"::"ADVANCE PAYMENT"   then begin
                 Receipts.CalcFields(Receipts."Recept Total");
        PostStudentCafeReceipts(Receipts."Employee No",Receipts."Receipt No.",Receipts."Recept Total");
               //    GenLine."Journal Template Name":=GenSetUp."Cash Template";
               //    GenLine."Journal Batch Name":=GenSetUp."Cash Batch";
                //   GenLine."Source Code":='ADVANCASH';
                  // GenLine."Account Type":=GenLine."Account Type"::"G/L Account";
                  //  GenLine."Account No.":='10119';//genledgeSetup."Cafeteria Advance Account";
                //   GenLine.Description:='Cafeteria ADVANCE PAYMENT Sales';
                //   GenLine."Bal. Account Type":=GenLine."Bal. Account Type"::Vendor;
                //   GenLine."Bal. Account No.":="Employee No";
                //   GenLine.VALIDATE(GenLine."Bal. Account No.");
                //   GenLine."Line No.":="Line No";
                //   GenLine."Shortcut Dimension 1 Code":="Campus Code";
                //   GenLine."Shortcut Dimension 2 Code":=Department;
                //   GenLine.VALIDATE(GenLine."Shortcut Dimension 1 Code");
                //   GenLine.VALIDATE(GenLine."Shortcut Dimension 2 Code");
                //   GenLine.Amount:=Receipts."Recept Total";
                //   GenLine.VALIDATE(GenLine.Amount);
        //ERROR('Amount is '+Receipts."Employee No"+', '+Receipts."Receipt No."+', '+FORMAT(Receipts."Recept Total"));
                    end;
        if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
        
                   GenLine.Insert(true);
                   end;
                    Approve(Receipts);
                   until  Receipts.Next=0;
        end;
        if Receipts."Transaction Type"<>Receipts."transaction type"::"ADVANCE PAYMENT" then  begin
        
        
                  GenLine.Reset;
                  GenSetUp.Get();
                  GenLine.SetRange(GenLine."Journal Template Name",GenSetUp."Cash Template");
                  GenLine.SetRange(GenLine."Journal Batch Name",GenSetUp."Cash Batch") ;
                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenLine);
            end;
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /*
        // Validate Fields
        
          TESTFIELD("Receipt No.");
         // TESTFIELD("Customer Name");
          TESTFIELD("Receipt Date");
          TESTFIELD(Department);
          TESTFIELD("Cashier Bank");
          {IF "Cashier Bank"="Paying Bank Account" THEN
          BEGIN
            ERROR('Customer Bank Account No. Can Not be The Same As Receiving Bank Account No.')
          END; }
            Receipts.RESET;
            Receipts.COPYFILTERS(Rec);
            Receipts.SETRANGE(Receipts.Status,Receipts.Status::Printed);
            Receipts.SETRANGE(Receipts.Select,TRUE);
            IF Receipts.FIND('-') THEN
              BEGIN
              END
            ELSE BEGIN
              ERROR('Select Receipts to Post.')
            END;
        
           GenSetUp.GET();
        
           GenLine.SETRANGE(GenLine."Journal Template Name",GenSetUp."Cash Template");
           GenLine.SETRANGE(GenLine."Journal Batch Name",GenSetUp."Cash Batch") ;
        
          // Clear The Batch
            IF GenLine.FIND('-') THEN
             BEGIN
               REPEAT
                 GenLine.DELETE;
                 UNTIL GenLine.NEXT=0;
             END;
         // Populate The Journal
            "Line No":=100000;
              Receipts.RESET;
              Receipts.COPYFILTERS(Rec);
              Receipts.SETRANGE(Receipts.Status,Receipts.Status::Printed);
              Receipts.SETRANGE(Receipts.Select,TRUE);
               IF Receipts.FIND('-') THEN
               BEGIN
               REPEAT
        
        // if this Receipt was on credit, then fetch the employee then
        //Add him this on then transactions or create one for the same.
        
        { IF Receipts."Transaction Type"=Receipts."Transaction Type"::CREDIT THEN
            IF Receipts."Employee No"<>'' THEN BEGIN
          prPayPeriod.RESET;
          prPayPeriod.SETRANGE(prPayPeriod."Date Opened",PeriodPostingto);
          IF prPayPeriod.FIND('-') THEN
            BEGIN
              premployeeTrans.RESET;
              premployeeTrans.SETRANGE(premployeeTrans."Employee Code",Receipts."Employee No");
              premployeeTrans.SETRANGE(premployeeTrans."Period Month",prPayPeriod."Period Month");
              premployeeTrans.SETRANGE(premployeeTrans."Period Year",prPayPeriod."Period Year");
              premployeeTrans.SETRANGE(premployeeTrans."Transaction Code",'120');
              IF premployeeTrans.FIND('-') THEN
                BEGIN
                Receipts.CALCFIELDS(Receipts."Recept Total");
                 premployeeTrans.Amount:=premployeeTrans.Amount+Receipts."Recept Total";
                 premployeeTrans.MODIFY;
                END ELSE BEGIN // insert the Cafeteria Transaction into the payroll for the Employee
                premployeeTrans.INIT;
                premployeeTrans."Employee Code":=Receipts."Employee No";
                premployeeTrans."Transaction Code":='120';
                premployeeTrans."Period Month":=prPayPeriod."Period Month";
                premployeeTrans."Period Year":=prPayPeriod."Period Year";
                premployeeTrans."Payroll Period":=prPayPeriod."Date Opened";
                premployeeTrans."Transaction Name":='CAFETERIA';
                Receipts.CALCFIELDS(Receipts."Recept Total");
                premployeeTrans.Amount:=Receipts."Recept Total";
                premployeeTrans.INSERT();
                END;
            END;
            END; }
        
        
        IF Receipts."Transaction Type"=Receipts."Transaction Type"::"ADVANCE PAYMENT" THEN BEGIN
        WITH Revenue DO
          BEGIN
          Revenue.RESET;
          Revenue.SETRANGE(Revenue."Posting Date",Receipts."Receipt Date");
         // Revenue.SETRANGE(Revenue."MAN CASH",Receipts.Sections);
        
        Receipts.CALCFIELDS(Receipts."Recept Total");
        IF Revenue.FIND('-') THEN BEGIN
        IF Receipts.Sections='CAFETERIA' THEN BEGIN
            IF Receipts."Transaction Type"=Receipts."Transaction Type"::CASH THEN
            Revenue."CAFE CASH":=Revenue."CAFE CASH"+Receipts."Recept Total"
            ELSE Revenue."CAFE CREDIT":=Revenue."CAFE CREDIT"+Receipts."Recept Total";
            Revenue."CAFE TOTAL":=Revenue."CAFE TOTAL"+Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Revenue."GRAND TOTAL"+Receipts."Recept Total";
            Revenue.MODIFY
         END ELSE IF Receipts.Sections='MANAGEMENT' THEN  BEGIN
            IF Receipts."Transaction Type"=Receipts."Transaction Type"::CASH THEN
            Revenue."MAN CASH":=Revenue."MAN CASH"+Receipts."Recept Total"
            ELSE Revenue."MAN CREDIT":=Revenue."MAN CREDIT"+Receipts."Recept Total";
            Revenue."MAN TOTAL":=Revenue."MAN TOTAL"+Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Revenue."GRAND TOTAL"+Receipts."Recept Total";
            Revenue.MODIFY
         END;
        END ELSE BEGIN
        IF Receipts.Sections='CAFETERIA' THEN BEGIN
            Revenue.RESET;
            IF Revenue.FIND('-') THEN BEGIN
             IF Revenue.COUNT = 0 THEN lines:=0 ELSE lines:=Revenue.COUNT; END ELSE lines:=0;
            Revenue.INIT();
            lines:=Revenue.COUNT+1;
            Revenue.Counts:=lines;
            Revenue."Posted By":=USERID;
            Revenue."Posting Date":=Receipts."Receipt Date";
            IF Receipts."Transaction Type"=Receipts."Transaction Type"::CASH THEN
            Revenue."CAFE CASH":=Receipts."Recept Total" ELSE Revenue."CAFE CREDIT":=Receipts."Recept Total";
            Revenue."CAFE TOTAL":=Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Receipts."Recept Total";
            Revenue.INSERT(TRUE);
         END ELSE IF Receipts.Sections='MANAGEMENT' THEN  BEGIN
            Revenue.RESET;
            IF Revenue.FIND('-') THEN BEGIN
             IF Revenue.COUNT = 0 THEN lines:=0 ELSE lines:=Revenue.COUNT; END ELSE lines:=0;
            lines:=Revenue.COUNT+1;
            Revenue.INIT();
            Revenue.Counts:=lines;
            Revenue."Posted By":=USERID;
            Revenue."Posting Date":=Receipts."Receipt Date";
            IF Receipts."Transaction Type"=Receipts."Transaction Type"::CASH THEN
            Revenue."MAN CASH":=Receipts."Recept Total" ELSE Revenue."MAN CREDIT":=Receipts."Recept Total";
            Revenue."MAN TOTAL":=Receipts."Recept Total";
            Revenue."GRAND TOTAL":=Receipts."Recept Total";
            Revenue.INSERT(TRUE);
        END;
        
        END;
        end;// IF Receipts."Transaction Type"=Receipts."Transaction Type"::"ADVANCE PAYMENT" THEN
        
          END;
                   "Line No":="Line No"+1000000;
                   GenLine.INIT();
                   GenLine."Journal Template Name":=GenSetUp."Cash Template";
                   GenLine."Journal Batch Name":=GenSetUp."Cash Batch";
                   GenLine."Source Code":='CAFECREDIT';
                   GenLine."Posting Date":=Receipts."Receipt Date";
                   GenLine."Document No.":=Receipts."Receipt No.";
                   GenLine."Transaction Type":=GenLine."Transaction Type"::Cafeteria;
                   Receipts.CALCFIELDS(Receipts."Recept Total");
                   GenLine.Amount:=-Receipts."Recept Total";
                   GenLine.VALIDATE(GenLine.Amount);
                   GenLine."Account Type":=GenLine."Account Type"::"G/L Account";
                  // IF "Transaction Type" = Receipts."Transaction Type"::CASH THEN
                   GenLine."Account No.":='10119';
                  //  ELSE GenLine."Account No.":='61027';
                   IF Receipts."Transaction Type" = Receipts."Transaction Type"::CASH THEN BEGIN
                   GenLine.Description:='Cafeteria Cash Receipts';
                  // Receipts.CALCFIELDS(Receipts."Recept Total");
                  // GenLine."Credit Amount":=Receipts."Recept Total";
                   GenLine."Bal. Account Type":=GenLine."Bal. Account Type"::"Bank Account";
                   GenLine."Bal. Account No.":=Receipts."Cashier Bank";
                  // GenLine.VALIDATE(GenLine."Credit Amount");
                   GenLine."Line No.":="Line No";
                   GenLine."Shortcut Dimension 1 Code":="Campus Code";
                   GenLine."Shortcut Dimension 2 Code":=Department;
                   GenLine.VALIDATE(GenLine."Shortcut Dimension 1 Code");
                   GenLine.VALIDATE(GenLine."Shortcut Dimension 2 Code");
        
                    END ELSE BEGIN
                   GenLine.Description:='Cafeteria Credit Sales';
                   GenLine."Bal. Account Type":=GenLine."Bal. Account Type"::Customer;
                   GenLine."Bal. Account No.":=Receipts."Employee No";
                   GenLine.VALIDATE(GenLine."Bal. Account No.");
                   GenLine."Line No.":="Line No";
                   GenLine."Shortcut Dimension 1 Code":="Campus Code";
                   GenLine."Shortcut Dimension 2 Code":=Department;
                   GenLine.VALIDATE(GenLine."Shortcut Dimension 1 Code");
                   GenLine.VALIDATE(GenLine."Shortcut Dimension 2 Code");
                    END;
                   GenLine.INSERT(TRUE);
                    Approve(Receipts);
                   UNTIL  Receipts.NEXT=0;
        END;  */
        
        Message('posted Successfully!');

    end;


    procedure Approve(Receipt: Record UnknownRecord61783)
    begin
           Receipt.Status:=Status::Posted;
         // "Update Mini Cash"();
         // "Create Journal"();
           Receipt."Posted By":=UserId;
           Receipt."Posted Date":=Today;
           Receipt."Posted Time":=Time;
            Receipt.Modify;
    end;


    procedure "Update Mini Cash"()
    begin
          /*IF BankLedger.FINDLAST() THEN
          BEGIN
           "Line No":=BankLedger."Entry No."+1
          END
          ELSE BEGIN
           "Line No":=1
          END;
        
          BankLedger.INIT;
          BankLedger."Entry No.":="Line No";
          BankLedger."Bank Account No.":="Paying Bank Account";
          BankLedger."Posting Date":=Date;
          BankLedger."Document No.":="Receipt No";
          BankLedger.Description:="Receipt No" + '/ Cash Settlement';
          BankLedger.Amount:=-Amount;
          BankLedger."Remaining Amount":=-Amount;
          BankLedger."Amount (LCY)":=-Amount;
          BankLedger."User ID":="Received By";
          BankLedger.Open:=TRUE;
          BankLedger."Document Date":=Date;
          BankLedger.INSERT(TRUE) ;
        */

    end;


    procedure "Create Journal"()
    begin
         /*
        GenLine.RESET;
        "Line No":=GenLine.COUNT+100000;
        GenLine.INIT;
        GenLine."Journal Template Name":='CASH RECEI';
        GenLine."Journal Batch Name":='CASH';
        GenLine."Posting Date":=Date;
        GenLine."Line No.":="Line No";
        GenLine."Document No.":="Doc No";
        GenLine."Document Type":=0;
        GenLine."External Document No.":="Cheque No";
        GenLine.Description:="Customer No"+' / '+"Cashier Bank";
        GenLine."Account Type":=GenLine."Account Type"::"Bank Account";
        GenLine."Account No.":="Receiving Bank A/C";
        GenLine.Amount:=Amt;
        GenLine."Bal. Account Type":=GenLine."Bal. Account Type"::"Bank Account";
        GenLine."Bal. Account No.":="Cashier Bank";
        GenLine.VALIDATE(GenLine.Amount);
        GenLine.INSERT(TRUE);
         */
        
        Receipts.Reset;
        Receipts.SetRange(Receipts.Status,Receipts.Status::Printed);
        Receipts.SetRange(Receipts.Select,true);
        if Receipts.Find('-') then
          begin
          repeat
          GenLine.Reset;
          "Line No":=GenLine.Count+100;
          GenLine.Init;
          GenLine."Journal Template Name":='CASH RECEI';
          GenLine."Journal Batch Name":='main2 cash';
          GenLine."Posting Date":=Receipts."Receipt Date";
          GenLine."Line No.":="Line No";
          GenLine."Document No.":=Receipts."Receipt No.";
          GenLine."Document Type":=0;
          GenLine."External Document No.":=Receipts."Doc. No.";
          GenLine.Description:="Customer Name"+' - '+"Doc. No.";
          GenLine.Remarks:='Cafeteria Sales';
          GenLine."Account Type":=GenLine."account type"::"Bank Account";
          GenLine."Account No.":='10201';
                   Receipts.CalcFields(Receipts."Recept Total");
                   GenLine."Credit Amount":=Receipts."Recept Total";
        
          GenLine."Bal. Account Type":=GenLine."bal. account type"::"Bank Account";
          GenLine."Bal. Account No.":=Receipts."Cashier Bank";
          GenLine.Validate(GenLine.Amount);
          GenLine.Insert(true);
          until Receipts.Next=0;
          end;

    end;


    procedure PostStudentCafeReceipts(var studno: Code[20];var ReceiptNo: Code[20];var CafeAmount: Decimal)
    begin
         studrecords.Reset;
         studrecords.SetRange(studrecords."No.",studno);
         if studrecords.Find('-') then begin
         end;

        Clear(StudBal);
        studrecords.CalcFields(studrecords."Balance (Cafe)");
        StudBal:=studrecords."Balance (Cafe)";
        Clear(recounts);

        cafestudLedgers.Reset;
        cafestudLedgers.SetCurrentkey(cafestudLedgers."Entry No.");
        if cafestudLedgers.Find('+') then
           recounts:=cafestudLedgers."Entry No."+1
         else
            recounts:=0;
        recounts:=recounts+1;

          StudBal:=StudBal-CafeAmount;

          cafestudLedgers.Init;
          cafestudLedgers."Entry No.":=recounts;
          cafestudLedgers."Cust. Ledger Entry No." :=recounts;
          cafestudLedgers."Posting Date" :=Today;
          cafestudLedgers."Document No.":=ReceiptNo;
          cafestudLedgers.Amount :=(CafeAmount*-1);
          cafestudLedgers."Customer No." :=studno;
          cafestudLedgers."User ID":=UserId;
          cafestudLedgers."Source Code":='CAFEADV';
          cafestudLedgers."Transaction No.":=recounts;
          cafestudLedgers."Reason Code" :='221';
          cafestudLedgers."Credit Amount":=(CafeAmount);
          cafestudLedgers.Description:='Student meals  ['+studno+'], Date: '+Format(Today);
          cafestudLedgers.Balance:=StudBal;
          cafestudLedgers.Insert;

          studcafeentries.Init;
          studcafeentries."Entry No.":=recounts;
          studcafeentries."Customer No." :=studno;
          studcafeentries."Posting Date":=Today;
          studcafeentries."Document No." :=ReceiptNo;
          studcafeentries.Description:='Payment for Meals ['+studno+'], Date: '+Format(Today);;
          studcafeentries."User ID" :=UserId;
          studcafeentries."Source Code":='CAFEADV';
          studcafeentries.Insert;
    end;
}


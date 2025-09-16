#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50111 "Budgetary Control"
{

    trigger OnRun()
    begin
    end;

    var
        BCSetup: Record UnknownRecord61721;
        DimMgt: Codeunit DimensionManagement;
        ShortcutDimCode: array [8] of Code[20];
        BudgetGL: Code[20];
        DimCode1: Code[20];
        DimCode2: Code[20];
        Text0001: label 'You Have exceeded the Budget by ';
        Text0002: label ' Do you want to Continue?';
        Text0003: label 'There is no Budget to Check against do you wish to continue?';
        GLBudgetEntry: Record "G/L Budget Entry";


    procedure CheckPurchase(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (PurchHeader."Document Date">BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
                 if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PurchLine.Reset;
              PurchLine.SetRange(PurchLine."Document Type",PurchHeader."Document Type");
              PurchLine.SetRange(PurchLine."Document No.",PurchHeader."No.");
              if PurchLine.FindFirst then
                begin
                  repeat
                  if PurchLine.Type<>PurchLine.Type::" " then begin
        
                 //Get the Dimension Here
                 //IF PurchLine."Line No." <> 0 THEN
                      // DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(
                        // DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                        // PurchLine."Line No.",ShortcutDimCode)
                    //  ELSE
                       // DimMgt.ClearDimSetFilter(ShortcutDimCode);
                 //Had to be put here for the sake of Calculating Individual Line Entries
        
                    //check the type of account in the payments line
                    //Item
                      if PurchLine.Type=PurchLine.Type::Item then begin
                          Item.Reset;
                          if not Item.Get(PurchLine."No.") then
                             Error('Item Does not Exist');
        
                          Item.TestField("Item G/L Budget Account");
                          BudgetGL:=Item."Item G/L Budget Account";
                       end;
        
                       if PurchLine.Type=PurchLine.Type::"Fixed Asset" then begin
                               FixedAssetsDet.Reset;
                               FixedAssetsDet.SetRange(FixedAssetsDet."No.",PurchLine."No.");
                                 if FixedAssetsDet.Find('-') then begin
                                   BudgetGL:=FixedAssetsDet."Asset G/L Budget Account";
                                    // FAPostingGRP.RESET;
                                     //FAPostingGRP.SETRANGE(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
        //                             IF FAPostingGRP.FIND('-') THEN
        //                               IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::Maintenance THEN
        //                                BEGIN
        //                                  BudgetGL:=FixedAssetsDet."Asset G/L Budget Account";
        //                                   //BudgetGL:=FAPostingGRP."Maintenance Expense Account";
        //                                     IF BudgetGL ='' THEN
        //                                       ERROR('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
        //                               END ELSE BEGIN
        //                                 IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"Acquisition Cost" THEN BEGIN
        //                                   //BudgetGL:=FAPostingGRP."Acquisition Cost Account";
        //                                   BudgetGL:= FixedAssetsDet."Asset G/L Budget Account";
        //                                      IF BudgetGL ='' THEN
        //                                         ERROR('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
        //                                 END;
        //                                 //To Accomodate any Additional Item under Custom 1 and Custom 2
        //                                 IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"3" THEN BEGIN
        //                                   //BudgetGL:=FAPostingGRP."Custom 2 Account";
        //                                   BudgetGL:= FixedAssetsDet."Asset G/L Budget Account";
        //                                      IF BudgetGL ='' THEN
        //                                         ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
        //                                         FAPostingGRP."Custom 1 Account");
        //                                 END;
        //
        //                                 IF PurchLine."FA Posting Type"=PurchLine."FA Posting Type"::"4" THEN BEGIN
        //                                   //BudgetGL:=FAPostingGRP."Custom 2 Account";
        //                                   BudgetGL:=FixedAssetsDet."Asset G/L Budget Account";
        //                                      IF BudgetGL ='' THEN
        //                                         ERROR('Ensure Fixed Asset No %1 has the %2 G/L Account',PurchLine."No.",
        //                                         FAPostingGRP."Custom 1 Account");
        //                                 END;
        //                                 //To Accomodate any Additional Item under Custom 1 and Custom 2
        //
        //                                END;
                                 end;
                       end;
        
                       if PurchLine.Type=PurchLine.Type::"G/L Account" then begin
                          BudgetGL:=PurchLine."No.";
                          if GLAcc.Get(PurchLine."No.") then
                             GLAcc.TestField("Budget Controlled",true);
                       end;
        
                    //End Checking Account in Payment Line
        
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(PurchHeader."Document Date",2),Date2dmy(PurchHeader."Document Date",3));
                               CurrMonth:=Date2dmy(PurchHeader."Document Date",2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(PurchHeader."Document Date",3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(PurchHeader."Document Date",3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
        
                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";
        
                              /* //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                              // Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                               //Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
                                   */
                BudgetAmount:=0;
                GLBudgetEntry.Reset;
                GLBudgetEntry.SetRange(GLBudgetEntry."Budget Name",BCSetup."Current Budget Code");
                GLBudgetEntry.SetRange(GLBudgetEntry.Date,BCSetup."Current Budget Start Date",LastDay);
                GLBudgetEntry.SetRange(GLBudgetEntry."G/L Account No.",BudgetGL);
                GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                if GLBudgetEntry.Find('-') then
                begin
                    repeat
                         //ActualsAmount +=
                         //BudgetAmount +=  GLBudgetEntry.Amount;
                          BudgetAmount:=BudgetAmount+GLBudgetEntry.Amount;
        
                    until GLBudgetEntry.Next =0;
                end;
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            /*IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                                ActualsAmount:=0;
                                Actuals.RESET;
                                Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                                Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                                Actuals."Posting Date",Actuals."Account No.");
                                Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                                Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                                Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                                Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                                Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                                Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                                Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                                   Actuals.CALCSUMS(Actuals.Amount);
                                   ActualsAmount:= Actuals.Amount;*/
                            //END ELSE BEGIN
                                ActualsAmount:=0;
                                GLAccount.Reset;
                                GLAccount.SetRange(GLAccount."No.",BudgetGL);
                                GLAccount.SetRange(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                if PurchLine."Shortcut Dimension 1 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 1 Filter",PurchLine."Shortcut Dimension 1 Code");
                                if PurchLine."Shortcut Dimension 2 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 2 Filter",PurchLine."Shortcut Dimension 2 Code");
                                if GLAccount.Find('-') then begin
                                 GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                end;
        
                            //END;
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                               Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount)
                           and not (BCSetup."Allow OverExpenditure") then
                            begin
                              Error('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                              PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                                Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                            end else begin
                                //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PurchLine."Outstanding Amount (LCY)")+ ActualsAmount>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;
                                //END ADDING CONFIRMATION
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=PurchHeader."Document Date";
                                if PurchHeader.DocApprovalType=PurchHeader.Docapprovaltype::Purchase then
                                    Commitments."Document Type":=Commitments."document type"::LPO
                                else
                                    Commitments."Document Type":=Commitments."document type"::Requisition;
        
                                if PurchHeader."Document Type"=PurchHeader."document type"::Invoice then
                                    Commitments."Document Type":=Commitments."document type"::PurchInvoice;
        
                                Commitments."Document No.":=PurchHeader."No.";
                                Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=PurchHeader."Document Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                               // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                                Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=Commitments.Type::Vendor;
                                Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments."Document Line No.":=PurchLine."Line No.";
                                Commitments.Insert;
                                //Tag the Purchase Line as Committed
                                  PurchLine.Committed:=true;
                                  PurchLine.Modify;
                                //End Tagging PurchLines as Committed
                            end;
                     end;
                  until PurchLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        
        PurchHeader.Reset;
        PurchHeader.SetRange(PurchHeader."No.",PurchLine."Document No.");
        if PurchHeader.Find('-') then begin
        PurchHeader."Budgeted Amount":=BudgetAmount;
        PurchHeader."Actual Expenditure":=ActualsAmount;
        PurchHeader."Committed Amount":=CommitmentAmount;
        PurchHeader."Budget Balance":=BudgetAmount-CommitmentAmount;//(ActualsAmount+CommitmentAmount+PurchHeader.Amount);
        PurchHeader.Modify;
        end;

    end;


    procedure CheckPayments(var PaymentHeader: Record UnknownRecord61688)
    var
        PayLine: Record UnknownRecord61705;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        
        //First Update Analysis View
        //UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (PaymentHeader.Date< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (PaymentHeader.Date>BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 In The Payment Voucher Does Not Fall Within Budget Dates %2 - %3',PaymentHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.Reset;
              PayLine.SetRange(PayLine.No,PaymentHeader."No.");
              PayLine.SetRange(PayLine."Account Type",PayLine."account type"::"G/L Account");
              PayLine.SetRange(PayLine."Budgetary Control A/C",true);
              if PayLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(PaymentHeader.Date,2),Date2dmy(PaymentHeader.Date,3));
                               CurrMonth:=Date2dmy(PaymentHeader.Date,2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(PaymentHeader.Date,3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(PaymentHeader.Date,3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
        
                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               BudgetGL:=PayLine."Account No.";
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                            GLBudgetEntry.Reset;
                            GLBudgetEntry.SetRange("G/L Account No.",BudgetGL);
                            GLBudgetEntry.SetRange(Date,BCSetup."Current Budget Start Date",LastDay);
                            GLBudgetEntry.SetRange("Budget Name",BCSetup."Current Budget Code");
                            GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            //GLAcc.SETRANGE("Dimension Set ID Filter",PayLine."Dimension Set ID");
                            if GLBudgetEntry.Find('-') then begin
                            repeat
                              // GLBudgetEntry.CALCFIELDS(Amount,"Net Change");
                             //ActualsAmount := GLAcc."Net Change";
                             BudgetAmount := BudgetAmount+GLBudgetEntry.Amount;  //GLBudgetEntry.Amount;
                             until GLBudgetEntry.Next=0;
                            //MESSAGE('%1',BudgetAmount);
                            end;
                          //get the summation on the actuals
        
                            ActualsAmount:=0;
                            GLEntry.Reset;
                            GLEntry.SetRange(GLEntry."G/L Account No.",BudgetGL);
                            GLEntry.SetRange(GLEntry."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                            GLEntry.SetRange(GLEntry."Global Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            GLEntry.SetRange(GLEntry."Global Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            if GLEntry.Find('-') then begin
                            repeat
                            ActualsAmount:=ActualsAmount+GLEntry.Amount;
                            until GLEntry.Next=0;
                            end;
        
        
                              /*
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF PayLine."Global Dimension 1 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
        
                            END;*/
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
        
        //                    Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
        //                    Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PayLine."NetAmount LCY"+ActualsAmount)>BudgetAmount )
                           and not ( BCSetup."Allow OverExpenditure") then  begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,PayLine.Type ,PayLine.No,
                                Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY"))));
                            end else begin
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PayLine."NetAmount LCY"+ ActualsAmount)>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."NetAmount LCY")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;
        
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=PaymentHeader.Date;
                                if PaymentHeader."Payment Type"=PaymentHeader."payment type"::Normal then
                                 Commitments."Document Type":=Commitments."document type"::"Payment Voucher"
                                else
                                  Commitments."Document Type":=Commitments."document type"::PettyCash;
                                Commitments."Document No.":=PaymentHeader."No.";
                                Commitments.Amount:=PayLine."NetAmount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=PaymentHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Insert;
                                //Tag the Payment Line as Committed
                                  PayLine.Committed:=true;
                                  PayLine.Modify;
                                //End Tagging Payment Lines as Committed
                            end;
        
                  until PayLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        
        
        
        PaymentHeader."Budgeted Amount":=BudgetAmount;
        PaymentHeader."Actual Expenditure":=ActualsAmount;
        PaymentHeader."Committed Amount":=CommitmentAmount;
        PaymentHeader.CalcFields(PaymentHeader."Total Net Amount");
        PaymentHeader."Budget Balance":=BudgetAmount-CommitmentAmount;//(ActualsAmount+CommitmentAmount+PaymentHeader."Total Net Amount");
        PaymentHeader.Modify;
        
        Message('Budgetary Checking Completed Successfully');
        
        Message('Budgetary Checking Completed Successfully');

    end;


    procedure CheckImprest(var ImprestHeader: Record UnknownRecord61704)
    var
        PayLine: Record UnknownRecord61714;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ImprestHeader.Date>BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.Reset;
              PayLine.SetRange(PayLine.No,ImprestHeader."No.");
              PayLine.SetRange(PayLine."Budgetary Control A/C",true);
              if PayLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ImprestHeader.Date,2),Date2dmy(ImprestHeader.Date,3));
                               CurrMonth:=Date2dmy(ImprestHeader.Date,2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ImprestHeader.Date,3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ImprestHeader.Date,3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
        
                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               //The GL Account
                                BudgetGL:=PayLine."Account No:";
                                DimCode1:=PayLine."Global Dimension 1 Code";
                                DimCode2:=PayLine."Shortcut Dimension 2 Code";
        
                               //check the summation of the budget in the database
                              /* BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;*/
        
                            GLBudgetEntry.Reset;
                            GLBudgetEntry.SetRange("G/L Account No.",BudgetGL);
                            GLBudgetEntry.SetRange(Date,BCSetup."Current Budget Start Date",LastDay);
                            GLBudgetEntry.SetRange("Budget Name",BCSetup."Current Budget Code");
                            GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            GLBudgetEntry.SetRange(GLBudgetEntry."Global Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            //GLAcc.SETRANGE("Dimension Set ID Filter",PayLine."Dimension Set ID");
                            if GLBudgetEntry.Find('-') then begin
                            repeat
                             BudgetAmount :=  BudgetAmount+GLBudgetEntry.Amount; //GLBudgetEntry.Amount;
                            //MESSAGE('%1',BudgetAmount);
                            until GLBudgetEntry.Next=0;
                            end;
                          //get the summation on the actuals
        
                            ActualsAmount:=0;
                            GLEntry.Reset;
                            GLEntry.SetRange(GLEntry."G/L Account No.",BudgetGL);
                            GLEntry.SetRange(GLEntry."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                            GLEntry.SetRange(GLEntry."Global Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            GLEntry.SetRange(GLEntry."Global Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            if GLEntry.Find('-') then begin
                            repeat
                            ActualsAmount:=ActualsAmount+GLEntry.Amount;
                            until GLEntry.Next=0;
                            end;
        
                          //Separate Analysis View and G/L Entry
                           /* IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF PayLine."Global Dimension 1 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                IF PayLine."Shortcut Dimension 2 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;*/
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           and not ( BCSetup."Allow OverExpenditure") then  begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                Format(Abs(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            end else begin
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;
        
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."document type"::Imprest;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=true;
                                  PayLine.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;
        
                  until PayLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        
        ImprestHeader."Budgeted Amount":=BudgetAmount;
        ImprestHeader."Actual Expenditure":=ActualsAmount;
        ImprestHeader."Committed Amount":=CommitmentAmount+ImprestHeader."Total Net Amount";
        ImprestHeader.CalcFields("Total Net Amount");
        ImprestHeader."Budget Balance":=BudgetAmount-(CommitmentAmount+ImprestHeader."Total Net Amount");//(ActualsAmount+CommitmentAmount+ImprestHeader."Total Net Amount");
        ImprestHeader.Modify;
        Message('Budgetary Checking Completed Successfully');

    end;


    procedure ReverseEntries(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance;DocNo: Code[20])
    var
        Commitments: Record UnknownRecord61722;
        EntryNo: Integer;
        CommittedLines: Record UnknownRecord61722;
    begin
        //Get Commitment Lines
        Commitments.Reset;
         if Commitments.Find('+') then
            EntryNo:=Commitments."Line No.";

        CommittedLines.Reset;
        CommittedLines.SetRange(CommittedLines."Document Type",DocumentType);
        CommittedLines.SetRange(CommittedLines."Document No.",DocNo);
        CommittedLines.SetRange(CommittedLines.Committed,true);
        if CommittedLines.Find('-') then begin
           repeat
             Commitments.Reset;
             Commitments.Init;
             EntryNo+=1;
             Commitments."Line No.":=EntryNo;
             Commitments.Date:=Today;
             Commitments."Posting Date":=CommittedLines."Posting Date";
             Commitments."Document Type":=CommittedLines."Document Type";
             Commitments."Document No.":=CommittedLines."Document No.";
             Commitments.Amount:=-CommittedLines.Amount;
            //Before Posting the Amount Check the Amount being passed From LPO as Qty Received
             if DocumentType=Documenttype::LPO  then begin
              Commitments.Amount:=-GetLineAmountToReverse(DocumentType,DocNo,CommittedLines."Document Line No.");
             end else begin
                 Commitments.Amount:=-CommittedLines.Amount;
             end;
             //END CHECK AMOUNT BEING POSTED FOR LPO

             Commitments."Month Budget":=CommittedLines."Month Budget";
             Commitments."Month Actual":=CommittedLines."Month Actual";
             Commitments.Committed:=false;
             Commitments."Committed By":=UserId;
             Commitments."Committed Date":=CommittedLines."Committed Date";
             Commitments."G/L Account No.":=CommittedLines."G/L Account No.";
             Commitments."Committed Time":=Time;
             //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
             Commitments."Shortcut Dimension 1 Code":=CommittedLines."Shortcut Dimension 1 Code";
             Commitments."Shortcut Dimension 2 Code":=CommittedLines."Shortcut Dimension 2 Code";
             Commitments."Shortcut Dimension 3 Code":=CommittedLines."Shortcut Dimension 3 Code";
             Commitments."Shortcut Dimension 4 Code":=CommittedLines."Shortcut Dimension 4 Code";
             Commitments.Budget:=CommittedLines.Budget;
             Commitments."Document Line No.":=CommittedLines."Document Line No.";
             Commitments."Budget Check Criteria":=CommittedLines."Budget Check Criteria";
             Commitments."Actual Source":=CommittedLines."Actual Source";
             Commitments.Insert;

           until CommittedLines.Next=0;
        end;
    end;


    procedure CheckFundsAvailability(Payments: Record UnknownRecord61688)
    var
        BankAcc: Record "Bank Account";
        "Current Source A/C Bal.": Decimal;
    begin
        //get the source account balance from the database table
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.",Payments."Paying Bank Account");
        BankAcc.SetRange(BankAcc."Bank Type",BankAcc."bank type"::Cash);
        if BankAcc.FindFirst then
          begin
            BankAcc.CalcFields(BankAcc.Balance);
            "Current Source A/C Bal.":=BankAcc.Balance;
            if ("Current Source A/C Bal."-Payments."Total Net Amount")<0 then
              begin
                Error('The transaction will result in a negative balance in the BANK ACCOUNT. %1:%2',BankAcc."No.",
                BankAcc.Name);
              end;
          end;
    end;


    procedure UpdateAnalysisView()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        BudgetaryControl: Record UnknownRecord61721;
        AnalysisView: Record "Analysis View";
    begin
        //Update Budget Lines
        if BudgetaryControl.Get then begin
          if BudgetaryControl."Actual Source"=BudgetaryControl."actual source"::"Analysis View Entry" then begin
             if BudgetaryControl."Analysis View Code"='' then
                Error('The Analysis view code can not be blank in the budgetary control setup');
          end;
          if BudgetaryControl."Analysis View Code"<>''  then begin
           AnalysisView.Reset;
           AnalysisView.SetRange(AnalysisView.Code,BudgetaryControl."Analysis View Code");
          // IF AnalysisView.FIND('-') THEN
          //   UpdateAnalysisView.UpdateAnalysisView_Budget(AnalysisView);
          end;
        end;
    end;


    procedure UpdateDim(DimCode: Code[20];DimValueCode: Code[20])
    begin
        /*IF DimCode = '' THEN
          EXIT;
        WITH GLBudgetDim DO BEGIN
          IF GET(Rec."Entry No.",DimCode) THEN
            DELETE;
          IF DimValueCode <> '' THEN BEGIN
            INIT;
            "Entry No." := Rec."Entry No.";
            "Dimension Code" := DimCode;
            "Dimension Value Code" := DimValueCode;
            INSERT;
          END;
        END; */

    end;


    procedure CheckIfBlocked(BudgetName: Code[20])
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        GLBudgetName.Get(BudgetName);
        GLBudgetName.TestField(Blocked,false);
    end;


    procedure CheckStaffClaim(var ImprestHeader: Record UnknownRecord61602)
    var
        PayLine: Record UnknownRecord61603;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ImprestHeader.Date>BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";

            //get the lines related to the payment header
              PayLine.Reset;
              PayLine.SetRange(PayLine.No,ImprestHeader."No.");
              PayLine.SetRange(PayLine."Budgetary Control A/C",true);
              if PayLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ImprestHeader.Date,2),Date2dmy(ImprestHeader.Date,3));
                               CurrMonth:=Date2dmy(ImprestHeader.Date,2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ImprestHeader.Date,3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ImprestHeader.Date,3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";

                               //The GL Account
                                BudgetGL:=PayLine."Account No:";

                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetCurrentkey(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetRange(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                               Budget.SetRange(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SetRange(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SetRange(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SetRange(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CalcSums(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;

                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                           if BCSetup."Actual Source"=BCSetup."actual source"::"Analysis View Entry" then begin
                            ActualsAmount:=0;
                            Actuals.Reset;
                            Actuals.SetCurrentkey(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SetRange(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SetRange(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SetRange(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SetRange(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SetRange(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SetRange(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SetRange(Actuals."Account No.",BudgetGL);
                               Actuals.CalcSums(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            end else begin
                                GLAccount.Reset;
                                GLAccount.SetRange(GLAccount."No.",BudgetGL);
                                GLAccount.SetRange(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                if PayLine."Global Dimension 1 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                if PayLine."Shortcut Dimension 2 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                if GLAccount.Find('-') then begin
                                 GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                end;
                            end;
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                                Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;

                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;

                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           and not ( BCSetup."Allow OverExpenditure") then  begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                Format(Abs(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            end else begin
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;

                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."document type"::StaffClaim;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                               // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=true;
                                  PayLine.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;

                  until PayLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin

          end;
        Message('Budgetary Checking Completed Successfully');
    end;


    procedure CheckStaffAdvance(var ImprestHeader: Record UnknownRecord61197)
    var
        PayLine: Record UnknownRecord61198;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader.Date< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ImprestHeader.Date>BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader.Date,
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";

            //get the lines related to the payment header
              PayLine.Reset;
              PayLine.SetRange(PayLine.No,ImprestHeader."No.");
              PayLine.SetRange(PayLine."Budgetary Control A/C",true);
              if PayLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ImprestHeader.Date,2),Date2dmy(ImprestHeader.Date,3));
                               CurrMonth:=Date2dmy(ImprestHeader.Date,2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ImprestHeader.Date,3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ImprestHeader.Date,3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;

                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";

                               //The GL Account
                                BudgetGL:=PayLine."Account No:";

                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetCurrentkey(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetRange(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                               Budget.SetRange(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SetRange(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SetRange(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SetRange(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CalcSums(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;

                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            if BCSetup."Actual Source"=BCSetup."actual source"::"Analysis View Entry" then begin
                            ActualsAmount:=0;
                            Actuals.Reset;
                            Actuals.SetCurrentkey(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SetRange(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SetRange(Actuals."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                            Actuals.SetRange(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SetRange(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SetRange(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SetRange(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SetRange(Actuals."Account No.",BudgetGL);
                               Actuals.CalcSums(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            end else begin
                                GLAccount.Reset;
                                GLAccount.SetRange(GLAccount."No.",BudgetGL);
                                GLAccount.SetRange(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                if PayLine."Global Dimension 1 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 1 Filter",PayLine."Global Dimension 1 Code");
                                if PayLine."Shortcut Dimension 2 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                if GLAccount.Find('-') then begin
                                 GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                end;
                            end;
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PayLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;

                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;

                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           and not ( BCSetup."Allow OverExpenditure") then  begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine.No,'Staff Imprest' ,PayLine.No,
                                Format(Abs(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            end else begin
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;

                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ImprestHeader.Date;
                                Commitments."Document Type":=Commitments."document type"::StaffAdvance;
                                Commitments."Document No.":=ImprestHeader."No.";
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ImprestHeader.Date;
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=true;
                                  PayLine.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;

                  until PayLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin

          end;
        Message('Budgetary Checking Completed Successfully');
    end;


    procedure CheckStaffAdvSurr(var ImprestHeader: Record UnknownRecord61199)
    var
        PayLine: Record UnknownRecord61203;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        //First Update Analysis View
        UpdateAnalysisView();

        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ImprestHeader."Surrender Date"< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ImprestHeader."Surrender Date">BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the Imprest Does Not Fall Within Budget Dates %2 - %3',ImprestHeader."Surrender Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");

              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");

            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";

            //get the lines related to the payment header
              PayLine.Reset;
              PayLine.SetRange(PayLine."Surrender Doc No.",ImprestHeader.No);
              PayLine.SetRange(PayLine."Budgetary Control A/C",true);
              if PayLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ImprestHeader."Surrender Date",2),Date2dmy(ImprestHeader."Surrender Date",3));
                               CurrMonth:=Date2dmy(ImprestHeader."Surrender Date",2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ImprestHeader."Surrender Date",3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ImprestHeader."Surrender Date",3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;

                               //If Budget is annual then change the Last day
                               if BCSetup."Budget Check Criteria"=BCSetup."budget check criteria"::"Whole Year" then
                                   LastDay:=BCSetup."Current Budget End Date";

                               //The GL Account
                                BudgetGL:=PayLine."Account No:";

                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetCurrentkey(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetRange(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                               Budget.SetRange(Budget."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                               Budget.SetRange(Budget."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                               Budget.SetRange(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               Budget.SetRange(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CalcSums(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;

                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            if BCSetup."Actual Source"=BCSetup."actual source"::"Analysis View Entry" then begin
                            ActualsAmount:=0;
                            Actuals.Reset;
                            Actuals.SetCurrentkey(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SetRange(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SetRange(Actuals."Dimension 1 Value Code",PayLine."Shortcut Dimension 1 Code");
                            Actuals.SetRange(Actuals."Dimension 2 Value Code",PayLine."Shortcut Dimension 2 Code");
                            Actuals.SetRange(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            Actuals.SetRange(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SetRange(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SetRange(Actuals."Account No.",BudgetGL);
                               Actuals.CalcSums(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            end else begin
                                GLAccount.Reset;
                                GLAccount.SetRange(GLAccount."No.",BudgetGL);
                                GLAccount.SetRange(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                if PayLine."Shortcut Dimension 1 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 1 Filter",PayLine."Shortcut Dimension 1 Code");
                                if PayLine."Shortcut Dimension 2 Code" <> '' then
                                  GLAccount.SetRange(GLAccount."Global Dimension 2 Filter",PayLine."Shortcut Dimension 2 Code");
                                if GLAccount.Find('-') then begin
                                 GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                end;
                            end;

                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SetRange(Commitments."Shortcut Dimension 1 Code",PayLine."Shortcut Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",PayLine."Shortcut Dimension 2 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;

                           //check if there is any budget
                           if (BudgetAmount<=0) and not (BCSetup."Allow OverExpenditure") then  begin
                              Error('No Budget To Check Against');
                           end else begin
                            if (BudgetAmount<=0) then begin
                             if not Confirm(Text0003,true) then begin
                                Error('Budgetary Checking Process Aborted');
                             end;
                            end;
                           end;

                           //check if the actuals plus the amount is greater then the budget amount
                           if ((CommitmentAmount + PayLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           and not ( BCSetup."Allow OverExpenditure") then  begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine."Surrender Doc No.",'Staff Imprest' ,PayLine."Surrender Doc No.",
                                Format(Abs(BudgetAmount-(CommitmentAmount + PayLine."Amount LCY"))));
                            end else begin
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                if ((CommitmentAmount + PayLine."Amount LCY"+ ActualsAmount)>BudgetAmount) then begin
                                    if not Confirm(Text0001+
                                    Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Amount LCY")))
                                    +Text0002,true) then begin
                                       Error('Budgetary Checking Process Aborted');
                                    end;
                                end;

                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ImprestHeader."Surrender Date";
                                Commitments."Document Type":=Commitments."document type"::StaffSurrender;
                                Commitments."Document No.":=ImprestHeader.No;
                                Commitments.Amount:=PayLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ImprestHeader."Surrender Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=PayLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=ImprestHeader."Account Type";
                                Commitments."Vendor/Cust No.":=ImprestHeader."Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  PayLine.Committed:=true;
                                  PayLine.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;

                  until PayLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin

          end;
        Message('Budgetary Checking Completed Successfully');
    end;


    procedure CheckGrantSurr()
    var
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        /*
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (GrantHeader."Grant Surrender Doc. Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Grant Does Not Fall Within Budget Dates %2 - %3',GrantHeader."Grant Surrender Doc. Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (GrantHeader."Grant Surrender Doc. Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 for the Grant Does Not Fall Within Budget Dates %2 - %3',GrantHeader."Grant Surrender Doc. Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              GrantLine.RESET;
              GrantLine.SETRANGE(GrantLine."Surrender Doc No.",GrantHeader.No);
              GrantLine.SETRANGE(GrantLine."Budgetary Control A/C",TRUE);
              IF GrantLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",2),DATE2DMY(GrantHeader.
                               "Grant Surrender Doc. Date",3));
        
                               CurrMonth:=DATE2DMY(GrantHeader."Grant Surrender Doc. Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(GrantHeader."Grant Surrender Doc. Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //If Budget is annual then change the Last day
                               IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               //The GL Account
                                BudgetGL:=GrantLine."Account No:";
        
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",GrantLine."Shortcut Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",GrantLine."Shortcut Dimension 2 Code");
                               Budget.SETRANGE(Budget."Dimension 3 Value Code",GrantLine."Shortcut Dimension 3 Code");
                               Budget.SETRANGE(Budget."Dimension 4 Value Code",GrantLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",GrantLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",GrantLine."Shortcut Dimension 2 Code");
                            Actuals.SETRANGE(Actuals."Dimension 3 Value Code",GrantLine."Shortcut Dimension 3 Code");
                            Actuals.SETRANGE(Actuals."Dimension 4 Value Code",GrantLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF GrantLine."Shortcut Dimension 1 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",GrantLine."Shortcut Dimension 1 Code");
                                IF GrantLine."Shortcut Dimension 2 Code" <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",GrantLine."Shortcut Dimension 2 Code");
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",GrantLine."Shortcut Dimension 1 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",GrantLine."Shortcut Dimension 2 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",GrantLine."Shortcut Dimension 3 Code");
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",GrantLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + GrantLine."Amount LCY"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              GrantLine."Surrender Doc No.",'Grant' ,GrantLine."Surrender Doc No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + GrantLine."Amount LCY"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + GrantLine."Amount LCY"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+GrantLine."Amount LCY")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                Commitments.RESET;
                                Commitments.INIT;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=TODAY;
                                Commitments."Posting Date":=GrantHeader."Grant Surrender Doc. Date";
                                Commitments."Document Type":=Commitments."Document Type"::StaffSurrender;
                                Commitments."Document No.":=GrantHeader.No;
                                Commitments.Amount:=GrantLine."Amount LCY";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=TRUE;
                                Commitments."Committed By":=USERID;
                                Commitments."Committed Date":=GrantHeader."Grant Surrender Doc. Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=TIME;
                               // Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=GrantLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=GrantLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=GrantLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=GrantLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=GrantHeader."Account Type";
                                Commitments."Vendor/Cust No.":=GrantHeader."Grant Partner Account No.";
                                Commitments."Budget Check Criteria":=BCSetup."Budget Check Criteria";
                                Commitments."Actual Source":=BCSetup."Actual Source";
                                Commitments.INSERT;
                                //Tag the Grant Surrender Line as Committed
                                  GrantLine.Committed:=TRUE;
                                  GrantLine.MODIFY;
                                //End Tagging Grant Surrender Lines as Committed
                            END;
        
                  UNTIL GrantLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        */

    end;


    procedure CheckGrantsBudget()
    var
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "Analysis View Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        /*
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.RESET;
        BCSetup.GET();
        IF BCSetup.Mandatory THEN//budgetary control is mandatory
          BEGIN
            //check if the dates are within the specified range in relation to the payment header table
            IF (PaymentHeader."Starting Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Grant Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Starting Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PaymentHeader."Starting Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In TheGrant Does Not Fall Within Budget Dates %2 - %3',PaymentHeader."Starting Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             IF Commitments.FIND('+') THEN
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PayLine.RESET;
              PayLine.SETRANGE(PayLine."Grant No.",PaymentHeader."No.");
              PayLine.SETRANGE(PayLine.Type,PayLine.Type::"2");
              PayLine.SETRANGE(PayLine."Budget Controlled",TRUE);
              IF PayLine.FINDFIRST THEN
                BEGIN
                  REPEAT
                               //Get Dimensions from Job Tasks
                               DimCode1:=''; DimCode2:='';
                               JobTaskLine.RESET;
                               JobTaskLine.SETRANGE(JobTaskLine."Grant No.",PayLine."Grant No.");
                               JobTaskLine.SETRANGE(JobTaskLine."Grant Task No.",PayLine."Grant Task No.");
                               IF JobTaskLine.FIND('-') THEN BEGIN
                                 DimCode1:=JobTaskLine."Global Dimension 1 Code"; DimCode2:=JobTaskLine."Global Dimension 2 Code";
                               END;
                               //End;
                               //check the votebook now
                               FirstDay:=DMY2DATE(1,DATE2DMY(PaymentHeader."Starting Date",2),DATE2DMY(PaymentHeader."Starting Date",3));
                               CurrMonth:=DATE2DMY(PaymentHeader."Starting Date",2);
                               IF CurrMonth=12 THEN
                                BEGIN
                                  LastDay:=DMY2DATE(1,1,DATE2DMY(PaymentHeader."Starting Date",3) +1);
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END
                               ELSE
                                BEGIN
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=DMY2DATE(1,CurrMonth,DATE2DMY(PaymentHeader."Starting Date",3));
                                  LastDay:=CALCDATE('-1D',LastDay);
                                END;
        
                               //If Budget is annual then change the Last day
                               IF BCSetup."Budget Check Criteria"=BCSetup."Budget Check Criteria"::"Whole Year" THEN
                                   LastDay:=BCSetup."Current Budget End Date";
        
                               BudgetGL:=PayLine."No.";
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                               Budget.SETRANGE(Budget."Dimension 1 Value Code",DimCode1);
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",DimCode2);
                               //Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                               //Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                          //Separate Analysis View and G/L Entry
                            IF BCSetup."Actual Source"=BCSetup."Actual Source"::"Analysis View Entry" THEN BEGIN
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",DimCode1);
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",DimCode2);
                            //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                            END ELSE BEGIN
                                GLAccount.RESET;
                                GLAccount.SETRANGE(GLAccount."No.",BudgetGL);
                                GLAccount.SETRANGE(GLAccount."Date Filter",BCSetup."Current Budget Start Date",LastDay);
                                IF DimCode1 <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 1 Filter",DimCode1);
                                IF DimCode2 <> '' THEN
                                  GLAccount.SETRANGE(GLAccount."Global Dimension 2 Filter",DimCode2);
                                IF GLAccount.FIND('-') THEN BEGIN
                                 GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                                 ActualsAmount:=GLAccount."Net Change";
                                END;
                            END;
        
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.RESET;
                            Commitments.SETCURRENTKEY(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SETRANGE(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SETRANGE(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SETRANGE(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",DimCode1);
                            Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",DimCode2);
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                               Commitments.CALCSUMS(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
        
                           //check if there is any budget
                           IF (BudgetAmount<=0) AND NOT (BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('No Budget To Check Against');
                           END ELSE BEGIN
                            IF (BudgetAmount<=0) THEN BEGIN
                             IF NOT CONFIRM(Text0003,TRUE) THEN BEGIN
                                ERROR('Budgetary Checking Process Aborted');
                             END;
                            END;
                           END;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           IF ((CommitmentAmount + PayLine."Total Cost (LCY)"+ActualsAmount)>BudgetAmount )
                           AND NOT ( BCSetup."Allow OverExpenditure") THEN  BEGIN
                              ERROR('The Amount in Grant No %1  %2 %3  Exceeds The Budget By %4',
                              PayLine."Grant No.",PayLine.Type ,PayLine."No.",
                                FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Total Cost (LCY)"))));
                            END ELSE BEGIN
                            //ADD A CONFIRMATION TO ALLOW USER TO DECIDE WHETHER TO CONTINUE
                                IF ((CommitmentAmount + PayLine."Total Cost (LCY)"+ ActualsAmount)>BudgetAmount) THEN BEGIN
                                    IF NOT CONFIRM(Text0001+
                                    FORMAT(ABS(BudgetAmount-(CommitmentAmount + ActualsAmount+PayLine."Total Cost (LCY)")))
                                    +Text0002,TRUE) THEN BEGIN
                                       ERROR('Budgetary Checking Process Aborted');
                                    END;
                                END;
        
                                //Tag the Payment Line as Committed
                                  PayLine."Budget Availability Checked":=TRUE;
                                  PayLine."Budget Available":=BudgetAmount-(CommitmentAmount + ActualsAmount);
                                  PayLine.MODIFY;
        
        
                                //End Tagging Payment Lines as Committed
                            END;
        
                  UNTIL PayLine.NEXT=0;
                END;
          END
        ELSE//budget control not mandatory
          BEGIN
        
          END;
        MESSAGE('Budgetary Checking Completed Successfully');
        */

    end;


    procedure GetLineAmountToReverse(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;DocNo: Code[20];DocLineNo: Integer) TotalAmount: Decimal
    var
        LPO: Record "Purchase Line";
        QtyToInvoice: Decimal;
    begin
        if DocumentType=Documenttype::LPO  then begin
            LPO.Reset;
            LPO.SetRange(LPO."Document Type",LPO."document type"::Order);
            LPO.SetRange(LPO."Document No.",DocNo);
            LPO.SetRange(LPO."Line No.",DocLineNo);
            if LPO.Find('-') then begin
              //Take care of reversal which might not
                 if  LPO."Qty. to Invoice"<>0 then
                   QtyToInvoice:=LPO."Qty. to Invoice"
                   else
                      QtyToInvoice:=LPO."Outstanding Quantity";

                  if LPO."VAT %"=0 then
                  TotalAmount:=QtyToInvoice*LPO."Direct Unit Cost"
                    else
                       TotalAmount:=(QtyToInvoice*LPO."Direct Unit Cost")*((LPO."VAT %"+100)/100)

            end;
        end;
    end;


    procedure ReverseOrderEntriesFromInvoice(DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance;DocNo: Code[20];LineNo: Integer;Amount: Decimal)
    var
        Commitments: Record UnknownRecord61722;
        EntryNo: Integer;
        CommittedLines: Record UnknownRecord61722;
    begin
        //Get Commitment Lines
        Commitments.Reset;
         if Commitments.Find('+') then
            EntryNo:=Commitments."Line No.";

        CommittedLines.Reset;
        CommittedLines.SetRange(CommittedLines."Document Type",DocumentType);
        CommittedLines.SetRange(CommittedLines."Document No.",DocNo);
        CommittedLines.SetRange(CommittedLines."Document Line No.",LineNo);
        CommittedLines.SetRange(CommittedLines.Committed,true);
        if CommittedLines.Find('-') then begin
           repeat
             Commitments.Reset;
             Commitments.Init;
             EntryNo+=1;
             Commitments."Line No.":=EntryNo;
             Commitments.Date:=Today;
             Commitments."Posting Date":=CommittedLines."Posting Date";
             Commitments."Document Type":=CommittedLines."Document Type";
             Commitments."Document No.":=CommittedLines."Document No.";
             Commitments.Amount:=-Amount;
             Commitments."Month Budget":=CommittedLines."Month Budget";
             Commitments."Month Actual":=CommittedLines."Month Actual";
             Commitments.Committed:=false;
             Commitments."Committed By":=UserId;
             Commitments."Committed Date":=CommittedLines."Committed Date";
             Commitments."G/L Account No.":=CommittedLines."G/L Account No.";
             Commitments."Committed Time":=Time;
             //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
             Commitments."Shortcut Dimension 1 Code":=CommittedLines."Shortcut Dimension 1 Code";
             Commitments."Shortcut Dimension 2 Code":=CommittedLines."Shortcut Dimension 2 Code";
             Commitments."Shortcut Dimension 3 Code":=CommittedLines."Shortcut Dimension 3 Code";
             Commitments."Shortcut Dimension 4 Code":=CommittedLines."Shortcut Dimension 4 Code";
             Commitments.Budget:=CommittedLines.Budget;
             Commitments."Document Line No.":=CommittedLines."Document Line No.";
             Commitments."Budget Check Criteria":=CommittedLines."Budget Check Criteria";
             Commitments."Actual Source":=CommittedLines."Actual Source";
             Commitments.Insert;

           until CommittedLines.Next=0;
        end;
    end;


    procedure ReverseOrdersReversal("No.": Code[20])
    var
        PurchLines: Record "Purchase Line";
        DocumentType: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance;
        PurchRecptLines: Record "Purch. Rcpt. Line";
        DeleteCommitment: Record UnknownRecord61722;
    begin
         PurchLines.Reset;
         PurchLines.SetRange(PurchLines."Document Type",PurchLines."document type"::Invoice);
         PurchLines.SetRange(PurchLines."Document No.","No.");
         if PurchLines.Find('-') then begin
           repeat
               if PurchLines.Type<>PurchLines.Type::" " then begin
                //Get Details of Order from Receipt lines
                PurchRecptLines.Reset;
                PurchRecptLines.SetRange(PurchRecptLines."Document No.",PurchLines."Receipt No.");
                PurchRecptLines.SetRange(PurchRecptLines."Line No.",PurchLines."Receipt Line No.");
                if PurchRecptLines.Find('-') then begin
                    DeleteCommitment.Reset;
                    DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::LPO);
                    DeleteCommitment.SetRange(DeleteCommitment."Document No.",PurchRecptLines."Order No.");
                    DeleteCommitment.SetRange(DeleteCommitment."Document Line No.",PurchRecptLines."Order Line No.");
                    DeleteCommitment.SetRange(DeleteCommitment.Committed,false);
                    DeleteCommitment.DeleteAll;

                end;
               end;
           until PurchLines.Next=0;
         end;
    end;


    procedure CheckPurchaseGlobal(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        "G/L Entry": Record "G/L Entry";
    begin
        //First Update Analysis View
        //UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            /* Commented to allow commitment to prev. budget
            IF (PurchHeader."Document Date"< BCSetup."Current Budget Start Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              END
            ELSE IF (PurchHeader."Document Date">BCSetup."Current Budget End Date") THEN
              BEGIN
                ERROR('The Current Date %1 In The Order Does Not Fall Within Budget Dates %2 - %3',PurchHeader."Document Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              END;
              */
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
            //Get Commitment Lines
                 if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              PurchLine.Reset;
              PurchLine.SetRange(PurchLine."Document Type",PurchHeader."Document Type");
              PurchLine.SetRange(PurchLine."Document No.",PurchHeader."No.");
              if PurchLine.FindFirst then
                begin
                  repeat
        
                 //Get the Dimension Here
                   if PurchLine."Line No." <> 0 then
                        //DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(
                        //  DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",
                        //  PurchLine."Line No.",ShortcutDimCode)
                      //ELSE
        //                DimMgt.ClearDimSetFilter(ShortcutDimCode);
                 //Had to be put here for the sake of Calculating Individual Line Entries
        
                    //check the type of account in the payments line
                    //Item
                      if PurchLine.Type=PurchLine.Type::Item then begin
                          Item.Reset;
                          if not Item.Get(PurchLine."No.") then
                             Error('Item Does not Exist');
        
                          Item.TestField("Item G/L Budget Account");
                          BudgetGL:=Item."Item G/L Budget Account";
                       end;
                      //  MESSAGE('FOUND');
                       if PurchLine.Type=PurchLine.Type::"Fixed Asset" then begin
                               FixedAssetsDet.Reset;
                               FixedAssetsDet.SetRange(FixedAssetsDet."No.",PurchLine."No.");
                                 if FixedAssetsDet.Find('-') then begin
                                     FAPostingGRP.Reset;
                                     FAPostingGRP.SetRange(FAPostingGRP.Code,FixedAssetsDet."FA Posting Group");
                                     if FAPostingGRP.Find('-') then
                                       if PurchLine."FA Posting Type"=PurchLine."fa posting type"::Maintenance then
                                        begin
                                          // BudgetGL:=FAPostingGRP."Maintenance Expense Account";
                                          BudgetGL:= FixedAssetsDet."Asset G/L Budget Account";
                                             if BudgetGL ='' then
                                               Error('Ensure Fixed Asset No %1 has the Maintenance G/L Account',PurchLine."No.");
                                       end else begin
                                       BudgetGL:= FixedAssetsDet."Asset G/L Budget Account";
                                           //BudgetGL:=FAPostingGRP."Acquisition Cost Account";
                                              if BudgetGL ='' then
                                                 Error('Ensure Fixed Asset No %1 has the Acquisition G/L Account',PurchLine."No.");
                                        end;
                                 end;
                       end;
        
                       if PurchLine.Type=PurchLine.Type::"G/L Account" then begin
                          BudgetGL:=PurchLine."No.";
                         // IF GLAcc.GET(PurchLine."No.") THEN
                             //GLAcc.TESTFIELD("Vote Book Entry",TRUE);
                       end;
        
                    //End Checking Account in Payment Line
        
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(PurchHeader."Document Date",2),Date2dmy(PurchHeader."Document Date",3));
                               CurrMonth:=Date2dmy(PurchHeader."Document Date",2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(PurchHeader."Document Date",3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(PurchHeader."Document Date",3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
                               //check the summation of the budget in the database
        
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetFilter(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                               Budget.SetRange(Budget."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                               if PurchHeader."Purchase Type"<>PurchHeader."purchase type"::Global then
                               Budget.SetRange(Budget."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                              // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 if Budget.Find('-') then begin
                                 repeat
                                  BudgetAmount:=BudgetAmount+Budget.Amount;
                                 until Budget.Next=0;
                                 end;
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            "G/L Entry".Reset;
                            "G/L Entry".SetRange("G/L Entry"."G/L Account No.",BudgetGL);
                            "G/L Entry".SetRange("G/L Entry"."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                            "G/L Entry".SetRange("G/L Entry"."Global Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            if PurchHeader."Purchase Type"<>PurchHeader."purchase type"::Global then
                            "G/L Entry".SetRange("G/L Entry"."Global Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                            if "G/L Entry".Find('-') then begin
                            repeat
                            ActualsAmount:=ActualsAmount+"G/L Entry".Amount;
                            until "G/L Entry".Next=0;
                            end;
                               /*
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                              // Budget.SETRANGE(Budget."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                               //Budget.SETRANGE(Budget."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                             //  Budget.SETRANGE(Budget."Dimension 3 Value Code",ShortcutDimCode[3]);
                             //  Budget.SETRANGE(Budget."Dimension 4 Value Code",ShortcutDimCode[4]);
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
                                 //  MESSAGE(FORMAT(Budget.Amount));
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            //Actuals.SETRANGE(Actuals."Dimension 1 Value Code",PurchLine."Shortcut Dimension 1 Code");
                           // Actuals.SETRANGE(Actuals."Dimension 2 Value Code",PurchLine."Shortcut Dimension 2 Code");
                            //Actuals.SETRANGE(Actuals."Dimension 3 Value Code",ShortcutDimCode[3]);
                            //Actuals.SETRANGE(Actuals."Dimension 4 Value Code",ShortcutDimCode[4]);
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                             */
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 1 Code");
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code",PurchLine."Shortcut Dimension 2 Code");
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",ShortcutDimCode[3]);
                            //Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",ShortcutDimCode[4]);
                                Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) then
                            begin
                              Error('No Budget To Check Against');
                            end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if (CommitmentAmount + PurchLine."Outstanding Amount (LCY)")>BudgetAmount then
                            begin
                             if PurchHeader."Allow Over Expenditure"=false then
                              Error('The Amount On Order No %1  %2 %3  Exceeds The Budget By %4',
                              PurchLine."Document No.",PurchLine.Type ,PurchLine."No.",
                                Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+PurchLine."Outstanding Amount (LCY)"))));
                            end else begin
        
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=PurchHeader."Posting Date";
                                Commitments."Posting Date":=PurchHeader."Document Date";
                                if PurchHeader.DocApprovalType=PurchHeader.Docapprovaltype::Purchase then
                                    Commitments."Document Type":=Commitments."document type"::LPO
                                else
                                    Commitments."Document Type":=Commitments."document type"::LPO;
        
                                if PurchHeader."Document Type"=PurchHeader."document type"::Invoice then
                                    Commitments."Document Type":=Commitments."document type"::PettyCash;
        
                                Commitments."Document No.":=PurchHeader."No.";
                                Commitments.Amount:=PurchLine."Outstanding Amount (LCY)";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=PurchHeader."Document Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                               // Commitments."Shortcut Dimension 1 Code":=PurchLine."Shortcut Dimension 1 Code";
                               // Commitments."Shortcut Dimension 2 Code":=PurchLine."Shortcut Dimension 2 Code";
                               // Commitments."Shortcut Dimension 3 Code":=ShortcutDimCode[3];
                                //Commitments."Shortcut Dimension 4 Code":=ShortcutDimCode[4];
                                Commitments.Budget:=BCSetup."Current Budget Code";
                                Commitments.Type:=Commitments.Type::Vendor;
                                Commitments."Vendor/Cust No.":=PurchHeader."Buy-from Vendor No.";
                                Commitments.Insert;
                                //Tag the Purchase Line as Committed
                                  PurchLine.Committed:=true;
                                  PurchLine.Modify;
                                //End Tagging PurchLines as Committed
                            end;
        
                  until PurchLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        
        PurchHeader.Reset;
        PurchHeader.SetRange(PurchHeader."No.",PurchLine."Document No.");
        if PurchHeader.Find('-') then begin
        PurchHeader."Budgeted Amount":=BudgetAmount;
        PurchHeader."Actual Expenditure":=ActualsAmount;
        PurchHeader."Committed Amount":=CommitmentAmount;
        PurchHeader."Budget Balance":=BudgetAmount-(ActualsAmount+CommitmentAmount+PurchHeader.Amount);
        PurchHeader.Modify;
        end;

    end;


    procedure CheckSRN(var ReqHeader: Record UnknownRecord61399)
    var
        SRNLine: Record UnknownRecord61724;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        "G/L Entry": Record "G/L Entry";
    begin
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ReqHeader."Request date"< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3',ReqHeader."Request date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ReqHeader."Request date">BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3',ReqHeader."Request date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              SRNLine.Reset;
              SRNLine.SetRange(SRNLine."Requistion No",ReqHeader."No.");
             // SRNLine.SETRANGE(SRNLine."Budgetary Control A/C",TRUE);
              if SRNLine.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ReqHeader."Request date",2),Date2dmy(ReqHeader."Request date",3));
                               CurrMonth:=Date2dmy(ReqHeader."Request date",2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ReqHeader."Request date",3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ReqHeader."Request date",3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
        
                               //The GL Account
                              //  if SRNLine.Type=SRNLine.Type::item then
                                if Item.Get(SRNLine."No.") then begin
                                Item.TestField(Item."Item G/L Budget Account");
                                BudgetGL:=Item."Item G/L Budget Account";
                                end;
        
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetFilter(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                             //  Budget.SETRANGE(Budget."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                               Budget.SetRange(Budget."Global Dimension 2 Code",SRNLine."Shortcut Dimension 2 Code");
                              // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 if Budget.Find('-') then begin
                                 repeat
                                  BudgetAmount:=BudgetAmount+Budget.Amount;
                                 until Budget.Next=0;
                                 end;
                              //  error(format(Budgetamount));
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            "G/L Entry".Reset;
                            "G/L Entry".SetRange("G/L Entry"."G/L Account No.",BudgetGL);
                            "G/L Entry".SetRange("G/L Entry"."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                           // "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                            "G/L Entry".SetRange("G/L Entry"."Global Dimension 2 Code",SRNLine."Shortcut Dimension 2 Code");
                            if "G/L Entry".Find('-') then begin
                            repeat
                            ActualsAmount:=ActualsAmount+"G/L Entry".Amount;
                            until "G/L Entry".Next=0;
                            end;
                              /*
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             //  Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                             //  Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",SRNLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                           // Actuals.SETRANGE(Actuals."Dimension 3 Value Code",SRNLine."Shortcut Dimension 3 Code");
                           // Actuals.SETRANGE(Actuals."Dimension 4 Value Code",SRNLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                          */
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          //  Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",SRNLine."Shortcut Dimension 2 Code");
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                                Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) then
                            begin
                              Error('No Budget To Check Against');
                            end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if (CommitmentAmount + SRNLine."Line Amount")>BudgetAmount then
                            begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              SRNLine."Requistion No",'SRN' ,SRNLine."No.",
                                Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+SRNLine."Line Amount"))));
                            end else begin
        
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ReqHeader."Request date";
                                Commitments."Document Type":=Commitments."document type"::SRN;
                                Commitments."Document No.":=ReqHeader."No.";
                                Commitments.Amount:=SRNLine."Line Amount";
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ReqHeader."Request date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                Commitments."Shortcut Dimension 1 Code":=SRNLine."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=SRNLine."Shortcut Dimension 2 Code";
                                Commitments."Shortcut Dimension 3 Code":=SRNLine."Shortcut Dimension 3 Code";
                                Commitments."Shortcut Dimension 4 Code":=SRNLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                               // Commitments.Type:=Commitments.Type::item;
                                Commitments."Vendor/Cust No.":=SRNLine."Requistion No";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  SRNLine.Committed:=true;
                                  SRNLine.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;
        
                  until SRNLine.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        Message('Budgetary Checking Completed Successfully');
        
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."No.",SRNLine."Requistion No");
        if ReqHeader.Find('-') then begin
        ReqHeader."Budgeted Amount":=BudgetAmount;
        ReqHeader."Actual Expenditure":=ActualsAmount;
        ReqHeader."Committed Amount":=CommitmentAmount;
        ReqHeader.CalcFields(Amount);
        ReqHeader."Budget Balance":=BudgetAmount-CommitmentAmount;//(ActualsAmount+CommitmentAmount+ReqHeader.Amount);
        ReqHeader.Modify;
        end;

    end;


    procedure CheckMeal(var ReqHeader: Record UnknownRecord61778)
    var
        Mline: Record UnknownRecord61779;
        Commitments: Record UnknownRecord61722;
        Amount: Decimal;
        GLAcc: Record "G/L Account";
        Item: Record Item;
        FirstDay: Date;
        LastDay: Date;
        CurrMonth: Integer;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        Actuals: Record "Analysis View Entry";
        ActualsAmount: Decimal;
        CommitmentAmount: Decimal;
        FixedAssetsDet: Record "Fixed Asset";
        FAPostingGRP: Record "FA Posting Group";
        EntryNo: Integer;
        "G/L Entry": Record "G/L Entry";
    begin
        //First Update Analysis View
        UpdateAnalysisView();
        
        //get the budget control setup first to determine if it mandatory or not
        BCSetup.Reset;
        BCSetup.Get();
        if BCSetup.Mandatory then//budgetary control is mandatory
          begin
            //check if the dates are within the specified range in relation to the payment header table
            if (ReqHeader."Request Date"< BCSetup."Current Budget Start Date") then
              begin
                Error('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3',ReqHeader."Request Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
              end
            else if (ReqHeader."Request Date">BCSetup."Current Budget End Date") then
              begin
                Error('The Current Date %1 for the SRN Does Not Fall Within Budget Dates %2 - %3',ReqHeader."Request Date",
                BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
        
              end;
            //Is budget Available
            CheckIfBlocked(BCSetup."Current Budget Code");
        
            //Get Commitment Lines
             if Commitments.Find('+') then
                EntryNo:=Commitments."Line No.";
        
            //get the lines related to the payment header
              Mline.Reset;
              Mline.SetRange(Mline."Booking Id",ReqHeader."Booking Id");
             // SRNLine.SETRANGE(SRNLine."Budgetary Control A/C",TRUE);
              if Mline.FindFirst then
                begin
                  repeat
                               //check the votebook now
                               FirstDay:=Dmy2date(1,Date2dmy(ReqHeader."Request Date",2),Date2dmy(ReqHeader."Request Date",3));
                               CurrMonth:=Date2dmy(ReqHeader."Request Date",2);
                               if CurrMonth=12 then
                                begin
                                  LastDay:=Dmy2date(1,1,Date2dmy(ReqHeader."Request Date",3) +1);
                                  LastDay:=CalcDate('-1D',LastDay);
                                end
                               else
                                begin
                                  CurrMonth:=CurrMonth +1;
                                  LastDay:=Dmy2date(1,CurrMonth,Date2dmy(ReqHeader."Request Date",3));
                                  LastDay:=CalcDate('-1D',LastDay);
                                end;
        
                               //The GL Account
                              //  if SRNLine.Type=SRNLine.Type::item then
                                if Item.Get(Mline."Meal Code") then begin
                                Item.TestField(Item."Item G/L Budget Account");
                                BudgetGL:=Item."Item G/L Budget Account";
                                end;
        
                               BudgetAmount:=0;
                               Budget.Reset;
                               Budget.SetRange(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SetFilter(Budget.Date,'%1..%2',BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                               Budget.SetRange(Budget."G/L Account No.",BudgetGL);
                               Budget.SetRange(Budget."Global Dimension 1 Code",'MAIN');
                               Budget.SetRange(Budget."Global Dimension 2 Code",Mline.Department);
                              // Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                 if Budget.Find('-') then begin
                                 repeat
                                  BudgetAmount:=BudgetAmount+Budget.Amount;
                                 until Budget.Next=0;
                                 end;
                              //  error(format(Budgetamount));
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            "G/L Entry".Reset;
                            "G/L Entry".SetRange("G/L Entry"."G/L Account No.",BudgetGL);
                            "G/L Entry".SetRange("G/L Entry"."Posting Date",BCSetup."Current Budget Start Date",BCSetup."Current Budget End Date");
                           // "G/L Entry".SETRANGE("G/L Entry"."Global Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                            "G/L Entry".SetRange("G/L Entry"."Global Dimension 2 Code",Mline.Department);
                            if "G/L Entry".Find('-') then begin
                            repeat
                            ActualsAmount:=ActualsAmount+"G/L Entry".Amount;
                            until "G/L Entry".Next=0;
                            end;
                              /*
                               //check the summation of the budget in the database
                               BudgetAmount:=0;
                               Budget.RESET;
                               Budget.SETCURRENTKEY(Budget."Budget Name",Budget."Posting Date",Budget."G/L Account No.",
                               Budget."Dimension 1 Value Code",Budget."Dimension 2 Value Code",Budget."Dimension 3 Value Code",
                               Budget."Dimension 4 Value Code");
                               Budget.SETRANGE(Budget."Budget Name",BCSetup."Current Budget Code");
                               Budget.SETRANGE(Budget."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                               Budget.SETRANGE(Budget."G/L Account No.",BudgetGL);
                             //  Budget.SETRANGE(Budget."Dimension 1 Value Code",PayLine."Global Dimension 1 Code");
                               Budget.SETRANGE(Budget."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                             //  Budget.SETRANGE(Budget."Dimension 3 Value Code",PayLine."Shortcut Dimension 3 Code");
                            //   Budget.SETRANGE(Budget."Dimension 4 Value Code",PayLine."Shortcut Dimension 4 Code");
                                   Budget.CALCSUMS(Budget.Amount);
                                   BudgetAmount:= Budget.Amount;
        
                          //get the summation on the actuals
                            ActualsAmount:=0;
                            Actuals.RESET;
                            Actuals.SETCURRENTKEY(Actuals."Analysis View Code",Actuals."Dimension 1 Value Code",
                            Actuals."Dimension 2 Value Code",Actuals."Dimension 3 Value Code",Actuals."Dimension 4 Value Code",
                            Actuals."Posting Date",Actuals."Account No.");
                            Actuals.SETRANGE(Actuals."Analysis View Code",BCSetup."Analysis View Code");
                            Actuals.SETRANGE(Actuals."Dimension 1 Value Code",SRNLine."Shortcut Dimension 1 Code");
                            Actuals.SETRANGE(Actuals."Dimension 2 Value Code",SRNLine."Shortcut Dimension 2 Code");
                           // Actuals.SETRANGE(Actuals."Dimension 3 Value Code",SRNLine."Shortcut Dimension 3 Code");
                           // Actuals.SETRANGE(Actuals."Dimension 4 Value Code",SRNLine."Shortcut Dimension 4 Code");
                            Actuals.SETRANGE(Actuals."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                            Actuals.SETRANGE(Actuals."Account No.",BudgetGL);
                               Actuals.CALCSUMS(Actuals.Amount);
                               ActualsAmount:= Actuals.Amount;
                          */
                          //get the committments
                            CommitmentAmount:=0;
                            Commitments.Reset;
                            Commitments.SetCurrentkey(Commitments.Budget,Commitments."G/L Account No.",
                            Commitments."Posting Date",Commitments."Shortcut Dimension 1 Code",Commitments."Shortcut Dimension 2 Code",
                            Commitments."Shortcut Dimension 3 Code",Commitments."Shortcut Dimension 4 Code");
                            Commitments.SetRange(Commitments.Budget,BCSetup."Current Budget Code");
                            Commitments.SetRange(Commitments."G/L Account No.",BudgetGL);
                            Commitments.SetRange(Commitments."Posting Date",BCSetup."Current Budget Start Date",LastDay);
                          //  Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code",SRNLine."Global Dimension 1 Code");
                            Commitments.SetRange(Commitments."Shortcut Dimension 2 Code",Mline.Department);
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 3 Code",PayLine."Shortcut Dimension 3 Code");
                           // Commitments.SETRANGE(Commitments."Shortcut Dimension 4 Code",PayLine."Shortcut Dimension 4 Code");
                                Commitments.SetRange(Committed,true);
                             if Commitments.FindFirst then begin
                               repeat
                               Commitments.CalcSums(Commitments.Amount);
                               CommitmentAmount:= Commitments.Amount;
                              until Commitments.Next=0;
                              end;
                           //check if there is any budget
                           if (BudgetAmount<=0) then
                            begin
                              Error('No Budget To Check Against');
                            end;
        
                           //check if the actuals plus the amount is greater then the budget amount
                           if (CommitmentAmount + Mline.Cost)>BudgetAmount then
                            begin
                              Error('The Amount Voucher No %1  %2 %3  Exceeds The Budget By %4',
                              Mline."Booking Id",'SRN' ,Mline."Booking Id",
                                Format(Abs(BudgetAmount-(CommitmentAmount + ActualsAmount+Mline.Cost))));
                            end else begin
        
                                Commitments.Reset;
                                Commitments.Init;
                                EntryNo+=1;
                                Commitments."Line No.":=EntryNo;
                                Commitments.Date:=Today;
                                Commitments."Posting Date":=ReqHeader."Request Date";
                                Commitments."Document Type":=Commitments."document type"::Meal;
                                Commitments."Document No.":=ReqHeader."Booking Id";
                                Commitments.Amount:=Mline.Cost;
                                Commitments."Month Budget":=BudgetAmount;
                                Commitments."Month Actual":=ActualsAmount;
                                Commitments.Committed:=true;
                                Commitments."Committed By":=UserId;
                                Commitments."Committed Date":=ReqHeader."Request Date";
                                Commitments."G/L Account No.":=BudgetGL;
                                Commitments."Committed Time":=Time;
                                //Commitments."Committed Machine":=ENVIRON('COMPUTERNAME');
                                //Commitments."Shortcut Dimension 1 Code":=mline."Shortcut Dimension 1 Code";
                                Commitments."Shortcut Dimension 2 Code":=Mline.Department;
                                //Commitments."Shortcut Dimension 3 Code":=SRNLine."Shortcut Dimension 3 Code";
                                //Commitments."Shortcut Dimension 4 Code":=SRNLine."Shortcut Dimension 4 Code";
                                Commitments.Budget:=BCSetup."Current Budget Code";
                               // Commitments.Type:=Commitments.Type::item;
                                Commitments."Vendor/Cust No.":=Mline."Booking Id";
                                Commitments.Insert;
                                //Tag the Imprest Line as Committed
                                  Mline.Commited:=true;
                                  Mline.Modify;
                                //End Tagging Imprest Lines as Committed
                            end;
        
                  until Mline.Next=0;
                end;
          end
        else//budget control not mandatory
          begin
        
          end;
        Message('Budgetary Checking Completed Successfully');
        
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Booking Id",Mline."Booking Id");
        if ReqHeader.Find('-') then begin
        ReqHeader."Budgeted Amount":=BudgetAmount;
        ReqHeader."Actual Expenditure":=ActualsAmount;
        ReqHeader."Committed Amount":=CommitmentAmount;
        ReqHeader.CalcFields("Total Cost");
        ReqHeader."Budget Balance":=BudgetAmount-CommitmentAmount;//(ActualsAmount+CommitmentAmount+ReqHeader."Total Cost");
        ReqHeader.Modify;
        end;

    end;
}


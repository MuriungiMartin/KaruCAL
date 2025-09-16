#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1720 "Deferral Utilities"
{

    trigger OnRun()
    begin
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        DeferralHeader: Record "Deferral Header";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        AmountRoundingPrecision: Decimal;
        InvalidPostingDateErr: label '%1 is not within the range of posting dates for your company.', Comment='%1=The date passed in for the posting date.';
        DeferSchedOutOfBoundsErr: label 'The deferral schedule falls outside the accounting periods that have been set up for the company.';
        SelectDeferralCodeMsg: label 'A deferral code must be selected for the line to view the deferral schedule.';


    procedure CreateRecurringDescription(PostingDate: Date;Description: Text[50]) FinalDescription: Text[50]
    var
        Day: Integer;
        Week: Integer;
        Month: Integer;
        Year: Integer;
        MonthText: Text[30];
    begin
        Day := Date2dmy(PostingDate,1);
        Week := Date2dwy(PostingDate,2);
        Month := Date2dmy(PostingDate,2);
        MonthText := Format(PostingDate,0,'<Month Text>');
        Year := Date2dmy(PostingDate,3);
        AccountingPeriod.SetRange("Starting Date",0D,PostingDate);
        if not AccountingPeriod.FindLast then
          AccountingPeriod.Name := '';
        FinalDescription :=
          CopyStr(StrSubstNo(Description,Day,Week,Month,MonthText,AccountingPeriod.Name,Year),1,MaxStrLen(Description));
    end;


    procedure CreateDeferralSchedule(DeferralCode: Code[10];DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer;AmountToDefer: Decimal;CalcMethod: Option "Straight-Line","Equal per Period","Days per Period","User-Defined";StartDate: Date;NoOfPeriods: Integer;ApplyDeferralPercentage: Boolean;DeferralDescription: Text[50];AdjustStartDate: Boolean;CurrencyCode: Code[10])
    var
        DeferralTemplate: Record "Deferral Template";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        AdjustedStartDate: Date;
        AdjustedDeferralAmount: Decimal;
    begin
        InitCurrency(CurrencyCode);
        DeferralTemplate.Get(DeferralCode);
        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting
        if AdjustStartDate then
          AdjustedStartDate := SetStartDate(DeferralTemplate,StartDate)
        else
          AdjustedStartDate := StartDate;

        AdjustedDeferralAmount := AmountToDefer;
        if ApplyDeferralPercentage then
          AdjustedDeferralAmount := ROUND(AdjustedDeferralAmount * (DeferralTemplate."Deferral %" / 100),AmountRoundingPrecision);

        SetDeferralRecords(DeferralHeader,DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo,
          CalcMethod,NoOfPeriods,AdjustedDeferralAmount,AdjustedStartDate,
          DeferralCode,DeferralDescription,AmountToDefer,AdjustStartDate,CurrencyCode);

        case CalcMethod of
          Calcmethod::"Straight-Line":
            CalculateStraightline(DeferralHeader,DeferralLine,DeferralTemplate);
          Calcmethod::"Equal per Period":
            CalculateEqualPerPeriod(DeferralHeader,DeferralLine,DeferralTemplate);
          Calcmethod::"Days per Period":
            CalculateDaysPerPeriod(DeferralHeader,DeferralLine,DeferralTemplate);
          Calcmethod::"User-Defined":
            CalculateUserDefined(DeferralHeader,DeferralLine,DeferralTemplate);
        end;
    end;


    procedure CalcDeferralNoOfPeriods(CalcMethod: Option;NoOfPeriods: Integer;StartDate: Date): Integer
    var
        DeferralTemplate: Record "Deferral Template";
        AccountingPeriod: Record "Accounting Period";
    begin
        case CalcMethod of
          DeferralTemplate."calc. method"::"Equal per Period",
          DeferralTemplate."calc. method"::"User-Defined":
            exit(NoOfPeriods);
          DeferralTemplate."calc. method"::"Straight-Line",
          DeferralTemplate."calc. method"::"Days per Period":
            begin
              AccountingPeriod.SetFilter("Starting Date",'>=%1',StartDate);
              AccountingPeriod.FindFirst;
              if AccountingPeriod."Starting Date" = StartDate then
                exit(NoOfPeriods);

              exit(NoOfPeriods + 1);
            end;
        end;

        DeferralTemplate."Calc. Method" := CalcMethod;
        DeferralTemplate.FieldError("Calc. Method");
    end;

    local procedure CalculateStraightline(DeferralHeader: Record "Deferral Header";var DeferralLine: Record "Deferral Line";DeferralTemplate: Record "Deferral Template")
    var
        AmountToDefer: Decimal;
        AmountToDeferFirstPeriod: Decimal;
        FractionOfPeriod: Decimal;
        PeriodicDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
        PeriodicCount: Integer;
        HowManyDaysLeftInPeriod: Integer;
        NumberOfDaysInPeriod: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        PerDiffSum: Decimal;
    begin
        // If the Start Date passed in matches the first date of a financial period, this is essentially the same
        // as the "Equal Per Period" deferral method, so call that function.
        AccountingPeriod.SetFilter("Starting Date",'>=%1',DeferralHeader."Start Date");
        if AccountingPeriod.FindFirst then begin
          if AccountingPeriod."Starting Date" = DeferralHeader."Start Date" then begin
            CalculateEqualPerPeriod(DeferralHeader,DeferralLine,DeferralTemplate);
            exit;
          end
        end else
          Error(DeferSchedOutOfBoundsErr);

        PeriodicDeferralAmount := ROUND(DeferralHeader."Amount to Defer" / DeferralHeader."No. of Periods",AmountRoundingPrecision);

        for PeriodicCount := 1 to (DeferralHeader."No. of Periods" + 1) do begin
          InitializeDeferralHeaderAndSetPostDate(DeferralLine,DeferralHeader,PeriodicCount,PostDate);

          if (PeriodicCount = 1) or (PeriodicCount = (DeferralHeader."No. of Periods" + 1)) then begin
            if PeriodicCount = 1 then begin
              Clear(RunningDeferralTotal);

              // Get the starting date of the accounting period of the posting date is in
              AccountingPeriod.SetFilter("Starting Date",'<%1',PostDate);
              if AccountingPeriod.FindLast then
                FirstPeriodDate := AccountingPeriod."Starting Date"
              else
                Error(DeferSchedOutOfBoundsErr);

              // Get the starting date of the next accounting period
              AccountingPeriod.SetFilter("Starting Date",'>%1',PostDate);
              if AccountingPeriod.FindFirst then
                SecondPeriodDate := AccountingPeriod."Starting Date"
              else
                Error(DeferSchedOutOfBoundsErr);

              HowManyDaysLeftInPeriod := (SecondPeriodDate - DeferralHeader."Start Date");
              NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);
              FractionOfPeriod := (HowManyDaysLeftInPeriod / NumberOfDaysInPeriod);

              AmountToDeferFirstPeriod := (PeriodicDeferralAmount * FractionOfPeriod);
              AmountToDefer := ROUND(AmountToDeferFirstPeriod,AmountRoundingPrecision);
              RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            end else
              // Last period
              AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
          end else begin
            AmountToDefer := ROUND(PeriodicDeferralAmount,AmountRoundingPrecision);
            RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
          end;

          DeferralLine."Posting Date" := PostDate;
          DeferralLine.Description := CreateRecurringDescription(PostDate,DeferralTemplate."Period Description");

          if GenJnlCheckLine.DateNotAllowed(PostDate) then
            Error(InvalidPostingDateErr,PostDate);

          PerDiffSum := PerDiffSum + ROUND(AmountToDefer / DeferralHeader."No. of Periods",AmountRoundingPrecision);

          DeferralLine.Amount := AmountToDefer;

          DeferralLine.Insert;
        end;
    end;

    local procedure CalculateEqualPerPeriod(DeferralHeader: Record "Deferral Header";var DeferralLine: Record "Deferral Line";DeferralTemplate: Record "Deferral Template")
    var
        PeriodicCount: Integer;
        PostDate: Date;
        AmountToDefer: Decimal;
        RunningDeferralTotal: Decimal;
    begin
        for PeriodicCount := 1 to DeferralHeader."No. of Periods" do begin
          InitializeDeferralHeaderAndSetPostDate(DeferralLine,DeferralHeader,PeriodicCount,PostDate);

          DeferralLine.Validate("Posting Date",PostDate);
          DeferralLine.Description := CreateRecurringDescription(PostDate,DeferralTemplate."Period Description");

          AmountToDefer := DeferralHeader."Amount to Defer";
          if PeriodicCount = 1 then
            Clear(RunningDeferralTotal);

          if PeriodicCount <> DeferralHeader."No. of Periods" then begin
            AmountToDefer := ROUND(AmountToDefer / DeferralHeader."No. of Periods",AmountRoundingPrecision);
            RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
          end else
            AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);

          DeferralLine.Amount := AmountToDefer;
          DeferralLine.Insert;
        end;
    end;

    local procedure CalculateDaysPerPeriod(DeferralHeader: Record "Deferral Header";var DeferralLine: Record "Deferral Line";DeferralTemplate: Record "Deferral Template")
    var
        AmountToDefer: Decimal;
        PeriodicCount: Integer;
        NumberOfDaysInPeriod: Integer;
        NumberOfDaysInSchedule: Integer;
        NumberOfDaysIntoCurrentPeriod: Integer;
        NumberOfPeriods: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        EndDate: Date;
        TempDate: Date;
        NoExtraPeriod: Boolean;
        DailyDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
    begin
        AccountingPeriod.SetFilter("Starting Date",'>=%1',DeferralHeader."Start Date");
        if AccountingPeriod.FindFirst then begin
          if AccountingPeriod."Starting Date" = DeferralHeader."Start Date" then
            NoExtraPeriod := true
          else
            NoExtraPeriod := false
        end else
          Error(DeferSchedOutOfBoundsErr);

        // If comparison used <=, it messes up the calculations
        if not NoExtraPeriod then begin
          AccountingPeriod.SetFilter("Starting Date",'<%1',DeferralHeader."Start Date");
          AccountingPeriod.FindLast;

          NumberOfDaysIntoCurrentPeriod := (DeferralHeader."Start Date" - AccountingPeriod."Starting Date");
        end else
          NumberOfDaysIntoCurrentPeriod := 0;

        if NoExtraPeriod then
          NumberOfPeriods := DeferralHeader."No. of Periods"
        else
          NumberOfPeriods := (DeferralHeader."No. of Periods" + 1);

        for PeriodicCount := 1 to NumberOfPeriods do begin
          // Figure out the end date...
          if PeriodicCount = 1 then
            TempDate := DeferralHeader."Start Date";

          if PeriodicCount <> NumberOfPeriods then begin
            AccountingPeriod.SetFilter("Starting Date",'>%1',TempDate);
            if AccountingPeriod.FindFirst then
              TempDate := AccountingPeriod."Starting Date"
            else
              Error(DeferSchedOutOfBoundsErr);
          end else
            // Last Period, special case here...
            if NoExtraPeriod then begin
              AccountingPeriod.SetFilter("Starting Date",'>%1',TempDate);
              if AccountingPeriod.FindFirst then
                TempDate := AccountingPeriod."Starting Date"
              else
                Error(DeferSchedOutOfBoundsErr);
              EndDate := TempDate;
            end else
              EndDate := (TempDate + NumberOfDaysIntoCurrentPeriod);
        end;
        NumberOfDaysInSchedule := (EndDate - DeferralHeader."Start Date");
        DailyDeferralAmount := (DeferralHeader."Amount to Defer" / NumberOfDaysInSchedule);

        for PeriodicCount := 1 to NumberOfPeriods do begin
          InitializeDeferralHeaderAndSetPostDate(DeferralLine,DeferralHeader,PeriodicCount,PostDate);

          if PeriodicCount = 1 then begin
            Clear(RunningDeferralTotal);
            FirstPeriodDate := DeferralHeader."Start Date";

            // Get the starting date of the next accounting period
            AccountingPeriod.SetFilter("Starting Date",'>%1',PostDate);
            AccountingPeriod.FindFirst;
            SecondPeriodDate := AccountingPeriod."Starting Date";
            NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

            AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount,AmountRoundingPrecision);
            RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
          end else begin
            // Get the starting date of the accounting period of the posting date is in
            AccountingPeriod.SetFilter("Starting Date",'<=%1',PostDate);
            AccountingPeriod.FindLast;
            FirstPeriodDate := AccountingPeriod."Starting Date";

            // Get the starting date of the next accounting period
            AccountingPeriod.SetFilter("Starting Date",'>%1',PostDate);
            AccountingPeriod.FindFirst;
            SecondPeriodDate := AccountingPeriod."Starting Date";

            NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

            if PeriodicCount <> NumberOfPeriods then begin
              // Not the last period
              AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount,AmountRoundingPrecision);
              RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            end else
              AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
          end;

          DeferralLine."Posting Date" := PostDate;
          DeferralLine.Description := CreateRecurringDescription(PostDate,DeferralTemplate."Period Description");

          if GenJnlCheckLine.DateNotAllowed(PostDate) then
            Error(InvalidPostingDateErr,PostDate);

          DeferralLine.Amount := AmountToDefer;

          DeferralLine.Insert;
        end;
    end;

    local procedure CalculateUserDefined(DeferralHeader: Record "Deferral Header";var DeferralLine: Record "Deferral Line";DeferralTemplate: Record "Deferral Template")
    var
        PeriodicCount: Integer;
        PostDate: Date;
    begin
        for PeriodicCount := 1 to DeferralHeader."No. of Periods" do begin
          InitializeDeferralHeaderAndSetPostDate(DeferralLine,DeferralHeader,PeriodicCount,PostDate);

          DeferralLine."Posting Date" := PostDate;
          DeferralLine.Description := CreateRecurringDescription(PostDate,DeferralTemplate."Period Description");

          if GenJnlCheckLine.DateNotAllowed(PostDate) then
            Error(InvalidPostingDateErr,PostDate);

          // For User-Defined, user must enter in deferral amounts
          DeferralLine.Insert;
        end;
    end;

    local procedure SetStartDate(DeferralTemplate: Record "Deferral Template";StartDate: Date) AdjustedStartDate: Date
    var
        DeferralStartOption: Option "Posting Date","Beginning of Period","End of Period","Beginning of Next Period";
    begin
        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting;
        case DeferralTemplate."Start Date" of
          Deferralstartoption::"Posting Date":
            AdjustedStartDate := StartDate;
          Deferralstartoption::"Beginning of Period":
            begin
              AccountingPeriod.SetRange("Starting Date",0D,StartDate);
              if AccountingPeriod.FindLast then
                AdjustedStartDate := AccountingPeriod."Starting Date";
            end;
          Deferralstartoption::"End of Period":
            begin
              AccountingPeriod.SetFilter("Starting Date",'>%1',StartDate);
              if AccountingPeriod.FindFirst then
                AdjustedStartDate := CalcDate('<-1D>',AccountingPeriod."Starting Date");
            end;
          Deferralstartoption::"Beginning of Next Period":
            begin
              AccountingPeriod.SetFilter("Starting Date",'>%1',StartDate);
              if AccountingPeriod.FindFirst then
                AdjustedStartDate := AccountingPeriod."Starting Date";
            end;
        end;
    end;


    procedure SetDeferralRecords(var DeferralHeader: Record "Deferral Header";DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer;CalcMethod: Option "Straight-Line","Equal per Period","Days per Period","User-Defined";NoOfPeriods: Integer;AdjustedDeferralAmount: Decimal;AdjustedStartDate: Date;DeferralCode: Code[10];DeferralDescription: Text[50];AmountToDefer: Decimal;AdjustStartDate: Boolean;CurrencyCode: Code[10])
    begin
        if not DeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then begin
          // Need to create the header record.
          DeferralHeader."Deferral Doc. Type" := DeferralDocType;
          DeferralHeader."Gen. Jnl. Template Name" := GenJnlTemplateName;
          DeferralHeader."Gen. Jnl. Batch Name" := GenJnlBatchName;
          DeferralHeader."Document Type" := DocumentType;
          DeferralHeader."Document No." := DocumentNo;
          DeferralHeader."Line No." := LineNo;
          DeferralHeader.Insert;
        end;
        DeferralHeader."Amount to Defer" := AdjustedDeferralAmount;
        if AdjustStartDate then
          DeferralHeader."Initial Amount to Defer" := AmountToDefer;
        DeferralHeader."Calc. Method" := CalcMethod;
        DeferralHeader."Start Date" := AdjustedStartDate;
        DeferralHeader."No. of Periods" := NoOfPeriods;
        DeferralHeader."Schedule Description" := DeferralDescription;
        DeferralHeader."Deferral Code" := DeferralCode;
        DeferralHeader."Currency Code" := CurrencyCode;
        DeferralHeader.Modify;
        // Remove old lines as they will be recalculated/recreated
        RemoveDeferralLines(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo);
    end;


    procedure RemoveOrSetDeferralSchedule(DeferralCode: Code[10];DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer;Amount: Decimal;PostingDate: Date;Description: Text[50];CurrencyCode: Code[10];AdjustStartDate: Boolean)
    var
        DeferralHeader: Record "Deferral Header";
        DeferralTemplate: Record "Deferral Template";
        DeferralDescription: Text[100];
    begin
        if DeferralCode = '' then
          // If the user cleared the deferral code, we should remove the saved schedule...
          if DeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then begin
            DeferralHeader.Delete;
            RemoveDeferralLines(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo);
          end;
        if DeferralCode <> '' then
          if LineNo <> 0 then
            if DeferralTemplate.Get(DeferralCode) then begin
              ValidateDeferralTemplate(DeferralTemplate);
              if GenJnlBatchName <> '' then
                DeferralDescription := GenJnlBatchName + '-' + CopyStr(Description,1,30)
              else
                DeferralDescription := DocumentNo + '-' + CopyStr(Description,1,30);

              CreateDeferralSchedule(DeferralCode,DeferralDocType,
                GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo,Amount,
                DeferralTemplate."Calc. Method",PostingDate,DeferralTemplate."No. of Periods",
                true,DeferralDescription,AdjustStartDate,CurrencyCode);
            end;
    end;


    procedure CreateScheduleFromGL(GenJournalLine: Record "Gen. Journal Line";FirstEntryNo: Integer)
    var
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        DeferralTemplate: Record "Deferral Template";
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostedDeferralLine: Record "Posted Deferral Line";
        CustPostingGr: Record "Customer Posting Group";
        VendPostingGr: Record "Vendor Posting Group";
        BankAcc: Record "Bank Account";
        BankAccPostingGr: Record "Bank Account Posting Group";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DeferralAccount: Code[20];
        Account: Code[20];
        GLAccount: Code[20];
        GLAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
    begin
        if DeferralHeader.Get(DeferralHeader."deferral doc. type"::"G/L",
             GenJournalLine."Journal Template Name",
             GenJournalLine."Journal Batch Name",0,'',
             GenJournalLine."Line No.")
        then begin
          if DeferralTemplate.Get(DeferralHeader."Deferral Code") then
            DeferralAccount := DeferralTemplate."Deferral Account";

          if (GenJournalLine."Account No." = '') and (GenJournalLine."Bal. Account No." <> '') then begin
            GLAccount := GenJournalLine."Bal. Account No.";
            GLAccountType := GenJournalLine."Bal. Account Type";
          end else begin
            GLAccount := GenJournalLine."Account No.";
            GLAccountType := GenJournalLine."Account Type";
          end;

          // Account types not G/L are not storing a GL account in the GenJnlLine's Account field, need to retrieve
          case GLAccountType of
            GenJournalLine."account type"::Customer:
              begin
                CustPostingGr.Get(GenJournalLine."Posting Group");
                Account := CustPostingGr.GetReceivablesAccount;
              end;
            GenJournalLine."account type"::Vendor:
              begin
                VendPostingGr.Get(GenJournalLine."Posting Group");
                Account := VendPostingGr.GetPayablesAccount;
              end;
            GenJournalLine."account type"::"Bank Account":
              begin
                BankAcc.Get(GLAccount);
                BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                Account := BankAccPostingGr."G/L Bank Account No.";
              end;
            else
              Account := GLAccount;
          end;

          // Create the Posted Deferral Schedule with the Document Number created from the posted GL Trx...
          PostedDeferralHeader.Init;
          PostedDeferralHeader.TransferFields(DeferralHeader);
          PostedDeferralHeader."Deferral Doc. Type" := DeferralHeader."deferral doc. type"::"G/L";
          // Adding document number so we can connect the Ledger and Deferral Schedule details...
          PostedDeferralHeader."Gen. Jnl. Document No." := GenJournalLine."Document No.";
          PostedDeferralHeader."Account No." := Account;
          PostedDeferralHeader."Document Type" := 0;
          PostedDeferralHeader."Document No." := '';
          PostedDeferralHeader."Line No." := GenJournalLine."Line No.";
          PostedDeferralHeader."Currency Code" := GenJournalLine."Currency Code";
          PostedDeferralHeader."Deferral Account" := DeferralAccount;
          PostedDeferralHeader."Posting Date" := GenJournalLine."Posting Date";
          PostedDeferralHeader."Entry No." := FirstEntryNo;
          PostedDeferralHeader.Insert;

          DeferralLine.SetRange("Deferral Doc. Type",DeferralHeader."deferral doc. type"::"G/L");
          DeferralLine.SetRange("Gen. Jnl. Template Name",GenJournalLine."Journal Template Name");
          DeferralLine.SetRange("Gen. Jnl. Batch Name",GenJournalLine."Journal Batch Name");
          DeferralLine.SetRange("Document Type",0);
          DeferralLine.SetRange("Document No.",'');
          DeferralLine.SetRange("Line No.",GenJournalLine."Line No.");
          if DeferralLine.FindSet then begin
            repeat
              PostedDeferralLine.Init;
              PostedDeferralLine.TransferFields(DeferralLine);
              PostedDeferralLine."Deferral Doc. Type" := DeferralHeader."deferral doc. type"::"G/L";
              PostedDeferralLine."Gen. Jnl. Document No." := GenJournalLine."Document No.";
              PostedDeferralLine."Account No." := Account;
              PostedDeferralLine."Document Type" := 0;
              PostedDeferralLine."Document No." := '';
              PostedDeferralLine."Line No." := GenJournalLine."Line No.";
              PostedDeferralLine."Currency Code" := GenJournalLine."Currency Code";
              PostedDeferralLine."Deferral Account" := DeferralAccount;
              PostedDeferralLine.Insert;
            until DeferralLine.Next = 0;
          end;
        end;

        GenJnlPostLine.RemoveDeferralSchedule(GenJournalLine);
    end;


    procedure DeferralCodeOnValidate(DeferralCode: Code[10];DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer;Amount: Decimal;PostingDate: Date;Description: Text[50];CurrencyCode: Code[10])
    var
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        DeferralTemplate: Record "Deferral Template";
        DeferralDescription: Text[50];
    begin
        DeferralHeader.Init;
        DeferralLine.Init;
        if DeferralCode = '' then
          // If the user cleared the deferral code, we should remove the saved schedule...
          DeferralCodeOnDelete(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo)
        else
          if LineNo <> 0 then
            if DeferralTemplate.Get(DeferralCode) then begin
              ValidateDeferralTemplate(DeferralTemplate);
              if GenJnlBatchName <> '' then
                DeferralDescription := GenJnlBatchName + '-' + CopyStr(Description,1,30)
              else
                DeferralDescription := DocumentNo + '-' + CopyStr(Description,1,30);
              CreateDeferralSchedule(DeferralCode,DeferralDocType,
                GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo,Amount,
                DeferralTemplate."Calc. Method",PostingDate,DeferralTemplate."No. of Periods",
                true,DeferralDescription,true,CurrencyCode);
            end;
    end;


    procedure DeferralCodeOnDelete(DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer)
    var
        DeferralHeader: Record "Deferral Header";
    begin
        if LineNo <> 0 then
          // Deferral Additions
          if DeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then begin
            DeferralHeader.Delete;
            RemoveDeferralLines(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo);
          end;
    end;


    procedure OpenLineScheduleEdit(DeferralCode: Code[10];DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer;Amount: Decimal;PostingDate: Date;Description: Text[50];CurrencyCode: Code[10]): Boolean
    var
        DeferralTemplate: Record "Deferral Template";
        DeferralHeader: Record "Deferral Header";
        DeferralSchedule: Page "Deferral Schedule";
        DeferralDescription: Text[50];
        Changed: Boolean;
    begin
        if DeferralCode = '' then
          Message(SelectDeferralCodeMsg)
        else
          if DeferralTemplate.Get(DeferralCode) then
            if DeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then begin
              DeferralSchedule.SetParameter(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo);
              DeferralSchedule.RunModal;
              Changed := DeferralSchedule.GetParameter;
              Clear(DeferralSchedule);
            end else begin
              if GenJnlBatchName <> '' then
                DeferralDescription := GenJnlBatchName + '-' + CopyStr(Description,1,30)
              else
                DeferralDescription := DocumentNo + '-' + CopyStr(Description,1,30);
              CreateDeferralSchedule(DeferralCode,DeferralDocType,
                GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo,Amount,
                DeferralTemplate."Calc. Method",PostingDate,DeferralTemplate."No. of Periods",true,DeferralDescription,true,
                CurrencyCode);
              Commit;
              if DeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then begin
                DeferralSchedule.SetParameter(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo);
                DeferralSchedule.RunModal;
                Changed := DeferralSchedule.GetParameter;
                Clear(DeferralSchedule);
              end;
            end;
        exit(Changed);
    end;


    procedure OpenLineScheduleView(DeferralCode: Code[10];DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer)
    var
        DeferralTemplate: Record "Deferral Template";
        PostedDeferralHeader: Record "Posted Deferral Header";
    begin
        // On view nothing will happen if the record does not exist
        if DeferralCode <> '' then
          if DeferralTemplate.Get(DeferralCode) then begin
            if PostedDeferralHeader.Get(DeferralDocType,GenJnlTemplateName,GenJnlBatchName,DocumentType,DocumentNo,LineNo) then
              Page.RunModal(Page::"Deferral Schedule View",PostedDeferralHeader);
          end;
    end;


    procedure OpenLineScheduleArchive(DeferralCode: Code[10];DeferralDocType: Integer;DocumentType: Integer;DocumentNo: Code[20];DocNoOccurence: Integer;VersionNo: Integer;LineNo: Integer)
    var
        DeferralHeaderArchive: Record "Deferral Header Archive";
    begin
        // On view nothing will happen if the record does not exist
        if DeferralCode <> '' then
          if DeferralHeaderArchive.Get(DeferralDocType,DocumentType,DocumentNo,DocNoOccurence,VersionNo,LineNo) then
            Page.RunModal(Page::"Deferral Schedule Archive",DeferralHeaderArchive);
    end;

    local procedure RemoveDeferralLines(DeferralDocType: Integer;GenJnlTemplateName: Code[10];GenJnlBatchName: Code[10];DocumentType: Integer;DocumentNo: Code[20];LineNo: Integer)
    var
        DeferralLine: Record "Deferral Line";
    begin
        DeferralLine.SetRange("Deferral Doc. Type",DeferralDocType);
        DeferralLine.SetRange("Gen. Jnl. Template Name",GenJnlTemplateName);
        DeferralLine.SetRange("Gen. Jnl. Batch Name",GenJnlBatchName);
        DeferralLine.SetRange("Document Type",DocumentType);
        DeferralLine.SetRange("Document No.",DocumentNo);
        DeferralLine.SetRange("Line No.",LineNo);
        DeferralLine.DeleteAll;
    end;

    local procedure ValidateDeferralTemplate(DeferralTemplate: Record "Deferral Template")
    begin
        with DeferralTemplate do begin
          TestField("Deferral Account");
          TestField("Deferral %");
          TestField("No. of Periods");
        end;
    end;


    procedure RoundDeferralAmount(var DeferralHeader: Record "Deferral Header";CurrencyCode: Code[10];CurrencyFactor: Decimal;PostingDate: Date;var AmtToDefer: Decimal;var AmtToDeferLCY: Decimal)
    var
        DeferralLine: Record "Deferral Line";
        CurrExchRate: Record "Currency Exchange Rate";
        UseDate: Date;
        DeferralCount: Integer;
        TotalAmountLCY: Decimal;
        TotalDeferralCount: Integer;
    begin
        // Calculate the LCY amounts for posting
        if PostingDate = 0D then
          UseDate := WorkDate
        else
          UseDate := PostingDate;

        DeferralHeader."Amount to Defer (LCY)" :=
          ROUND(CurrExchRate.ExchangeAmtFCYToLCY(UseDate,CurrencyCode,DeferralHeader."Amount to Defer",CurrencyFactor));
        DeferralHeader.Modify;
        AmtToDefer := DeferralHeader."Amount to Defer";
        AmtToDeferLCY := DeferralHeader."Amount to Defer (LCY)";
        DeferralLine.SetRange("Deferral Doc. Type",DeferralHeader."Deferral Doc. Type");
        DeferralLine.SetRange("Gen. Jnl. Template Name",DeferralHeader."Gen. Jnl. Template Name");
        DeferralLine.SetRange("Gen. Jnl. Batch Name",DeferralHeader."Gen. Jnl. Batch Name");
        DeferralLine.SetRange("Document Type",DeferralHeader."Document Type");
        DeferralLine.SetRange("Document No.",DeferralHeader."Document No.");
        DeferralLine.SetRange("Line No.",DeferralHeader."Line No.");
        if DeferralLine.FindSet then begin
          TotalDeferralCount := DeferralLine.Count;
          repeat
            DeferralCount := DeferralCount + 1;
            if DeferralCount = TotalDeferralCount then begin
              DeferralLine."Amount (LCY)" := DeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
              DeferralLine.Modify;
            end else begin
              DeferralLine."Amount (LCY)" :=
                ROUND(CurrExchRate.ExchangeAmtFCYToLCY(UseDate,CurrencyCode,DeferralLine.Amount,CurrencyFactor));
              TotalAmountLCY := TotalAmountLCY + DeferralLine."Amount (LCY)";
              DeferralLine.Modify;
            end;
          until DeferralLine.Next = 0;
        end;
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    var
        Currency: Record Currency;
    begin
        if CurrencyCode = '' then
          Currency.InitRoundingPrecision
        else begin
          Currency.Get(CurrencyCode);
          Currency.TestField("Amount Rounding Precision");
        end;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;


    procedure GetSalesDeferralDocType(): Integer
    begin
        exit(DeferralHeader."deferral doc. type"::Sales)
    end;

    local procedure InitializeDeferralHeaderAndSetPostDate(var DeferralLine: Record "Deferral Line";DeferralHeader: Record "Deferral Header";PeriodicCount: Integer;var PostDate: Date)
    begin
        DeferralLine.Init;
        DeferralLine."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type";
        DeferralLine."Gen. Jnl. Template Name" := DeferralHeader."Gen. Jnl. Template Name";
        DeferralLine."Gen. Jnl. Batch Name" := DeferralHeader."Gen. Jnl. Batch Name";
        DeferralLine."Document Type" := DeferralHeader."Document Type";
        DeferralLine."Document No." := DeferralHeader."Document No.";
        DeferralLine."Line No." := DeferralHeader."Line No.";
        DeferralLine."Currency Code" := DeferralHeader."Currency Code";

        if PeriodicCount = 1 then begin
          AccountingPeriod.SetFilter("Starting Date",'..%1',DeferralHeader."Start Date");
          if not AccountingPeriod.FindFirst then
            Error(DeferSchedOutOfBoundsErr);

          PostDate := DeferralHeader."Start Date";
        end else begin
          AccountingPeriod.SetFilter("Starting Date",'>%1',PostDate);
          if AccountingPeriod.FindFirst then
            PostDate := AccountingPeriod."Starting Date"
          else
            Error(DeferSchedOutOfBoundsErr);
        end;
    end;


    procedure GetPurchDeferralDocType(): Integer
    begin
        exit(DeferralHeader."deferral doc. type"::Purchase)
    end;


    procedure GetDeferralStartDate(DeferralDocType: Integer;RecordDocumentType: Integer;RecordDocumentNo: Code[20];RecordLineNo: Integer;DeferralCode: Code[10];PostingDate: Date): Date
    var
        DeferralHeader: Record "Deferral Header";
        DeferralTemplate: Record "Deferral Template";
    begin
        if DeferralHeader.Get(DeferralDocType,'','',RecordDocumentType,RecordDocumentNo,RecordLineNo) then
          exit(DeferralHeader."Start Date");

        if DeferralTemplate.Get(DeferralCode) then
          exit(SetStartDate(DeferralTemplate,PostingDate));

        exit(PostingDate);
    end;


    procedure AdjustTotalAmountForDeferrals(DeferralCode: Code[10];var AmtToDefer: Decimal;var AmtToDeferACY: Decimal;var TotalAmount: Decimal;var TotalAmountACY: Decimal;var TotalVATBase: Decimal;var TotalVATBaseACY: Decimal)
    begin
        TotalVATBase := TotalAmount;
        TotalVATBaseACY := TotalAmountACY;
        if DeferralCode <> '' then
          if (AmtToDefer = TotalAmount) and (AmtToDeferACY = TotalAmountACY) then begin
            AmtToDefer := 0;
            AmtToDeferACY := 0;
          end else begin
            TotalAmount := TotalAmount - AmtToDefer;
            TotalAmountACY := TotalAmountACY - AmtToDeferACY;
          end;
    end;
}


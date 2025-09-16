#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5626 "FA General Report"
{
    Permissions = TableData "Fixed Asset"=rm;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Posting Date Filter';
        Text001: label 'You must specify the Starting Date and the Ending Date.';
        Text002: label 'The Starting Date is later than the Ending Date.';
        Text003: label 'You must not specify closing dates.';
        Text004: label 'You must specify the First Depreciation Date and the Last Depreciation Date.';
        Text005: label 'The First Depreciation Date is later than the Last Depreciation Date.';
        Text006: label 'Sorting fixed assets';
        FADeprBook: Record "FA Depreciation Book";
        FALedgEntry: Record "FA Ledger Entry";
        DepreciationCalc: Codeunit "Depreciation Calculation";


    procedure GetLastDate(FANo: Code[20];PostingType: Integer;EndingDate: Date;DeprBookCode: Code[10];GLEntry: Boolean): Date
    var
        FirstLast: Text[1];
    begin
        ClearAll;
        if PostingType = 0 then
          exit(0D);
        if EndingDate = 0D then
          EndingDate := Dmy2date(31,12,9999);
        with FALedgEntry do begin
          Reset;
          if GLEntry then begin
            SetCurrentkey(
              "FA No.","Depreciation Book Code","FA Posting Category","FA Posting Type","Posting Date");
            SetRange("Depreciation Book Code",DeprBookCode);
            SetRange("FA No.",FANo);
            SetRange("FA Posting Category","fa posting category"::" ");
            SetRange("Posting Date",0D,EndingDate);
          end else begin
            DepreciationCalc.SetFAFilter(FALedgEntry,FANo,DeprBookCode,true);
            SetRange("FA Posting Date",0D,EndingDate);
          end;
          FirstLast := '+';
          case PostingType of
            FADeprBook.FieldNo("Last Acquisition Cost Date"):
              SetRange("FA Posting Type","fa posting type"::"Acquisition Cost");
            FADeprBook.FieldNo("Last Depreciation Date"):
              SetRange("FA Posting Type","fa posting type"::Depreciation);
            FADeprBook.FieldNo("Last Write-Down Date"):
              SetRange("FA Posting Type","fa posting type"::"Write-Down");
            FADeprBook.FieldNo("Last Appreciation Date"):
              SetRange("FA Posting Type","fa posting type"::Appreciation);
            FADeprBook.FieldNo("Last Custom 1 Date"):
              SetRange("FA Posting Type","fa posting type"::"Custom 1");
            FADeprBook.FieldNo("Last Custom 2 Date"):
              SetRange("FA Posting Type","fa posting type"::"Custom 2");
            FADeprBook.FieldNo("Last Salvage Value Date"):
              SetRange("FA Posting Type","fa posting type"::"Salvage Value");
            FADeprBook.FieldNo("Acquisition Date"),
            FADeprBook.FieldNo("G/L Acquisition Date"):
              begin
                SetRange("FA Posting Type","fa posting type"::"Acquisition Cost");
                FirstLast := '-';
              end;
            FADeprBook.FieldNo("Disposal Date"):
              begin
                SetRange("FA Posting Type","fa posting type"::"Proceeds on Disposal");
                FirstLast := '-';
              end;
          end;

          if Find(FirstLast) then begin
            if GLEntry then
              exit("Posting Date");

            exit("FA Posting Date");
          end;
          exit(0D);
        end;
    end;


    procedure CalcFAPostedAmount(FANo: Code[20];PostingType: Integer;Period: Option "Before Starting Date","Net Change","at Ending Date";StartingDate: Date;EndingDate: Date;DeprBookCode: Code[10];BeforeAmount: Decimal;UntilAmount: Decimal;OnlyReclassified: Boolean;OnlyBookValue: Boolean): Decimal
    begin
        ClearAll;
        if PostingType = 0 then
          exit(0);
        if EndingDate = 0D then
          EndingDate := Dmy2date(31,12,9999);
        with FALedgEntry do begin
          case PostingType of
            FADeprBook.FieldNo("Book Value"):
              SetCurrentkey("FA No.","Depreciation Book Code","Part of Book Value");
            FADeprBook.FieldNo("Depreciable Basis"):
              SetCurrentkey("FA No.","Depreciation Book Code","Part of Depreciable Basis");
            else begin
              SetCurrentkey(
                "FA No.","Depreciation Book Code",
                "FA Posting Category","FA Posting Type","FA Posting Date");
              SetRange("FA Posting Category","fa posting category"::" ");
            end;
          end;
          SetRange("FA No.",FANo);
          SetRange("Depreciation Book Code",DeprBookCode);
          if OnlyReclassified then
            SetRange("Reclassification Entry",true);
          if OnlyBookValue then
            SetRange("Part of Book Value",true);
          case PostingType of
            FADeprBook.FieldNo("Acquisition Cost"):
              SetRange("FA Posting Type","fa posting type"::"Acquisition Cost");
            FADeprBook.FieldNo(Depreciation):
              SetRange("FA Posting Type","fa posting type"::Depreciation);
            FADeprBook.FieldNo("Write-Down"):
              SetRange("FA Posting Type","fa posting type"::"Write-Down");
            FADeprBook.FieldNo(Appreciation):
              SetRange("FA Posting Type","fa posting type"::Appreciation);
            FADeprBook.FieldNo("Custom 1"):
              SetRange("FA Posting Type","fa posting type"::"Custom 1");
            FADeprBook.FieldNo("Custom 2"):
              SetRange("FA Posting Type","fa posting type"::"Custom 2");
            FADeprBook.FieldNo("Proceeds on Disposal"):
              SetRange("FA Posting Type","fa posting type"::"Proceeds on Disposal");
            FADeprBook.FieldNo("Gain/Loss"):
              SetRange("FA Posting Type","fa posting type"::"Gain/Loss");
            FADeprBook.FieldNo("Salvage Value"):
              SetRange("FA Posting Type","fa posting type"::"Salvage Value");
            FADeprBook.FieldNo("Book Value"):
              SetRange("Part of Book Value",true);
            FADeprBook.FieldNo("Depreciable Basis"):
              SetRange("Part of Depreciable Basis",true);
          end;
          case Period of
            Period::"Before Starting Date":
              SetRange("FA Posting Date",0D,StartingDate - 1);
            Period::"Net Change":
              SetRange("FA Posting Date",StartingDate,EndingDate);
            Period::"at Ending Date":
              SetRange("FA Posting Date",0D,EndingDate);
          end;
          CalcSums(Amount);

          if (PostingType = FADeprBook.FieldNo("Book Value")) or
             (PostingType = FADeprBook.FieldNo(Depreciation))
          then
            case Period of
              Period::"Before Starting Date":
                Amount := Amount + BeforeAmount;
              Period::"Net Change":
                Amount := Amount - BeforeAmount + UntilAmount;
              Period::"at Ending Date":
                Amount := Amount + UntilAmount;
            end;
          exit(Amount);
        end;
    end;


    procedure CalcGLPostedAmount(FANo: Code[20];PostingType: Integer;Period: Option " ",Disposal,"Bal. Disposal";StartingDate: Date;EndingDate: Date;DeprBookCode: Code[10]): Decimal
    begin
        ClearAll;
        if PostingType = 0 then
          exit(0);
        if EndingDate = 0D then
          EndingDate := Dmy2date(31,12,9999);
        with FALedgEntry do begin
          SetCurrentkey(
            "FA No.","Depreciation Book Code",
            "FA Posting Category","FA Posting Type","Posting Date");
          SetRange("FA No.",FANo);
          SetRange("Depreciation Book Code",DeprBookCode);
          SetRange("FA Posting Category",Period);
          SetRange("Posting Date",StartingDate,EndingDate);
          case PostingType of
            FADeprBook.FieldNo("Acquisition Cost"):
              SetRange("FA Posting Type","fa posting type"::"Acquisition Cost");
            FADeprBook.FieldNo(Depreciation):
              SetRange("FA Posting Type","fa posting type"::Depreciation);
            FADeprBook.FieldNo("Write-Down"):
              SetRange("FA Posting Type","fa posting type"::"Write-Down");
            FADeprBook.FieldNo(Appreciation):
              SetRange("FA Posting Type","fa posting type"::Appreciation);
            FADeprBook.FieldNo("Custom 1"):
              SetRange("FA Posting Type","fa posting type"::"Custom 1");
            FADeprBook.FieldNo("Custom 2"):
              SetRange("FA Posting Type","fa posting type"::"Custom 2");
            FADeprBook.FieldNo("Proceeds on Disposal"):
              SetRange("FA Posting Type","fa posting type"::"Proceeds on Disposal");
            FADeprBook.FieldNo("Gain/Loss"):
              SetRange("FA Posting Type","fa posting type"::"Gain/Loss");
            FADeprBook.FieldNo("Book Value on Disposal"):
              SetRange("FA Posting Type","fa posting type"::"Book Value on Disposal");
          end;
          CalcSums(Amount);
          exit(Amount);
        end;
    end;


    procedure AppendFAPostingFilter(var FA: Record "Fixed Asset";StartingDate: Date;EndingDate: Date)
    begin
        if (StartingDate = 0D) and (EndingDate = 0D) then
          exit;
        if StartingDate = 0D then
          FA.SetFilter("FA Posting Date Filter",'..%1',EndingDate)
        else
          if EndingDate = 0D then
            FA.SetFilter("FA Posting Date Filter",'%1..',StartingDate)
          else
            FA.SetFilter("FA Posting Date Filter",'%1..%2',StartingDate,EndingDate);
    end;


    procedure AppendPostingDateFilter(var FAFilter: Text;StartingDate: Date;EndingDate: Date)
    var
        PostingDateFilter: Text[50];
    begin
        PostingDateFilter := StrSubstNo('%1: %2..%3',Text000,StartingDate,EndingDate);
        if FAFilter = '' then
          FAFilter := PostingDateFilter
        else
          FAFilter := FAFilter + StrSubstNo('%1 %2',',',PostingDateFilter);
    end;


    procedure ValidateDates(StartingDate: Date;EndingDate: Date)
    begin
        if (EndingDate = 0D) or (StartingDate <= 00000101D) then
          Error(Text001);

        if StartingDate > EndingDate then
          Error(Text002);

        if (NormalDate(StartingDate) <> StartingDate) or (NormalDate(EndingDate) <> EndingDate) then
          Error(Text003);
    end;


    procedure ValidateDeprDates(StartingDate: Date;EndingDate: Date)
    begin
        if (EndingDate = 0D) or (StartingDate <= 00000101D) then
          Error(Text004);

        if StartingDate > EndingDate then
          Error(Text005);

        if (NormalDate(StartingDate) <> StartingDate) or (NormalDate(EndingDate) <> EndingDate) then
          Error(Text003);
    end;


    procedure SetFAPostingGroup(var FA2: Record "Fixed Asset";DeprBookCode: Code[10])
    var
        FA: Record "Fixed Asset";
        FADeprBook: Record "FA Depreciation Book";
        Window: Dialog;
    begin
        Window.Open(Text006);
        FA.LockTable;
        FA.Copy(FA2);
        FA.SetRange("FA Posting Group");
        if FA.Find('-') then
          repeat
            if FADeprBook.Get(FA."No.",DeprBookCode) then
              if FA."FA Posting Group" <> FADeprBook."FA Posting Group" then begin
                FA."FA Posting Group" := FADeprBook."FA Posting Group";
                FA.Modify;
              end;
          until FA.Next = 0;
        Commit;
        Window.Close;
    end;
}


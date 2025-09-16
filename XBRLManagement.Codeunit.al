#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 420 "XBRL Management"
{

    trigger OnRun()
    begin
    end;

    var
        CompanyInformation: Record "Company Information";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        PeriodOption: Option "Accounting Period","Fiscal Year";
        PeriodOptionText: Text[30];
        NoOfPeriods: Integer;
        Text001: label 'Accounting Period';
        Text002: label 'Fiscal Year';
        Text003: label '%1 is not a period start date.';


    procedure AddAttribute(DOMNode: dotnet XmlNode;Name: Text[250];Value: Text[250])
    var
        TempAttribute: dotnet XmlNode;
    begin
        TempAttribute := DOMNode.OwnerDocument.CreateAttribute(Name);
        if Value <> '' then
          TempAttribute.Value := Value;
        DOMNode.Attributes.SetNamedItem(TempAttribute);
        Clear(TempAttribute);
    end;


    procedure AddAttributeWithNamespace(DOMNode: dotnet XmlNode;Name: Text[250];Value: Text[250];Prefix: Text[250];Namespace: Text[250])
    var
        TempAttribute: dotnet XmlNode;
    begin
        TempAttribute := DOMNode.OwnerDocument.CreateAttribute(Prefix,Name,Namespace);
        if Value <> '' then
          TempAttribute.Value := Value;
        DOMNode.Attributes.SetNamedItem(TempAttribute);
        Clear(TempAttribute);
    end;


    procedure CalcConstant(var XBRLTaxonomyLine: Record "XBRL Taxonomy Line"): Decimal
    var
        XBRLLineConst: Record "XBRL Line Constant";
    begin
        with XBRLLineConst do begin
          Reset;
          SetRange("XBRL Taxonomy Name",XBRLTaxonomyLine."XBRL Taxonomy Name");
          SetRange("XBRL Taxonomy Line No.",XBRLTaxonomyLine."Line No.");
          SetRange("Starting Date",0D,PeriodEndDate);
          if FindLast then
            exit("Constant Amount");

          exit(XBRLTaxonomyLine."Constant Amount");
        end;
    end;


    procedure CalcAmount(var XBRLTaxonomyLine: Record "XBRL Taxonomy Line"): Decimal
    var
        GLEntry: Record "G/L Entry";
        GLAcc: Record "G/L Account";
        XBRLGLMapLine: Record "XBRL G/L Map Line";
        Amount: Decimal;
    begin
        Amount := 0;
        with XBRLGLMapLine do begin
          Reset;
          SetRange("XBRL Taxonomy Name",XBRLTaxonomyLine."XBRL Taxonomy Name");
          SetRange("XBRL Taxonomy Line No.",XBRLTaxonomyLine."Line No.");
          if Find('-') then
            repeat
              GLEntry.Reset;
              GLEntry.SetCurrentkey("G/L Account No.","Posting Date");
              GLEntry.SetFilter("G/L Account No.","G/L Account Filter");
              if ((XBRLTaxonomyLine.GetFilter("Business Unit Filter") <> '') or
                  (XBRLTaxonomyLine.GetFilter("Global Dimension 1 Filter") <> '') or
                  (XBRLTaxonomyLine.GetFilter("Global Dimension 2 Filter") <> ''))
              then begin
                GLEntry.SetCurrentkey(
                  "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code");
                XBRLTaxonomyLine.Copyfilter("Business Unit Filter",GLEntry."Business Unit Code");
                XBRLTaxonomyLine.Copyfilter("Global Dimension 1 Filter",GLEntry."Global Dimension 1 Code");
                XBRLTaxonomyLine.Copyfilter("Global Dimension 2 Filter",GLEntry."Global Dimension 2 Code");
              end;
              GLEntry.FilterGroup(2);
              if "Business Unit Filter" <> '' then begin
                GLEntry.SetCurrentkey(
                  "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code");
                GLEntry.SetFilter("Business Unit Code","Business Unit Filter");
              end;
              if "Global Dimension 1 Filter" <> '' then begin
                GLEntry.SetCurrentkey(
                  "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code");
                GLEntry.SetFilter("Global Dimension 1 Code","Global Dimension 1 Filter");
              end;
              if "Global Dimension 2 Filter" <> '' then begin
                GLEntry.SetCurrentkey(
                  "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code");
                GLEntry.SetFilter("Global Dimension 2 Code","Global Dimension 2 Filter");
              end;
              GLEntry.FilterGroup(0);
              case "Timeframe Type" of
                "timeframe type"::"Net Change":
                  GLEntry.SetRange("Posting Date",PeriodStartDate,PeriodEndDate);
                "timeframe type"::"Beginning Balance":
                  GLEntry.SetRange("Posting Date",0D,ClosingDate(PeriodStartDate - 1));
                "timeframe type"::"Ending Balance":
                  GLEntry.SetRange("Posting Date",0D,PeriodEndDate);
              end;
              case "Amount Type" of
                "amount type"::"Net Amount":
                  begin
                    GLEntry.CalcSums(Amount);
                    if (("Normal Balance" = "normal balance"::"Debit (positive)") and (GLEntry.Amount < 0) or
                        ("Normal Balance" = "normal balance"::"Credit (negative)") and (GLEntry.Amount > 0))
                    then
                      Amount := Amount - Abs(GLEntry.Amount)
                    else
                      Amount := Amount + Abs(GLEntry.Amount);
                  end;
                "amount type"::"Debits Only":
                  begin
                    GLEntry.CalcSums("Debit Amount");
                    Amount := Amount + GLEntry."Debit Amount";
                  end;
                "amount type"::"Credits Only":
                  begin
                    GLEntry.CalcSums("Credit Amount");
                    Amount := Amount + GLEntry."Credit Amount";
                  end;
              end;
              with GLAcc do begin
                SetFilter("No.",XBRLGLMapLine."G/L Account Filter");
                SetFilter("Account Type",'%1|%2',"account type"::"End-Total","account type"::Total);
                GLEntry.Copyfilter("Posting Date","Date Filter");
                GLEntry.Copyfilter("Global Dimension 1 Code","Global Dimension 1 Filter");
                GLEntry.Copyfilter("Global Dimension 2 Code","Global Dimension 2 Filter");
                GLEntry.Copyfilter("Business Unit Code","Business Unit Filter");
                if Find('-') then
                  repeat
                    case "Amount Type" of
                      "amount type"::"Net Amount":
                        begin
                          CalcFields("Net Change");
                          if (("Normal Balance" = "normal balance"::"Debit (positive)") and ("Net Change" < 0) or
                              ("Normal Balance" = "normal balance"::"Credit (negative)") and ("Net Change" > 0))
                          then
                            Amount := Amount - Abs("Net Change")
                          else
                            Amount := Amount + Abs("Net Change");
                        end;
                      "amount type"::"Debits Only":
                        begin
                          CalcFields("Debit Amount");
                          Amount := Amount + "Debit Amount";
                        end;
                      "amount type"::"Credits Only":
                        begin
                          CalcFields("Credit Amount");
                          Amount := Amount + "Credit Amount";
                        end;
                    end;
                  until Next = 0;
              end;
            until Next = 0;
        end;
        exit(Amount);
    end;


    procedure CalcRollup(var XBRLTaxonomyLine: Record "XBRL Taxonomy Line"): Decimal
    var
        XBRLTaxonomyLine2: Record "XBRL Taxonomy Line";
        XBRLRollupLine: Record "XBRL Rollup Line";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        XBRLRollupLine.SetRange("XBRL Taxonomy Name",XBRLTaxonomyLine."XBRL Taxonomy Name");
        XBRLRollupLine.SetRange("XBRL Taxonomy Line No.",XBRLTaxonomyLine."Line No.");
        with XBRLRollupLine do
          if Find('-') then
            repeat
              XBRLTaxonomyLine2.Get("XBRL Taxonomy Name","From XBRL Taxonomy Line No.");
              XBRLTaxonomyLine2.CopyFilters(XBRLTaxonomyLine);
              case XBRLTaxonomyLine2."Source Type" of
                XBRLTaxonomyLine2."source type"::Constant:
                  TotalAmount := TotalAmount + Weight * XBRLTaxonomyLine2."Constant Amount";
                XBRLTaxonomyLine2."source type"::"General Ledger":
                  TotalAmount := TotalAmount + Weight * CalcAmount(XBRLTaxonomyLine2);
                XBRLTaxonomyLine2."source type"::Rollup:
                  TotalAmount := TotalAmount + Weight * CalcRollup(XBRLTaxonomyLine2);
              end;
            until Next = 0;
        exit(TotalAmount);
    end;

    local procedure CalcPeriodEndDate(StartDate: Date): Date
    var
        AccountingPeriodRec: Record "Accounting Period";
        EndDate: Date;
    begin
        Clear(AccountingPeriodRec);
        if PeriodOption = Periodoption::"Fiscal Year" then
          AccountingPeriodRec.SetRange("New Fiscal Year",true);
        if not AccountingPeriodRec.Get(StartDate) then
          Error(Text003,StartDate);
        AccountingPeriodRec.Next;
        EndDate := CalcDate('<-1D>',AccountingPeriodRec."Starting Date");
        exit(EndDate);
    end;

    local procedure CalcPeriodStartDate(EndDate: Date): Date
    var
        AccountingPeriodRec: Record "Accounting Period";
    begin
        Clear(AccountingPeriodRec);
        AccountingPeriodRec.SetRange("Starting Date",0D,EndDate);
        if PeriodOption = Periodoption::"Fiscal Year" then
          AccountingPeriodRec.SetRange("New Fiscal Year",true);
        AccountingPeriodRec.FindLast;
        exit(AccountingPeriodRec."Starting Date");
    end;


    procedure ExpandString(Description: Text[200]): Text[250]
    var
        Parameters: array [25] of Text[50];
        Result: Text[250];
        I: Integer;
        Param: Integer;
        Digits: Integer;
    begin
        // Setup all the parameters
        if CompanyInformation.Name = '' then
          CompanyInformation.Get;
        Clear(Parameters);
        Parameters[1] := Format(PeriodEndDate,0,'<Day>');
        Parameters[2] := Format(PeriodEndDate,0,'<Day,2>');
        Parameters[3] := Format(PeriodEndDate,0,'<Month,2>');
        Parameters[4] := Format(PeriodEndDate,0,'<Month Text>');
        Parameters[5] := Format(PeriodEndDate,0,'<Year>');
        Parameters[6] := Format(PeriodEndDate,0,'<Year4>');
        Parameters[7] := Format(PeriodStartDate,0,'<Day>');
        Parameters[8] := Format(PeriodStartDate,0,'<Day,2>');
        Parameters[9] := Format(PeriodStartDate,0,'<Month,2>');
        Parameters[10] := Format(PeriodStartDate,0,'<Month Text>');
        Parameters[11] := Format(PeriodStartDate,0,'<Year>');
        Parameters[12] := Format(PeriodStartDate,0,'<Year4>');
        Parameters[13] := Format(NoOfPeriods);
        Parameters[14] := PeriodOptionText;
        Parameters[15] := CompanyInformation.Name;

        // Replace all substitution parameters (%1..%25 allowed)
        I := 1;
        while I <= StrLen(Description) do begin
          Digits := 0;
          if Description[I] = '%' then
            case true of
              (Description[I + 1] in ['1','2']) and (Description[I + 2] in ['0'..'9']):  // Two digits
                Digits := 2;
              (Description[I + 1] in ['0'..'9']):                                      // One digit
                Digits := 1;
            end;
          if Digits = 0 then begin
            if StrLen(Result) < 250 then
              Result := Result + CopyStr(Description,I,1)
            else
              I := 251;
          end else begin
            Evaluate(Param,CopyStr(Description,I + 1,Digits));
            if StrLen(Result) + StrLen(Parameters[Param]) < 250 then
              Result := Result + Parameters[Param]
            else
              I := 251;
          end;
          I := I + 1 + Digits;
        end;
        exit(Result);
    end;


    procedure FormatAmount2(Amount: Decimal): Text[30]
    begin
        exit(ConvertStr(Format(Amount,0,1),',','.'));
    end;


    procedure InitializeOptions(NumOfPeriods: Integer;PerOption: Option "Accounting Period","Fiscal Year")
    begin
        PeriodOption := PerOption;
        if PerOption = Peroption::"Accounting Period" then
          PeriodOptionText := Text001
        else
          PeriodOptionText := Text002;
        NoOfPeriods := NumOfPeriods;
    end;


    procedure SetPeriodDates(StartingDate: Date;EndDate: Date;var XBRLTaxonomyLine: Record "XBRL Taxonomy Line")
    begin
        if EndDate = 0D then
          PeriodEndDate := CalcPeriodEndDate(StartingDate)
        else
          PeriodEndDate := EndDate;
        if EndDate = 0D then
          PeriodStartDate := CalcPeriodStartDate(PeriodEndDate)
        else
          PeriodStartDate := StartingDate;
        XBRLTaxonomyLine.SetRange("Date Filter",PeriodStartDate,PeriodEndDate);
    end;
}


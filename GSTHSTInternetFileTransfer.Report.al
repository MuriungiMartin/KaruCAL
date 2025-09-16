#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10500 "GST/HST Internet File Transfer"
{
    Caption = 'GST/HST Internet File Transfer';
    Permissions = TableData "VAT Entry"=imd;
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;
    UseRequestPage = true;

    dataset
    {
        dataitem("VAT Entry";"VAT Entry")
        {
            DataItemTableView = sorting("Entry No.");
            column(ReportForNavId_7612; 7612)
            {
            }

            trigger OnAfterGetRecord()
            var
                VATEntry: Record "VAT Entry";
            begin
                if ("Posting Date" >= StartDate) and ("Posting Date" <= EndDate) then begin
                  case "GST/HST" of
                    "gst/hst"::Rebate:
                      Rebate := Rebate + Amount;
                    "gst/hst"::Acquisition:
                      TaxDueOnAcquisition := TaxDueOnAcquisition + Amount;
                    "gst/hst"::"Self Assessment":
                      OtherGSTHST := OtherGSTHST + Amount;
                    "gst/hst"::"New Housing Rebates":
                      if ((Date2dmy("Posting Date",2) > 6) and (Date2dmy("Posting Date",3) = 2010)) or
                         (Date2dmy("Posting Date",3) > 2010)
                      then
                        NewHousingRebates := NewHousingRebates + Amount;
                    "gst/hst"::"Pension Rebate":
                      if "Posting Date" > 20111004D then
                        PensionRebate := PensionRebate + Amount;
                  end;

                  case Type of
                    Type::Purchase:
                      TotalITCAdjsmnt := TotalITCAdjsmnt + Amount;
                    Type::Sale:
                      begin
                        SalesOtherRevenue := SalesOtherRevenue + Base;
                        TotalGSTHSTAdjstmnt := TotalGSTHSTAdjstmnt + Amount;
                      end;
                    Type::Settlement:
                      PaidByInstallments := PaidByInstallments + Base;
                  end;
                end;

                VATEntry.Copy("VAT Entry");
                if VATEntry.Next = 0 then begin
                  CheckValue(NewHousingRebates,'135');
                  CheckValue(PensionRebate,'136');
                  WriteToFile;
                end;
            end;

            trigger OnPostDataItem()
            begin
                VATFile.Close;
            end;

            trigger OnPreDataItem()
            begin
                Clear(VATFile);
                VATFile.TextMode := true;
                VATFile.WriteMode := true;
                VATFile.Create(FileName);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which GST/HST information is included.';
                    }
                    field(EndDate;EndDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which GST/HST information is included.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ToFile: Text[1024];
    begin
        ToFile := 'GSTHST.tax';
        Download(FileName,Text002,'',Text001,ToFile);
    end;

    trigger OnPreReport()
    var
        RBMgt: Codeunit "File Management";
    begin
        if StartDate = 0D then
          Error(Text004);
        if EndDate = 0D then
          Error(Text006);
        if StartDate > EndDate then
          Error(Text005);

        FileName := RBMgt.ServerTempFileName('tax');
    end;

    var
        CompanyInfo: Record "Company Information";
        AccountIdentifier: Record UnknownRecord10100;
        VATFile: File;
        StartDate: Date;
        EndDate: Date;
        SalesOtherRevenue: Decimal;
        TotalGSTHSTAdjstmnt: Decimal;
        TotalITCAdjsmnt: Decimal;
        PaidByInstallments: Decimal;
        Rebate: Decimal;
        TaxDueOnAcquisition: Decimal;
        OtherGSTHST: Decimal;
        NewHousingRebates: Decimal;
        FileName: Text[250];
        Text001: label 'Tax Files (*.tax)|*.tax|All Files (*.*)|*.*', Comment='Only translate ''Tax Files'' and ''All Files'' {Split=r"[\|\(]\*\.[^ |)]*[|) ]?"}';
        Text002: label 'Export HST/GST File';
        Text004: label 'Start Date should not be blank.';
        Text005: label 'End Date should be greater than the Start Date.';
        Text006: label 'End Date should not be blank.';
        Text007: label 'Account Number is not defined for GST/HST in Account Identifiers.';
        Text008: label 'Amount in field %1 cannot have more than %2 digits.';
        PensionRebate: Decimal;
        Text009: label 'Amount in field %1 cannot be more than amount in field %2.';


    procedure WriteToFile()
    begin
        SalesOtherRevenue := Abs(SalesOtherRevenue);
        TotalGSTHSTAdjstmnt := Abs(TotalGSTHSTAdjstmnt);

        CompanyInfo.Get;
        if AccountIdentifier.Get(CompanyInfo."Federal ID No.",AccountIdentifier."program identifier"::RT) then begin
          VATFile.Write(
            'SFT*' + CompanyInfo."Software Identification Code" + '~TRS*GST34' + '~ACN*' +
            CompanyInfo."Federal ID No." + 'RT' + AccountIdentifier."Reference No." + '~SDT*' +
            FormatDates(StartDate) + '~NDT*' + FormatDates(EndDate) + '~101*' +
            FormatDecimals(SalesOtherRevenue,13,'101') + '~105*' +
            FormatDecimals(TotalGSTHSTAdjstmnt,11,'105') + '~108*' +
            FormatDecimals(TotalITCAdjsmnt,11,'108') + '~109*' +
            FormatDecimals(TotalGSTHSTAdjstmnt - TotalITCAdjsmnt,11,'109') + '~110*' +
            FormatDecimals(PaidByInstallments,11,'110') + '~111*' +
            FormatDecimals(Rebate,11,'111') + '~205*' +
            FormatDecimals(TaxDueOnAcquisition,11,'205') + '~405*' +
            FormatDecimals(OtherGSTHST,11,'405') + '~114*' +
            FormatDecimals(
              CheckForPositive(
                TotalGSTHSTAdjstmnt - TotalITCAdjsmnt - Rebate +
                TaxDueOnAcquisition + OtherGSTHST),11,'114') + '~115*' +
            FormatDecimals(
              CheckForNegative(
                TotalGSTHSTAdjstmnt - TotalITCAdjsmnt - Rebate +
                TaxDueOnAcquisition + OtherGSTHST),11,'115') + '~135*' +
            FormatDecimals(NewHousingRebates,11,'135') + '~136*' +
            FormatDecimals(PensionRebate,11,'136') + '~EOD');
        end else
          Error(Text007);
    end;


    procedure FormatDecimals(DecValue: Decimal;MaxDigits: Integer;FieldName: Text[3]): Text[13]
    var
        DecValueString: Text[30];
    begin
        DecValueString := DelChr(Format(DecValue),'=',',');

        if DecValue <> 0 then begin
          if StrPos(DecValueString,'.') <> 0 then begin
            if StrLen(DecValueString) - StrPos(DecValueString,'.') = 1 then
              DecValueString := InsStr(DelChr(DecValueString,'=','.'),'0',StrLen(DecValueString) + 1)
            else
              DecValueString := DelChr(DecValueString,'=','.')
          end else
            DecValueString := InsStr(DecValueString,'00',StrLen(DecValueString) + 1);
          if StrLen(DecValueString) > MaxDigits then
            Error(Text008,FieldName,MaxDigits);
          exit(DecValueString);
        end;
        exit('000')
    end;


    procedure FormatDates(Date: Date): Text[8]
    begin
        exit(Format(Date,0,'<Closing><Year4><Month,2><Day,2>'));
    end;


    procedure CheckForNegative(DecValue: Decimal): Decimal
    begin
        if DecValue <= 0 then
          exit(0);
        exit(DecValue);
    end;


    procedure CheckForPositive(DecValue: Decimal): Decimal
    begin
        if DecValue >= 0 then
          exit(0);
        exit(Abs(DecValue));
    end;

    local procedure CheckValue(Value: Decimal;FieldName: Text[3])
    begin
        if Value > TotalITCAdjsmnt then
          Error(Text009,FieldName,'108');
    end;
}


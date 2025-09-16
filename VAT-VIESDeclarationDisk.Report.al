#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 88 "VAT- VIES Declaration Disk"
{
    Caption = 'VAT- VIES Declaration Disk';
    Permissions = TableData "VAT Entry"=imd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("VAT Entry";"VAT Entry")
        {
            DataItemTableView = sorting(Type,"Country/Region Code","VAT Registration No.","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date") where(Type=const(Sale));
            RequestFilterFields = "VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date";
            column(ReportForNavId_7612; 7612)
            {
            }

            trigger OnAfterGetRecord()
            var
                VATEntry: Record "VAT Entry";
                TotalValueOfItemSupplies: Decimal;
                TotalValueOfServiceSupplies: Decimal;
                GroupTotal: Boolean;
            begin
                if "EU Service" then begin
                  if UseAmtsInAddCurr then
                    TotalValueOfServiceSupplies := "Additional-Currency Base"
                  else
                    TotalValueOfServiceSupplies := Base
                end else
                  if UseAmtsInAddCurr then
                    TotalValueOfItemSupplies := "Additional-Currency Base"
                  else
                    TotalValueOfItemSupplies := Base;

                if "EU 3-Party Trade" then begin
                  EU3PartyItemTradeAmt := EU3PartyItemTradeAmt + TotalValueOfItemSupplies;
                  EU3PartyServiceTradeAmt := EU3PartyServiceTradeAmt + TotalValueOfServiceSupplies;
                end;
                TotalValueofItemSuppliesTotal += TotalValueOfItemSupplies;
                TotalValueofServiceSuppliesTot += TotalValueOfServiceSupplies;

                VATEntry.Copy("VAT Entry");
                if VATEntry.Next = 1 then begin
                  if (VATEntry."Country/Region Code" <> "Country/Region Code") or
                     (VATEntry."VAT Registration No." <> "VAT Registration No.")
                  then
                    GroupTotal := true;
                end else
                  GroupTotal := true;

                if GroupTotal then begin
                  WriteGrTotalsToFile(TotalValueofServiceSuppliesTot,TotalValueofItemSuppliesTotal,
                    EU3PartyServiceTradeAmt,EU3PartyItemTradeAmt);
                  EU3PartyItemTradeTotalAmt += EU3PartyItemTradeAmt;
                  EU3PartyServiceTradeTotalAmt += EU3PartyServiceTradeAmt;

                  TotalValueofItemSuppliesTotal := 0;
                  TotalValueofServiceSuppliesTot := 0;

                  EU3PartyItemTradeAmt := 0;
                  EU3PartyServiceTradeAmt := 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                VATFile.Write(
                  Format(
                    '10' + DecimalNumeralZeroFormat(NoOfGrTotal,9) +
                    DecimalNumeralZeroFormat(EU3PartyItemTradeTotalAmt,15) +
                    DecimalNumeralSign(-EU3PartyItemTradeTotalAmt) +
                    DecimalNumeralZeroFormat(EU3PartyServiceTradeTotalAmt,15) +
                    DecimalNumeralSign(-EU3PartyServiceTradeTotalAmt),
                    80));
                VATFile.Close;
            end;

            trigger OnPreDataItem()
            begin
                Clear(VATFile);
                VATFile.TextMode := true;
                VATFile.WriteMode := true;
                VATFile.Create(FileName);

                CompanyInfo.Get;
                VATRegNo := ConvertStr(CompanyInfo."VAT Registration No.",Text001,'    ');
                VATFile.Write(Format('00' + Format(VATRegNo,8) + Text002,80));
                VATFile.Write(Format('0100001',80));

                NoOfGrTotal := 0;
                Period := GetRangemax("Posting Date");
                InternalReferenceNo := Format(Period,4,2) + '000000';
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
                    field(UseAmtsInAddCurr;UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
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
    begin
        if not HideFileDialog then begin
          FileManagement.DownloadHandler(FileName ,'','',FileManagement.GetToFilterText('',FileName),ToFileNameTxt);
          FileManagement.DeleteServerFile(FileName);
        end
    end;

    trigger OnPreReport()
    begin
        FileName := FileManagement.ServerTempFileName('txt');
    end;

    var
        Text001: label 'WwWw';
        Text002: label 'LIST';
        Text003: label '%1 was not filled in for all tax entries in which %2 = %3.';
        Text004: label 'It is not possible to display %1 in a field with a length of %2.';
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        Cust: Record Customer;
        FileManagement: Codeunit "File Management";
        VATFile: File;
        TotalValueofServiceSuppliesTot: Decimal;
        TotalValueofItemSuppliesTotal: Decimal;
        EU3PartyServiceTradeAmt: Decimal;
        EU3PartyItemTradeAmt: Decimal;
        EU3PartyItemTradeTotalAmt: Decimal;
        EU3PartyServiceTradeTotalAmt: Decimal;
        NoOfGrTotal: Integer;
        FileName: Text;
        VATRegNo: Code[20];
        InternalReferenceNo: Text[10];
        Period: Date;
        UseAmtsInAddCurr: Boolean;
        ToFileNameTxt: label 'Default.txt';
        HideFileDialog: Boolean;

    local procedure DecimalNumeralSign(DecimalNumeral: Decimal): Text[1]
    begin
        if DecimalNumeral >= 0 then
          exit('+');
        exit('-');
    end;

    local procedure DecimalNumeralZeroFormat(DecimalNumeral: Decimal;Length: Integer): Text[250]
    begin
        exit(TextZeroFormat(DelChr(Format(ROUND(Abs(DecimalNumeral),1,'<'),0,1)),Length));
    end;

    local procedure TextZeroFormat(Text: Text[250];Length: Integer): Text[250]
    begin
        if StrLen(Text) > Length then
          Error(
            Text004,
            Text,Length);
        exit(PadStr('',Length - StrLen(Text),'0') + Text);
    end;

    local procedure WriteGrTotalsToFile(TotalValueofServiceSupplies: Decimal;TotalValueofItemSupplies: Decimal;EU3PartyServiceTradeAmt: Decimal;EU3PartyItemTradeAmt: Decimal)
    begin
        if (ROUND(Abs(TotalValueofItemSupplies),1,'<') <> 0) or (ROUND(Abs(TotalValueofServiceSupplies),1,'<') <> 0) or
           (ROUND(Abs(EU3PartyItemTradeAmt),1,'<') <> 0) or (ROUND(Abs(EU3PartyServiceTradeAmt),1,'<') <> 0)
        then
          with "VAT Entry" do begin
            if "VAT Registration No." = '' then begin
              Type := Type::Sale;
              Error(
                Text003,
                FieldCaption("VAT Registration No."),FieldCaption(Type),Type);
            end;

            Cust.Get("Bill-to/Pay-to No.");
            Cust.TestField("Country/Region Code");
            Country.Get(Cust."Country/Region Code");
            Cust.TestField("VAT Registration No.");
            Country.Get("Country/Region Code");
            Country.TestField("EU Country/Region Code");
            NoOfGrTotal := NoOfGrTotal + 1;

            InternalReferenceNo := IncStr(InternalReferenceNo);
            SetRange("Country/Region Code","Country/Region Code");
            SetRange("Bill-to/Pay-to No.","Bill-to/Pay-to No.");
            ModifyAll("Internal Ref. No.",InternalReferenceNo);
            SetRange("Country/Region Code");
            SetRange("Bill-to/Pay-to No.");

            VATFile.Write(
              Format(
                '02' + Format(InternalReferenceNo,10) +
                DecimalNumeralZeroFormat(Date2dmy(Period,3) MOD 100,2) +
                DecimalNumeralZeroFormat(Date2dmy(Period,2),2) +
                DecimalNumeralZeroFormat(Date2dmy(Period,1),2) +
                Format(VATRegNo,8) + Format(Country."EU Country/Region Code",2) + Format("VAT Registration No.",12) +
                DecimalNumeralZeroFormat(TotalValueofItemSupplies,15) + DecimalNumeralSign(-TotalValueofItemSupplies) + '0' +
                DecimalNumeralZeroFormat(TotalValueofServiceSupplies,15) + DecimalNumeralSign(-TotalValueofServiceSupplies) + '0' +
                DecimalNumeralZeroFormat(EU3PartyItemTradeAmt,15) + DecimalNumeralSign(-EU3PartyItemTradeAmt) + '0' +
                DecimalNumeralZeroFormat(EU3PartyServiceTradeAmt,15) + DecimalNumeralSign(-EU3PartyServiceTradeAmt),
                120));
          end;
    end;


    procedure GetFileName(): Text[1024]
    begin
        exit(FileName);
    end;


    procedure InitializeRequest(NewHideFileDialog: Boolean)
    begin
        HideFileDialog := NewHideFileDialog;
    end;
}


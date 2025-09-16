#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10102 "Top __ Vendor List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Top __ Vendor List.rdlc';
    Caption = 'Top __ Vendor List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Heading;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            MaxIteration = 1;
            column(ReportForNavId_6714; 6714)
            {
            }
            column(MainTitle_;MainTitle)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(TIME;Time)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(ColHead;ColHead)
            {
            }
            column(PrintToExcel;PrintToExcel)
            {
            }
            column(Heading_Number;Number)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(iCaption;iCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(TopNo_i_Caption;TopNo_i_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            dataitem(Vendor;Vendor)
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.","Vendor Posting Group","Purchaser Code","Date Filter";
                column(ReportForNavId_3182; 3182)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(1,"No.");
                    CalcFields("Balance on Date (LCY)","Purchases (LCY)");
                    TopBalance[NextTopLineNo] := "Balance on Date (LCY)";
                    TopPurch[NextTopLineNo] := "Purchases (LCY)";
                    if TopType = Toptype::"Balances ($)" then
                      TopAmount[NextTopLineNo] := TopBalance[NextTopLineNo]
                    else
                      TopAmount[NextTopLineNo] := TopPurch[NextTopLineNo];
                    GrandTotal := GrandTotal + TopAmount[NextTopLineNo];
                    GrandTotalBalance := GrandTotalBalance + TopBalance[NextTopLineNo];
                    GrandTotalPurch := GrandTotalPurch + TopPurch[NextTopLineNo];
                    TopNo[NextTopLineNo] := "No.";
                    TopName[NextTopLineNo] := Name;
                    i := NextTopLineNo;
                    if NextTopLineNo < (VendorsToRank + 1) then
                      NextTopLineNo := NextTopLineNo + 1;
                    while i > 1 do begin
                      i := i - 1;
                      if TopAmount[i + 1] > TopAmount[i] then begin
                        // Sort the vendors by amount, largest should be first, smallest last. Put
                        // values from position i into save variables, move values from position
                        // i+1 to position i then put save values back in array in position i+1.
                        SwapCode(TopNo,i);
                        SwapAmt(TopAmount,i);
                        SwapAmt(TopPurch,i);
                        SwapAmt(TopBalance,i);
                        SwapText(TopName,i);
                      end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NextTopLineNo := 1;
                    Window.Open(Text000);
                end;
            }
            dataitem(PrintLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                MaxIteration = 99;
                column(ReportForNavId_9279; 9279)
                {
                }
                column(i;i)
                {
                }
                column(TopNo_i_;TopNo[i])
                {
                }
                column(Top__;"Top%")
                {
                    DecimalPlaces = 1:1;
                }
                column(TopAmount_i_;TopAmount[i])
                {
                }
                column(BarText;BarText)
                {
                }
                column(TopName_i_;TopName[i])
                {
                }
                column(BarTextNNC;BarTextNNC)
                {
                }
                column(STRSUBSTNO__Top__1_Total__2__VendorsToRank_TopTotalText_;StrSubstNo('Top %1 Total %2',VendorsToRank,TopTotalText))
                {
                }
                column(Top___Control23;"Top%")
                {
                    DecimalPlaces = 1:1;
                }
                column(TopTotal;TopTotal)
                {
                }
                column(V100_0____Top__;100.0 - "Top%")
                {
                    DecimalPlaces = 1:1;
                }
                column(GrandTotal___TopTotal;GrandTotal - TopTotal)
                {
                }
                column(Total_____TopTotalText;'Total ' + TopTotalText)
                {
                }
                column(GrandTotal;GrandTotal)
                {
                }
                column(PrintLoop_Number;Number)
                {
                }
                column(All_other_vendorsCaption;All_other_vendorsCaptionLbl)
                {
                }
                column(V100_0Caption;V100_0CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    i := i + 1;
                    if i = NextTopLineNo then begin
                      if TopType = Toptype::"Balances ($)" then
                        TopTotalText := Text006
                      else
                        TopTotalText := Text007;
                      if GrandTotal <> 0 then
                        "Top%" := ROUND(TopTotal / GrandTotal * 100,0.1)
                      else
                        "Top%" := 0;
                      CurrReport.Break;
                    end;
                    TopTotal := TopTotal + TopAmount[i];
                    TopTotalBalance := TopTotalBalance + TopBalance[i];
                    TopTotalPurch := TopTotalPurch + TopPurch[i];
                    if (TopAmount[1] > 0) and (TopAmount[i] > 0) then
                      BarText := ParagraphHandling.PadStrProportional('',ROUND(TopAmount[i] / TopAmount[1] * 61,1),7,'|')
                    else
                      BarText := '';
                    if GrandTotal <> 0 then
                      "Top%" := ROUND(TopAmount[i] / GrandTotal * 100,0.1)
                    else
                      "Top%" := 0;

                    if (TopAmount[1] > 0) and (TopAmount[i] > 0) then
                      BarTextNNC := ROUND(TopAmount[i] / TopAmount[1] * 100,1)
                    else
                      BarTextNNC := 0;

                    if TopType = Toptype::"Balances ($)" then
                      TopTotalText := Text006
                    else
                      TopTotalText := Text007;

                    if PrintToExcel then
                      MakeExcelDataBody;
                end;

                trigger OnPostDataItem()
                begin
                    if PrintToExcel then
                      if (GrandTotalBalance <> TopTotalBalance) or (GrandTotalPurch <> TopTotalPurch) then begin
                        if GrandTotal <> 0 then
                          "Top%" := ROUND(TopTotal / GrandTotal * 100,0.1)
                        else
                          "Top%" := 0;
                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn('',false,'',false,false,false,'',ExcelBuf."cell type"::Text);
                        ExcelBuf.AddColumn(Format(Text114),false,'',false,false,false,'',ExcelBuf."cell type"::Text);
                        ExcelBuf.AddColumn(GrandTotalPurch - TopTotalPurch,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
                        ExcelBuf.AddColumn(GrandTotalBalance - TopTotalBalance,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
                        ExcelBuf.AddColumn((100 - "Top%") / 100,false,'',false,false,false,'0.0%',ExcelBuf."cell type"::Number);
                      end;
                end;

                trigger OnPreDataItem()
                begin
                    Window.Close;
                    i := 0;
                end;
            }
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
                    field(Show;TopType)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show';
                        OptionCaption = 'Balances ($),Purchases ($)';
                        ToolTip = 'Specifies which accounts to include. All Accounts: Includes all accounts with transactions. Accounts with Balances: Includes accounts with balances. Accounts with Activity: Includes accounts that are currently active.';
                    }
                    field(VendorsToRank;VendorsToRank)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'No. of Vendors to Rank';
                        ToolTip = 'Specifies the number of vendors that you want to include. You can include up to 99 vendors. The default value in this field is zero, but if you leave a zero there, the report will include 20 vendors.';

                        trigger OnValidate()
                        begin
                            if not (VendorsToRank < ArrayLen(TopNo)) then
                              Error(Text008,ArrayLen(TopNo));
                        end;
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print to Excel';
                        ToolTip = 'Specifies if you want to export the data to an Excel spreadsheet for additional analysis or formatting before printing.';
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
        if PrintToExcel then
          CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        
        if VendorsToRank = 0 then // default
          VendorsToRank := 20;
        if TopType = Toptype::"Balances ($)" then begin
          if Vendor.GetFilter("Date Filter") = '' then
            SubTitle := Text001
          else
            SubTitle := Text009 + ' ' +
              Format(Vendor.GetRangemax("Date Filter")) + ')';
          ColHead := Text002;
        end else begin
          if Vendor.GetFilter("Date Filter") = '' then
            SubTitle := Text003
          else
            SubTitle := Text004 + ' ' + Vendor.GetFilter("Date Filter") + ')';
          ColHead := Text007;
        end;
        
        MainTitle := StrSubstNo(Text005,VendorsToRank);
        /* Temporarily remove date filter, since it will show in the header anyway */
        Vendor.SetRange("Date Filter");
        FilterString := Vendor.GetFilters;
        
        if PrintToExcel then
          MakeExcelInfo;

    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        FilterString: Text;
        MainTitle: Text[150];
        SubTitle: Text;
        ColHead: Text[15];
        TopTotalText: Text[40];
        BarText: Text[250];
        TopName: array [100] of Text[50];
        "Top%": Decimal;
        GrandTotal: Decimal;
        GrandTotalBalance: Decimal;
        GrandTotalPurch: Decimal;
        TopAmount: array [100] of Decimal;
        TopTotal: Decimal;
        TopTotalBalance: Decimal;
        TopTotalPurch: Decimal;
        TopBalance: array [100] of Decimal;
        TopPurch: array [100] of Decimal;
        i: Integer;
        NextTopLineNo: Integer;
        VendorsToRank: Integer;
        TopType: Option "Balances ($)","Purchases ($)";
        TopNo: array [100] of Code[20];
        CompanyInformation: Record "Company Information";
        Window: Dialog;
        ParagraphHandling: Codeunit "Paragraph Handling";
        Text000: label 'Going through vendors   #1##################';
        Text001: label '(by Balance Due)';
        Text002: label 'Balances';
        Text003: label '(by Total Purchases)';
        Text004: label '(by Purchases During the Period';
        Text005: label 'Top %1 Vendors';
        Text006: label 'Amount Outstanding';
        Text007: label 'Purchases';
        Text008: label 'Number of vendors must be less than %1.';
        PrintToExcel: Boolean;
        Text009: label '(by Balance Due as of';
        Text101: label 'Data';
        Text103: label 'Company Name';
        Text104: label 'Report No.';
        Text105: label 'Report Name';
        Text106: label 'User ID';
        Text107: label 'Date / Time';
        Text108: label 'Subtitle';
        Text109: label 'Vendor Filters';
        Text110: label 'Purchase Amount';
        Text111: label 'Balance Amount';
        Text112: label 'Percent of Total Purchases';
        Text113: label 'Percent of Total Balance';
        Text114: label 'All other vendors';
        BarTextNNC: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        iCaptionLbl: label 'Rank';
        EmptyStringCaptionLbl: label '%';
        TopNo_i_CaptionLbl: label 'Vendor';
        NameCaptionLbl: label 'Name';
        All_other_vendorsCaptionLbl: label 'All other vendors';
        V100_0CaptionLbl: label '100.0';

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text103),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text105),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Format(MainTitle),false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text104),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Report::"Top __ Vendor List",false,false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text106),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text107),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddInfoColumn(Time,false,false,false,false,'',ExcelBuf."cell type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text108),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(SubTitle,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text109),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(FilterString,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          Vendor.TableCaption + ' ' + Vendor.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Vendor.FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text110),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text111),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        if TopType = Toptype::"Balances ($)" then
          ExcelBuf.AddColumn(Format(Text113),false,'',true,false,true,'',ExcelBuf."cell type"::Text)
        else
          ExcelBuf.AddColumn(Format(Text112),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(TopNo[i],false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TopName[i],false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TopPurch[i],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(TopBalance[i],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("Top%" / 100,false,'',false,false,false,'0.0%',ExcelBuf."cell type"::Number);
    end;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text101,MainTitle,COMPANYNAME,UserId);
        Error('');
    end;

    local procedure SwapAmt(var AmtArray: array [100] of Decimal;Index: Integer)
    var
        TempAmt: Decimal;
    begin
        TempAmt := AmtArray[Index];
        AmtArray[Index] := AmtArray[Index + 1];
        AmtArray[Index + 1] := TempAmt;
    end;

    local procedure SwapText(var TextArray: array [100] of Text[50];Index: Integer)
    var
        TempText: Text[50];
    begin
        TempText := TextArray[Index];
        TextArray[Index] := TextArray[Index + 1];
        TextArray[Index + 1] := TempText;
    end;

    local procedure SwapCode(var CodeArray: array [100] of Code[20];Index: Integer)
    var
        TempCode: Code[20];
    begin
        TempCode := CodeArray[Index];
        CodeArray[Index] := CodeArray[Index + 1];
        CodeArray[Index + 1] := TempCode;
    end;
}


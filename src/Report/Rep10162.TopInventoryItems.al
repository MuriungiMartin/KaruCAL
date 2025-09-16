#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10162 "Top __ Inventory Items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Top __ Inventory Items.rdlc';
    Caption = 'Top __ Inventory Items';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Inventory Posting Group","Date Filter","Location Filter","Base Unit of Measure";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(MainTitle;MainTitle)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ColHead;ColHead)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(PrintToExcel;PrintToExcel)
            {
            }
            column(Item_No_;"No.")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Integer_NumberCaption;Integer_NumberCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Top__Caption;Top__CaptionLbl)
            {
            }
            column(TopNo_Number_Caption;TopNo_Number_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                CalcFields("Sales (LCY)","Net Change");
                TopSale[NextTopLineNo] := "Sales (LCY)";
                TopQty[NextTopLineNo] := "Net Change";
                with ValueEntry do begin
                  Reset;
                  if (Item.GetFilter("Global Dimension 1 Filter") <> '') or
                     (Item.GetFilter("Global Dimension 2 Filter") <> '')
                  then
                    SetCurrentkey(
                      "Item No.","Posting Date","Item Ledger Entry Type","Entry Type",
                      "Variance Type","Item Charge No.","Location Code","Variant Code",
                      "Global Dimension 1 Code","Global Dimension 2 Code")
                  else
                    SetCurrentkey(
                      "Item No.","Posting Date","Item Ledger Entry Type","Entry Type",
                      "Variance Type","Item Charge No.","Location Code","Variant Code");
                  SetRange("Item No.",Item."No.");
                  Item.Copyfilter("Location Filter","Location Code");
                  Item.Copyfilter("Variant Filter","Variant Code");
                  Item.Copyfilter("Global Dimension 1 Filter","Global Dimension 1 Code");
                  Item.Copyfilter("Global Dimension 2 Filter","Global Dimension 2 Code");
                  Item.Copyfilter("Date Filter","Posting Date");
                  CalcSums("Cost Amount (Actual)");
                  TopValue[NextTopLineNo] := "Cost Amount (Actual)";
                end;
                case TopType of
                  Toptype::Sales:
                    TopAmount[NextTopLineNo] := TopSale[NextTopLineNo];
                  Toptype::"Qty on Hand":
                    TopAmount[NextTopLineNo] := TopQty[NextTopLineNo];
                  Toptype::"Inventory Value":
                    TopAmount[NextTopLineNo] := TopValue[NextTopLineNo];
                end;
                if (TopAmount[NextTopLineNo] = 0) and not PrintAlsoIfZero then
                  CurrReport.Skip;
                GrandTotal := GrandTotal + TopAmount[NextTopLineNo];
                GrandTotalSale := GrandTotalSale + TopSale[NextTopLineNo];
                GrandTotalQty := GrandTotalQty + TopQty[NextTopLineNo];
                GrandTotalValue := GrandTotalValue + TopValue[NextTopLineNo];
                TopNo[NextTopLineNo] := "No.";
                TopName[NextTopLineNo] := Description;
                i := NextTopLineNo;
                if NextTopLineNo < (ItemsToRank + 1) then
                  NextTopLineNo := NextTopLineNo + 1;
                while i > 1 do begin
                  i := i - 1;
                  if TopSorting = Topsorting::Largest then begin
                    if TopAmount[i + 1] > TopAmount[i] then
                      Interchange(i);
                  end else begin
                    if TopAmount[i + 1] < TopAmount[i] then
                      Interchange(i);
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ItemsToRank = 0 then // defaults to 20 if no amount entered
                  ItemsToRank := 20;
                MainTitle := StrSubstNo(Text000,ItemsToRank);
                if TopSorting = Topsorting::Largest then
                  SubTitle := Text001
                else
                  SubTitle := Text002;
                case TopType of
                  Toptype::Sales:
                    begin
                      SubTitle := SubTitle + ' ' + Text003;
                      if GetFilter("Date Filter") <> '' then
                        SubTitle := SubTitle + ' ' + Text006 + ' ' + GetFilter("Date Filter");
                      ColHead := Text008;
                    end;
                  Toptype::"Inventory Value":
                    begin
                      SubTitle := SubTitle + ' ' + Text004;
                      if GetFilter("Date Filter") <> '' then begin
                        /* readjust filter so it is correct */
                        TempDate := GetRangemax("Date Filter");
                        SetRange("Date Filter",0D,TempDate);
                        SubTitle := SubTitle + ' ' + StrSubstNo(Text007,TempDate);
                      end;
                      ColHead := Text009;
                    end;
                  Toptype::"Qty on Hand":
                    begin
                      SubTitle := SubTitle + ' ' + Text005;
                      if GetFilter("Date Filter") <> '' then begin
                        /* readjust filter so it is correct */
                        TempDate := GetRangemax("Date Filter");
                        SetRange("Date Filter",0D,TempDate);
                        SubTitle := SubTitle + ' ' + StrSubstNo(Text007,TempDate);
                      end;
                      ColHead := Text010;
                    end;
                end;
                NextTopLineNo := 1;
                Window.Open(Text011);
                
                if PrintToExcel then
                  MakeExcelInfo;

            end;
        }
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 99;
            column(ReportForNavId_5444; 5444)
            {
            }
            column(Integer_Number;Number)
            {
            }
            column(TopNo_Number_;TopNo[Number])
            {
            }
            column(TopName_Number_;TopName[Number])
            {
            }
            column(Top__;"Top%")
            {
                DecimalPlaces = 1:1;
            }
            column(TopAmount_Number_;TopAmount[Number])
            {
            }
            column(BarText;BarText)
            {
            }
            column(BarTextNNC;BarTextNNC)
            {
            }
            column(STRSUBSTNO_Text013_ItemsToRank_TopTotalText_;StrSubstNo(Text013,ItemsToRank,TopTotalText))
            {
            }
            column(Top___Control22;"Top%")
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
            column(STRSUBSTNO_Text014_TopTotalText_;StrSubstNo(Text014,TopTotalText))
            {
            }
            column(GrandTotal;GrandTotal)
            {
            }
            column(All_other_itemsCaption;All_other_itemsCaptionLbl)
            {
            }
            column(V100_0Caption;V100_0CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TopTotal := TopTotal + TopAmount[Number];
                TopTotalSale := TopTotalSale + TopSale[Number];
                TopTotalQty := TopTotalQty + TopQty[Number];
                TopTotalValue := TopTotalValue + TopValue[Number];
                if (TopScale > 0) and (TopAmount[Number] > 0) then
                  BarText :=
                    ParagraphHandling.PadStrProportional(
                      '',ROUND(TopAmount[Number] / TopScale * 61,1),7,'|')
                else
                  BarText := '';
                if GrandTotal <> 0 then
                  "Top%" := ROUND(TopAmount[Number] / GrandTotal * 100,0.1)
                else
                  "Top%" := 0;

                if (TopScale > 0) and (TopAmount[Number] > 0) then
                  BarTextNNC := ROUND(TopAmount[Number] / TopScale * 100,1)
                else
                  BarTextNNC := 0;

                case TopType of
                  Toptype::Sales:
                    TopTotalText := Text008;
                  Toptype::"Inventory Value":
                    TopTotalText := Text009;
                  Toptype::"Qty on Hand":
                    TopTotalText := Text010;
                end;

                if PrintToExcel then
                  MakeExcelDataBody;
            end;

            trigger OnPostDataItem()
            begin
                if PrintToExcel then
                  if (GrandTotalValue <> TopTotalValue) or
                     (GrandTotalQty <> TopTotalQty) or
                     (GrandTotalSale <> TopTotalSale)
                  then begin
                    if GrandTotal <> 0 then
                      "Top%" := ROUND(TopTotal / GrandTotal * 100,0.1)
                    else
                      "Top%" := 0;
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn('',false,'',false,false,false,'',ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(Format(Text115),false,'',false,false,false,'',ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(GrandTotalSale - TopTotalSale,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(GrandTotalQty - TopTotalQty,false,'',false,false,false,'',ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(GrandTotalValue - TopTotalValue,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn((100 - "Top%") / 100,false,'',false,false,false,'0.0%',ExcelBuf."cell type"::Number);
                  end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Close;
                SetRange(Number,1,NextTopLineNo - 1);
                if TopSorting = Topsorting::Largest then
                  TopScale := TopAmount[1]
                else
                  if NextTopLineNo > 1 then
                    TopScale := TopAmount[NextTopLineNo - 1 ]
                  else
                    TopScale := 0;
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
                    field(TopSorting;TopSorting)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show';
                        OptionCaption = 'Largest,Smallest';
                    }
                    field(TopType;TopType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amounts to Show';
                        OptionCaption = 'Sales,Qty on Hand,Inventory Value';
                    }
                    field(PrintAlsoIfZero;PrintAlsoIfZero)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Including Zero Amounts';
                    }
                    field(ItemsToRank;ItemsToRank)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Number of Items to Rank';
                        MaxValue = 99;
                        MinValue = 0;
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        begin
            if ItemsToRank > 99 then
              Error(Text012);
        end;
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
        /* temporarily remove date filter, since it will show in the header anyway */
        Item.SetRange("Date Filter");
        ItemFilter := Item.GetFilters;

    end;

    var
        ValueEntry: Record "Value Entry";
        CompanyInformation: Record "Company Information";
        ExcelBuf: Record "Excel Buffer" temporary;
        ItemFilter: Text;
        MainTitle: Text;
        SubTitle: Text;
        ColHead: Text[20];
        TempDate: Date;
        TopTotalText: Text[40];
        BarText: Text[250];
        TopName: array [100] of Text[50];
        TopNo: array [100] of Code[20];
        TopAmount: array [100] of Decimal;
        TopQty: array [100] of Decimal;
        TopSale: array [100] of Decimal;
        TopValue: array [100] of Decimal;
        TopScale: Decimal;
        TopTotal: Decimal;
        TopTotalQty: Decimal;
        TopTotalSale: Decimal;
        TopTotalValue: Decimal;
        GrandTotal: Decimal;
        GrandTotalQty: Decimal;
        GrandTotalSale: Decimal;
        GrandTotalValue: Decimal;
        "Top%": Decimal;
        NextTopLineNo: Integer;
        ItemsToRank: Integer;
        i: Integer;
        TopType: Option Sales,"Qty on Hand","Inventory Value";
        TopSorting: Option Largest,Smallest;
        PrintAlsoIfZero: Boolean;
        Window: Dialog;
        ParagraphHandling: Codeunit "Paragraph Handling";
        Text000: label 'Top %1 Inventory Items';
        Text001: label 'Largest';
        Text002: label 'Smallest';
        Text003: label 'sales';
        Text004: label 'inventory value';
        Text005: label 'quantity on hand';
        Text006: label 'during the period';
        Text007: label 'on %1';
        Text008: label 'Sales';
        Text009: label 'Inventory Value';
        Text010: label 'Quantity on Hand';
        Text011: label 'Sorting items    #1##################';
        Text012: label 'Number of Items must be less than %1';
        Text013: label 'Top %1 Total %2';
        Text014: label 'Total %1';
        PrintToExcel: Boolean;
        Text101: label 'Data';
        Text103: label 'Company Name';
        Text104: label 'Report No.';
        Text105: label 'Report Name';
        Text106: label 'User ID';
        Text107: label 'Date / Time';
        Text108: label 'Subtitle';
        Text109: label 'Item Filters';
        Text112: label 'Percent of Total Sales';
        Text113: label 'Percent of Total Inventory Value';
        Text114: label 'Percent of Total Quantity on Hand';
        Text115: label 'All other inventory items';
        BarTextNNC: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Integer_NumberCaptionLbl: label 'Rank';
        DescriptionCaptionLbl: label 'Description';
        Top__CaptionLbl: label '% of Total';
        TopNo_Number_CaptionLbl: label 'Item No.';
        All_other_itemsCaptionLbl: label 'All other items';
        V100_0CaptionLbl: label '100.0';


    procedure Interchange(i: Integer)
    begin
        SwapCode(TopNo,i);
        SwapText(TopName,i);
        SwapAmt(TopAmount,i);
        SwapAmt(TopQty,i);
        SwapAmt(TopValue,i);
        SwapAmt(TopSale,i);
    end;

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
        ExcelBuf.AddInfoColumn(Report::"Top __ Inventory Items",false,false,false,false,'',ExcelBuf."cell type"::Number);
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
        ExcelBuf.AddInfoColumn(ItemFilter,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          Item.TableCaption + ' ' + Item.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text008),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text010),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text009),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        case TopType of
          Toptype::Sales:
            ExcelBuf.AddColumn(Format(Text112),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          Toptype::"Qty on Hand":
            ExcelBuf.AddColumn(Format(Text114),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
          Toptype::"Inventory Value":
            ExcelBuf.AddColumn(Format(Text113),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        end;
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(TopNo[Integer.Number],false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TopName[Integer.Number],false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(TopSale[Integer.Number],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(TopQty[Integer.Number],false,'',false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(TopValue[Integer.Number],false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
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


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10049 "Cust./Item Stat. by Salespers."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cust.Item Stat. by Salespers..rdlc';
    Caption = 'Cust./Item Stat. by Salespers.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Salesperson/Purchaser";"Salesperson/Purchaser")
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code",Name;
            RequestFilterHeading = 'Salesperson';
            column(ReportForNavId_3065; 3065)
            {
            }
            column(FORMAT_TODAY_0_4;Format(Today,0,4))
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
            column(FilterString;FilterString)
            {
            }
            column(PrintToExcel;PrintToExcel)
            {
            }
            column(FilterString2;FilterString2)
            {
            }
            column(FilterString3;FilterString3)
            {
            }
            column(OnlyOnePerPage;OnlyOnePerPage)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(Salesperson_Purchaser__TABLECAPTION___________FilterString;"Salesperson/Purchaser".TableCaption + ':  ' + FilterString)
            {
            }
            column(Customer_TABLECAPTION___________FilterString2;Customer.TableCaption + ':  ' + FilterString2)
            {
            }
            column(Value_Entry__TABLECAPTION___________FilterString3;"Value Entry".TableCaption + ':  ' + FilterString3)
            {
            }
            column(SalespersonString;SalespersonString)
            {
            }
            column(Salesperson_Purchaser_Code;Code)
            {
            }
            column(Salesperson_Purchaser_Name;Name)
            {
            }
            column(Value_Entry___Sales_Amount__Actual__;"Value Entry"."Sales Amount (Actual)")
            {
            }
            column(Profit;Profit)
            {
            }
            column(Value_Entry___Discount_Amount_;"Value Entry"."Discount Amount")
            {
            }
            column(Profit__;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(Customer_Item_Statistics_by_SalespersonCaption;Customer_Item_Statistics_by_SalespersonCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_CodeCaption;Salesperson_Purchaser_CodeCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_NameCaption;Salesperson_Purchaser_NameCaptionLbl)
            {
            }
            column(Customer__No__Caption;Customer__No__CaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer_NameCaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;Item__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(Profit_Control51Caption;Profit_Control51CaptionLbl)
            {
            }
            column(Profit___Control53Caption;Profit___Control53CaptionLbl)
            {
            }
            column(Value_Entry__Item_No__Caption;Value_Entry__Item_No__CaptionLbl)
            {
            }
            column(Item_DescriptionCaption;Item_DescriptionCaptionLbl)
            {
            }
            column(Invoiced_Quantity_Caption;Invoiced_Quantity_CaptionLbl)
            {
            }
            column(Value_Entry__Sales_Amount__Actual__Caption;Value_Entry__Sales_Amount__Actual__CaptionLbl)
            {
            }
            column(Value_Entry__Discount_Amount_Caption;Value_Entry__Discount_Amount_CaptionLbl)
            {
            }
            column(Report_TotalsCaption;Report_TotalsCaptionLbl)
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemTableView = sorting("Salesperson Code","No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.","Search Name";
                column(ReportForNavId_6836; 6836)
                {
                }
                column(Customer__No__;"No.")
                {
                }
                column(Customer_Name;Name)
                {
                }
                column(Customer__Phone_No__;"Phone No.")
                {
                }
                column(Customer_Contact;Contact)
                {
                }
                column(Salesperson_Purchaser__Code;"Salesperson/Purchaser".Code)
                {
                }
                column(Value_Entry___Sales_Amount__Actual___Control41;"Value Entry"."Sales Amount (Actual)")
                {
                }
                column(Profit_Control42;Profit)
                {
                }
                column(Value_Entry___Discount_Amount__Control43;"Value Entry"."Discount Amount")
                {
                }
                column(Profit___Control44;"Profit%")
                {
                    DecimalPlaces = 1:1;
                }
                column(Customer_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
                {
                }
                column(Customer_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
                {
                }
                column(Phone_Caption;Phone_CaptionLbl)
                {
                }
                column(Contact_Caption;Contact_CaptionLbl)
                {
                }
                column(Salesperson_TotalsCaption;Salesperson_TotalsCaptionLbl)
                {
                }
                dataitem("Value Entry";"Value Entry")
                {
                    DataItemLink = "Source No."=field("No."),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                    DataItemTableView = sorting("Source Type","Source No.","Item Ledger Entry Type","Item No.","Posting Date") where("Source Type"=const(Customer),"Item Ledger Entry Type"=const(Sale),"Expected Cost"=const(false));
                    RequestFilterFields = "Item No.","Inventory Posting Group","Posting Date";
                    column(ReportForNavId_8894; 8894)
                    {
                    }
                    column(Value_Entry__Item_No__;"Item No.")
                    {
                    }
                    column(Item_Description;Item.Description)
                    {
                    }
                    column(Invoiced_Quantity_;-"Invoiced Quantity")
                    {
                    }
                    column(Item__Base_Unit_of_Measure_;Item."Base Unit of Measure")
                    {
                    }
                    column(Value_Entry__Sales_Amount__Actual__;"Sales Amount (Actual)")
                    {
                    }
                    column(Profit_Control51;Profit)
                    {
                    }
                    column(Value_Entry__Discount_Amount_;"Discount Amount")
                    {
                    }
                    column(Profit___Control53;"Profit%")
                    {
                        DecimalPlaces = 1:1;
                    }
                    column(Customer__No___Control54;Customer."No.")
                    {
                    }
                    column(Value_Entry__Sales_Amount__Actual___Control55;"Sales Amount (Actual)" + 0)
                    {
                    }
                    column(Profit_Control56;Profit + 0)
                    {
                    }
                    column(Value_Entry__Discount_Amount__Control57;"Discount Amount" + 0)
                    {
                    }
                    column(Profit___Control58;"Profit%" + 0)
                    {
                        DecimalPlaces = 1:1;
                    }
                    column(Value_Entry_Entry_No_;"Entry No.")
                    {
                    }
                    column(Value_Entry_Source_No_;"Source No.")
                    {
                    }
                    column(Value_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                    {
                    }
                    column(Value_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                    {
                    }
                    column(Customer_TotalsCaption;Customer_TotalsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ValueEntryTotalForItem."Item No." <> "Item No." then begin
                          "CalculateProfit%";
                          if PrintToExcel and (ValueEntryTotalForItem."Item No." <> '') then
                            MakeExcelDataBody;
                          Clear(ValueEntryTotalForItem);
                          ProfitTotalForItem := 0;
                          if not Item.Get("Item No.") then begin
                            Item.Description := 'Others';
                            Item."Base Unit of Measure" := '';
                          end;
                        end;

                        Profit := "Sales Amount (Actual)" + "Cost Amount (Actual)";
                        "Discount Amount" := -"Discount Amount";

                        ValueEntryTotalForItem."Item No." := "Item No.";
                        ValueEntryTotalForItem."Invoiced Quantity" += "Invoiced Quantity";
                        ValueEntryTotalForItem."Sales Amount (Actual)" += "Sales Amount (Actual)";
                        ValueEntryTotalForItem."Discount Amount" += "Discount Amount";
                        ProfitTotalForItem += Profit;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if PrintToExcel and (ValueEntryTotalForItem."Item No." <> '') then begin
                          "CalculateProfit%";
                          MakeExcelDataBody;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        case SalespersonToUse of
                          Salespersontouse::"Assigned To Customer":
                            SetRange("Salespers./Purch. Code");
                          Salespersontouse::"Assigned To Sales Order":
                            SetRange("Salespers./Purch. Code","Salesperson/Purchaser".Code);
                        end;

                        CurrReport.CreateTotals("Invoiced Quantity","Sales Amount (Actual)",Profit,"Discount Amount");
                        Clear(ValueEntryTotalForItem);
                        ProfitTotalForItem := 0;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    case SalespersonToUse of
                      Salespersontouse::"Assigned To Customer":
                        begin
                          SetCurrentkey("Salesperson Code","No.");
                          SetRange("Salesperson Code","Salesperson/Purchaser".Code);
                        end;
                      Salespersontouse::"Assigned To Sales Order":
                        begin
                          SetCurrentkey("No.");
                          SetRange("Salesperson Code");
                        end;
                    end;

                    CurrReport.CreateTotals("Value Entry"."Sales Amount (Actual)",Profit,"Value Entry"."Discount Amount");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.NewPagePerRecord := OnlyOnePerPage;

                if OnlyOnePerPage then
                  PageGroupNo := PageGroupNo + 1
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Value Entry"."Sales Amount (Actual)",Profit,"Value Entry"."Discount Amount");
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
                    field(SalespersonToUse;SalespersonToUse)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Salesperson To Use';
                        OptionCaption = 'Assigned To Customer,Assigned To Sales Order';
                        ToolTip = 'Specifies if the report must be based on the salesperson that is assigned to the customer or to the sales order.';
                    }
                    field(OnlyOnePerPage;OnlyOnePerPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Salesperson';
                        ToolTip = 'Specifies if each salesperson''s statistics begins on a new page.';
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Suite;
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
        FilterString := "Salesperson/Purchaser".GetFilters;
        FilterString2 := Customer.GetFilters;
        FilterString3 := "Value Entry".GetFilters;
        case SalespersonToUse of
          Salespersontouse::"Assigned To Customer":
            SalespersonString := Text002;
          Salespersontouse::"Assigned To Sales Order":
            SalespersonString := Text003;
          else
            Error(Text001);
        end;

        if PrintToExcel then
          MakeExcelInfo;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        FilterString: Text;
        FilterString2: Text;
        FilterString3: Text;
        Profit: Decimal;
        "Profit%": Decimal;
        OnlyOnePerPage: Boolean;
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        SalespersonToUse: Option "Assigned To Customer","Assigned To Sales Order";
        SalespersonString: Text[250];
        Text001: label 'Invalid option chosen for Salesperson To Use.';
        Text002: label 'Individual sale shows under the Salesperson assigned to that Customer.';
        Text003: label 'Individual sale shows under the Salesperson assigned to that individual Sales Order.';
        PrintToExcel: Boolean;
        Text101: label 'Data';
        Text102: label 'Customer/Item Statistics by Salesperson';
        Text103: label 'Company Name';
        Text104: label 'Report No.';
        Text105: label 'Report Name';
        Text106: label 'User ID';
        Text107: label 'Date / Time';
        Text108: label 'Salesperson Filters';
        Text109: label 'Customer Filters';
        Text110: label 'Value Entry Filters';
        Text111: label 'Salesperson to Use';
        Text112: label 'Contribution Margin';
        Text113: label 'Contribution Ratio';
        Text114: label 'Salesperson';
        PageGroupNo: Integer;
        ValueEntryTotalForItem: Record "Value Entry";
        ProfitTotalForItem: Decimal;
        Customer_Item_Statistics_by_SalespersonCaptionLbl: label 'Customer/Item Statistics by Salesperson';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Salesperson_Purchaser_CodeCaptionLbl: label 'Salesperson';
        Salesperson_Purchaser_NameCaptionLbl: label 'Salesperson Name';
        Customer__No__CaptionLbl: label 'Customer No.';
        Customer_NameCaptionLbl: label 'Customer Name';
        Item__Base_Unit_of_Measure_CaptionLbl: label 'Unit of Measure';
        Profit_Control51CaptionLbl: label 'Contribution Margin';
        Profit___Control53CaptionLbl: label 'Contrib Ratio';
        Value_Entry__Item_No__CaptionLbl: label 'Item Number';
        Item_DescriptionCaptionLbl: label 'Item Description';
        Invoiced_Quantity_CaptionLbl: label 'Quantity';
        Value_Entry__Sales_Amount__Actual__CaptionLbl: label 'Amount';
        Value_Entry__Discount_Amount_CaptionLbl: label 'Discount';
        Report_TotalsCaptionLbl: label 'Report Totals';
        Phone_CaptionLbl: label 'Phone:';
        Contact_CaptionLbl: label 'Contact:';
        Salesperson_TotalsCaptionLbl: label 'Salesperson Totals';
        Customer_TotalsCaptionLbl: label 'Customer Totals';


    procedure "CalculateProfit%"()
    begin
        if ValueEntryTotalForItem."Sales Amount (Actual)" <> 0 then
          "Profit%" := ROUND(100 * ProfitTotalForItem / ValueEntryTotalForItem."Sales Amount (Actual)",0.1)
        else
          "Profit%" := 0;
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text103),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text105),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text102),false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text104),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Report::"Cust./Item Stat. by Salespers.",false,false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text106),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text107),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddInfoColumn(Time,false,false,false,false,'',ExcelBuf."cell type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text111),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(SalespersonString,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text108),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(FilterString,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text109),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(FilterString2,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text110),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(FilterString3,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          Text114 + ' ' + "Salesperson/Purchaser".FieldCaption(Code),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Text114 + ' ' + "Salesperson/Purchaser".FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Customer.TableCaption + ' ' + Customer.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Customer.FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Item No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Invoiced Quantity"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Base Unit of Measure"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Sales Amount (Actual)"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text112),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text113),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Value Entry".FieldCaption("Discount Amount"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Salesperson/Purchaser".Code,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("Salesperson/Purchaser".Name,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Customer."No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Customer.Name,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ValueEntryTotalForItem."Item No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Item.Description,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(-ValueEntryTotalForItem."Invoiced Quantity",false,'',false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Item."Base Unit of Measure",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          ValueEntryTotalForItem."Sales Amount (Actual)",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(ProfitTotalForItem,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn("Profit%" / 100,false,'',false,false,false,'0.0%',ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(ValueEntryTotalForItem."Discount Amount",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
    end;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text101,Text102,COMPANYNAME,UserId);
        Error('');
    end;
}


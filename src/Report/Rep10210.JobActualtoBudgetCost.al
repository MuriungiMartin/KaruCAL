#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10210 "Job Actual to Budget (Cost)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job Actual to Budget (Cost).rdlc';
    Caption = 'Job Actual to Budget (Cost)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            RequestFilterFields = "No.","Bill-to Customer No.","Posting Date Filter","Planning Date Filter",Status;
            column(ReportForNavId_8019; 8019)
            {
            }
            column(Job_No_;"No.")
            {
            }
            column(Job_Planning_Date_Filter;"Planning Date Filter")
            {
            }
            column(Job_Posting_Date_Filter;"Posting Date Filter")
            {
            }
            dataitem(PageHeader;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8122; 8122)
                {
                }
                column(USERID;UserId)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(TIME;Time)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(STRSUBSTNO_Text000_Job__No___;StrSubstNo(Text000,Job."No."))
                {
                }
                column(CompanyInformation_Name;CompanyInformation.Name)
                {
                }
                column(BudgetOptionText;BudgetOptionText)
                {
                }
                column(Job_Task___No__of_Blank_Lines_;"Job Task"."No. of Blank Lines")
                {
                }
                column(PageGroupNo;PageGroupNo)
                {
                }
                column(PrintToExcel;PrintToExcel)
                {
                }
                column(Job_TABLECAPTION_____Filters______JobFilter;Job.TableCaption + ' Filters: ' + JobFilter)
                {
                }
                column(JobFilter;JobFilter)
                {
                }
                column(Job_Task__TABLECAPTION_____Filters______JobTaskFilter;"Job Task".TableCaption + ' Filters: ' + JobTaskFilter)
                {
                }
                column(JobTaskFilter;JobTaskFilter)
                {
                }
                column(Job__Description_2_;Job."Description 2")
                {
                }
                column(Job_FIELDCAPTION__Ending_Date____________FORMAT_Job__Ending_Date__;Job.FieldCaption("Ending Date") + ': ' + Format(Job."Ending Date"))
                {
                }
                column(Job_Description;Job.Description)
                {
                }
                column(Job_FIELDCAPTION__Starting_Date____________FORMAT_Job__Starting_Date__;Job.FieldCaption("Starting Date") + ': ' + Format(Job."Starting Date"))
                {
                }
                column(PageHeader_Number;Number)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_DescriptionCaption;Job_DescriptionCaptionLbl)
                {
                }
                column(VarianceCaption;VarianceCaptionLbl)
                {
                }
                column(JobDiffBuff__Budgeted_Total_Cost_Caption;JobDiffBuff__Budgeted_Total_Cost_CaptionLbl)
                {
                }
                column(JobDiffBuff__Total_Cost_Caption;JobDiffBuff__Total_Cost_CaptionLbl)
                {
                }
                column(JobDiffBuff__No__Caption;JobDiffBuff__No__CaptionLbl)
                {
                }
                column(FORMAT_JobDiffBuff_Type_Caption;FORMAT_JobDiffBuff_Type_CaptionLbl)
                {
                }
                column(Variance__Caption;Variance__CaptionLbl)
                {
                }
                column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480005Caption;PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480005CaptionLbl)
                {
                }
                column(Job_Task___Job_Task_No___Control1480006Caption;Job_Task___Job_Task_No___Control1480006CaptionLbl)
                {
                }
                column(JobDiffBuff_DescriptionCaption;JobDiffBuff_DescriptionCaptionLbl)
                {
                }
                dataitem("Job Task";"Job Task")
                {
                    DataItemLink = "Job No."=field("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = sorting("Job No.","Job Task No.");
                    RequestFilterFields = "Job Task No.";
                    column(ReportForNavId_2969; 2969)
                    {
                    }
                    column(Job_Task_Job_No_;"Job No.")
                    {
                    }
                    column(Job_Task_Job_Task_No_;"Job Task No.")
                    {
                    }
                    dataitem(BlankLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7860; 7860)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,"Job Task"."No. of Blank Lines");
                        end;
                    }
                    dataitem("Job Planning Line";"Job Planning Line")
                    {
                        DataItemLink = "Job No."=field("No."),"Planning Date"=field("Planning Date Filter");
                        DataItemLinkReference = Job;
                        DataItemTableView = sorting("Job No.","Job Task No.","Schedule Line","Planning Date") where(Type=filter(<>Text));
                        column(ReportForNavId_9714; 9714)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Job.SetJobDiffBuff(
                              JobDiffBuff,"Job No.","Job Task"."Job Task No.","Job Task"."Job Task Type",Type,"No.",
                              "Location Code","Variant Code","Unit of Measure Code","Work Type Code");

                            if JobDiffBuff.Find then begin
                              JobDiffBuff."Budgeted Quantity" := JobDiffBuff."Budgeted Quantity" + Quantity;
                              JobDiffBuff."Budgeted Total Cost" := JobDiffBuff."Budgeted Total Cost" + "Total Cost (LCY)";
                              JobDiffBuff.Modify;
                            end else begin
                              if "Job Task"."Job Task Type" = "Job Task"."job task type"::Posting then
                                JobDiffBuff.Description := GetItemDescription(Type,"No.");
                              JobDiffBuff."Budgeted Quantity" := Quantity;
                              JobDiffBuff."Budgeted Total Cost" := "Total Cost (LCY)";
                              JobDiffBuff.Insert;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            case "Job Task"."Job Task Type" of
                              "Job Task"."job task type"::Posting:
                                SetRange("Job Task No.","Job Task"."Job Task No.");
                              "Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total":
                                CurrReport.Break;
                              "Job Task"."job task type"::Total,"Job Task"."job task type"::"End-Total":
                                SetFilter("Job Task No.","Job Task".Totaling);
                            end;
                            case BudgetAmountsPer of
                              Budgetamountsper::Schedule:
                                SetFilter("Line Type",'%1|%2',"line type"::Budget,"line type"::"Both Budget and Billable");
                              Budgetamountsper::Contract:
                                SetFilter("Line Type",'%1|%2',"line type"::Billable,"line type"::"Both Budget and Billable");
                            end;
                        end;
                    }
                    dataitem("Job Ledger Entry";"Job Ledger Entry")
                    {
                        DataItemLink = "Job No."=field("No."),"Posting Date"=field("Posting Date Filter");
                        DataItemLinkReference = Job;
                        DataItemTableView = sorting("Job No.","Job Task No.","Entry Type","Posting Date") where("Entry Type"=const(Usage));
                        column(ReportForNavId_5612; 5612)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Job.SetJobDiffBuff(
                              JobDiffBuff,"Job No.","Job Task"."Job Task No.","Job Task"."Job Task Type",Type,"No.",
                              "Location Code","Variant Code","Unit of Measure Code","Work Type Code");

                            if JobDiffBuff.Find then begin
                              JobDiffBuff.Quantity := JobDiffBuff.Quantity + Quantity;
                              JobDiffBuff."Total Cost" := JobDiffBuff."Total Cost" + "Total Cost (LCY)";
                              JobDiffBuff.Modify;
                            end else begin
                              if "Job Task"."Job Task Type" = "Job Task"."job task type"::Posting then
                                JobDiffBuff.Description := GetItemDescription(Type,"No.");
                              JobDiffBuff.Quantity := Quantity;
                              JobDiffBuff."Total Cost" := "Total Cost (LCY)";
                              JobDiffBuff.Insert;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            case "Job Task"."Job Task Type" of
                              "Job Task"."job task type"::Posting:
                                SetRange("Job Task No.","Job Task"."Job Task No.");
                              "Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total":
                                CurrReport.Break;
                              "Job Task"."job task type"::Total,"Job Task"."job task type"::"End-Total":
                                SetFilter("Job Task No.","Job Task".Totaling);
                            end;
                        end;
                    }
                    dataitem("Integer";"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_5444; 5444)
                        {
                        }
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description;PadStr('',2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Task___Job_Task_No__;"Job Task"."Job Task No.")
                        {
                        }
                        column(Job_Task___Job_Task_Type__IN___Job_Task___Job_Task_Type___Heading__Job_Task___Job_Task_Type____Begin_Total__;"Job Task"."Job Task Type" in ["Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total"])
                        {
                        }
                        column(Job__No__;Job."No.")
                        {
                        }
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480005;PadStr('',2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Task___Job_Task_No___Control1480006;"Job Task"."Job Task No.")
                        {
                        }
                        column(JobDiffBuff__Total_Cost_;JobDiffBuff."Total Cost")
                        {
                            AutoFormatType = 1;
                        }
                        column(JobDiffBuff__Budgeted_Total_Cost_;JobDiffBuff."Budgeted Total Cost")
                        {
                            AutoFormatType = 1;
                        }
                        column(Variance;Variance)
                        {
                            AutoFormatType = 1;
                        }
                        column(Variance__;"Variance%")
                        {
                            DecimalPlaces = 1:1;
                        }
                        column(FORMAT_JobDiffBuff_Type_;Format(JobDiffBuff.Type))
                        {
                        }
                        column(JobDiffBuff__No__;JobDiffBuff."No.")
                        {
                        }
                        column(JobDiffBuff_Description;JobDiffBuff.Description)
                        {
                        }
                        column(Job_Task___Job_Task_Type_____Job_Task___Job_Task_Type___Posting;"Job Task"."Job Task Type" = "Job Task"."job task type"::Posting)
                        {
                        }
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480007;PadStr('',2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Task___Job_Task_No___Control1480008;"Job Task"."Job Task No.")
                        {
                        }
                        column(JobDiffBuff__Total_Cost__Control1480013;JobDiffBuff."Total Cost")
                        {
                            AutoFormatType = 1;
                        }
                        column(JobDiffBuff__Budgeted_Total_Cost__Control1480014;JobDiffBuff."Budgeted Total Cost")
                        {
                            AutoFormatType = 1;
                        }
                        column(Variance_Control1480015;Variance)
                        {
                            AutoFormatType = 1;
                        }
                        column(Variance___Control1480016;"Variance%")
                        {
                            DecimalPlaces = 1:1;
                        }
                        column(Job_Task___Job_Task_Type__IN___Job_Task___Job_Task_Type___Total__Job_Task___Job_Task_Type____End_Total__;"Job Task"."Job Task Type" in ["Job Task"."job task type"::Total,"Job Task"."job task type"::"End-Total"])
                        {
                        }
                        column(Integer_Number;Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            with JobDiffBuff do begin
                              case Number of
                                0:
                                  exit;
                                1:
                                  Find('-');
                                else
                                  Next;
                              end;

                              Variance := "Total Cost" - "Budgeted Total Cost";
                              if "Budgeted Total Cost" = 0 then
                                "Variance%" := 0
                              else
                                "Variance%" := 100 * Variance / "Budgeted Total Cost";
                            end;

                            if PrintToExcel then
                              MakeExcelDataBody;
                        end;

                        trigger OnPreDataItem()
                        begin
                            with JobDiffBuff do begin
                              Reset;
                              SetRange("Job No.","Job Task"."Job No.");
                              SetRange("Job Task No.","Job Task"."Job Task No.");
                            end;
                            if "Job Task"."Job Task Type" in ["Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total"] then
                              SetRange(Number,0,JobDiffBuff.Count)
                            else
                              SetRange(Number,1,JobDiffBuff.Count)
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        JobDiffBuff.Reset;

                        PageGroupNo := NextPageGroupNo;
                        if "New Page" then
                          NextPageGroupNo := PageGroupNo + 1;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                JobDiffBuff.DeleteAll;

                if PrintToExcel then
                  MakeExcelInfo;
            end;

            trigger OnPostDataItem()
            begin
                if PrintToExcel then
                  CreateExcelbook;
            end;

            trigger OnPreDataItem()
            begin
                if (Count > 1) and PrintToExcel then
                  Error(Text003);
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
                    field(BudgetAmountsPer;BudgetAmountsPer)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Budget Amounts Per';
                        OptionCaption = 'Budget,Billable';
                        ToolTip = 'Specifies if the budget amounts must be based on budgets or billables.';
                    }
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Jobs;
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        JobFilter := Job.GetFilters;
        JobTaskFilter := "Job Task".GetFilters;
        if BudgetAmountsPer = Budgetamountsper::Schedule then
          BudgetOptionText := Text001
        else
          BudgetOptionText := Text002;
    end;

    var
        CompanyInformation: Record "Company Information";
        JobDiffBuff: Record "Job Difference Buffer" temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        JobFilter: Text;
        JobTaskFilter: Text;
        Variance: Decimal;
        "Variance%": Decimal;
        Text000: label 'Actual Cost to Budget Cost for Job %1';
        Text001: label 'Budgeted Amounts are per the Budget';
        Text002: label 'Budgeted Amounts are per the Contract';
        BudgetAmountsPer: Option Schedule,Contract;
        BudgetOptionText: Text[50];
        PrintToExcel: Boolean;
        Text003: label 'When printing to Excel, you must select only one Job.';
        Text101: label 'Data';
        Text102: label 'Job Actual to Budget (Cost)';
        Text103: label 'Company Name';
        Text104: label 'Report No.';
        Text105: label 'Report Name';
        Text106: label 'User ID';
        Text107: label 'Date / Time';
        Text108: label 'Job Filters';
        Text109: label 'Job Task Filters';
        Text110: label 'Variance';
        Text111: label 'Percent Variance';
        Text112: label 'Budget Option';
        Text113: label 'Job Information:';
        Text114: label 'Starting / Ending Dates';
        Text115: label 'Actual Total Cost';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Job_DescriptionCaptionLbl: label 'Job Description';
        VarianceCaptionLbl: label 'Variance';
        JobDiffBuff__Budgeted_Total_Cost_CaptionLbl: label 'Budgeted Total Cost';
        JobDiffBuff__Total_Cost_CaptionLbl: label 'Actual Total Cost';
        JobDiffBuff__No__CaptionLbl: label 'No.';
        FORMAT_JobDiffBuff_Type_CaptionLbl: label 'Type';
        Variance__CaptionLbl: label 'Percent Variance';
        PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480005CaptionLbl: label 'Job Task Description';
        Job_Task___Job_Task_No___Control1480006CaptionLbl: label 'Job Task No.';
        JobDiffBuff_DescriptionCaptionLbl: label 'Description';


    procedure GetItemDescription(Type: Option Resource,Item,"G/L Account";No: Code[20]): Text[50]
    var
        Res: Record Resource;
        Item: Record Item;
        GLAcc: Record "G/L Account";
    begin
        case Type of
          Type::Resource:
            if Res.Get(No) then
              exit(Res.Name);
          Type::Item:
            if Item.Get(No) then
              exit(Item.Description);
          Type::"G/L Account":
            if GLAcc.Get(No) then
              exit(GLAcc.Name);
        end;
        exit('');
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text103),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text105),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(StrSubstNo(Text000,Job."No."),false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text104),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Report::"Job Actual to Budget (Cost)",false,false,false,false,'',ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text106),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text107),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddInfoColumn(Time,false,false,false,false,'',ExcelBuf."cell type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text112),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(BudgetOptionText,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text108),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(JobFilter,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text109),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(JobTaskFilter,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text113),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(
          '  ' + Job.TableCaption + ' ' + Job.FieldCaption("No."),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Job."No.",false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('  ' + Job.FieldCaption(Description),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Job.Description + ' ' + Job."Description 2",false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('  ' + Format(Text114),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Format(Job."Starting Date"),false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.AddInfoColumn(Format(Job."Ending Date"),false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Job Task".FieldCaption("Job Task No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          "Job Task".TableCaption + ' ' + "Job Task".FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(JobDiffBuff.FieldCaption(Type),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(JobDiffBuff.FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(JobDiffBuff.FieldCaption(Description),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text115),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(JobDiffBuff.FieldCaption("Budgeted Total Cost"),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text110),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text111),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Job Task"."Job Task No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        case "Job Task"."Job Task Type" of
          "Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total":
            ExcelBuf.AddColumn(
              PadStr('',2 * "Job Task".Indentation) + "Job Task".Description,false,'',true,false,false,'',ExcelBuf."cell type"::Text);
          "Job Task"."job task type"::Posting:
            begin
              ExcelBuf.AddColumn(
                PadStr('',2 * "Job Task".Indentation) + "Job Task".Description,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(Format(JobDiffBuff.Type),false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(JobDiffBuff."No.",false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(JobDiffBuff.Description,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(JobDiffBuff."Total Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(JobDiffBuff."Budgeted Total Cost",false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(Variance,false,'',false,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn("Variance%" / 100,false,'',false,false,false,'0.0%',ExcelBuf."cell type"::Number);
            end;
          "Job Task"."job task type"::Total,"Job Task"."job task type"::"End-Total":
            begin
              ExcelBuf.AddColumn(
                PadStr('',2 * "Job Task".Indentation) + "Job Task".Description,false,'',true,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn('',false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn('',false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn('',false,'',false,false,false,'',ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(JobDiffBuff."Total Cost",false,'',true,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(JobDiffBuff."Budgeted Total Cost",false,'',true,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(Variance,false,'',true,false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn("Variance%" / 100,false,'',true,false,false,'0.0%',ExcelBuf."cell type"::Number);
            end;
        end;
    end;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text101,Text102,COMPANYNAME,UserId);
        Error('');
    end;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1006 "Job - Planning Lines"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job - Planning Lines.rdlc';
    Caption = 'Job - Planning Lines';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            column(ReportForNavId_8019; 8019)
            {
            }
            column(No_Job;StrSubstNo('%1 %2 %3 %4',TableCaption,FieldCaption("No."),"No.",Description))
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(JobTaskCaption;"Job Task".TableCaption + ': ' + JTFilter)
                {
                }
                column(ShowJTFilter;JTFilter)
                {
                }
                column(Desc_Job;Job.Description)
                {
                }
                column(CurrCodeJob0Fld;JobCalcBatches.GetCurrencyCode(Job,0,CurrencyField))
                {
                }
                column(CurrCodeJob2Fld;JobCalcBatches.GetCurrencyCode(Job,2,CurrencyField))
                {
                }
                column(CurrCodeJob3Fld;JobCalcBatches.GetCurrencyCode(Job,3,CurrencyField))
                {
                }
                column(JobPlanningLinesCaption;JobPlanningLinesCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                column(JobPlannLinePlannDtCptn;JobPlannLinePlannDtCptnLbl)
                {
                }
                column(LineTypeCaption;LineTypeCaptionLbl)
                {
                }
            }
            dataitem("Job Task";"Job Task")
            {
                DataItemLink = "Job No."=field("No.");
                DataItemTableView = sorting("Job No.","Job Task No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Job No.","Job Task No.";
                column(ReportForNavId_2969; 2969)
                {
                }
                column(JobTaskNo_JobTask;"Job Task No.")
                {
                }
                column(Desc_JobTask;Description)
                {
                }
                column(TotalCost1_JobTask;TotalCost[1])
                {
                }
                column(TotalCost2_JobTask;TotalCost[2])
                {
                }
                column(FooterTotalCost1_JobTask;FooterTotalCost1)
                {
                }
                column(FooterTotalCost2_JobTask;FooterTotalCost2)
                {
                }
                column(FooterLineDisAmt1_JobTask;FooterLineDiscountAmount1)
                {
                }
                column(FooterLineDisAmt2_JobTask;FooterLineDiscountAmount2)
                {
                }
                column(FooterLineAmt1_JobTask;FooterLineAmount1)
                {
                }
                column(FooterLineAmt2_JobTask;FooterLineAmount2)
                {
                }
                column(JobTaskNo_JobTaskCaption;FieldCaption("Job Task No."))
                {
                }
                column(TotalScheduleCaption;TotalScheduleCaptionLbl)
                {
                }
                column(TotalContractCaption;TotalContractCaptionLbl)
                {
                }
                dataitem("Job Planning Line";"Job Planning Line")
                {
                    DataItemLink = "Job No."=field("Job No."),"Job Task No."=field("Job Task No."),"Planning Date"=field("Planning Date Filter");
                    DataItemLinkReference = "Job Task";
                    DataItemTableView = sorting("Job No.","Job Task No.","Line No.");
                    column(ReportForNavId_9714; 9714)
                    {
                    }
                    column(TotCostLCY_JobPlanningLine;"Total Cost (LCY)")
                    {
                    }
                    column(Qty_JobPlanningLine;Quantity)
                    {
                        IncludeCaption = false;
                    }
                    column(Desc_JobPlanningLine;Description)
                    {
                        IncludeCaption = false;
                    }
                    column(No_JobPlanningLine;"No.")
                    {
                        IncludeCaption = false;
                    }
                    column(Type_JobPlanningLine;Type)
                    {
                        IncludeCaption = false;
                    }
                    column(PlannDate_JobPlanningLine;Format("Planning Date"))
                    {
                    }
                    column(DocNo_JobPlanningLine;"Document No.")
                    {
                        IncludeCaption = false;
                    }
                    column(UOMCode_JobPlanningLine;"Unit of Measure Code")
                    {
                        IncludeCaption = false;
                    }
                    column(LineDiscAmLCY_JobPlanningLine;"Line Discount Amount (LCY)")
                    {
                    }
                    column(AmtLCY_JobPlanningLine;"Line Amount (LCY)")
                    {
                    }
                    column(LineType_JobPlanningLine;SelectStr("Line Type" + 1,Text000))
                    {
                    }
                    column(FieldLocalCurr_JobPlanningLine;CurrencyField = Currencyfield::"Local Currency")
                    {
                    }
                    column(TotalCost_JobPlanningLine;"Total Cost")
                    {
                    }
                    column(LineDiscAmt_JobPlanningLine;"Line Discount Amount")
                    {
                    }
                    column(LineAmt_JobPlanningLine;"Line Amount")
                    {
                    }
                    column(ForeignCurr_JobPlanningLine;CurrencyField = Currencyfield::"Foreign Currency")
                    {
                    }
                    column(TotalCost1_JobPlanningLine;TotalCost[1])
                    {
                    }
                    column(LineAmt1_JobPlanningLine;LineAmount[1])
                    {
                    }
                    column(LineDisAmt1_JobPlanningLine;LineDiscountAmount[1])
                    {
                    }
                    column(LineAmt2_JobPlanningLine;LineAmount[2])
                    {
                    }
                    column(LineDisAmt2_JobPlanningLine;LineDiscountAmount[2])
                    {
                    }
                    column(TotalCost2_JobPlanningLine;TotalCost[2])
                    {
                    }
                    column(JobNo_JobPlanningLine;"Job No.")
                    {
                    }
                    column(JobTaskNo_JobPlanningLine;"Job Task No.")
                    {
                    }
                    column(ScheduleCaption;ScheduleCaptionLbl)
                    {
                    }
                    column(ContractCaption;ContractCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if CurrencyField = Currencyfield::"Local Currency" then begin
                          if "Schedule Line" then begin
                            FooterTotalCost1 += "Total Cost (LCY)";
                            TotalCost[1] += "Total Cost (LCY)";
                            TotalPrice[1] += "Total Price (LCY)";
                            FooterLineDiscountAmount1 += "Line Discount Amount (LCY)";
                            LineDiscountAmount[1] += "Line Discount Amount (LCY)";
                            FooterLineAmount1 += "Line Amount (LCY)";
                            LineAmount[1] += "Line Amount (LCY)";
                          end;
                          if "Contract Line" then begin
                            FooterTotalCost2 += "Total Cost (LCY)";
                            TotalCost[2] += "Total Cost (LCY)";
                            TotalPrice[2] += "Total Price (LCY)";
                            FooterLineDiscountAmount2 += "Line Discount Amount (LCY)";
                            LineDiscountAmount[2] += "Line Discount Amount (LCY)";
                            FooterLineAmount2 += "Line Amount (LCY)";
                            LineAmount[2] += "Line Amount (LCY)";
                          end;
                        end else begin
                          if "Schedule Line" then begin
                            FooterTotalCost1 += "Total Cost";
                            TotalCost[1] += "Total Cost";
                            TotalPrice[1] += "Total Price";
                            FooterLineDiscountAmount1 += "Line Discount Amount";
                            LineDiscountAmount[1] += "Line Discount Amount";
                            FooterLineAmount1 += "Line Amount";
                            LineAmount[1] += "Line Amount";
                          end;
                          if "Contract Line" then begin
                            FooterTotalCost2 += "Total Cost";
                            TotalCost[2] += "Total Cost";
                            TotalPrice[2] += "Total Price";
                            FooterLineDiscountAmount2 += "Line Discount Amount";
                            LineDiscountAmount[2] += "Line Discount Amount";
                            FooterLineAmount2 += "Line Amount";
                            LineAmount[2] += "Line Amount";
                          end;
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(TotalCost,TotalPrice,LineDiscountAmount,LineAmount);
                end;
            }

            trigger OnAfterGetRecord()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                CurrReport.PageNo := 1;
                JobPlanningLine.SetRange("Job No.","No.");
                JobPlanningLine.SetFilter("Planning Date",JobPlanningDateFilter);
                if not JobPlanningLine.FindFirst then
                  CurrReport.Skip;

                FooterTotalCost1 := 0;
                FooterTotalCost2 := 0;
                FooterLineDiscountAmount1 := 0;
                FooterLineDiscountAmount2 := 0;
                FooterLineAmount1 := 0;
                FooterLineAmount2 := 0;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("No.",JobFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CurrencyField;CurrencyField)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Currency';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the currency that amounts are shown in.';
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
        JobPlannLineTypeCaption = 'Type';
        JobPlannLineDocNoCaption = 'Document No.';
        JobPlannLineNoCaption = 'No.';
        JobPlannLineDescCaption = 'Description';
        JobPlannLineQtyCaption = 'Quantity';
        JobPlannLineUOMCodeCptn = 'Unit of Measure Code';
        JobTaskNo_JobTaskCptn = 'Job Task No.';
    }

    trigger OnPreReport()
    begin
        JTFilter := "Job Task".GetFilters;
        JobFilter := "Job Task".GetFilter("Job No.");
        JobPlanningDateFilter := "Job Task".GetFilter("Planning Date Filter");
    end;

    var
        JobCalcBatches: Codeunit "Job Calculate Batches";
        TotalCost: array [2] of Decimal;
        TotalPrice: array [2] of Decimal;
        LineDiscountAmount: array [2] of Decimal;
        LineAmount: array [2] of Decimal;
        JobFilter: Text;
        JTFilter: Text;
        CurrencyField: Option "Local Currency","Foreign Currency";
        Text000: label 'Budget,Billable,Bud.+Bill.';
        FooterTotalCost1: Decimal;
        FooterTotalCost2: Decimal;
        FooterLineDiscountAmount1: Decimal;
        FooterLineDiscountAmount2: Decimal;
        FooterLineAmount1: Decimal;
        FooterLineAmount2: Decimal;
        JobPlanningLinesCaptionLbl: label 'Job Planning Lines';
        CurrReportPageNoCaptionLbl: label 'Page';
        JobPlannLinePlannDtCptnLbl: label 'Planning Date';
        LineTypeCaptionLbl: label 'Line Type';
        TotalScheduleCaptionLbl: label 'Total Budget';
        TotalContractCaptionLbl: label 'Total Billable';
        ScheduleCaptionLbl: label 'Budget';
        ContractCaptionLbl: label 'Billable';
        JobPlanningDateFilter: Text;


    procedure InitializeRequest(NewCurrencyField: Option "Local Currency","Foreign Currency")
    begin
        CurrencyField := NewCurrencyField;
    end;
}


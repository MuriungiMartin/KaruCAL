#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1013 "Items per Job"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Items per Job.rdlc';
    Caption = 'Items per Job';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Posting Date Filter";
            column(ReportForNavId_8019; 8019)
            {
            }
            column(TodayFormatted;Format(Today))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(JobTableCaptionJobFilter;TableCaption + ': ' + JobFilter)
            {
            }
            column(JobFilter;JobFilter)
            {
            }
            column(ItemTableCaptItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(No_Job;"No.")
            {
            }
            column(Description_Job;Description)
            {
            }
            column(Amount3_JobBuffer;JobBuffer."Amount 3")
            {
            }
            column(Amount1_JobBuffer;JobBuffer."Amount 2")
            {
            }
            column(ItemsperJobCaption;ItemsperJobCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption;AllamountsareinLCYCaptionLbl)
            {
            }
            column(JobBufferLineAmountCaption;JobBufferLineAmountCaptionLbl)
            {
            }
            column(JobBufferTotalCostCaption;JobBufferTotalCostCaptionLbl)
            {
            }
            column(JobBuffeUOMCaption;JobBuffeUOMCaptionLbl)
            {
            }
            column(JobBufferQuantityCaption;JobBufferQuantityCaptionLbl)
            {
            }
            column(JobBufferDescriptionCaption;JobBufferDescriptionCaptionLbl)
            {
            }
            column(ItemNoCaption;ItemNoCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(ActNo1_JobBuffer;JobBuffer."Account No. 1")
                {
                }
                column(Description_JobBuffer;JobBuffer.Description)
                {
                }
                column(ActNo2_JobBuffer;JobBuffer."Account No. 2")
                {
                }
                column(Amount2_JobBuffer;JobBuffer."Amount 1")
                {
                    DecimalPlaces = 0:5;
                }
                column(TableCaptionJobNo;Text000 + ' ' + Job.TableCaption + ' ' + Job."No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                      if not JobBuffer.Find('-') then
                        CurrReport.Break;
                    end else
                      if JobBuffer.Next = 0 then
                        CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(JobBuffer."Amount 2",JobBuffer."Amount 3",JobBuffer."Amount 4");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                JobBuffer2.ReportJobItem(Job,Item,JobBuffer);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(JobBuffer."Amount 2",JobBuffer."Amount 3");
            end;
        }
        dataitem(Item2;Item)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_9183; 9183)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        Item.CopyFilters(Item2);
        JobFilter := Job.GetFilters;
        ItemFilter := Item.GetFilters;
    end;

    var
        Item: Record Item;
        JobBuffer2: Record "Job Buffer" temporary;
        JobBuffer: Record "Job Buffer" temporary;
        JobFilter: Text;
        ItemFilter: Text;
        Text000: label 'Total for';
        ItemsperJobCaptionLbl: label 'Items per Job';
        CurrReportPageNoCaptionLbl: label 'Page';
        AllamountsareinLCYCaptionLbl: label 'All amounts are in $';
        JobBufferLineAmountCaptionLbl: label 'Line Amount';
        JobBufferTotalCostCaptionLbl: label 'Total Cost';
        JobBuffeUOMCaptionLbl: label 'Unit of Measure';
        JobBufferQuantityCaptionLbl: label 'Quantity';
        JobBufferDescriptionCaptionLbl: label 'Description';
        ItemNoCaptionLbl: label 'Item No.';
        TotalCaptionLbl: label 'Total';
}


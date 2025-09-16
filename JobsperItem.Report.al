#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1014 "Jobs per Item"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Jobs per Item.rdlc';
    Caption = 'Jobs per Item';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(TodayFormatted;Format(Today))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemTableCaptiontemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(JobTableCaptionJobFilter;Job.TableCaption + ': ' + JobFilter)
            {
            }
            column(JobFilter;JobFilter)
            {
            }
            column(Description_Item;Description)
            {
            }
            column(No_Item;"No.")
            {
            }
            column(Amount3_JobBuffer;JobBuffer."Amount 3")
            {
            }
            column(Amount2_JobBuffer;JobBuffer."Amount 2")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(JobsperItemCaption;JobsperItemCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption;AllamountsareinLCYCaptionLbl)
            {
            }
            column(JobNoCaption;JobNoCaptionLbl)
            {
            }
            column(JobBufferDscrptnCaption;JobBufferDscrptnCaptionLbl)
            {
            }
            column(JobBufferQuantityCaption;JobBufferQuantityCaptionLbl)
            {
            }
            column(JobBufferUOMCaption;JobBufferUOMCaptionLbl)
            {
            }
            column(JobBufferTotalCostCaption;JobBufferTotalCostCaptionLbl)
            {
            }
            column(JobBufferLineAmountCaption;JobBufferLineAmountCaptionLbl)
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
                column(AccountNo1_JobBuffer;JobBuffer."Account No. 1")
                {
                }
                column(Description_JobBuffer;JobBuffer.Description)
                {
                }
                column(AccountNo2_JobBuffer;JobBuffer."Account No. 2")
                {
                }
                column(Amount1_JobBuffer;JobBuffer."Amount 1")
                {
                    DecimalPlaces = 0:5;
                }
                column(TableCapionItemNo;Text000 + ' ' + Item.TableCaption + ' ' + Item."No.")
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
                    CurrReport.CreateTotals(JobBuffer."Amount 2",JobBuffer."Amount 3");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                JobBuffer2.ReportItemJob(Item,Job,JobBuffer);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(JobBuffer."Amount 2",JobBuffer."Amount 3");
            end;
        }
        dataitem(Job2;Job)
        {
            RequestFilterFields = "No.","Bill-to Customer No.","Posting Date Filter";
            column(ReportForNavId_1931; 1931)
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
        ItemFilter := Item.GetFilters;

        Job.CopyFilters(Job2);
        JobFilter := Job.GetFilters;
    end;

    var
        Job: Record Job;
        JobBuffer2: Record "Job Buffer" temporary;
        JobBuffer: Record "Job Buffer" temporary;
        JobFilter: Text;
        ItemFilter: Text;
        Text000: label 'Total for';
        CurrReportPageNoCaptionLbl: label 'Page';
        JobsperItemCaptionLbl: label 'Jobs per Item';
        AllamountsareinLCYCaptionLbl: label 'All amounts are in $';
        JobNoCaptionLbl: label 'Job No.';
        JobBufferDscrptnCaptionLbl: label 'Description';
        JobBufferQuantityCaptionLbl: label 'Quantity';
        JobBufferUOMCaptionLbl: label 'Unit of Measure';
        JobBufferTotalCostCaptionLbl: label 'Total Cost';
        JobBufferLineAmountCaptionLbl: label 'Line Amount';
        TotalCaptionLbl: label 'Total';
}


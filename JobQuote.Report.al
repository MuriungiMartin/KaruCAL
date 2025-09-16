#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1016 "Job Quote"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job Quote.rdlc';
    WordLayout = './Layouts/JobQuote.docx';
    Caption = 'Job Quote';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job;Job)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Planning Date Filter";
            column(ReportForNavId_8019; 8019)
            {
            }
            column(CompanyAddress1;CompanyAddr[1])
            {
            }
            column(CompanyAddress2;CompanyAddr[2])
            {
            }
            column(CompanyAddress3;CompanyAddr[3])
            {
            }
            column(CompanyAddress4;CompanyAddr[4])
            {
            }
            column(CompanyAddress5;CompanyAddr[5])
            {
            }
            column(CompanyAddress6;CompanyAddr[6])
            {
            }
            column(CompanyPicture;CompanyInfo.Picture)
            {
            }
            column(CompanyLogoPosition;CompanyLogoPosition)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(JobtableCaptJobFilter;TableCaption + ': ' + JobFilter)
            {
            }
            column(JobFilter;JobFilter)
            {
            }
            column(JobTasktableCaptFilter;"Job Task".TableCaption + ': ' + JobTaskFilter)
            {
            }
            column(JobTaskFilter;JobTaskFilter)
            {
            }
            column(No_Job;"No.")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(JobQuoteCaptLbl;JobQuoteCaptLbl)
            {
            }
            column(BillToAddress1;BillToAddr[1])
            {
            }
            column(BillToAddress2;BillToAddr[2])
            {
            }
            column(BillToAddress3;BillToAddr[3])
            {
            }
            column(BillToAddress4;BillToAddr[4])
            {
            }
            column(BillToAddress5;BillToAddr[5])
            {
            }
            column(BillToAddress6;BillToAddr[6])
            {
            }
            dataitem("Job Task";"Job Task")
            {
                DataItemLink = "Job No."=field("No.");
                DataItemTableView = sorting("Job No.","Job Task No.");
                PrintOnlyIfDetail = true;
                column(ReportForNavId_2969; 2969)
                {
                }
                column(JobTaskNo_JobTask;HeaderJobTaskNo)
                {
                }
                column(Indentation_JobTask;HeaderJobTask)
                {
                }
                column(NewTaskGroup;NewTaskGroup)
                {
                }
                column(QuantityCaption;QuantityLbl)
                {
                }
                column(UnitCostCaption;UnitCostLbl)
                {
                }
                column(TotalCostCaption;TotalCostLbl)
                {
                }
                column(JobTaskTypeCaption;JobTaskTypeLbl)
                {
                }
                column(NoCaption;NoLbl)
                {
                }
                column(Description_Job;Job.Description)
                {
                }
                column(DescriptionCaption;DescriptionCaptionLbl)
                {
                }
                column(JobTaskNoCapt;JobTaskNoCaptLbl)
                {
                }
                column(TotalJobTask;TotalJobTask)
                {
                }
                column(TotalJob;TotalJob)
                {
                }
                dataitem("Job Planning Line";"Job Planning Line")
                {
                    DataItemLink = "Job No."=field("Job No."),"Job Task No."=field("Job Task No.");
                    DataItemTableView = sorting("Job No.","Job Task No.","Line No.");
                    RequestFilterFields = "Job Task No.";
                    column(ReportForNavId_7; 7)
                    {
                    }
                    column(ShowIntBody1;"Job Task"."Job Task Type" in ["Job Task"."job task type"::Heading,"Job Task"."job task type"::"Begin-Total"])
                    {
                    }
                    column(Quantity;Quantity)
                    {
                    }
                    column(UnitCostLCY;"Unit Price (LCY)")
                    {
                    }
                    column(UnitCost;"Unit Price")
                    {
                    }
                    column(TotalCostLCY;"Total Price (LCY)")
                    {
                    }
                    column(TotalCost;"Total Price")
                    {
                    }
                    column(Type;Type)
                    {
                    }
                    column(Number;"No.")
                    {
                    }
                    column(JobPlanningLine_JobTaskNo;"Job Task No.")
                    {
                    }
                    column(JobPlanningLine_Type;Type)
                    {
                    }
                    column(JobPlanningLine_LineType;"Line Type")
                    {
                    }
                    column(Indentation_JobTask2;PadStr('',2 * "Job Task".Indentation) + Description)
                    {
                    }
                    column(Indentation_JobTaskTotal;PadStr('',2 * "Job Task".Indentation) + Description)
                    {
                    }
                    column(ShowIntBody2;"Job Task"."Job Task Type" in ["Job Task"."job task type"::Total,"Job Task"."job task type"::"End-Total"])
                    {
                    }
                    column(ShowIntBody3;("Job Task"."Job Task Type" in ["Job Task"."job task type"::Posting]) and PrintSection)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PrintSection := true;
                        if "Line Type" = "line type"::Budget then begin
                          PrintSection := false;
                          CurrReport.Skip;
                        end;
                        JobTotalValue += ("Unit Price" * Quantity);

                        if FirstLineHasBeenOutput then
                          Clear(CompanyInfo.Picture);
                        FirstLineHasBeenOutput := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CompanyInfo.CalcFields(Picture);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Job Task Type" = "job task type"::"Begin-Total" then begin
                      if Indentation = 0 then
                        TotalJob := TotalLbl + ' ' + Description;
                      HeaderJobTask := PadStr('',2 * Indentation) + Description;
                      HeaderJobTaskNo := Format("Job Task No.");
                      TotalJobTask := PadStr('',2 * Indentation) + TotalLbl + ' ' + Description;
                    end;

                    if ((CurrentIndentation > 0) and (CurrentIndentation < Indentation)) or ("Job Task Type" = "job task type"::"End-Total") then
                      NewTaskGroup := NewTaskGroup + 1;

                    CurrentIndentation := Indentation;
                end;

                trigger OnPreDataItem()
                begin
                    CompanyInfo.CalcFields(Picture);
                end;
            }
            dataitem(Totals;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_99; 99)
                {
                }
                column(JobTotalValue;JobTotalValue)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                JobTotalValue := 0;
                NewTaskGroup := 0;
                FormatAddr.Company(CompanyAddr,CompanyInfo);
                Customer.Get("Bill-to Customer No.");
                FormatAddr.Customer(BillToAddr,Customer);
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
            }
        }

        actions
        {
        }
    }

    labels
    {
        JobNoLbl = 'Job No.';
        JobDescriptionLbl = 'Description';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        JobsSetup.Get;
    end;

    trigger OnPreReport()
    begin
        JobFilter := Job.GetFilters;
        JobTaskFilter := "Job Planning Line".GetFilters;
        CompanyLogoPosition := JobsSetup."Logo Position on Documents";
    end;

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        JobsSetup: Record "Jobs Setup";
        FormatAddr: Codeunit "Format Address";
        JobFilter: Text;
        JobTaskFilter: Text;
        FirstLineHasBeenOutput: Boolean;
        PrintSection: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        JobQuoteCaptLbl: label 'Job Quote';
        DescriptionCaptionLbl: label 'Description';
        JobTaskNoCaptLbl: label 'Job Task No.';
        QuantityLbl: label 'Quantity';
        UnitCostLbl: label 'Unit Cost';
        TotalCostLbl: label 'Total Cost';
        JobTaskTypeLbl: label 'Job Task Type';
        NoLbl: label 'No.';
        NewTaskGroup: Integer;
        CurrentIndentation: Integer;
        TotalLbl: label 'Total';
        CompanyLogoPosition: Integer;
        JobTotalValue: Decimal;
        CompanyAddr: array [8] of Text[50];
        BillToAddr: array [8] of Text[50];
        TotalJobTask: Text[250];
        TotalJob: Text[250];
        HeaderJobTaskNo: Text[250];
        HeaderJobTask: Text[250];
}


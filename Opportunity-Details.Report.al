#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5068 "Opportunity - Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Opportunity - Details.rdlc';
    Caption = 'Opportunity - Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Opportunity;Opportunity)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_9773; 9773)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(Filter_Opportunity;TableCaption + OppFilter)
            {
            }
            column(OppFilter;OppFilter)
            {
            }
            column(Desc_Opportunity;TableCaption + ': ' + "No." + ', ' + Description)
            {
            }
            column(DateClosed_Opp;Format("Date Closed"))
            {
            }
            column(No_Opp;"No.")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(OpportunityDetailsCaption;OpportunityDetailsCaptionLbl)
            {
            }
            column(OpportunityDateClosedCaption;OpportunityDateClosedCaptionLbl)
            {
            }
            dataitem(PreTodo;"To-do")
            {
                DataItemLink = "Opportunity No."=field("No.");
                DataItemTableView = sorting("Opportunity No.",Date,Closed) order(ascending) where("Opportunity Entry No."=const(0),"System To-do Type"=filter(Team|Organizer));
                column(ReportForNavId_7381; 7381)
                {
                }
                column(Status_Pretodo;Status)
                {
                    IncludeCaption = true;
                }
                column(Date_PreTodo;Format(Date))
                {
                }
                column(Desc_PreTodo;Description)
                {
                    IncludeCaption = true;
                }
                column(Priority_Pretodo;Priority)
                {
                    IncludeCaption = true;
                }
                column(Type_PreTodo;Type)
                {
                    IncludeCaption = true;
                }
                column(No_PreTodo;"No.")
                {
                }
                column(InitialTodosCaption;InitialTodosCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Team Code" <> '') and ("System To-do Type" <> "system to-do type"::Team) then
                      CurrReport.Skip
                end;
            }
            dataitem("Opportunity Entry";"Opportunity Entry")
            {
                DataItemLink = "Opportunity No."=field("No.");
                DataItemTableView = sorting("Opportunity No.") order(ascending) where("Sales Cycle Stage"=filter(<>0));
                column(ReportForNavId_1151; 1151)
                {
                }
                column(SalesCycleStage_OppEntry;"Sales Cycle Stage")
                {
                }
                column(Desc_SalesCycleStage;SalesCycleStage.Description)
                {
                }
                column(DateChange_OppEntry;Format("Date of Change"))
                {
                }
                column(Estimated_OppEntry;Format("Estimated Close Date"))
                {
                }
                column(Active_OppEntry;Active)
                {
                    IncludeCaption = true;
                }
                column(QuoteFormat_OppEntry;Format(SalesCycleStage."Quote Required"))
                {
                }
                column(Skip2_SalesCycleStage;Format(SalesCycleStage."Allow Skip"))
                {
                }
                column(Active2_OppEntry;Format(Active))
                {
                }
                column(StageCaption;StageCaptionLbl)
                {
                }
                column(SalesCycleStageDescriptionCaption;SalesCycleStageDescriptionCaptionLbl)
                {
                }
                column(SalesCycleStageQuoteRequiredCaption;SalesCycleStageQuoteRequiredCaptionLbl)
                {
                }
                column(SalesCycleStageAllowSkipCaption;SalesCycleStageAllowSkipCaptionLbl)
                {
                }
                column(OpportunityEntryDateofChangeCaption;OpportunityEntryDateofChangeCaptionLbl)
                {
                }
                column(OpportunityEntryEstimatedCloseDateCaption;OpportunityEntryEstimatedCloseDateCaptionLbl)
                {
                }
                dataitem("To-do";"To-do")
                {
                    DataItemLink = "Opportunity No."=field("Opportunity No."),"Opportunity Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Opportunity No.",Date,Closed) order(ascending) where("System To-do Type"=filter(Team|Organizer));
                    column(ReportForNavId_6499; 6499)
                    {
                    }
                    column(Status_Todo;Status)
                    {
                        IncludeCaption = true;
                    }
                    column(Date_Todo;Format(Date))
                    {
                    }
                    column(Desc_Todo;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Priority_Todo;Priority)
                    {
                        IncludeCaption = true;
                    }
                    column(Type_Todo;Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_Todo;"No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Team Code" <> '') and ("System To-do Type" <> "system to-do type"::Team) then
                          CurrReport.Skip;
                        if PlannedStartingDate = 0D then
                          PlannedStartingDate := Date;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if SalesCycleStage.Get("Sales Cycle Code","Sales Cycle Stage") then
                      CurrStage := "Sales Cycle Stage";
                    if not ("Sales Cycle Stage" = LastSalesCycleStage) then
                      PlannedStartingDate := 0D;
                    LastSalesCycleStage := "Sales Cycle Stage";
                end;
            }
            dataitem("Sales Cycle Stage";"Sales Cycle Stage")
            {
                DataItemLink = "Sales Cycle Code"=field("Sales Cycle Code");
                DataItemTableView = sorting("Sales Cycle Code",Stage);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_8511; 8511)
                {
                }
                column(Stage_SalesCycleStage;Stage)
                {
                    IncludeCaption = true;
                }
                column(Quote2_SalesCycleStage;"Quote Required")
                {
                    IncludeCaption = true;
                }
                column(Skip3_SalesCycleStage;"Allow Skip")
                {
                    IncludeCaption = true;
                }
                column(Desc_SalescCycleStage;Description)
                {
                    IncludeCaption = true;
                }
                column(Quote_SalesCycleStage;Format("Quote Required"))
                {
                }
                column(Skip1_SalesCycleStage;Format("Allow Skip"))
                {
                }
                dataitem("Activity Step";"Activity Step")
                {
                    DataItemLink = "Activity Code"=field("Activity Code");
                    DataItemTableView = sorting("Activity Code","Step No.");
                    column(ReportForNavId_7392; 7392)
                    {
                    }
                    column(Desc_ActivityStep;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Priority_ActivityStep;Priority)
                    {
                        IncludeCaption = true;
                    }
                    column(Type_ActivityStep;Type)
                    {
                        IncludeCaption = true;
                    }
                    column(StartDate_ActivityStep;Format(ActivityStartDate))
                    {
                    }
                    column(PlannedActivityStatus;SelectStr(ActivityStatus + 1,Text001))
                    {
                    }
                    column(StepNo_ActivityStep;"Step No.")
                    {
                    }
                    column(StatusCaption;StatusCaptionLbl)
                    {
                    }
                    column(ActivityStartDateCaption;ActivityStartDateCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ActivityStartDate := CalcDate("Date Formula",StageStartDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if PlannedStartingDate <> 0D then
                      StageStartDate := CalcDate("Date Formula",PlannedStartingDate);
                    PlannedStartingDate := StageStartDate;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter(Stage,'>%1',CurrStage);
                    if CurrStage = 0 then
                      PlannedStartingDate := WorkDate;
                end;
            }
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
        PreTodoDateCaption = 'Starting Date';
        PreTodoNoCaption = 'To-do No.';
    }

    trigger OnPreReport()
    begin
        OppFilter := Opportunity.GetFilters;
    end;

    var
        SalesCycleStage: Record "Sales Cycle Stage";
        OppFilter: Text;
        StageStartDate: Date;
        ActivityStartDate: Date;
        ActivityStatus: Option Planned;
        CurrStage: Integer;
        Text001: label 'Planned';
        LastSalesCycleStage: Integer;
        PlannedStartingDate: Date;
        CurrReportPageNoCaptionLbl: label 'Page';
        OpportunityDetailsCaptionLbl: label 'Opportunity - Details';
        OpportunityDateClosedCaptionLbl: label 'Date Closed';
        InitialTodosCaptionLbl: label 'Initial To-dos';
        StageCaptionLbl: label 'Stage';
        SalesCycleStageDescriptionCaptionLbl: label 'Description';
        SalesCycleStageQuoteRequiredCaptionLbl: label 'Quote Required';
        SalesCycleStageAllowSkipCaptionLbl: label 'Allow Skip';
        OpportunityEntryDateofChangeCaptionLbl: label 'Date of Change';
        OpportunityEntryEstimatedCloseDateCaptionLbl: label 'Estimated Close Date';
        StatusCaptionLbl: label 'Status';
        ActivityStartDateCaptionLbl: label 'Date';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5059 "Team - To-dos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Team - To-dos.rdlc';
    Caption = 'Team - To-dos';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("To-do";"To-do")
        {
            DataItemTableView = sorting("Team Code",Date) where("System To-do Type"=const(Team));
            RequestFilterFields = "Team Code",Date,"Campaign No.";
            column(ReportForNavId_6499; 6499)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(To_do__TABLECAPTION__________TodoFilter;TableCaption + ': ' + TodoFilter)
            {
            }
            column(TodoFilter;TodoFilter)
            {
            }
            column(To_do__Team_Code_;"Team Code")
            {
            }
            column(To_do__Team_Name_;"Team Name")
            {
            }
            column(To_do__No__;"No.")
            {
            }
            column(To_do_Date;Format(Date))
            {
            }
            column(To_do_Type;Type)
            {
            }
            column(To_do_Description;Description)
            {
            }
            column(To_do__Contact_No__;"Contact No.")
            {
            }
            column(To_do__Campaign_No__;"Campaign No.")
            {
            }
            column(To_do_Status;Status)
            {
            }
            column(To_do_Priority;Priority)
            {
            }
            column(To_do__Salesperson_Code_;"Salesperson Code")
            {
            }
            column(To_do__Opportunity_No__;"Opportunity No.")
            {
            }
            column(To_do__Date_Closed_;Format("Date Closed"))
            {
            }
            column(Team___To_doCaption;Team___To_doCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(To_do__No__Caption;FieldCaption("No."))
            {
            }
            column(To_do_DateCaption;To_do_DateCaptionLbl)
            {
            }
            column(To_do_TypeCaption;FieldCaption(Type))
            {
            }
            column(To_do_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(To_do__Contact_No__Caption;FieldCaption("Contact No."))
            {
            }
            column(To_do__Campaign_No__Caption;FieldCaption("Campaign No."))
            {
            }
            column(To_do_StatusCaption;FieldCaption(Status))
            {
            }
            column(To_do_PriorityCaption;FieldCaption(Priority))
            {
            }
            column(To_do__Salesperson_Code_Caption;FieldCaption("Salesperson Code"))
            {
            }
            column(To_do__Opportunity_No__Caption;FieldCaption("Opportunity No."))
            {
            }
            column(To_do__Date_Closed_Caption;To_do__Date_Closed_CaptionLbl)
            {
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
    }

    trigger OnPreReport()
    begin
        TodoFilter := "To-do".GetFilters;
    end;

    var
        TodoFilter: Text;
        Team___To_doCaptionLbl: label 'Team - To-do';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        To_do_DateCaptionLbl: label 'Starting Date';
        To_do__Date_Closed_CaptionLbl: label 'Date Closed';
}


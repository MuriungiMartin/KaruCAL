#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 22 "No. Series Check"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/No. Series Check.rdlc';
    Caption = 'No. Series Check';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("No. Series";"No. Series")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_7326; 7326)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("No. Series Line";"No. Series Line")
        {
            DataItemTableView = sorting("Starting No.");
            RequestFilterFields = "Starting Date";
            column(ReportForNavId_9252; 9252)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(No__Series__TABLECAPTION__________NoSeriesFilter;"No. Series".TableCaption + ': ' + NoSeriesFilter)
            {
            }
            column(NoSeriesFilter;NoSeriesFilter)
            {
            }
            column(NoSeriesLineFilter;NoSeriesLineFilter)
            {
            }
            column(No__Series_Line__Series_Code_;"Series Code")
            {
            }
            column(No__Series_Line__Starting_Date_;Format("Starting Date"))
            {
            }
            column(No__Series_Line__Starting_No__;"Starting No.")
            {
            }
            column(No__Series_Line__Ending_No__;"Ending No.")
            {
            }
            column(No__Series_Line__Last_No__Used_;"Last No. Used")
            {
            }
            column(No__Series_Line_Open;Format(Open))
            {
            }
            column(No__Series_Line__Warning_No__;"Warning No.")
            {
            }
            column(No__Series_Line__Increment_by_No__;"Increment-by No.")
            {
            }
            column(NoSeries2_Description;NoSeries2.Description)
            {
            }
            column(No__Series_CheckCaption;No__Series_CheckCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No__Series_Line_OpenCaption;CaptionClassTranslate(FieldCaption(Open)))
            {
            }
            column(No__Series_Line__Increment_by_No__Caption;FieldCaption("Increment-by No."))
            {
            }
            column(No__Series_Line__Warning_No__Caption;FieldCaption("Warning No."))
            {
            }
            column(No__Series_Line__Last_No__Used_Caption;FieldCaption("Last No. Used"))
            {
            }
            column(No__Series_Line__Ending_No__Caption;FieldCaption("Ending No."))
            {
            }
            column(No__Series_Line__Starting_No__Caption;FieldCaption("Starting No."))
            {
            }
            column(No__Series_Line__Starting_Date_Caption;No__Series_Line__Starting_Date_CaptionLbl)
            {
            }
            column(NoSeries2_DescriptionCaption;NoSeries2_DescriptionCaptionLbl)
            {
            }
            column(No__Series_Line__Series_Code_Caption;No__Series_Line__Series_Code_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                NoSeries2.Code := "Series Code";
                if not NoSeries2.Find then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Series Code");
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
        NoSeriesFilter := "No. Series".GetFilters;
        NoSeriesLineFilter := "No. Series Line".GetFilters;
        NoSeries2.Copy("No. Series");
    end;

    var
        NoSeries2: Record "No. Series";
        NoSeriesFilter: Text;
        NoSeriesLineFilter: Text;
        No__Series_CheckCaptionLbl: label 'No. Series Check';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No__Series_Line__Starting_Date_CaptionLbl: label 'Starting Date';
        NoSeries2_DescriptionCaptionLbl: label 'Description';
        No__Series_Line__Series_Code_CaptionLbl: label 'Code';
}


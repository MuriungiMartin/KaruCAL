#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 21 "No. Series"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/No. Series.rdlc';
    Caption = 'No. Series';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("No. Series";"No. Series")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_7326; 7326)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(No__Series__TABLECAPTION__________NoSeriesFilter;TableCaption + ': ' + NoSeriesFilter)
            {
            }
            column(No__Series_Line__TABLECAPTION__________NoSeriesLineFilter;"No. Series Line".TableCaption + ': ' + NoSeriesLineFilter)
            {
            }
            column(No__Series_Code;Code)
            {
            }
            column(No__Series_Description;Description)
            {
            }
            column(No__Series__Default_Nos__;Format("Default Nos."))
            {
            }
            column(No__Series__Manual_Nos__;Format("Manual Nos."))
            {
            }
            column(No__Series__Date_Order_;Format("Date Order"))
            {
            }
            column(No__SeriesCaption;No__SeriesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No__Series_Line_OpenCaption;No__Series_Line_OpenCaptionLbl)
            {
            }
            column(No__Series_Line__Increment_by_No__Caption;"No. Series Line".FieldCaption("Increment-by No."))
            {
            }
            column(No__Series_Line__Warning_No__Caption;"No. Series Line".FieldCaption("Warning No."))
            {
            }
            column(No__Series_Line__Last_No__Used_Caption;"No. Series Line".FieldCaption("Last No. Used"))
            {
            }
            column(No__Series_Line__Ending_No__Caption;"No. Series Line".FieldCaption("Ending No."))
            {
            }
            column(No__Series_Line__Starting_No__Caption;"No. Series Line".FieldCaption("Starting No."))
            {
            }
            column(No__Series_Line__Starting_Date_Caption;No__Series_Line__Starting_Date_CaptionLbl)
            {
            }
            column(No__Series__Default_Nos__Caption;No__Series__Default_Nos__CaptionLbl)
            {
            }
            column(No__Series__Manual_Nos__Caption;No__Series__Manual_Nos__CaptionLbl)
            {
            }
            column(No__Series__Date_Order_Caption;No__Series__Date_Order_CaptionLbl)
            {
            }
            dataitem("No. Series Line";"No. Series Line")
            {
                DataItemLink = "Series Code"=field(Code);
                DataItemTableView = sorting("Series Code");
                RequestFilterFields = "Starting Date";
                column(ReportForNavId_9252; 9252)
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
                column(No__Series_Line_Series_Code;"Series Code")
                {
                }
            }
            dataitem("No. Series Relationship";"No. Series Relationship")
            {
                DataItemLink = Code=field(Code);
                DataItemTableView = sorting(Code);
                column(ReportForNavId_7517; 7517)
                {
                }
                column(No__Series_Relationship__Series_Code_;"Series Code")
                {
                }
                column(No__Series_Relationship__Series_Description_;"Series Description")
                {
                }
                column(No__Series_Relationship_Code;Code)
                {
                }
                column(Related_No__SeriesCaption;Related_No__SeriesCaptionLbl)
                {
                }
                dataitem(NoSeriesLine2;"No. Series Line")
                {
                    DataItemLink = "Series Code"=field("Series Code");
                    DataItemTableView = sorting("Series Code");
                    column(ReportForNavId_1705; 1705)
                    {
                    }
                    column(NoSeriesLine2__Starting_Date_;Format("Starting Date"))
                    {
                    }
                    column(NoSeriesLine2__Starting_No__;"Starting No.")
                    {
                    }
                    column(NoSeriesLine2__Ending_No__;"Ending No.")
                    {
                    }
                    column(NoSeriesLine2__Last_No__Used_;"Last No. Used")
                    {
                    }
                    column(NoSeriesLine2__Warning_No__;"Warning No.")
                    {
                    }
                    column(NoSeriesLine2__Increment_by_No__;"Increment-by No.")
                    {
                    }
                    column(NoSeriesLine2_Open;Format(Open))
                    {
                    }
                    column(NoSeriesLine2_Series_Code;"Series Code")
                    {
                    }
                }
            }
            dataitem(BlankLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_7186; 7186)
                {
                }
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
        NoSeriesFilter := "No. Series".GetFilters;
        NoSeriesLineFilter := "No. Series Line".GetFilters;
    end;

    var
        NoSeriesFilter: Text;
        NoSeriesLineFilter: Text;
        No__SeriesCaptionLbl: label 'No. Series';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No__Series_Line_OpenCaptionLbl: label 'Open';
        No__Series_Line__Starting_Date_CaptionLbl: label 'Starting Date';
        No__Series__Default_Nos__CaptionLbl: label 'Default Nos.';
        No__Series__Manual_Nos__CaptionLbl: label 'Manual Nos.';
        No__Series__Date_Order_CaptionLbl: label 'Date Order';
        Related_No__SeriesCaptionLbl: label 'Related No. Series';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10000 "Account Schedule Layout"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Account Schedule Layout.rdlc';
    Caption = 'Account Schedule Layout';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Acc. Schedule Name";"Acc. Schedule Name")
        {
            DataItemTableView = sorting(Name);
            PrintOnlyIfDetail = true;
            RequestFilterFields = Name;
            column(ReportForNavId_1726; 1726)
            {
            }
            column(Acc__Schedule_Name_Name;Name)
            {
            }
            dataitem("Acc. Schedule Line";"Acc. Schedule Line")
            {
                DataItemLink = "Schedule Name"=field(Name);
                DataItemTableView = sorting("Schedule Name","Line No.");
                RequestFilterFields = "Row No.";
                column(ReportForNavId_7769; 7769)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
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
                column(SubTitle;SubTitle)
                {
                }
                column(Acc__Schedule_Line__TABLECAPTION__________AccSchedLineFilter;"Acc. Schedule Line".TableCaption + ': ' + AccSchedLineFilter)
                {
                }
                column(AccSchedFilter;AccSchedLineFilter)
                {
                }
                column(Acc__Schedule_Line__Row_No__;"Row No.")
                {
                }
                column(Acc__Schedule_Line_Description;Description)
                {
                }
                column(Acc__Schedule_Line__Totaling_Type_;"Totaling Type")
                {
                }
                column(Acc__Schedule_Line_Totaling;Totaling)
                {
                }
                column(FORMAT__New_Page__;Format("New Page"))
                {
                }
                column(Acc__Schedule_Line_Show;Show)
                {
                }
                column(FORMAT__Show_Opposite_Sign__;Format("Show Opposite Sign"))
                {
                }
                column(FORMAT_Bold_;Format(Bold))
                {
                }
                column(FORMAT_Italic_;Format(Italic))
                {
                }
                column(Acc__Schedule_Line__Row_Type_;"Row Type")
                {
                }
                column(Acc__Schedule_Line__Amount_Type_;"Amount Type")
                {
                }
                column(Acc__Schedule_Line__Schedule_Name_;"Schedule Name")
                {
                }
                column(Acc__Schedule_Line_Line_No_;"Line No.")
                {
                }
                column(Account_Schedule_LayoutCaption;Account_Schedule_LayoutCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Acc__Schedule_Line__Row_No__Caption;FieldCaption("Row No."))
                {
                }
                column(Acc__Schedule_Line_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Acc__Schedule_Line__Totaling_Type_Caption;FieldCaption("Totaling Type"))
                {
                }
                column(Acc__Schedule_Line_TotalingCaption;FieldCaption(Totaling))
                {
                }
                column(FORMAT__New_Page__Caption;FORMAT__New_Page__CaptionLbl)
                {
                }
                column(Acc__Schedule_Line_ShowCaption;FieldCaption(Show))
                {
                }
                column(FORMAT__Show_Opposite_Sign__Caption;FORMAT__Show_Opposite_Sign__CaptionLbl)
                {
                }
                column(FORMAT_Bold_Caption;FORMAT_Bold_CaptionLbl)
                {
                }
                column(FORMAT_Italic_Caption;FORMAT_Italic_CaptionLbl)
                {
                }
                column(Acc__Schedule_Line__Row_Type_Caption;FieldCaption("Row Type"))
                {
                }
                column(Acc__Schedule_Line__Amount_Type_Caption;FieldCaption("Amount Type"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                SubTitle := StrSubstNo(Text000,Description);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        CompanyInformation.Get;
        AccSchedLineFilter := "Acc. Schedule Line".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        AccSchedLineFilter: Text;
        SubTitle: Text[132];
        Text000: label 'for %1';
        Account_Schedule_LayoutCaptionLbl: label 'Account Schedule Layout';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        FORMAT__New_Page__CaptionLbl: label 'New Page';
        FORMAT__Show_Opposite_Sign__CaptionLbl: label 'Show Opposite Sign';
        FORMAT_Bold_CaptionLbl: label 'Bold';
        FORMAT_Italic_CaptionLbl: label 'Italic';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 509 "Change Log Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Change Log Entries.rdlc';
    Caption = 'Change Log Entries';

    dataset
    {
        dataitem("Change Log Entry";"Change Log Entry")
        {
            RequestFilterFields = "Date and Time";
            column(ReportForNavId_1204; 1204)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Change_Log_Entry__GETFILTERS;GetFilters)
            {
            }
            column(Change_Log_Entry__Table_Name_;"Table Caption")
            {
            }
            column(Change_Log_Entry__Primary_Key_;"Primary Key")
            {
            }
            column(Change_Log_Entry__Field_Name_;"Field Caption")
            {
            }
            column(Change_Log_Entry__Type_of_Change_;"Type of Change")
            {
            }
            column(Change_Log_Entry__Old_Value_;GetLocalOldValue)
            {
            }
            column(Change_Log_Entry__New_Value_;GetLocalNewValue)
            {
            }
            column(Change_Log_Entry__User_ID_;"User ID")
            {
            }
            column(DT2DATE__Date_and_Time__;Format(Dt2Date("Date and Time")))
            {
            }
            column(Change_Log_Entry_Time;Time)
            {
            }
            column(Change_Log_Entry_Date_and_Time;"Date and Time")
            {
            }
            column(Change_Log_EntriesCaption;Change_Log_EntriesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption;FiltersCaptionLbl)
            {
            }
            column(Change_Log_Entry__Table_Name_Caption;FieldCaption("Table Caption"))
            {
            }
            column(Change_Log_Entry__Primary_Key_Caption;FieldCaption("Primary Key"))
            {
            }
            column(Change_Log_Entry__Field_Name_Caption;FieldCaption("Field Caption"))
            {
            }
            column(Change_Log_Entry__Type_of_Change_Caption;FieldCaption("Type of Change"))
            {
            }
            column(Change_Log_Entry__Old_Value_Caption;FieldCaption("Old Value"))
            {
            }
            column(Change_Log_Entry__New_Value_Caption;FieldCaption("New Value"))
            {
            }
            column(Change_Log_Entry__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(DT2DATE__Date_and_Time__Caption;DT2DATE__Date_and_Time__CaptionLbl)
            {
            }
            column(Change_Log_Entry_TimeCaption;FieldCaption(Time))
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Table Caption","Field Caption");
                "Primary Key" := GetPrimaryKeyFriendlyName;
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

    var
        Change_Log_EntriesCaptionLbl: label 'Change Log Entries';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        FiltersCaptionLbl: label 'Filters';
        DT2DATE__Date_and_Time__CaptionLbl: label 'Date';
}


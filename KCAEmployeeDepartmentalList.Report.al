#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51656 "KCA Employee Departmental List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Employee Departmental List.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_3372; 3372)
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
            column(USERID;UserId)
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__HR_Employee_C___Department_Code_;"HRM-Employee C"."Department Code")
            {
            }
            column(HR_Employee_C__Section_Code_;"Section Code")
            {
            }
            column(KCA_University_Employee_Depatmental_ListCaption;KCA_University_Employee_Depatmental_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(Staff_No_Caption;Staff_No_CaptionLbl)
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(Station_Campus_Caption;Station_Campus_CaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                MYDIMENSIONS.Reset;
                if ("HRM-Employee C".Find('-')) then
                begin
                MYDIMENSIONS.SetRange(MYDIMENSIONS.Code,"HRM-Employee C"."Department Code" );
                if MYDIMENSIONS.Find('-') then
                begin
                MYDEP := MYDIMENSIONS.Name;
                end;
                end;
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
        MYDIMENSIONS: Record "Dimension Value";
        MYDEP: Text[30];
        KCA_University_Employee_Depatmental_ListCaptionLbl: label 'KCA University Employee Depatmental List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Staff_No_CaptionLbl: label 'Staff No.';
        DepartmentCaptionLbl: label 'Department';
        Station_Campus_CaptionLbl: label 'Station(Campus)';
}


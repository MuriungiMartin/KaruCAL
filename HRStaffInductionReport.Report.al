#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51187 "HR Staff  Induction Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Staff  Induction Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61246;UnknownTable61246)
        {
            DataItemTableView = sorting("Induction Code");
            RequestFilterFields = "Induction Code";
            column(ReportForNavId_8419; 8419)
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
            column(HR_Induction_Schedule__Induction_Code_;"Induction Code")
            {
            }
            column(HR_Induction_Schedule__Department_Code_;"Department Code")
            {
            }
            column(HR_Induction_Schedule__Induction_Period_;"Induction Period")
            {
            }
            column(HR_Induction_Schedule__Induction_Start_date_;"Induction Start date")
            {
            }
            column(HR_Induction_Schedule__Induction_End__date_;"Induction End  date")
            {
            }
            column(HR_Induction_Schedule__Department_Name_;"Department Name")
            {
            }
            column(HR_Induction_ScheduleCaption;HR_Induction_ScheduleCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Induction_ScheduleCaption;Company_Induction_ScheduleCaptionLbl)
            {
            }
            column(HR_Induction_Schedule__Induction_Code_Caption;FieldCaption("Induction Code"))
            {
            }
            column(HR_Induction_Schedule__Department_Code_Caption;FieldCaption("Department Code"))
            {
            }
            column(HR_Induction_Schedule__Induction_Period_Caption;FieldCaption("Induction Period"))
            {
            }
            column(HR_Induction_Schedule__Induction_Start_date_Caption;FieldCaption("Induction Start date"))
            {
            }
            column(HR_Induction_Schedule__Induction_End__date_Caption;FieldCaption("Induction End  date"))
            {
            }
            column(HR_Induction_Schedule__Department_Name_Caption;FieldCaption("Department Name"))
            {
            }
            dataitem(UnknownTable61247;UnknownTable61247)
            {
                DataItemLink = "Induction Code"=field("Induction Code");
                column(ReportForNavId_1489; 1489)
                {
                }
                column(HR_Staff__Induction__Employee_Code_;"Employee Code")
                {
                }
                column(HR_Staff__Induction__Employee_name_;"Employee name")
                {
                }
                column(HR_Staff__Induction_Depatment;Depatment)
                {
                }
                column(HR_Staff__Induction__Induction_Status_;"Induction Status")
                {
                }
                column(HR_Staff__Induction__Employee_Code_Caption;FieldCaption("Employee Code"))
                {
                }
                column(HR_Staff__Induction__Employee_name_Caption;FieldCaption("Employee name"))
                {
                }
                column(HR_Staff__Induction_DepatmentCaption;FieldCaption(Depatment))
                {
                }
                column(Induction_StatusCaption;Induction_StatusCaptionLbl)
                {
                }
                column(ParticipantsCaption;ParticipantsCaptionLbl)
                {
                }
                column(HR_Staff__Induction_Induction_Code;"Induction Code")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Induction Code");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        HR_Induction_ScheduleCaptionLbl: label 'HR Induction Schedule';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Company_Induction_ScheduleCaptionLbl: label 'Company Induction Schedule';
        Induction_StatusCaptionLbl: label 'Induction Status';
        ParticipantsCaptionLbl: label 'Participants';
}


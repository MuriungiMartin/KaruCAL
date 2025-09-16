#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51484 "Summary Enrollment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Summary Enrollment.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","Stage Filter","Date Filter",Status;
            column(ReportForNavId_1410; 1410)
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
            column(TIME;Time)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(GETFILTER__Semester_Filter__;GetFilter("Semester Filter"))
            {
            }
            column(GETFILTER__Date_Filter__;GetFilter("Date Filter"))
            {
            }
            column(Programme__School_Code_;"School Code")
            {
            }
            column(Summary_EnrollmentCaption;Summary_EnrollmentCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Semester_FilterCaption;Semester_FilterCaptionLbl)
            {
            }
            column(FilterCaption;FilterCaptionLbl)
            {
            }
            column(Programme__School_Code_Caption;FieldCaption("School Code"))
            {
            }
            column(Programme_Stages_DescriptionCaption;"ACA-Programme Stages".FieldCaption(Description))
            {
            }
            column(Programme_Stages_CodeCaption;"ACA-Programme Stages".FieldCaption(Code))
            {
            }
            column(Total_RegisteredCaption;Total_RegisteredCaptionLbl)
            {
            }
            column(Programme_Stages__Registered_Full_Time_Caption;"ACA-Programme Stages".FieldCaption("Registered Full Time"))
            {
            }
            column(Programme_Stages__Registered_Part_Time_Caption;"ACA-Programme Stages".FieldCaption("Registered Part Time"))
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code),Code=field("Stage Filter");
                RequestFilterFields = "Date Filter";
                column(ReportForNavId_3691; 3691)
                {
                }
                column(Programme_Stages_Description;Description)
                {
                }
                column(Programme_Stages__Student_Registered_;"Student Registered")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                column(Programme_Stages__Registered_Full_Time_;"Registered Full Time")
                {
                }
                column(Programme_Stages__Registered_Part_Time_;"Registered Part Time")
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code);
                    DataItemTableView = where(Reversed=const(No));
                    RequestFilterFields = "Settlement Type";
                    column(ReportForNavId_2901; 2901)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    TotalIncome:=TotalIncome+"ACA-Programme Stages"."Total Income";
                    TotalReg:=TotalReg+"ACA-Programme Stages"."Student Registered";
                end;

                trigger OnPreDataItem()
                begin
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Semester Filter","ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Date Filter","ACA-Programme".GetFilter("ACA-Programme"."Date Filter"));
                    //"Programme Stages".SETFILTER("Programme Stages".Status,Programme.GETFILTER(Programme.Status));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalIncome:=0;
                TotalReg:=0;
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
        TotalIncome: Decimal;
        TotalReg: Integer;
        Sem: Text[250];
        Summary_EnrollmentCaptionLbl: label 'Summary Enrollment';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Semester_FilterCaptionLbl: label 'Semester Filter';
        FilterCaptionLbl: label 'Filter';
        Total_RegisteredCaptionLbl: label 'Total Registered';
}


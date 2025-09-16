#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51688 "Detailed Enrollments1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Enrollments1.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","Date Filter";
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme__Semester_Filter_;"Semester Filter")
            {
            }
            column(Programme__Date_Filter_;"Date Filter")
            {
            }
            column(Programme__School_Code_;"School Code")
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
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
            column(Programme__Semester_Filter_Caption;FieldCaption("Semester Filter"))
            {
            }
            column(Programme__Date_Filter_Caption;FieldCaption("Date Filter"))
            {
            }
            column(Programme__School_Code_Caption;FieldCaption("School Code"))
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
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
                column(TotalReg;TotalReg)
                {
                }
                column(Programme_Stages_CodeCaption;FieldCaption(Code))
                {
                }
                column(Programme_Stages_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Programme_Stages__Student_Registered_Caption;FieldCaption("Student Registered"))
                {
                }
                column(Programme_Stages__Registered_Full_Time_Caption;FieldCaption("Registered Full Time"))
                {
                }
                column(Programme_Stages__Registered_Part_Time_Caption;FieldCaption("Registered Part Time"))
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
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
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages".Status,"ACA-Programme".GetFilter("ACA-Programme".Status));
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
        Cust: Record Customer;
        SName: Text[200];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        ProgrammeCaptionLbl: label 'Programme';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}


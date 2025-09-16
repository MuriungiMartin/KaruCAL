#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51632 "Detailed Enrollment - Paid"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Enrollment - Paid.rdlc';

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
            column(TIME;Time)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(SemFilter;SemFilter)
            {
            }
            column(Programme__Date_Filter_;"Date Filter")
            {
            }
            column(Programme_Description_Control1000000008;Description)
            {
            }
            column(Programme_Registered;Registered)
            {
            }
            column(Programme_Paid;Paid)
            {
            }
            column(TTotIncome;TTotIncome)
            {
            }
            column(TTotPaid;TTotPaid)
            {
            }
            column(Students_Course_Enrollment_and__Payment_DetailsCaption;Students_Course_Enrollment_and__Payment_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Semester_FilterCaption;Semester_FilterCaptionLbl)
            {
            }
            column(Programme__Date_Filter_Caption;FieldCaption("Date Filter"))
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(PROGRAMME_Caption;PROGRAMME_CaptionLbl)
            {
            }
            column(Total_RegisteredCaption;Total_RegisteredCaptionLbl)
            {
            }
            column(Total_PaidCaption;Total_PaidCaptionLbl)
            {
            }
            column(Overall_TotalsCaption;Overall_TotalsCaptionLbl)
            {
            }
            column(Programme_Code;Code)
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
                column(Programme_Stages__Registered_Full_Time_;"Registered Full Time")
                {
                }
                column(Programme_Stages__Registered_Part_Time_;"Registered Part Time")
                {
                }
                column(Programme_Description_Control1000000010;"ACA-Programme".Description)
                {
                }
                column(Programme_Stages_Paid;Paid)
                {
                }
                column(Programme_Stages__Paid_Part_Time_;"Paid Part Time")
                {
                }
                column(Programme_Stages__Paid_Full_Time_;"Paid Full Time")
                {
                }
                column(TotIncome;TotIncome)
                {
                }
                column(TotPaid;TotPaid)
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
                column(STAGE_Caption;STAGE_CaptionLbl)
                {
                }
                column(Total_PaidCaption_Control1000000056;Total_PaidCaption_Control1000000056Lbl)
                {
                }
                column(Programme_Stages__Paid_Part_Time_Caption;FieldCaption("Paid Part Time"))
                {
                }
                column(Programme_Stages__Paid_Full_Time_Caption;FieldCaption("Paid Full Time"))
                {
                }
                column(TotalsCaption;TotalsCaptionLbl)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code);
                    DataItemTableView = sorting("Student Type");
                    RequestFilterFields = "Student Type";
                    column(ReportForNavId_2901; 2901)
                    {
                    }
                    column(Course_Registration__Student_Type_;"Student Type")
                    {
                    }
                    column(Course_Registration__Student_No__;"Student No.")
                    {
                    }
                    column(Course_Registration__Reg__Transacton_ID_;"Reg. Transacton ID")
                    {
                    }
                    column(Course_Registration__Registration_Date_;"Registration Date")
                    {
                    }
                    column(SName;SName)
                    {
                    }
                    column(Course_Registration__Total_Billed_;"Total Billed")
                    {
                    }
                    column(Course_Registration__Total_Paid_;"Total Paid")
                    {
                    }
                    column(Total_Billed___Total_Paid_;"Total Billed"-"Total Paid")
                    {
                    }
                    column(Course_Registration__Student_Type_Caption;FieldCaption("Student Type"))
                    {
                    }
                    column(Course_Registration__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
                    {
                    }
                    column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
                    {
                    }
                    column(NameCaption;NameCaptionLbl)
                    {
                    }
                    column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
                    {
                    }
                    column(Course_Registration__Total_Billed_Caption;FieldCaption("Total Billed"))
                    {
                    }
                    column(Course_Registration__Total_Paid_Caption;FieldCaption("Total Paid"))
                    {
                    }
                    column(BalanceCaption;BalanceCaptionLbl)
                    {
                    }
                    column(Course_Registration_Programme;Programme)
                    {
                    }
                    column(Course_Registration_Semester;Semester)
                    {
                    }
                    column(Course_Registration_Register_for;"Register for")
                    {
                    }
                    column(Course_Registration_Stage;Stage)
                    {
                    }
                    column(Course_Registration_Unit;Unit)
                    {
                    }
                    column(Course_Registration_Entry_No_;"Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        if Cust.Get("ACA-Course Registration"."Student No.") then
                        SName:=Cust.Name
                        else
                        SName:='';
                        TotPaid:=TotPaid+"ACA-Course Registration"."Total Paid";
                        TotIncome:=TotIncome+"ACA-Course Registration"."Total Billed";
                        TTotPaid:= TTotPaid+"ACA-Course Registration"."Total Paid";
                        TTotIncome:=TTotIncome+"ACA-Course Registration"."Total Billed";
                    end;

                    trigger OnPreDataItem()
                    begin
                        LastFieldNo := FieldNo("Student Type");

                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"))
                        ;
                        "ACA-Course Registration".SetFilter("ACA-Course Registration"."Registration Date",
                        "ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Date Filter"));
                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Status,"ACA-Programme Stages".GetFilter("ACA-Programme Stages".Status));
                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Reversed,'no');
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    "ACA-Programme Stages".CalcFields("ACA-Programme Stages"."Total Income1");
                    TotalIncome:=TotalIncome+"ACA-Programme Stages"."Total Income1";
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
                SemFilter:="ACA-Programme".GetFilter("ACA-Programme"."Semester Filter");
                TotPaid:=0;
                TotIncome:=0;
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
        SemFilter: Text[150];
        TotPaid: Decimal;
        TotIncome: Decimal;
        TTotPaid: Decimal;
        TTotIncome: Decimal;
        Students_Course_Enrollment_and__Payment_DetailsCaptionLbl: label 'Students Course Enrollment and  Payment Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Semester_FilterCaptionLbl: label 'Semester Filter';
        DepartmentCaptionLbl: label 'Department';
        PROGRAMME_CaptionLbl: label 'PROGRAMME:';
        Total_RegisteredCaptionLbl: label 'Total Registered';
        Total_PaidCaptionLbl: label 'Total Paid';
        Overall_TotalsCaptionLbl: label 'Overall Totals';
        STAGE_CaptionLbl: label 'STAGE:';
        Total_PaidCaption_Control1000000056Lbl: label 'Total Paid';
        TotalsCaptionLbl: label 'Totals';
        NameCaptionLbl: label 'Name';
        BalanceCaptionLbl: label 'Balance';
}


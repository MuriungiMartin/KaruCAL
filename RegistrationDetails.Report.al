#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51475 "Registration Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Registration Details.rdlc';

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
            column(Programme_Description;Description)
            {
            }
            column(Programme__Registered_Full_Time_;"Registered Full Time")
            {
            }
            column(Programme__Paid_Full_Time_;"Paid Full Time")
            {
            }
            column(Programme__Registered_Part_Time_;"Registered Part Time")
            {
            }
            column(Programme__Paid_Part_Time_;"Paid Part Time")
            {
            }
            column(Programme_Registered;Registered)
            {
            }
            column(Programme_Paid;Paid)
            {
            }
            column(Programme__Part_Time_Budget___Programme__Full_Time_Budget_;"ACA-Programme"."Part Time Budget"+ "ACA-Programme"."Full Time Budget")
            {
            }
            column(Enroll;Enroll)
            {
            }
            column(Registration_DetailsCaption;Registration_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_PaidCaption;FieldCaption(Paid))
            {
            }
            column(RegCaption;RegCaptionLbl)
            {
            }
            column(Programme__Paid_Part_Time_Caption;FieldCaption("Paid Part Time"))
            {
            }
            column(Reg_Part_TimeCaption;Reg_Part_TimeCaptionLbl)
            {
            }
            column(Programme__Paid_Full_Time_Caption;FieldCaption("Paid Full Time"))
            {
            }
            column(Reg_Full_TimeCaption;Reg_Full_TimeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(Programme_Stages__Full_Time_Budget_Caption;"ACA-Programme Stages".FieldCaption("Full Time Budget"))
            {
            }
            column(Programme_Stages__Part_Time_Budget_Caption;"ACA-Programme Stages".FieldCaption("Part Time Budget"))
            {
            }
            column(BudgetCaption;BudgetCaptionLbl)
            {
            }
            column(EnrollCaption;EnrollCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
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
                column(Programme_Stages_Paid;Paid)
                {
                }
                column(Programme_Stages_Registered;Registered)
                {
                }
                column(Programme_Stages__Paid_Part_Time_;"Paid Part Time")
                {
                }
                column(Programme_Stages__Registered_Part_Time_;"Registered Part Time")
                {
                }
                column(Programme_Stages__Paid_Full_Time_;"Paid Full Time")
                {
                }
                column(Programme_Stages__Registered_Full_Time_;"Registered Full Time")
                {
                }
                column(Programme_Stages_Description;Description)
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                column(Programme_Stages__Full_Time_Budget_;"Full Time Budget")
                {
                }
                column(Programme_Stages__Part_Time_Budget_;"Part Time Budget")
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }

                trigger OnPreDataItem()
                begin
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Date Filter","ACA-Programme".GetFilter("ACA-Programme"."Date Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Programme".CalcFields("ACA-Programme"."Part Time Budget","ACA-Programme"."Full Time Budget","ACA-Programme".Paid);
                Enroll:=0;
                if ("ACA-Programme".Paid > 0) and (("ACA-Programme"."Part Time Budget"+ "ACA-Programme"."Full Time Budget") > 0)  then
                Enroll:=("ACA-Programme".Paid/("ACA-Programme"."Part Time Budget"+ "ACA-Programme"."Full Time Budget"))*100;
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
        Enroll: Decimal;
        Registration_DetailsCaptionLbl: label 'Registration Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        RegCaptionLbl: label 'Reg';
        Reg_Part_TimeCaptionLbl: label 'Reg Part Time';
        Reg_Full_TimeCaptionLbl: label 'Reg Full Time';
        DescriptionCaptionLbl: label 'Description';
        CodeCaptionLbl: label 'Code';
        BudgetCaptionLbl: label 'Budget';
        EnrollCaptionLbl: label '% Enroll';
        TotalsCaptionLbl: label 'Totals';
}


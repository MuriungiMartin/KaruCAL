#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51697 "Detailed Student Enrollment BU"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Student Enrollment BU.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            CalcFields = "Registered Part Time","Paid Part Time","Registered Full Time","Paid Full Time";
            DataItemTableView = sorting("Programme Code",Code);
            RequestFilterFields = "Programme Code","Semester Filter";
            column(ReportForNavId_3691; 3691)
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
            column(Programme_Stages__GETFILTER__Programme_Stages___Semester_Filter__;"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"))
            {
            }
            column(Programme_Stages__Programme_Code_;"Programme Code")
            {
            }
            column(Programme_Stages_Code;Code)
            {
            }
            column(Programme_Stages_Description;Description)
            {
            }
            column(Programme_Stages__Student_Registered_;"Student Registered")
            {
            }
            column(Programme_Stages__Registered_Part_Time_;"Registered Part Time")
            {
            }
            column(Programme_Stages__Registered_Full_Time_;"Registered Full Time")
            {
            }
            column(Programme_Stages__Paid_Part_Time_;"Paid Part Time")
            {
            }
            column(Programme_Stages__Paid_Full_Time_;"Paid Full Time")
            {
            }
            column(Programme_Stages__Full_Time_Budget_;"Full Time Budget")
            {
            }
            column(Programme_Stages__Part_Time_Budget_;"Part Time Budget")
            {
            }
            column(percantage;percantage)
            {
            }
            column(Programme_Stages_Paid;Paid)
            {
            }
            column(Summary_Enrollment___Registered_Paid_And_Budget_VarianceCaption;Summary_Enrollment___Registered_Paid_And_Budget_VarianceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Semester_Filter_Caption;Semester_Filter_CaptionLbl)
            {
            }
            column(Programme_Stages__Programme_Code_Caption;FieldCaption("Programme Code"))
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
            column(Registered_Part_TimeCaption;Registered_Part_TimeCaptionLbl)
            {
            }
            column(Registered_Full_TimeCaption;Registered_Full_TimeCaptionLbl)
            {
            }
            column(Paid_Part_TimeCaption;Paid_Part_TimeCaptionLbl)
            {
            }
            column(Paid_Full_TimeCaption;Paid_Full_TimeCaptionLbl)
            {
            }
            column(Part_Time_BudgetCaption;Part_Time_BudgetCaptionLbl)
            {
            }
            column(varianceCaption;varianceCaptionLbl)
            {
            }
            column(Full_Time_BudgetCaption;Full_Time_BudgetCaptionLbl)
            {
            }
            column(Total_PaidCaption;Total_PaidCaptionLbl)
            {
            }
            column(Programme_Stages_Registered;Registered)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalStuds:=TotalStuds+"ACA-Programme Stages"."Student Registered";
                 StudReg:=0;
                 StudRegPT:=0;
                 PaidPT:=0;
                 PaidFT:=0;
                 StudRegFT:=0;
                /*
                Programme.RESET;
                Programme.SETRANGE(Programme.Code,"Programme Stages"."Programme Code");
                Programme.SETFILTER(Programme."Semester Filter","Programme Stages".GETFILTER("Programme Stages"."Semester Filter"));
                IF  Programme.FIND('-') THEN BEGIN
                Programme.CALCFIELDS(Programme."Student Registered");
                Programme.CALCFIELDS(Programme."Registered Part Time");
                Programme.CALCFIELDS(Programme."Paid Part Time");
                Programme.CALCFIELDS(Programme."Registered Full Time");
                Programme.CALCFIELDS(Programme."Paid Full Time");
                Programme.CALCFIELDS(Programme."Full Time Budget");
                Programme.CALCFIELDS(Programme."Part Time Budget");
                StudReg:=Programme."Student Registered";
                StudRegPT:=Programme."Registered Part Time";
                PaidPT:=Programme."Paid Part Time";
                PaidFT:=Programme."Paid Full Time";
                StudRegFT:=Programme."Registered Full Time";
                PartBudget:=Programme."Part Time Budget";
                FullBudget:=Programme."Full Time Budget";
                TPaid:=PaidPT+PaidFT;
                TBudget:=Programme."Part Time Budget"+Programme."Full Time Budget";
                percantage:=0;
                IF (TPaid<>0) AND (TBudget<>0) THEN
                percantage:=(TPaid/TBudget)/100;
                END;
                */
                percantage:=0;
                TPaid:="ACA-Programme Stages"."Paid Part Time"+"ACA-Programme Stages"."Paid Full Time";
                TBudget:="ACA-Programme Stages"."Full Time Budget"+"ACA-Programme Stages"."Part Time Budget";
                if (TPaid<>0) and (TBudget<>0) then
                percantage:=(TPaid/TBudget)*100;

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Programme Code");
                //TStudReg:=0;
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
        TotalStuds: Integer;
        Programme: Record UnknownRecord61511;
        StudReg: Integer;
        StudRegPT: Integer;
        PaidPT: Integer;
        PaidFT: Integer;
        StudRegFT: Integer;
        TStudReg: Integer;
        TStudRegPT: Integer;
        TPaidPT: Integer;
        TPaidFT: Integer;
        Programmes: Record UnknownRecord61511;
        TStudRegFT: Integer;
        percantage: Decimal;
        PartBudget: Decimal;
        FullBudget: Decimal;
        TBudget: Decimal;
        TPaid: Decimal;
        SFilter: Text[100];
        Summary_Enrollment___Registered_Paid_And_Budget_VarianceCaptionLbl: label 'Summary Enrollment - Registered,Paid And Budget Variance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Semester_Filter_CaptionLbl: label 'Semester Filter:';
        Registered_Part_TimeCaptionLbl: label 'Registered Part Time';
        Registered_Full_TimeCaptionLbl: label 'Registered Full Time';
        Paid_Part_TimeCaptionLbl: label 'Paid Part Time';
        Paid_Full_TimeCaptionLbl: label 'Paid Full Time';
        Part_Time_BudgetCaptionLbl: label 'Part Time Budget';
        varianceCaptionLbl: label '%variance';
        Full_Time_BudgetCaptionLbl: label 'Full Time Budget';
        Total_PaidCaptionLbl: label 'Total Paid';
}


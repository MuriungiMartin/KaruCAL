#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51695 "Detailed Student Enrollment1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Student Enrollment1.rdlc';

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
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TIME;Time)
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
            column(Programme_Stages__Programme_Code__Control1000000008;"Programme Code")
            {
            }
            column(StudReg;StudReg)
            {
            }
            column(StudRegPT;StudRegPT)
            {
            }
            column(StudRegFT;StudRegFT)
            {
            }
            column(PaidPT;PaidPT)
            {
            }
            column(PaidFT;PaidFT)
            {
            }
            column(FullBudget;FullBudget)
            {
            }
            column(PartBudget;PartBudget)
            {
            }
            column(PaidT;PaidT)
            {
            }
            column(Tbudget;Tbudget)
            {
            }
            column(percantage;percantage)
            {
            }
            column(Pdescription;Pdescription)
            {
            }
            column(TStudReg;TStudReg)
            {
            }
            column(TStudRegPT;TStudRegPT)
            {
            }
            column(TStudRegFT;TStudRegFT)
            {
            }
            column(TPaidPT;TPaidPT)
            {
            }
            column(TPaidFT;TPaidFT)
            {
            }
            column(GPaidT;GPaidT)
            {
            }
            column(GTbudget;GTbudget)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(KARATINAUNIVERSITY1Caption;KARATINAUNIVERSITY1CaptionLbl)
            {
            }
            column(CLASS_REGISTRATION_SUMMARY___AS_AT_Caption;CLASS_REGISTRATION_SUMMARY___AS_AT_CaptionLbl)
            {
            }
            column(TIMECaption;TIMECaptionLbl)
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
            column(Total_BudgetCaption;Total_BudgetCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(SUBTOTALCaption;SUBTOTALCaptionLbl)
            {
            }
            column(Total_StudentsCaption;Total_StudentsCaptionLbl)
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
                Programme.Reset;
                Programme.SetRange(Programme.Code,"ACA-Programme Stages"."Programme Code");
                Programme.SetFilter(Programme."Semester Filter","ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"));
                //////////////////////////////////////////////////////////////
                if  Programme.Find('-') then begin
                Programme.CalcFields(Programme."Student Registered");
                Programme.CalcFields(Programme."Registered Part Time");
                Programme.CalcFields(Programme."Paid Part Time");
                Programme.CalcFields(Programme."Registered Full Time");
                Programme.CalcFields(Programme."Paid Full Time");
                Programme.CalcFields(Programme."Full Time Budget");
                Programme.CalcFields(Programme."Part Time Budget");
                StudReg:=Programme."Student Registered";
                StudRegPT:=Programme."Registered Part Time";
                PaidPT:=Programme."Paid Part Time";
                PaidFT:=Programme."Paid Full Time";
                StudRegFT:=Programme."Registered Full Time";
                PartBudget:=Programme."Part Time Budget";
                FullBudget:=Programme."Full Time Budget";
                PaidT:=PaidPT+PaidFT;
                Tbudget:=PartBudget+FullBudget;
                //percantage:=((PaidPT+PaidFT)/(Programme."Part Time Budget"+Programme."Full Time Budget"))/100;
                end;
                 //"Programme Stages".CALCFIELDS("Programme Stages"."Student Registered");
                 //TStudReg:="Programme Stages"."Student Registered";
                //TStudReg:=TStudReg+StudReg;
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
        PaidT: Decimal;
        Tbudget: Decimal;
        GTbudget: Decimal;
        GPaidT: Decimal;
        Pdescription: Text[70];
        Progr: Record UnknownRecord61511;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        KARATINAUNIVERSITY1CaptionLbl: label 'KARATINA UNIVERSITY';
        CLASS_REGISTRATION_SUMMARY___AS_AT_CaptionLbl: label 'CLASS REGISTRATION SUMMARY - AS AT ';
        TIMECaptionLbl: label 'TIME';
        Registered_Part_TimeCaptionLbl: label 'Registered Part Time';
        Registered_Full_TimeCaptionLbl: label 'Registered Full Time';
        Paid_Part_TimeCaptionLbl: label 'Paid Part Time';
        Paid_Full_TimeCaptionLbl: label 'Paid Full Time';
        Part_Time_BudgetCaptionLbl: label 'Part Time Budget';
        varianceCaptionLbl: label '%variance';
        Full_Time_BudgetCaptionLbl: label 'Full Time Budget';
        Total_PaidCaptionLbl: label 'Total Paid';
        Total_BudgetCaptionLbl: label 'Total Budget';
        TotalCaptionLbl: label 'Total';
        SUBTOTALCaptionLbl: label 'SUBTOTAL';
        Total_StudentsCaptionLbl: label 'Total Students';
}


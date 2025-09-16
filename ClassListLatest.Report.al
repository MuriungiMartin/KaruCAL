#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51694 "Class List Latest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Class List Latest.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student Type") where(Reversed=const(No),Registered=const(Yes));
            RequestFilterFields = Programme,Stage,Semester,"Student Type","Settlement Type";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(StudType;StudType)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration__Course_Registration__Programme;"ACA-Course Registration".Programme)
            {
            }
            column(Course_Registration__Course_Registration__Programme_Control1000000018;"ACA-Course Registration".Programme)
            {
            }
            column(TODAY;Today)
            {
            }
            column(Course_Registration__Course_Registration__Semester;"ACA-Course Registration".Semester)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(SName;SName)
            {
            }
            column(Hesabu;Hesabu)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(MONCaption;MONCaptionLbl)
            {
            }
            column(TUECaption;TUECaptionLbl)
            {
            }
            column(WEDCaption;WEDCaptionLbl)
            {
            }
            column(THURCaption;THURCaptionLbl)
            {
            }
            column(FRICaption;FRICaptionLbl)
            {
            }
            column(SATCaption;SATCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(StageCaption;StageCaptionLbl)
            {
            }
            column(Student_TypeCaption;Student_TypeCaptionLbl)
            {
            }
            column(semester_filterCaption;semester_filterCaptionLbl)
            {
            }
            column(Issued_OnCaption;Issued_OnCaptionLbl)
            {
            }
            column(LecturerCaption;LecturerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Class_List___Paid_StudentsCaption;Class_List___Paid_StudentsCaptionLbl)
            {
            }
            column(SUNCaption;SUNCaptionLbl)
            {
            }
            column(MONCaption_Control1000000003;MONCaption_Control1000000003Lbl)
            {
            }
            column(TUECaption_Control1000000004;TUECaption_Control1000000004Lbl)
            {
            }
            column(WEDCaption_Control1000000005;WEDCaption_Control1000000005Lbl)
            {
            }
            column(THURCaption_Control1000000006;THURCaption_Control1000000006Lbl)
            {
            }
            column(FRICaption_Control1000000041;FRICaption_Control1000000041Lbl)
            {
            }
            column(SATCaption_Control1000000043;SATCaption_Control1000000043Lbl)
            {
            }
            column(SUNCaption_Control1000000044;SUNCaption_Control1000000044Lbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
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
                Hesabu:=Hesabu+1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Student Type");

                //"Course Registration".SETFILTER("Course Registration".Semester,ProgramStages.GETFILTER(ProgramStages."Semester Filter"));
                //"Course Registration".SETFILTER("Course Registration"."Registration Date",
                //ProgramStages.GETFILTER(ProgramStages."Date Filter"));
                //"Course Registration".SETFILTER("Course Registration".Status,ProgramStages.GETFILTER(ProgramStages.Status));
                Stage:="ACA-Course Registration".GetFilter("ACA-Course Registration".Stage);
                StudType:="ACA-Course Registration".GetFilter("ACA-Course Registration"."Student Type");
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
        Hesabu: Integer;
        Stage: Text[30];
        StudType: Text[30];
        ProgramStages: Record UnknownRecord61516;
        "Code": Code[10];
        Description: Text[30];
        MONCaptionLbl: label 'MON';
        TUECaptionLbl: label 'TUE';
        WEDCaptionLbl: label 'WED';
        THURCaptionLbl: label 'THUR';
        FRICaptionLbl: label 'FRI';
        SATCaptionLbl: label 'SAT';
        CodeCaptionLbl: label 'Code';
        DescriptionCaptionLbl: label 'Description';
        StageCaptionLbl: label 'Stage';
        Student_TypeCaptionLbl: label 'Student Type';
        semester_filterCaptionLbl: label 'semester filter';
        Issued_OnCaptionLbl: label 'Issued On';
        LecturerCaptionLbl: label 'Lecturer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Class_List___Paid_StudentsCaptionLbl: label 'Class List - Paid Students';
        SUNCaptionLbl: label 'SUN';
        MONCaption_Control1000000003Lbl: label 'MON';
        TUECaption_Control1000000004Lbl: label 'TUE';
        WEDCaption_Control1000000005Lbl: label 'WED';
        THURCaption_Control1000000006Lbl: label 'THUR';
        FRICaption_Control1000000041Lbl: label 'FRI';
        SATCaption_Control1000000043Lbl: label 'SAT';
        SUNCaption_Control1000000044Lbl: label 'SUN';
}


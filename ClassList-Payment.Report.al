#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51635 "Class List - Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Class List - Payment.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student Type") where(Reversed=const(No),"Total Paid"=filter(>="1,700"));
            RequestFilterFields = Programme,Stage,Semester,"Student Type";
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
            column(Course_Registration__Total_Billed_;"Total Billed")
            {
            }
            column(Course_Registration__Total_Paid_;"Total Paid")
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
            column(Class_List___PaymentsCaption;Class_List___PaymentsCaptionLbl)
            {
            }
            column(Course_Registration__Total_Paid_Caption;FieldCaption("Total Paid"))
            {
            }
            column(Course_Registration__Total_Billed_Caption;FieldCaption("Total Billed"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
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
        CodeCaptionLbl: label 'Code';
        DescriptionCaptionLbl: label 'Description';
        StageCaptionLbl: label 'Stage';
        Student_TypeCaptionLbl: label 'Student Type';
        semester_filterCaptionLbl: label 'semester filter';
        Issued_OnCaptionLbl: label 'Issued On';
        LecturerCaptionLbl: label 'Lecturer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Class_List___PaymentsCaptionLbl: label 'Class List - Payments';
        NamesCaptionLbl: label 'Names';
        Student_No_CaptionLbl: label 'Student No.';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51723 "Validate Student Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Student Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type","Entry No.") where("Exam Status"=filter(""),Reversed=const(No));
            RequestFilterFields = Programme,Semester,Stage;
            column(ReportForNavId_2901; 2901)
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
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration__Settlement_Type_;"Settlement Type")
            {
            }
            column(Course_Registration__Registration_Date_;"Registration Date")
            {
            }
            column(Course_Registration__Units_Taken_;"Units Taken")
            {
            }
            column(Course_RegistrationCaption;Course_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Course_Registration__Settlement_Type_Caption;FieldCaption("Settlement Type"))
            {
            }
            column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
            {
            }
            column(Course_Registration__Units_Taken_Caption;FieldCaption("Units Taken"))
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Register_for;"Register for")
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
                 "ACA-Course Registration".Validate("ACA-Course Registration"."Registration Date");
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
        Course_RegistrationCaptionLbl: label 'Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}


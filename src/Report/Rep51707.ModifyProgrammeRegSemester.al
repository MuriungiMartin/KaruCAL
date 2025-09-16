#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51707 "Modify Programme Reg Semester"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Modify Programme Reg Semester.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Programme,Stage,Semester,"Semester Filter";
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
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration__Register_for_;"Register for")
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
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration__Register_for_Caption;FieldCaption("Register for"))
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
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
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
                ENo:=ENo+1;
                
                
                /*"Course Registration".Semester:=Sem;
                "Course Registration".MODIFY;*/
                
                "ACA-Course Registration".Rename("Reg. Transacton ID","Student No.",
                Programme,Sem,"Register for",Stage,Unit,"Student Type","Entry No.");
                
                /**** UPDATE SETTLEMENT TYPE ****/
                
                /*"Course Registration"."Settlement Type":='DIRECTBONDO';
                "Course Registration".MODIFY;*/

            end;

            trigger OnPreDataItem()
            begin
                
                Sem:="ACA-Course Registration".GetFilter("ACA-Course Registration"."Semester Filter");
                
                if Sem = '' then
                Error('You must specify the semmester')
                
                /**** UPDATE SETTLEMENT TYPE ****/
                
                /*IF "Course Registration".GETFILTER("Course Registration"."Student No.")='' THEN
                ERROR('You Must Specify a Student No. Filter!');*/

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
        ENo: Integer;
        Sem: Code[20];
        Course_RegistrationCaptionLbl: label 'Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51591 "Mass Update Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Mass Update Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = Programme,Stage,Semester,"Student No.","Programme Filter","Stage Filter","Unit Filter";
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
            column(Course_Registration__Reg__Transacton_ID_;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Semester;Semester)
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
            column(Course_Registration__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
            {
            }
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
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
                StudentUnits2.Reset;
                StudentUnits2.SetRange(StudentUnits2."Student No.","ACA-Course Registration"."Student No.");
                StudentUnits2.SetRange(StudentUnits2."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                StudentUnits2.SetRange(StudentUnits2.Unit,Units.Code);
                if StudentUnits2.Find('-') = false then begin

                StudentUnits.Init;
                StudentUnits."Reg. Transacton ID":="Reg. Transacton ID";
                StudentUnits."Student No.":="Student No.";
                StudentUnits.Programme:=GetFilter("ACA-Course Registration"."Programme Filter");
                StudentUnits.Stage:=GetFilter("ACA-Course Registration"."Stage Filter");
                StudentUnits."Unit Stage":=GetFilter("ACA-Course Registration"."Stage Filter");
                StudentUnits.Unit:=Units.Code;
                StudentUnits.Semester:=Semester;
                StudentUnits."Register for":="Register for";
                StudentUnits."No. Of Units":=Units."No. Units";
                StudentUnits."Unit Type":=Units."unit type"::Required;
                StudentUnits.Taken:=true;
                StudentUnits."System Created":=true;
                StudentUnits.Insert;

                end;
            end;

            trigger OnPreDataItem()
            begin
                Units.Reset;
                Units.SetRange(Units."Programme Code","ACA-Course Registration".GetFilter("ACA-Course Registration"."Programme Filter"));
                Units.SetRange(Units."Stage Code","ACA-Course Registration".GetFilter("ACA-Course Registration"."Stage Filter"));
                Units.SetRange(Units.Code,"ACA-Course Registration".GetFilter("ACA-Course Registration"."Unit Filter"));
                if Units.Find('-') = false then
                Error('Unit not found.');
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
        StudentUnits: Record UnknownRecord61549;
        StudentUnits2: Record UnknownRecord61549;
        UnitCode: Code[20];
        Units: Record UnknownRecord61517;
        StageUnits: Integer;
        Course_RegistrationCaptionLbl: label 'Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}


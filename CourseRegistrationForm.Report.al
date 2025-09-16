#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51571 "Course Registration Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Course Registration Form.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = "Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Registration_Date_;"Registration Date")
            {
            }
            column(Course_Registration__Student_Type_;"Student Type")
            {
            }
            column(Stages_Description;Stages.Description)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
            {
            }
            column(Course_Registration__Student_Type_Caption;FieldCaption("Student Type"))
            {
            }
            column(KARATINA_UNIVERSITYS_COURSE_REGISTRATION_FORMCaption;KARATINA_UNIVERSITYS_COURSE_REGISTRATION_FORMCaptionLbl)
            {
            }
            column(Units_Taken_Caption;Units_Taken_CaptionLbl)
            {
            }
            column(LevelCaption;LevelCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
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
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Reg. Transacton ID"=field("Reg. Transacton ID"),"Student No."=field("Student No.");
                DataItemTableView = where(Taken=const(Yes));
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(UDesc;UDesc)
                {
                }
                column(Signature_Caption;Signature_CaptionLbl)
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Student_Units_Student_No_;"Student No.")
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    UDesc:='';
                    Units.Reset;
                    Units.SetRange(Units."Programme Code","ACA-Student Units".Programme);
                    Units.SetRange(Units.Code,Unit);
                    if Units.Find('-') then
                    UDesc:=Units.Desription;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("ACA-Course Registration"."Student No.") then
                RFound:=true;
                if Prog.Get("ACA-Course Registration".Programme) then
                RFound:=true;
                if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                RFound:=true;
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
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        KARATINA_UNIVERSITYS_COURSE_REGISTRATION_FORMCaptionLbl: label 'KARATINA UNIVERSITY COURSE REGISTRATION FORM';
        Units_Taken_CaptionLbl: label 'Units Taken:';
        LevelCaptionLbl: label 'Level';
        ProgrammeCaptionLbl: label 'Programme';
        NamesCaptionLbl: label 'Names';
        Signature_CaptionLbl: label 'Signature:';
}


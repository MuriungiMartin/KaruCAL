#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51595 "Exam Card - Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Card - Label.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = "Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(StudNo;StudNo)
            {
            }
            column(Names;Names)
            {
            }
            column(FacultyDesc;FacultyDesc)
            {
            }
            column(FacultyDesc2;FacultyDesc2)
            {
            }
            column(Names2;Names2)
            {
            }
            column(StudNo2;StudNo2)
            {
            }
            column(ProgCode;ProgCode)
            {
            }
            column(ProgCode2;ProgCode2)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
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
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if RegHide = false then begin
                StudNo:='';
                Names:='';
                FacultyDesc:='';
                ProgCode:='';

                StudNo:="ACA-Course Registration"."Student No.";
                ProgCode:="ACA-Course Registration".Programme;
                if Cust.Get("ACA-Course Registration"."Student No.") then
                Names:=Cust.Name;
                if Prog.Get("ACA-Course Registration".Programme) then begin
                if FacultyR.Get(Prog.Faculty) then
                FacultyDesc:=FacultyR.Description;
                end;

                end else begin
                StudNo2:='';
                Names2:='';
                FacultyDesc2:='';
                ProgCode2:='';

                StudNo2:="ACA-Course Registration"."Student No.";
                ProgCode2:="ACA-Course Registration".Programme;
                if Cust.Get("ACA-Course Registration"."Student No.") then
                Names2:=Cust.Name;
                if Prog.Get("ACA-Course Registration".Programme) then begin
                if FacultyR.Get(Prog.Faculty) then
                FacultyDesc2:=FacultyR.Description;
                end;


                end;


                if RegHide = false then
                RegHide:=true
                else
                RegHide:=false;
            end;

            trigger OnPreDataItem()
            begin
                RegHide := false;
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
        St: Integer;
        StudNo: Code[20];
        Names: Text[100];
        FacultyDesc: Text[100];
        ProgCode: Code[20];
        StudNo2: Code[20];
        Names2: Text[100];
        FacultyDesc2: Text[100];
        ProgCode2: Code[20];
        FacultyR: Record UnknownRecord61587;
        RegHide: Boolean;
}


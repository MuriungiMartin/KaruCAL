#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51717 "Exam Card Labels4"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Card Labels4.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Programme,Semester,Stage;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(col1StudNo;col1StudNo)
            {
            }
            column(col2StudNo;col2StudNo)
            {
            }
            column(col1Faculty;col1Faculty)
            {
            }
            column(col1Programme;col1Programme)
            {
            }
            column(col2Faculty;col2Faculty)
            {
            }
            column(col2Programme;col2Programme)
            {
            }
            column(col1Names;col1Names)
            {
            }
            column(col2Names;col2Names)
            {
            }
            column(col1Bal;col1Bal)
            {
            }
            column(col2Bal;col2Bal)
            {
            }
            column(i;i)
            {
            }
            column(j;j)
            {
            }
            column(i_Control1102760013;i)
            {
            }
            column(j_Control1102760014;j)
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
                j:=j+1;

                if recCustomer.Get("ACA-Course Registration"."Student No.") then
                begin
                  txtNames:=UpperCase(recCustomer.Name);
                  recCustomer.CalcFields(recCustomer."Balance (LCY)");
                  bal:=recCustomer."Balance (LCY)";
                end;

                if (bal>0)and(j<studCount) then
                begin
                  CurrReport.Skip;
                end
                else
                begin
                i:=i+1;

                col2StudNo:='';
                col2Programme:='';
                col2Faculty:='';
                col2Names:='';
                col2Bal:=0;

                recProgramme.SetRange(recProgramme.Code,"ACA-Course Registration".Programme);
                if recProgramme.Find('-') then
                begin
                  txtProgramme:=recProgramme.Description;
                  FacultyCode:=recProgramme.Faculty;
                end;

                recFaculty.SetRange(recFaculty.Code,FacultyCode);
                if recFaculty.Find('-') then
                  txtFaculty:=recFaculty.Description;

                if i MOD 2=1 then
                begin
                  if j=studCount then
                  begin
                    col1StudNo:="ACA-Course Registration"."Student No.";
                    col1Programme:=txtProgramme;
                    col1Faculty:=txtFaculty;
                    col1Names:=txtNames;
                    col1Bal:=bal;
                  end
                  else
                  begin
                    col1StudNo:="ACA-Course Registration"."Student No.";
                    col1Programme:=txtProgramme;
                    col1Faculty:=txtFaculty;
                    col1Names:=txtNames;
                    col1Bal:=bal;
                    CurrReport.Skip;
                  end;
                end
                else
                begin
                if bal<=0 then
                begin
                  col2StudNo:="ACA-Course Registration"."Student No.";
                  col2Programme:=txtProgramme;
                  col2Faculty:=txtFaculty;
                  col2Names:=txtNames;
                  col2Bal:=bal;
                end;
                end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                studCount:="ACA-Course Registration".Count;
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
        col1StudNo: Code[15];
        col1Programme: Text[100];
        col1Faculty: Text[100];
        col1Names: Text[50];
        col1Bal: Decimal;
        col2StudNo: Code[15];
        col2Programme: Text[100];
        col2Faculty: Text[100];
        col2Names: Text[50];
        col2Bal: Decimal;
        i: Integer;
        j: Integer;
        studCount: Integer;
        recProgramme: Record UnknownRecord61511;
        txtProgramme: Text[100];
        recFaculty: Record UnknownRecord61587;
        txtFaculty: Text[100];
        FacultyCode: Code[10];
        txtNames: Text[50];
        recCustomer: Record Customer;
        bal: Decimal;
}


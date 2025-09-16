#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65207 "Lect Class Attendance List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lect Class Attendance List.rdlc';

    dataset
    {
        dataitem(UnknownTable65202;UnknownTable65202)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,Lecturer) order(ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = Semester,Lecturer,Programme,Stage,Unit;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(progName;progName)
            {
            }
            column(faculty;ACAProgramme.Faculty)
            {
            }
            column(LectName;LectName)
            {
            }
            column(Programme;"ACA-Lecturers Units".Programme)
            {
            }
            column(UnitsStage;"ACA-Lecturers Units".Stage)
            {
            }
            column(UnitCode;"ACA-Lecturers Units".Unit)
            {
            }
            column(UnitDesc;"ACA-Lecturers Units".Description)
            {
            }
            column(Semester;"ACA-Lecturers Units".Semester)
            {
            }
            column(LectCode;"ACA-Lecturers Units".Lecturer)
            {
            }
            column(MarksSubmitted;"ACA-Lecturers Units"."Marks Submitted")
            {
            }
            column(RegStudents;"ACA-Lecturers Units"."Registered Students")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone1;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompPage;CompanyInformation."Home Page")
            {
            }
            column(CompPin;CompanyInformation."Company P.I.N")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompRegNo;CompanyInformation."Registration No.")
            {
            }
            column(GroupingConcortion;"ACA-Lecturers Units".Programme+"ACA-Lecturers Units".Lecturer+"ACA-Lecturers Units".Semester+"ACA-Lecturers Units".Unit)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = Semester=field(Semester),Unit=field(Unit);
                DataItemTableView = sorting("Student No.",Unit) order(ascending);
                column(ReportForNavId_1000000009; 1000000009)
                {
                }
                column(studNo;"ACA-Student Units"."Student No.")
                {
                }
                column(StudName;StudName)
                {
                }
                column(seq;seq)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(StudName);
                    if Customer.Get("ACA-Student Units"."Student No.") then
                    StudName:=Customer.Name;

                    seq:=seq+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(seq);
                Clear(LectName);
                if HRMEmployeeC.Get("ACA-Lecturers Units".Lecturer) then
                  LectName:=HRMEmployeeC.Initials+' '+HRMEmployeeC."Last Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."First Name";

                Clear(progName);
                if ACAProgramme.Get("ACA-Lecturers Units".Programme) then progName:=ACAProgramme.Description;
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

    trigger OnInitReport()
    begin
        if CompanyInformation.Get() then
          CompanyInformation.CalcFields(CompanyInformation.Picture);
        Clear(Gtoto);
        Clear(seq);
    end;

    var
        CompanyInformation: Record "Company Information";
        Gtoto: Decimal;
        seq: Integer;
        StudName: Code[150];
        Customer: Record Customer;
        HRMEmployeeC: Record UnknownRecord61188;
        LectName: Text[220];
        progName: Code[150];
        ACAProgramme: Record UnknownRecord61511;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69273 "Lecturer Appointment Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Appointment Letter.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000004; 1000000004)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(seq;seq)
            {
            }
            column(comp;'KARATINA UNIVERSITY')
            {
            }
            column(tittle;'LECTURER APPOINTMENT LETTER')
            {
            }
            column(CompName;info.Name)
            {
            }
            column(CompAddress;info.Address)
            {
            }
            column(CompPhone;info."Phone No.")
            {
            }
            column(CompMail;info."E-Mail")
            {
            }
            column(CompHomePage;info."Home Page")
            {
            }
            column(EmpNo;"HRM-Employee C"."No.")
            {
            }
            column(EmpName;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(bonapettie;'***************************************** BON APETTIE *****************************************')
            {
            }
            dataitem(UnknownTable61541;UnknownTable61541)
            {
                DataItemLink = Lecturer=field("No.");
                column(ReportForNavId_1; 1)
                {
                }
                column("Program";"ACA-Lecturers Units - Old".Programme)
                {
                }
                column(Stage;"ACA-Lecturers Units - Old".Stage)
                {
                }
                column(UnitCode;"ACA-Lecturers Units - Old".Unit)
                {
                }
                column(UnitName;"ACA-Lecturers Units - Old".Description)
                {
                }
                column(Sem;"ACA-Lecturers Units - Old".Semester)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                 seq:=seq+1;
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
          DateFilter:=Today;
    end;

    trigger OnPreReport()
    begin
          info.Reset;
          if info.Find('-') then begin
          info.CalcFields(info.Picture);
          end;
          Clear(seq);
    end;

    var
        DateFilter: Date;
        CafeSections: Option " ",Students,Staff;
        info: Record "Company Information";
        seq: Integer;
}


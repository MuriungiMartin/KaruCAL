#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51862 "Student Applications Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Applications Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            RequestFilterFields = "Settlement Type",Date;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;"ACA-Applic. Form Header"."Application No.")
            {
            }
            column(Date;"ACA-Applic. Form Header".Date)
            {
            }
            column(regno;"ACA-Applic. Form Header"."Admission No")
            {
            }
            column(Name;"ACA-Applic. Form Header".Surname+' '+"ACA-Applic. Form Header"."Other Names")
            {
            }
            column(sur;"ACA-Applic. Form Header"."Other Names")
            {
            }
            column(dob;"ACA-Applic. Form Header"."Date Of Birth")
            {
            }
            column(gender;"ACA-Applic. Form Header".Gender)
            {
            }
            column(address;"ACA-Applic. Form Header"."Address for Correspondence1"+' '+"ACA-Applic. Form Header"."Address for Correspondence2")
            {
            }
            column(n;"ACA-Applic. Form Header"."Address for Correspondence2")
            {
            }
            column(phone;"ACA-Applic. Form Header"."Telephone No. 1")
            {
            }
            column(degree;"ACA-Applic. Form Header"."First Degree Choice")
            {
            }
            column(picture;CI.Picture)
            {
            }
            column(Campus;"ACA-Applic. Form Header".Campus)
            {
            }
            column(Semester;"ACA-Applic. Form Header"."First Choice Semester")
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(Status;"ACA-Applic. Form Header".Status)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ProgName:='';
                if prog.Get("First Degree Choice")then
                  begin
                    ProgName:=prog.Description;
                    end;
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

    trigger OnPreReport()
    begin
                       CI.Get();
                       CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        prog: Record UnknownRecord61511;
        ProgName: Text[100];
}


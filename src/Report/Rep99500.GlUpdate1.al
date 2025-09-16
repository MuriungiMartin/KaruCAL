#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99500 "G/l Update 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Gl Update 1.rdlc';

    dataset
    {
        dataitem(GlEntry;"G/L Entry")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                gl1.Reset;
                //gl1.SETRANGE("Entry No.", GlEntry."Entry No.");
                 gl1.SetRange("Document No.",GlEntry."Document No.");
                 //gl1.SETRANGE("G/L Account No.",GlEntry."G/L Account No.");

                 if gl1.Find('-') then begin
                  repeat
                   // gl1.CALCFIELDS("Count Doc No");
                    if gl1."Count Doc No"<>0 then begin
                      //ERROR('%1%2%3', gl1."Count Doc No",'for document no',gl1."Document No.");
                          gl1.Available:= gl1."Count Doc No";
                       gl1.Modify;

                       end;

                    until gl1.Next=0;
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

    var
        gl1: Record "G/L Entry";
        Gl2: Record "G/L Entry";
}


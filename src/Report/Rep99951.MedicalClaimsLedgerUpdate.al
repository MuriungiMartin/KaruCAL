#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99951 "Medical Claims Ledger Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Medical Claims Ledger Update.rdlc';

    dataset
    {
        dataitem(MClaim;UnknownTable90022)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Mclaim1.Reset;
                Mclaim1.SetRange("Document No.", MClaim."Document No.");
                Mclaim1.SetRange(Mclaim1."Staff No.",MClaim."Staff No.");
                if Mclaim1.Find('-') then begin
                  repeat
                    if Mclaim1."Staff No."<>'0001' then begin
                      Mclaim1."Staff No.":= 'MED'+MClaim."Staff No.";
                      Mclaim1.Modify;
                      end;
                //    Mclaim2.RESET;
                //    Mclaim2.SETRANGE("Document No.", Mclaim1."Document No.");
                //    Mclaim2.SETRANGE("Staff No.",Mclaim1."Staff No.");
                //    IF Mclaim2.FIND('-') THEN BEGIN
                //      Mclaim2."Staff No.":= 'MED'+Mclaim1."Staff No.";
                //      Mclaim2.MODIFY;
                //      END;
                  until Mclaim1.Next=0;
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
        Mclaim1: Record UnknownRecord90022;
        Mclaim2: Record UnknownRecord90022;
}


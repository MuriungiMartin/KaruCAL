#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51017 "Detail delete"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detail delete.rdlc';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = where("Customer No."=filter('AST/1694/12'));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(DocNo;"Detailed Cust. Ledg. Entry"."Document No.")
            {
            }
            column(No;"Detailed Cust. Ledg. Entry"."Customer No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*Detail.RESET;
                Detail.SETRANGE(Detail."Document No.","Detailed Cust. Ledg. Entry"."Document No.");
                IF Detail.FIND('-') THEN BEGIN
                "Detailed Cust. Ledg. Entry".DELETE;
                "Detailed Cust. Ledg. Entry".MODIFY;
                END;
                 */
                 glentry.Reset;
                 //glentry.SETRANGE(glentry."Entry No.","Detailed Cust. Ledg. Entry"."Entry No.");
                 glentry.SetRange(glentry."Bal. Account No.","Detailed Cust. Ledg. Entry"."Customer No.");
                 glentry.SetRange(glentry."Document No.","Detailed Cust. Ledg. Entry"."Document No.");
                 if glentry.Find('-') then begin
                 "Detailed Cust. Ledg. Entry".Amount:=glentry.Amount;
                 "Detailed Cust. Ledg. Entry".Modify;
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
        Detail: Record "Detailed Cust. Ledg. Entry";
        glentry: Record "G/L Entry";
}


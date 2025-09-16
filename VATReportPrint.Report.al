#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 740 "VAT Report Print"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Report Print.rdlc';
    Caption = 'Tax Report Print';

    dataset
    {
        dataitem("VAT Report Header";"VAT Report Header")
        {
            column(ReportForNavId_5644; 5644)
            {
            }
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
        Error('');
    end;
}


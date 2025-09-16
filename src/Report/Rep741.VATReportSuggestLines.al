#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 741 "VAT Report Suggest Lines"
{
    Caption = 'Tax Report Suggest Lines';
    ProcessingOnly = true;

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
}


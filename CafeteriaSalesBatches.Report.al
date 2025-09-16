#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99427 "Cafeteria Sales Batches"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cafeteria Sales Batches.rdlc';

    dataset
    {
        dataitem(Cbatch;"Cafeteria Sales Batches")
        {
            DataItemTableView = where("Batch Status"=filter(<>Posted));
            RequestFilterFields = User_Id,Batch_Date;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Batch.Reset;
                Batch.SetRange(User_Id, Cbatch.User_Id);
                Batch.SetRange(Batch_Date,Cbatch.Batch_Date);
                if Batch.Find('-') then begin
                repeat
                  POSSalesHeader.PostReceiptToJournal(Batch);
                  until Batch.Next=0;
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
        POSSalesHeader: Record "POS Sales Header";
        Batch: Record "Cafeteria Sales Batches";
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99433 "Update Pesa Flow Transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Pesa Flow Transactions.rdlc';

    dataset
    {
        dataitem(CoreBankingDet;Core_Banking_Details)
        {
            DataItemTableView = where(Posted=filter(false),"Exists In Pesaflow"=filter(true));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CoreBankingDet.CalcFields(CoreBankingDet."Pesa Flow Stud. Ref.");
                if CoreBankingDet."Pesa Flow Stud. Ref." <> '' then begin
                  if CoreBankingDet.Rename("Statement No",Bank_Code,"Transaction Number",CoreBankingDet."Pesa Flow Stud. Ref.") then;
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
}


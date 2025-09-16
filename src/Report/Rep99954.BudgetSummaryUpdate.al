#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99954 "Budget Summary Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Budget Summary Update.rdlc';

    dataset
    {
        dataitem(FinSummary;UnknownTable77077)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                finbudget2.Reset;
                finbudget2.SetRange("Budget Name", FinSummary."Budget Name");
                finbudget2.SetRange("G/L Account No.", FinSummary."G/L Account No.");
                finbudget2.SetRange("Global Dimension 1 Code", FinSummary."Global Dimension 1 Code");
                finbudget2.SetRange("Global Dimension 2 Code", FinSummary."Global Dimension 2 Code");
                if finbudget2.Find('-') then begin
                  repeat
                  finbudget2.CalcFields(Allocation,Utilized);
                  finbudget2.Balance:= finbudget2.Allocation-finbudget2.Utilized;
                  finbudget2.Modify;
                  until finbudget2.Next=0;
                  end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Updated');
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
        finbudget2: Record UnknownRecord77077;
}


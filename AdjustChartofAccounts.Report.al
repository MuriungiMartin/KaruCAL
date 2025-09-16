#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50000 "Adjust Chart of Accounts"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = where("Account Type"=filter(<>Posting));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(acName);
                acName:="G/L Account".Name;
                if acName<>'' then begin
                  "G/L Account".Name:=acName;
                  "G/L Account".Modify;
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
        acName: Code[200];
}


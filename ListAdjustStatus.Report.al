#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77747 "List Adjust Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/List Adjust Status.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Nos;Customer."No.")
            {
            }
            column(Names;Customer.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (StrLen(Customer."No."))>3 then begin
                if ((CopyStr(Customer."No.",((StrLen(Customer."No."))-2),3)) in ['/07','/08','/09','/10','/11','/12','/13','/14','007','008','009','010','011','012','013','014']) then begin
                  Customer.Status:=Customer.Status::Alumni;
                  Customer.Modify;
                  end;
                  end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done!');
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


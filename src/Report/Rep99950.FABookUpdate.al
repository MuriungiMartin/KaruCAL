#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99950 "FA Book Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FA Book Update.rdlc';

    dataset
    {
        dataitem(faledger;"FA Ledger Entry")
        {
            RequestFilterFields = "FA Posting Group","FA No.","Posting Date";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                faledger2.Reset;
                faledger2.SetRange(faledger2."Document No.",faledger."Document No.");
                faledger2.SetRange(faledger2."FA No.", faledger."FA No.");
                if faledger2.Find('-') then begin
                  repeat
                    fabook2.Reset;
                    fabook2.SetRange(fabook2."FA No.", faledger2."FA No.");
                    if fabook2.Find('-') then begin
                      if fabook2."Acquisition Date"=0D then
                        fabook2."Acquisition Date":= faledger2."Posting Date";
                      fabook2.Modify;
                      end;
                    until faledger2.Next=0;

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
        fabook2: Record "FA Depreciation Book";
        faledger2: Record "FA Ledger Entry";
}


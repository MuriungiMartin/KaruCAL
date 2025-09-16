#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51196 "In-bound Mails"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/In-bound Mails.rdlc';

    dataset
    {
        dataitem(UnknownTable61635;UnknownTable61635)
        {
            DataItemTableView = where("Direction Type"=filter("Incoming Mail (Internal)"|"Incoming Mail (External)"));
            column(ReportForNavId_1; 1)
            {
            }
            column(no;"REG-Mail Register".No)
            {
            }
            column(subjDoc;"REG-Mail Register"."Subject of Doc.")
            {
            }
            column(maildate;"REG-Mail Register"."Mail Date")
            {
            }
            column(address;"REG-Mail Register".Addressee)
            {
            }
            column(mailtime;"REG-Mail Register"."mail Time")
            {
            }
            column(rec;"REG-Mail Register".Receiver)
            {
            }
            column(addtype;"REG-Mail Register"."Addresee Type")
            {
            }
            column(comment;"REG-Mail Register".Comments)
            {
            }
            column(doctype;"REG-Mail Register"."Doc type")
            {
            }
            column(dispBy;"REG-Mail Register"."Dispatched by")
            {
            }
            column(email;"REG-Mail Register".Email)
            {
            }
            column(ref;"REG-Mail Register"."Doc Ref No.")
            {
            }
            column(delBy;"REG-Mail Register"."Delivered By (Mail)")
            {
            }
            column(DelPhone;"REG-Mail Register"."Delivered By (Phone)")
            {
            }
            column(DelName;"REG-Mail Register"."Delivered By (Name)")
            {
            }
            column(DelID;"REG-Mail Register"."Delivered By (ID)")
            {
            }
            column(DelTown;"REG-Mail Register"."Delivered By (Town)")
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


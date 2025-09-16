#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50049 "ACA-Marketing Strategy"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Marketing Strategy.rdlc';

    dataset
    {
        dataitem(UnknownTable61648;UnknownTable61648)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(mktDesc_desc;"ACA-Marketing Strategies".Code+': '+"ACA-Marketing Strategies".Description)
            {
            }
            dataitem(UnknownTable61348;UnknownTable61348)
            {
                DataItemLink = "How You knew about us"=field(Code);
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(No;"ACA-Enquiry Header"."Enquiry No.")
                {
                }
                column(Date;"ACA-Enquiry Header"."Enquiry Date")
                {
                }
                column(SName;"ACA-Enquiry Header".Surname)
                {
                }
                column(ONames;"ACA-Enquiry Header"."Other Names")
                {
                }
                column(Programme;"ACA-Enquiry Header".Programme)
                {
                }
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


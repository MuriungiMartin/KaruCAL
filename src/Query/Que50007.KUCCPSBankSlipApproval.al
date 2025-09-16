#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50007 "KUCCPS BankSlip_Approval"
{

    elements
    {
        dataitem(KuucpsImpoz;UnknownTable70082)
        {
            DataItemTableFilter = "Medical Doc Verified"=filter(Yes),Processed=filter(No),"Result Slip Verified"=filter(Yes),"Bank Slip Verified"=filter(No);
            column(ser;ser)
            {
            }
            column(Index;Index)
            {
            }
            column(Admin;Admin)
            {
            }
            column(Prog;Prog)
            {
            }
            column(Names;Names)
            {
            }
            column(Gender;Gender)
            {
            }
            column(Phone;Phone)
            {
            }
            column(Alt_Phone;"Alt. Phone")
            {
            }
            column(Bank_Slip_Uploaded;"Bank Slip Uploaded")
            {
            }
            column(Bank_Slip_Verified;"Bank Slip Verified")
            {
            }
            column(Bank_Slip_Url;"Bank Slip Url")
            {
            }
        }
    }
}


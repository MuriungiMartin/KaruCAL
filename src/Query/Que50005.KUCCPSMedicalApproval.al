#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50005 "KUCCPS Medical_Approval"
{

    elements
    {
        dataitem(KuucpsImpoz;UnknownTable70082)
        {
            DataItemTableFilter = "Medical Doc Verified"=filter(No),Processed=filter(No);
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
            column(Medical_Doc_Uploaded;"Medical Doc Uploaded")
            {
            }
            column(Medical_Doc_Verified;"Medical Doc Verified")
            {
            }
            column(Medical_Url;"Medical Url")
            {
            }
        }
    }
}


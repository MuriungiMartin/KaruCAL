#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51028 "Population Analy. (Gend/Type)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Population Analy. (GendType).rdlc';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = where("Dimension Code"=filter('SCHOOL'));
            PrintOnlyIfDetail = false;
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            column(Dim_Name;"Dimension Value".Code+' '+"Dimension Value".Name)
            {
            }
            dataitem(UnknownTable61511;UnknownTable61511)
            {
                DataItemLink = "School Code"=field(Code);
                column(ReportForNavId_1000000002; 1000000002)
                {
                }
                column(Desc;"ACA-Programme".Description)
                {
                }
                column(JabMAle;"ACA-Programme"."Total JAB Male")
                {
                }
                column(JabFemale;"ACA-Programme"."Total JAB Female")
                {
                }
                column(sspMale;"ACA-Programme"."Total SSP Male")
                {
                }
                column(sspFemale;"ACA-Programme"."Total SSP Female")
                {
                }
                column(StudRegistered;"ACA-Programme"."Student Registered")
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


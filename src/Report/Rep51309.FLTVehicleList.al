#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51309 "FLT Vehicle List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT Vehicle List.rdlc';

    dataset
    {
        dataitem(UnknownTable61816;UnknownTable61816)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Asset_No;"FLT-Vehicle Header"."No.")
            {
            }
            column(Reg_No;"FLT-Vehicle Header"."Registration No.")
            {
            }
            column(Desc;"FLT-Vehicle Header".Description)
            {
            }
            column(Make;"FLT-Vehicle Header".Make)
            {
            }
            column(Model;"FLT-Vehicle Header".Model)
            {
            }
            column(ManYear;"FLT-Vehicle Header"."Year Of Manufacture")
            {
            }
            column(Chasis;"FLT-Vehicle Header"."Chassis Serial No.")
            {
            }
            column(engineNo;"FLT-Vehicle Header"."Engine Serial No.")
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


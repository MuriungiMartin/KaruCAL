#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51003 "Hostels Allocation Buffer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostels Allocation Buffer.rdlc';

    dataset
    {
        dataitem(UnknownTable61000;UnknownTable61000)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudentNo_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Bank Account No.")
            {
            }
            column(StudentName_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Statement No.")
            {
            }
            column(Gender_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Statement Line No.")
            {
            }
            column(HostelNo_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Document No.")
            {
            }
            column(RoomNo_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Transaction Date")
            {
            }
            column(SpaceNo_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines".Description)
            {
            }
            column(HostelName_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Statement Amount")
            {
            }
            column(Amount_RoomAllocationBuffer;"FIN-Bank A/C Stmt Lines"."Applied Amount")
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


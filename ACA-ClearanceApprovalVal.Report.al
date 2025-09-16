#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51749 "ACA-Clearance Approval Val"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61758;UnknownTable61758)
        {
            DataItemTableView = where("Priority Level"=filter("Final level"),Status=filter(Created));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    "ACA-Clearance Approval Entries".Status:="ACA-Clearance Approval Entries".Status::Open;
                    "ACA-Clearance Approval Entries".Modify;
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


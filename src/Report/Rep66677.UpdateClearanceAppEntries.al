#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66677 "Update Clearance App. Entries"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61758;UnknownTable61758)
        {
            DataItemTableView = where("Clearance Level Code"=filter(FINANCE));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // // ACAClearanceApprovalEntries.RESET;
                // // ACAClearanceApprovalEntries.SETFILTER("Clearance Level Code",'<>%1','FINANCE');
                // // ACAClearanceApprovalEntries.SETFILTER(Status,'%1',ACAClearanceApprovalEntries.Status::Open);
                // // ACAClearanceApprovalEntries.SETFILTER(Semester,'%1',"ACA-Clearance Approval Entries".Semester);
                // // ACAClearanceApprovalEntries.SETFILTER("Student ID",'%1',"ACA-Clearance Approval Entries"."Student ID");
                // // ACAClearanceApprovalEntries.SETFILTER("Academic Year",'%1',"ACA-Clearance Approval Entries"."Academic Year");
                // // IF ACAClearanceApprovalEntries.FIND('-') THEN BEGIN
                // // "ACA-Clearance Approval Entries".Status :="ACA-Clearance Approval Entries".Status::Created;
                // //  "ACA-Clearance Approval Entries".MODIFY;
                // //  END;

                  "ACA-Clearance Approval Entries"."Priority Level" :="ACA-Clearance Approval Entries"."priority level"::Finance;
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

    var
        ACAClearanceApprovalEntries: Record UnknownRecord61758;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5182 "Delete Opportunities"
{
    Caption = 'Delete Opportunities';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Opportunity;Opportunity)
        {
            DataItemTableView = where(Closed=const(true));
            RequestFilterFields = "No.","Date Closed","Salesperson Code","Campaign No.","Contact No.","Sales Cycle Code";
            column(ReportForNavId_9773; 9773)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RMCommentLine.SetRange("Table Name",RMCommentLine."table name"::Opportunity);
                RMCommentLine.SetRange("No.","No.");
                RMCommentLine.DeleteAll;

                OppEntry.SetRange("Opportunity No.","No.");
                OppEntry.DeleteAll;

                Delete;
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
        RMCommentLine: Record "Rlshp. Mgt. Comment Line";
        OppEntry: Record "Opportunity Entry";
}


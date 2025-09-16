#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5179 "Delete Sales Quote Versions"
{
    Caption = 'Delete Archived Sales Quote Versions';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Header Archive";"Sales Header Archive")
        {
            DataItemTableView = sorting("Document Type","No.","Doc. No. Occurrence","Version No.") where("Document Type"=const(Quote),"Interaction Exist"=const(false));
            RequestFilterFields = "No.","Date Archived","Sell-to Customer No.";
            column(ReportForNavId_3260; 3260)
            {
            }

            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.SetRange("Document Type",SalesHeader."document type"::Quote);
                SalesHeader.SetRange("No.","No.");
                SalesHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                if not SalesHeader.FindFirst then
                  Delete(true);
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

    trigger OnPostReport()
    begin
        Message(Text000);
    end;

    var
        Text000: label 'Archived versions deleted.';
}


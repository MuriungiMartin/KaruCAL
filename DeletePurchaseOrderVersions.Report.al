#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5178 "Delete Purchase Order Versions"
{
    Caption = 'Delete Archived Purchase Order Versions';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Purchase Header Archive";"Purchase Header Archive")
        {
            DataItemTableView = sorting("Document Type","No.","Doc. No. Occurrence","Version No.") where("Document Type"=const(Order),"Interaction Exist"=const(false));
            RequestFilterFields = "No.","Date Archived","Buy-from Vendor No.";
            column(ReportForNavId_6075; 6075)
            {
            }

            trigger OnAfterGetRecord()
            var
                PurchHeader: Record "Purchase Header";
            begin
                PurchHeader.SetRange("Document Type",PurchHeader."document type"::Order);
                PurchHeader.SetRange("No.","No.");
                PurchHeader.SetRange("Doc. No. Occurrence","Doc. No. Occurrence");
                if not PurchHeader.FindFirst then
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


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 84 "Update Analysis Views"
{
    Caption = 'Update Analysis Views';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Analysis View";"Analysis View")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_3400; 3400)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not Blocked then
                  UpdateAnalysisView.Update("Analysis View",2,true)
                else
                  BlockedOccured := true;
            end;

            trigger OnPostDataItem()
            begin
                if BlockedOccured then
                  Message(Text000)
                else
                  Message(Text001);
            end;

            trigger OnPreDataItem()
            begin
                LockTable;
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
        UpdateAnalysisView: Codeunit "Update Analysis View";
        Text000: label 'One or more of the selected Analysis Views is Blocked, and could not be updated.';
        BlockedOccured: Boolean;
        Text001: label 'All selected Analysis Views were updated successfully.';
}


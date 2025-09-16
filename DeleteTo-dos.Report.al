#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5188 "Delete To-dos"
{
    Caption = 'Delete To-dos';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("To-do";"To-do")
        {
            DataItemTableView = where(Canceled=const(true),"System To-do Type"=filter(Organizer|Team));
            RequestFilterFields = "No.",Date,"Salesperson Code","Team Code","Campaign No.","Contact No.";
            column(ReportForNavId_6499; 6499)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Team Code" = '') or ("System To-do Type" = "system to-do type"::Team) then
                  Delete(true)
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


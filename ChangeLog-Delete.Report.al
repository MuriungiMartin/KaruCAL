#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 510 "Change Log - Delete"
{
    Caption = 'Change Log - Delete';
    Permissions = TableData "Change Log Entry"=rid;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Change Log Entry";"Change Log Entry")
        {
            DataItemTableView = sorting("Table No.","Primary Key Field 1 Value");
            RequestFilterFields = "Date and Time","Table No.";
            column(ReportForNavId_1204; 1204)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Delete;
                EntriesDeleted := EntriesDeleted + 1;
            end;

            trigger OnPostDataItem()
            begin
                Message(Text003,EntriesDeleted);
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

    trigger OnPreReport()
    var
        ChangeLogEntry: Record "Change Log Entry";
    begin
        if "Change Log Entry".GetFilter("Date and Time") <> '' then begin
          ChangeLogEntry.CopyFilters("Change Log Entry");
          if ChangeLogEntry.FindLast then
            if Dt2Date(ChangeLogEntry."Date and Time") > CalcDate('<-1Y>',Today) then
              if not Confirm(Text002,false) then
                CurrReport.Quit;
        end else
          if not Confirm(Text001,false) then
            CurrReport.Quit;
    end;

    var
        Text001: label 'You have not defined a date filter. Do you want to continue?';
        Text002: label 'Your date filter allows deletion of entries that are less than one year old. Do you want to continue?';
        EntriesDeleted: Integer;
        Text003: label '%1 entries were deleted.';
}


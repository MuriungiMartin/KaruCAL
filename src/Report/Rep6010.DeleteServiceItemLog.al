#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6010 "Delete Service Item Log"
{
    Caption = 'Delete Service Item Log';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Item Log";"Service Item Log")
        {
            DataItemTableView = sorting("Change Date");
            RequestFilterFields = "Change Date","Service Item No.";
            column(ReportForNavId_2683; 2683)
            {
            }

            trigger OnPostDataItem()
            begin
                if CounterTotal > 1 then
                  Message(Text004,CounterTotal)
                else
                  Message(Text005,CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                CounterTotal := Count;
                if CounterTotal = 0 then begin
                  Message(Text000);
                  CurrReport.Break;
                end;
                if not Confirm(StrSubstNo(Text001,CounterTotal,TableCaption),false) then
                  Error(Text003);

                DeleteAll;
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
        Text000: label 'There is nothing to delete.';
        Text001: label '%1 %2 records will be deleted.\\Do you want to continue?', Comment='10 Service Item Log  record(s) will be deleted.\\Do you want to continue?';
        Text003: label 'No records were deleted.';
        Text004: label '%1 records were deleted.';
        Text005: label '%1 record was deleted.';
        CounterTotal: Integer;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1141 "Delete Old Cost Entries"
{
    Caption = 'Delete Old Cost Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(YearEndingDate;YearEndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Year Ending Date';

                    trigger OnValidate()
                    begin
                        if YearEndDate <> CalcDate('<CY>',YearEndDate) then
                          Error(Text001,YearEndDate);

                        if WorkDate - YearEndDate < 365 then
                          Error(Text002,YearEndDate);

                        if not Confirm(Text003,false,YearEndDate) then
                          exit;

                        CostEntry.SetCurrentkey("Cost Type No.","Posting Date");
                        CostEntry.SetRange("Posting Date",0D,YearEndDate);
                        if not CostEntry.IsEmpty then begin
                          CostEntry.DeleteAll;
                          Message(Text004,YearEndDate);
                        end else
                          Error(Text005,YearEndDate);
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CostEntry: Record "Cost Entry";
        YearEndDate: Date;
        Text001: label '%1 is not at year''s end.';
        Text002: label 'The selected year ending date %1 must be older than last year.';
        Text003: label 'Are you sure you want to delete all cost entries up to and including %1?';
        Text004: label 'All cost entries up to and including %1 deleted.';
        Text005: label 'No cost entries were found before %1.';
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5686 "Cancel FA Entries"
{
    Caption = 'Cancel FA Entries';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UseNewPosting;UseNewPosting)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use New Posting Date';
                        ToolTip = 'Specifies that a new posting date is applied to the journal entries created by the batch job. If the field is cleared, the posting date of the fixed asset ledger entries to be canceled is copied to the journal entries that the batch job creates.';
                    }
                    field(NewPostingDate;NewPostingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'New Posting Date';
                        ToolTip = 'Specifies the posting date to be applied to the journal entries created by the batch job when the Use New Posting Date field is selected.';
                    }
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

    trigger OnPreReport()
    begin
        if UseNewPosting then
          if NewPostingDate = 0D then
            Error(Text000);
        if not UseNewPosting then
          if NewPostingDate > 0D then
            Error(Text001);
        if NewPostingDate > 0D then
          if NormalDate(NewPostingDate) <> NewPostingDate then
            Error(Text002);

        CancelFALedgEntries.TransferLine(FALedgEntry,false,NewPostingDate);
    end;

    var
        Text000: label 'You must specify New Posting Date.';
        Text001: label 'You must not specify New Posting Date.';
        Text002: label 'You must not specify a closing date.';
        FALedgEntry: Record "FA Ledger Entry";
        CancelFALedgEntries: Codeunit "Cancel FA Ledger Entries";
        UseNewPosting: Boolean;
        NewPostingDate: Date;


    procedure GetFALedgEntry(var FALedgEntry2: Record "FA Ledger Entry")
    begin
        FALedgEntry.Copy(FALedgEntry2);
    end;
}


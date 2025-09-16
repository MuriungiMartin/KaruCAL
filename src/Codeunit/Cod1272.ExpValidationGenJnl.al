#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1272 "Exp. Validation Gen. Jnl."
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        DeletePaymentFileBatchErrors;
        DeletePaymentFileErrors;

        GenJnlLine.CopyFilters(Rec);
        if GenJnlLine.FindSet then
          repeat
            Codeunit.Run(Codeunit::"Payment Export Gen. Jnl Check",GenJnlLine);
          until GenJnlLine.Next = 0;

        if GenJnlLine.HasPaymentFileErrorsInBatch then begin
          Commit;
          Error(HasErrorsErr);
        end;
    end;

    var
        HasErrorsErr: label 'The file export has one or more errors.\\For each line to be exported, resolve the errors displayed to the right and then try to export again.';
}


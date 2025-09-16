#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1137 "Transfer Budget to Actual"
{
    Caption = 'Transfer Budget to Actual';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Cost Budget Entry";"Cost Budget Entry")
        {
            DataItemTableView = sorting("Budget Name","Cost Type No.",Date);
            RequestFilterFields = "Budget Name",Date,Allocated,"Cost Type No.","Cost Center Code","Cost Object Code";
            column(ReportForNavId_3233; 3233)
            {
            }

            trigger OnAfterGetRecord()
            var
                SourceCodeSetup: Record "Source Code Setup";
            begin
                SourceCodeSetup.Get;
                SourceCodeSetup.TestField("Transfer Budget to Actual");
                TempCostJnlLine.Init;
                LastEntryNo := LastEntryNo + 1;
                TempCostJnlLine."Line No." := LastEntryNo;
                TempCostJnlLine."Cost Type No." := "Cost Type No.";
                TempCostJnlLine."Posting Date" := Date;
                TempCostJnlLine."Document No." := "Document No.";
                if TempCostJnlLine."Document No." = '' then
                  TempCostJnlLine."Document No." := 'BUDGET';
                TempCostJnlLine.Description := Description;
                TempCostJnlLine.Amount := Amount;
                TempCostJnlLine."Cost Center Code" := "Cost Center Code";
                TempCostJnlLine."Cost Object Code" := "Cost Object Code";
                TempCostJnlLine."Source Code" := SourceCodeSetup."Transfer Budget to Actual";
                TempCostJnlLine."Allocation Description" := "Allocation Description";
                TempCostJnlLine."Allocation ID" := "Allocation ID";
                TempCostJnlLine.Insert;

                NoInserted := NoInserted + 1;
                if (NoInserted MOD 100) = 0 then
                  Window.Update(2,NoInserted);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                if not Confirm(Text004,true,NoInserted) then
                  Error('');

                PostCostJournalLines;
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Budget Name") = '' then
                  Error(Text000);

                if GetFilter(Date) = '' then
                  Error(Text001);

                if not Confirm(Text002,true,GetFilter("Budget Name"),GetFilter(Date)) then
                  Error('');

                LockTable;

                Window.Open(Text003);

                Window.Update(1,Count);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        TempCostJnlLine: Record "Cost Journal Line" temporary;
        Window: Dialog;
        LastEntryNo: Integer;
        NoInserted: Integer;
        Text000: label 'Define the name of the source budget.';
        Text001: label 'Date range must be defined.';
        Text002: label 'The cost budget "%1" for the date range of "%2" will be transferred to the actual cost entries. \Do you want to start the job?';
        Text003: label 'Copying budget entries\No of entries #1#####\Copied        #2#####';
        Text004: label '%1 budget entries were transferred to actual cost entries.\\Do you want to copy entries?';
        Text005: label 'Posting Cost Entries                 @1@@@@@@@@@@\';

    local procedure PostCostJournalLines()
    var
        CostJnlLine: Record "Cost Journal Line";
        CAJnlPostLine: Codeunit "CA Jnl.-Post Line";
        Window2: Dialog;
        JournalLineCount: Integer;
        CostJnlLineStep: Integer;
    begin
        TempCostJnlLine.Reset;
        Window2.Open(
          Text005);
        if TempCostJnlLine.Count > 0 then
          JournalLineCount := 10000 * 100000 DIV TempCostJnlLine.Count;
        if TempCostJnlLine.FindSet then
          repeat
            CostJnlLineStep := CostJnlLineStep + JournalLineCount;
            Window2.Update(1,CostJnlLineStep DIV 100000);
            CostJnlLine := TempCostJnlLine;
            CAJnlPostLine.RunWithCheck(CostJnlLine);
          until TempCostJnlLine.Next = 0;
        Window2.Close;
    end;
}


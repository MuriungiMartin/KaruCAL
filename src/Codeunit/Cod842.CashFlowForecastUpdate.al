#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 842 "Cash Flow Forecast Update"
{

    trigger OnRun()
    var
        CashFlowSetup: Record "Cash Flow Setup";
        CashFlowManagement: Codeunit "Cash Flow Management";
        OriginalWorkDate: Date;
    begin
        RemoveScheduledTaskIfUserInactive;

        OriginalWorkDate := WorkDate;
        WorkDate := LogInManagement.GetDefaultWorkDate;
        if CashFlowSetup.Get then
          CashFlowManagement.UpdateCashFlowForecast(CashFlowSetup."Cortana Intelligence Enabled");
        WorkDate := OriginalWorkDate;
    end;

    var
        LogInManagement: Codeunit LogInManagement;

    local procedure RemoveScheduledTaskIfUserInactive()
    var
        CashFlowManagement: Codeunit "Cash Flow Management";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
    begin
        if not LogInManagement.UserLogonExistsWithinPeriod(Periodtype::Week,2) then
          CashFlowManagement.DeleteJobQueueEntries;
    end;
}


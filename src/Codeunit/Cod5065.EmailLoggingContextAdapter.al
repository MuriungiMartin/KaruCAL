#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5065 "Email Logging Context Adapter"
{
    SingleInstance = false;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        EmailLoggingDispatcher: Codeunit "Email Logging Dispatcher";
    begin
        if not EmailLoggingDispatcher.Run(Rec) then
          Error(Text001,EmailLoggingDispatcher.GetErrorContext,GetLastErrorText);
    end;

    var
        Text001: label '%1 : %2.';
}


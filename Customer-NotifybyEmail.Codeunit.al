#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5915 "Customer-Notify by Email"
{
    TableNo = "Service Header";

    trigger OnRun()
    begin
        ServHeader := Rec;
        NotifyByEMailWhenServiceIsDone;
        Rec := ServHeader;
    end;

    var
        Text000: label 'We have finished carrying out service order %1.';
        Text001: label 'You can collect your serviced items when it is convenient for you.';
        Text002: label 'The customer will be notified as requested because service order %1 is now %2.';
        ServHeader: Record "Service Header";

    local procedure NotifyByEMailWhenServiceIsDone()
    var
        ServEmailQueue: Record "Service Email Queue";
    begin
        if ServHeader."Notify Customer" <> ServHeader."notify customer"::"By Email" then
          exit;

        ServEmailQueue.Init;
        if ServHeader."Ship-to Code" <> '' then
          ServEmailQueue."To Address" := ServHeader."Ship-to E-Mail";
        if ServEmailQueue."To Address" = '' then
          ServEmailQueue."To Address" := ServHeader."E-Mail";
        if ServEmailQueue."To Address" = '' then
          exit;

        ServEmailQueue."Copy-to Address" := '';
        ServEmailQueue."Subject Line" := StrSubstNo(Text000,ServHeader."No.");
        ServEmailQueue."Body Line" := Text001;
        ServEmailQueue."Attachment Filename" := '';
        ServEmailQueue."Document Type" := ServEmailQueue."document type"::"Service Order";
        ServEmailQueue."Document No." := ServHeader."No.";
        ServEmailQueue.Status := ServEmailQueue.Status::" ";
        ServEmailQueue.Insert(true);
        ServEmailQueue.ScheduleInJobQueue;
        Message(
          Text002,
          ServHeader."No.",ServHeader.Status);
    end;
}


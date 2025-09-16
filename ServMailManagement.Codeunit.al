#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5916 ServMailManagement
{
    TableNo = "Service Email Queue";

    trigger OnRun()
    begin
        Clear(Mail);
        if not Mail.NewMessage(
             "To Address",
             "Copy-to Address",
             '',
             "Subject Line",
             "Body Line",
             "Attachment Filename",
             false)
        then
          Error('');
    end;

    var
        Mail: Codeunit Mail;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1632 "Office Error Engine"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        ErrorMessage: Text;


    procedure ShowError(Message: Text)
    begin
        ErrorMessage := Message;
        Page.Run(Page::"Office Error Dlg");
    end;


    procedure GetError(): Text
    begin
        exit(ErrorMessage);
    end;
}


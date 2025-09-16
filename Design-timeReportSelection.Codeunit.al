#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9654 "Design-time Report Selection"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        SelectedCustomLayoutCode: Code[20];


    procedure SetSelectedCustomLayout(NewCustomLayoutCode: Code[20])
    begin
        SelectedCustomLayoutCode := NewCustomLayoutCode;
    end;


    procedure GetSelectedCustomLayout(): Code[20]
    begin
        exit(SelectedCustomLayoutCode);
    end;
}


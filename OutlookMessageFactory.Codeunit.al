#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9530 "Outlook Message Factory"
{
    SingleInstance = true;
    Subtype = Normal;

    trigger OnRun()
    begin
    end;

    var
        [RunOnClient]
        OutlookMessageFactory: dotnet IOutlookMessageFactory;


    procedure CreateOutlookMessage(var OutlookMessage: dotnet IOutlookMessage)
    begin
        if IsNull(OutlookMessageFactory) then
          CreateDefaultOutlookMessageFactory;
        OutlookMessage := OutlookMessageFactory.CreateOutlookMessage;
    end;


    procedure SetOutlookMessageFactory(ParmOutlookMessageFactory: dotnet IOutlookMessageFactory)
    begin
        OutlookMessageFactory := ParmOutlookMessageFactory;
    end;

    local procedure CreateDefaultOutlookMessageFactory()
    var
        [RunOnClient]
        CreateOutlookMessageFactory: dotnet OutlookMessageFactory;
    begin
        OutlookMessageFactory := CreateOutlookMessageFactory.OutlookMessageFactory;
    end;
}


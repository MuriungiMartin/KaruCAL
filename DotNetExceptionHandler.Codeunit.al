#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1291 "DotNet Exception Handler"
{

    trigger OnRun()
    begin
    end;

    var
        OuterException: dotnet Exception;


    procedure Catch(var Exception: dotnet Exception;Type: dotnet Type)
    begin
        Collect;
        if not CastToType(Exception,Type) then
          Rethrow;
    end;


    procedure Collect()
    begin
        OuterException := GetLastErrorObject;
    end;

    local procedure IsCollected(): Boolean
    begin
        exit(not IsNull(OuterException));
    end;


    procedure TryCastToType(Type: dotnet Type): Boolean
    var
        Exception: dotnet FormatException;
    begin
        exit(CastToType(Exception,Type));
    end;


    procedure CastToType(var Exception: dotnet Exception;Type: dotnet Type): Boolean
    begin
        if not IsCollected then
          exit(false);

        Exception := OuterException.GetBaseException;
        if IsNull(Exception) then
          exit(false);

        if Type.Equals(Exception.GetType) then
          exit(true);

        exit(false);
    end;


    procedure GetMessage(): Text
    var
        Exception: dotnet Exception;
    begin
        if not IsCollected then
          exit;

        Exception := OuterException.GetBaseException;
        if IsNull(Exception) then
          exit;

        exit(Exception.Message);
    end;


    procedure Rethrow()
    var
        RootCauseMessage: Text;
    begin
        RootCauseMessage := GetMessage;

        if RootCauseMessage <> '' then
          Error(RootCauseMessage);

        if IsNull(OuterException.InnerException) then
          Error(OuterException.Message);

        Error(OuterException.InnerException.Message);
    end;
}


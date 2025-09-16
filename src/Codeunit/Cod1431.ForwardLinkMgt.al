#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1431 "Forward Link Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        LanguageUrlParameterTxt: label '&clcid=0x%1', Locked=true;


    procedure GetLanguageSpecificUrl(NonLanguageSpecificURL: Text): Text
    var
        LanguageSpecificURL: Text;
    begin
        LanguageSpecificURL := NonLanguageSpecificURL + GetLanguageUrlParameter;
        exit(LanguageSpecificURL);
    end;

    local procedure GetLanguageUrlParameter(): Text
    var
        Convert: dotnet Convert;
        LanguageHexaDecimalCode: Text;
        LanguageUrlParameter: Text;
    begin
        LanguageHexaDecimalCode := Convert.ToString(GlobalLanguage,16);
        LanguageUrlParameter := StrSubstNo(LanguageUrlParameterTxt,LanguageHexaDecimalCode);
        exit(LanguageUrlParameter);
    end;
}


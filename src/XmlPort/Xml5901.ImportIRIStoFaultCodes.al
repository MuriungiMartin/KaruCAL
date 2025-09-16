#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 5901 "Import IRIS to Fault Codes"
{
    Caption = 'Import IRIS to Fault Codes';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    UseRequestPage = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Fault Code";"Fault Code")
            {
                XmlName = 'FaultCode';
                fieldelement(Code;"Fault Code".Code)
                {
                }
                fieldelement(Description;"Fault Code".Description)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    "Fault Code"."Fault Area Code" := CopyStr("Fault Code".Code,1,1);
                    "Fault Code"."Symptom Code" := CopyStr("Fault Code".Code,2,1);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}


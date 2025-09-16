#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 1660 "Import Payroll"
{
    Caption = 'Import Payroll';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Payroll Import Buffer";"Payroll Import Buffer")
            {
                XmlName = 'PayrollBuffer';
                fieldelement(PostingDate;"Payroll Import Buffer"."Transaction date")
                {
                }
                fieldelement(Account;"Payroll Import Buffer"."Account No.")
                {
                }
                fieldelement(Amount;"Payroll Import Buffer".Amount)
                {
                }
                fieldelement(Description;"Payroll Import Buffer".Description)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    I += 1;
                    "Payroll Import Buffer"."Entry No." := I;
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

    trigger OnInitXmlPort()
    begin
        I := 0;
    end;

    var
        I: Integer;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 1670 ITEMS
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
            tableelement("<item>";Item)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(No;"<item>"."No.")
                {
                }
                fieldelement(b;"<item>"."VAT Prod. Posting Group")
                {
                    MinOccurs = Once;
                }
                fieldelement(Bmeasure;"<item>"."Unit Cost")
                {
                    MinOccurs = Zero;
                }
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

    var
        I: Integer;
}


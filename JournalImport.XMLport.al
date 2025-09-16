#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50063 "Journal Import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("hr-employee";"Gen. Journal Line")
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"HR-Employee"."Line No.")
                {
                }
                fieldelement(b;"HR-Employee"."Posting Date")
                {
                }
                fieldelement(c;"HR-Employee"."Document No.")
                {
                }
                fieldelement(d;"HR-Employee"."Account Type")
                {
                }
                fieldelement(e;"HR-Employee"."Account No.")
                {
                }
                fieldelement(f;"HR-Employee".Description)
                {
                }
                fieldelement(g;"HR-Employee".Amount)
                {
                }
                fieldelement(i;"HR-Employee"."Bal. Account Type")
                {
                }
                fieldelement(h;"HR-Employee"."Bal. Account No.")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    "HR-Employee"."Journal Template Name":='GENERAL';
                    "HR-Employee"."Journal Batch Name":='DEFAULT';
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


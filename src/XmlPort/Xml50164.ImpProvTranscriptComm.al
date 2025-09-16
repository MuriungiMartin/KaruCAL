#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50164 "Imp. Prov. Transcript Comm"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable88852;UnknownTable88852)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"Provisional Transcript Comment".Code)
                {
                }
                fieldelement(b;"Provisional Transcript Comment"."Special Programme Class")
                {
                }
                fieldelement(c;"Provisional Transcript Comment"."1st Year Trans. Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"Provisional Transcript Comment"."2nd Year  Trans. Comments")
                {
                }
                fieldelement(e;"Provisional Transcript Comment"."3rd Year  Trans. Comments")
                {
                }
                fieldelement(f;"Provisional Transcript Comment"."4th Year  Trans. Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(g;"Provisional Transcript Comment"."5th Year  Trans. Comments")
                {
                }
                fieldelement(h;"Provisional Transcript Comment"."6th Year  Trans. Comments")
                {
                }
                fieldelement(i;"Provisional Transcript Comment"."7th Year  Trans. Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(j;"Provisional Transcript Comment"."Exam Category")
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
}


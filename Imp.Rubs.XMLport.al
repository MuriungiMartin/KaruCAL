#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50040 "Imp. Rubs"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61739;UnknownTable61739)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Results Status".Code)
                {
                }
                fieldelement(b;"ACA-Results Status".Description)
                {
                }
                fieldelement(c;"ACA-Results Status"."Status Msg1")
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"ACA-Results Status"."Status Msg2")
                {
                }
                fieldelement(e;"ACA-Results Status"."Status Msg3")
                {
                }
                fieldelement(f;"ACA-Results Status"."Status Msg4")
                {
                    MinOccurs = Zero;
                }
                fieldelement(g;"ACA-Results Status"."Status Msg5")
                {
                }
                fieldelement(h;"ACA-Results Status"."Order No")
                {
                }
                fieldelement(i;"ACA-Results Status"."Show Reg. Remarks")
                {
                    MinOccurs = Zero;
                }
                fieldelement(j;"ACA-Results Status"."Manual Status Processing")
                {
                }
                fieldelement(k;"ACA-Results Status".Prefix)
                {
                }
                fieldelement(l;"ACA-Results Status"."Status Msg6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(m;"ACA-Results Status"."IncludeVariable 1")
                {
                }
                fieldelement(n;"ACA-Results Status"."IncludeVariable 2")
                {
                }
                fieldelement(o;"ACA-Results Status"."IncludeVariable 3")
                {
                    MinOccurs = Zero;
                }
                fieldelement(p;"ACA-Results Status"."IncludeVariable 4")
                {
                }
                fieldelement(q;"ACA-Results Status"."IncludeVariable 5")
                {
                }
                fieldelement(r;"ACA-Results Status"."IncludeVariable 6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(s;"ACA-Results Status"."Maximum Units Failed")
                {
                }
                fieldelement(t;"ACA-Results Status".Status)
                {
                }
                fieldelement(u;"ACA-Results Status"."Summary Page Caption")
                {
                    MinOccurs = Zero;
                }
                fieldelement(v;"ACA-Results Status"."Include Failed Units Headers")
                {
                }
                fieldelement(w;"ACA-Results Status"."Fails Based on")
                {
                }
                fieldelement(x;"ACA-Results Status"."Transcript Remarks")
                {
                    MinOccurs = Zero;
                }
                fieldelement(y;"ACA-Results Status"."Final Year Comment")
                {
                }
                fieldelement(z;"ACA-Results Status"."Academic Year")
                {
                }
                fieldelement(aa;"ACA-Results Status"."Min/Max Based on")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ab;"ACA-Results Status"."Include Academic Year Caption")
                {
                }
                fieldelement(ac;"ACA-Results Status"."Academic Year Text")
                {
                }
                fieldelement(ad;"ACA-Results Status".Pass)
                {
                    MinOccurs = Zero;
                }
                fieldelement(ae;"ACA-Results Status"."Supp. Rubric Caption")
                {
                }
                fieldelement(af;"ACA-Results Status"."Supp. Rubric Caption 2")
                {
                }
                fieldelement(ag;"ACA-Results Status"."Supp. Rubric Caption 3")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ah;"ACA-Results Status"."Supp. Rubric Caption 4")
                {
                }
                fieldelement(ai;"ACA-Results Status"."Supp. Rubric Caption 5")
                {
                }
                fieldelement(aj;"ACA-Results Status"."Supp. Rubric Caption 6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ak;"ACA-Results Status"."Special Programme Class")
                {
                }
                fieldelement(al;"ACA-Results Status"."Special Programme Scope")
                {
                }
                fieldelement(am;"ACA-Results Status"."Include no. of Repeats")
                {
                }
                fieldelement(an;"ACA-Results Status"."Min. Unit Repeat Counts")
                {
                }
                fieldelement(ao;"ACA-Results Status"."Max. Unit Repeat Counts")
                {
                }
                fieldelement(ap;"ACA-Results Status"."Maximum Academic Repeat")
                {
                }
                fieldelement(aq;"ACA-Results Status"."Lead Status")
                {
                }
                fieldelement(ar;"ACA-Results Status"."Minimum Academic Repeats")
                {
                }
                fieldelement(as;"ACA-Results Status"."Minimum Core Fails")
                {
                }
                fieldelement(at;"ACA-Results Status"."1st Year Grad. Comments")
                {
                }
                fieldelement(bu;"ACA-Results Status"."2nd Year Grad. Comments")
                {
                }
                fieldelement(cv;"ACA-Results Status"."3rd Year Grad. Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(dw;"ACA-Results Status"."4th Year Grad. Comments")
                {
                }
                fieldelement(ex;"ACA-Results Status"."5th Year Grad. Comments")
                {
                }
                fieldelement(fy;"ACA-Results Status"."6th Year Grad. Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(gz;"ACA-Results Status"."Finalists Grad. Comm. Degree")
                {
                }
                fieldelement(ha;"ACA-Results Status"."Grad. Status Msg 1")
                {
                }
                fieldelement(ib;"ACA-Results Status"."Grad. Status Msg 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(jc;"ACA-Results Status"."Grad. Status Msg 3")
                {
                }
                fieldelement(kd;"ACA-Results Status"."Grad. Status Msg 4")
                {
                }
                fieldelement(le;"ACA-Results Status"."Grad. Status Msg 5")
                {
                    MinOccurs = Zero;
                }
                fieldelement(mf;"ACA-Results Status"."Grad. Status Msg 6")
                {
                }
                fieldelement(ng;"ACA-Results Status"."Supp. Status Msg1")
                {
                }
                fieldelement(oh;"ACA-Results Status"."Supp. Status Msg2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(pi;"ACA-Results Status"."Supp. Status Msg3")
                {
                }
                fieldelement(qj;"ACA-Results Status"."Supp. Status Msg4")
                {
                }
                fieldelement(rk;"ACA-Results Status"."Supp. Status Msg5")
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


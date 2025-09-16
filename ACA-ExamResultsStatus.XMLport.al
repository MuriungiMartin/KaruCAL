#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50204 "ACA-Exam Results Status"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61739;UnknownTable61739)
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Results Status".Code)
                {
                }
                fieldelement(b;"ACA-Results Status".Description)
                {
                }
                fieldelement(c;"ACA-Results Status"."Status Msg1")
                {
                }
                fieldelement(d;"ACA-Results Status"."Status Msg2")
                {
                }
                fieldelement(e;"ACA-Results Status"."Status Msg3")
                {
                }
                fieldelement(f;"ACA-Results Status"."Status Msg4")
                {
                }
                fieldelement(k;"ACA-Results Status"."Status Msg5")
                {
                }
                fieldelement(b;"ACA-Results Status"."Order No")
                {
                }
                fieldelement(c;"ACA-Results Status"."Show Reg. Remarks")
                {
                }
                fieldelement(d;"ACA-Results Status"."Manual Status Processing")
                {
                }
                fieldelement(e;"ACA-Results Status".Prefix)
                {
                }
                fieldelement(f;"ACA-Results Status"."Status Msg6")
                {
                }
                fieldelement(aa;"ACA-Results Status"."IncludeVariable 1")
                {
                }
                fieldelement(ba;"ACA-Results Status"."IncludeVariable 2")
                {
                }
                fieldelement(ca;"ACA-Results Status"."IncludeVariable 3")
                {
                }
                fieldelement(da;"ACA-Results Status"."IncludeVariable 4")
                {
                }
                fieldelement(ea;"ACA-Results Status"."IncludeVariable 5")
                {
                }
                fieldelement(fa;"ACA-Results Status"."IncludeVariable 6")
                {
                }
                fieldelement(ka;"ACA-Results Status"."Minimum Units Failed")
                {
                }
                fieldelement(ba;"ACA-Results Status"."Maximum Units Failed")
                {
                }
                fieldelement(ca;"ACA-Results Status".Status)
                {
                }
                fieldelement(da;"ACA-Results Status"."Summary Page Caption")
                {
                }
                fieldelement(ea;"ACA-Results Status"."Include Failed Units Headers")
                {
                }
                fieldelement(fa;"ACA-Results Status"."Fails Based on")
                {
                }
                fieldelement(aaa;"ACA-Results Status"."Transcript Remarks")
                {
                }
                fieldelement(baa;"ACA-Results Status"."Final Year Comment")
                {
                }
                fieldelement(caa;"ACA-Results Status"."Academic Year")
                {
                }
                fieldelement(daa;"ACA-Results Status"."Min/Max Based on")
                {
                }
                fieldelement(eaa;"ACA-Results Status"."Include Academic Year Caption")
                {
                }
                fieldelement(faa;"ACA-Results Status"."Academic Year Text")
                {
                }
                fieldelement(kaa;"ACA-Results Status".Pass)
                {
                }
                fieldelement(baa;"ACA-Results Status"."Supp. Rubric Caption")
                {
                }
                fieldelement(caa;"ACA-Results Status"."Supp. Rubric Caption 2")
                {
                }
                fieldelement(daa;"ACA-Results Status"."Supp. Rubric Caption 3")
                {
                }
                fieldelement(eaa;"ACA-Results Status"."Supp. Rubric Caption 4")
                {
                }
                fieldelement(faa;"ACA-Results Status"."Supp. Rubric Caption 5")
                {
                }
                fieldelement(aab;"ACA-Results Status"."Supp. Rubric Caption 6")
                {
                }
                fieldelement(bab;"ACA-Results Status"."Special Programme Class")
                {
                }
                fieldelement(cab;"ACA-Results Status"."Special Programme Scope")
                {
                }
                fieldelement(dab;"ACA-Results Status"."Include no. of Repeats")
                {
                }
                fieldelement(eab;"ACA-Results Status"."Min. Unit Repeat Counts")
                {
                }
                fieldelement(fab;"ACA-Results Status"."Max. Unit Repeat Counts")
                {
                }
                fieldelement(kab;"ACA-Results Status"."Maximum Academic Repeat")
                {
                }
                fieldelement(bab;"ACA-Results Status"."1st Year Grad. Comments")
                {
                }
                fieldelement(cab;"ACA-Results Status"."2nd Year Grad. Comments")
                {
                }
                fieldelement(dab;"ACA-Results Status"."3rd Year Grad. Comments")
                {
                }
                fieldelement(eab;"ACA-Results Status"."4th Year Grad. Comments")
                {
                }
                fieldelement(fab;"ACA-Results Status"."5th Year Grad. Comments")
                {
                }
                fieldelement(aac;"ACA-Results Status"."6th Year Grad. Comments")
                {
                }
                fieldelement(bac;"ACA-Results Status"."7th Year Grad. Comments")
                {
                }
                fieldelement(cac;"ACA-Results Status"."Finalists Grad. Comm. Degree")
                {
                }
                fieldelement(dac;"ACA-Results Status"."Grad. Status Msg 1")
                {
                }
                fieldelement(eac;"ACA-Results Status"."Grad. Status Msg 2")
                {
                }
                fieldelement(fac;"ACA-Results Status"."Grad. Status Msg 3")
                {
                }
                fieldelement(kac;"ACA-Results Status"."Grad. Status Msg 4")
                {
                }
                fieldelement(bac;"ACA-Results Status"."Grad. Status Msg 5")
                {
                }
                fieldelement(cac;"ACA-Results Status"."Grad. Status Msg 6")
                {
                }
                fieldelement(dac;"ACA-Results Status"."Finalists Grad. Comm. Dip")
                {
                }
                fieldelement(eac;"ACA-Results Status"."Finalists Grad. Comm. Cert.")
                {
                }
                fieldelement(fac;"ACA-Results Status"."Supp. Status Msg1")
                {
                }
                fieldelement(aad;"ACA-Results Status"."Supp. Status Msg2")
                {
                }
                fieldelement(bad;"ACA-Results Status"."Supp. Status Msg3")
                {
                }
                fieldelement(cad;"ACA-Results Status"."Supp. Status Msg4")
                {
                }
                fieldelement(dad;"ACA-Results Status"."Supp. Status Msg5")
                {
                }
                fieldelement(ead;"ACA-Results Status"."Include CF% Fail")
                {
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


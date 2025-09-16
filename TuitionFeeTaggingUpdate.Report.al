#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50700 "Tuition Fee Tagging Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Tuition Fee Tagging Update.rdlc';

    dataset
    {
        dataitem(UnknownTable90027;UnknownTable90027)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudentNo_TuitionFeeTagging;"Tuition Fee Tagging"."Student No.")
            {
            }
            column(DocumentNo_TuitionFeeTagging;"Tuition Fee Tagging"."Document No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                TuitionTagging.Reset;
                TuitionTagging.SetRange("Student No.","Tuition Fee Tagging"."Student No.");
                TuitionTagging.SetRange("Document No","Tuition Fee Tagging"."Document No");
                TuitionTagging.SetRange(Modified,false);
                if TuitionTagging.FindSet then begin
                  repeat
                    GlEntry.Reset;
                    GlEntry.SetRange("Document No.",TuitionTagging."Document No");
                    GlEntry.SetRange("G/L Account No.",TuitionTagging."G/l Tagge During Billing");
                    if GlEntry.FindSet then begin
                      GlEntry."G/L Account No.":=TuitionTagging."G/l to be Tagged";
                      GlEntry.Modify;
                      end;
                      TuitionTagging.Modified:=true;
                      TuitionTagging.Modify;
                    until TuitionTagging.Next=0;
                  end;
            end;
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

    labels
    {
    }

    var
        GlEntry: Record "G/L Entry";
        TuitionTagging: Record UnknownRecord90027;
}


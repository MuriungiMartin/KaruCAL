#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77712 "Aca Rec Proc."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(YearOfAdmin);
                if StrLen("ACA-Course Registration"."Student No.")>1 then begin
                if Evaluate(YearOfAdmin,CopyStr("ACA-Course Registration"."Student No.",StrLen("ACA-Course Registration"."Student No.")-1,2)) then
                 "ACA-Course Registration"."Year of Admission":=YearOfAdmin;
                "ACA-Course Registration".Modify;
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
        YearOfAdmin: Integer;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78004 "ACA-Validate Units 5"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = where(Grade=filter(E));
            RequestFilterFields = Semester,"Academic Year";
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Student Units".Validate("ACA-Student Units".Grade);
                "ACA-Student Units".Validate("ACA-Student Units"."Special Exam");
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
        VarcharPart: Code[5];
        OldUnitCode: Code[10];
        NewUnitCode: Code[10];
        IntegerPart: Code[10];
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        ACAUnitsSubjects3: Record UnknownRecord61517;
        ACAUnitsSubjects4: Record UnknownRecord61517;
        CountedValues: Integer;
}


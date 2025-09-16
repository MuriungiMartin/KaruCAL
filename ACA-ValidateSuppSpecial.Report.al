#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78005 "ACA-Validate Supp/Special"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable78002;UnknownTable78002)
        {
            RequestFilterFields = Semester,"Academic Year";
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            var
                AcaSpecialExamsResults: Record UnknownRecord78003;
            begin
                // // ACACourseRegistration.RESET;
                // // ACACourseRegistration.SETRANGE("Student No.","Aca-Special Exams Details"."Student No.");
                // // ACACourseRegistration.SETRANGE(Semester,"Aca-Special Exams Details".Semester);
                // // ACACourseRegistration.SETFILTER(ACACourseRegistration."Yearly Remarks",'%1|%2|%3','SUPP','SPECIAL','SUPP/SPECIAL');
                // // IF NOT (ACACourseRegistration.FIND('-')) THEN BEGIN
                // // "Aca-Special Exams Details".DELETE;
                // //  AcaSpecialExamsResults.RESET;
                // //  AcaSpecialExamsResults.SETRANGE("Current Academic Year","Aca-Special Exams Details"."Current Academic Year");
                // //  AcaSpecialExamsResults.SETRANGE("Academic Year","Aca-Special Exams Details"."Academic Year");
                // //  AcaSpecialExamsResults.SETRANGE("Student No.","Aca-Special Exams Details"."Student No.");
                // //  AcaSpecialExamsResults.SETRANGE(Semester,"Aca-Special Exams Details".Semester);
                // //  AcaSpecialExamsResults.SETRANGE(Unit,"Aca-Special Exams Details"."Unit Code");
                // //  IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
                // //    AcaSpecialExamsResults.DELETEALL;
                // //   END;
                // // END;
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
        ACACourseRegistration: Record UnknownRecord61532;
}


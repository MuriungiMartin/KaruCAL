#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51790 "Creg Validate"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Programme,Stage;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(FeesBilled_CourseRegistration;"ACA-Course Registration"."Fees Billed")
            {
            }
            column(TotalBilled_CourseRegistration;"ACA-Course Registration"."Total Billed")
            {
            }
            column(StudentNo_CourseRegistration;"ACA-Course Registration"."Student No.")
            {
            }
            column(Semester_CourseRegistration;"ACA-Course Registration".Semester)
            {
            }
            column(Programme_CourseRegistration;"ACA-Course Registration".Programme)
            {
            }
            column(Settlement_type;"ACA-Course Registration"."Settlement Type")
            {
            }

            trigger OnAfterGetRecord()
            begin

                 //"Course Registration".RESET;
                 //"Course Registration".SETRANGE("Course Registration".Posted,FALSE);

                 "ACA-Course Registration".Session:='SEPT 15';
                 "ACA-Course Registration".Validate("ACA-Course Registration".Session);
                  "ACA-Course Registration".Modify;
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
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51545 "Enrollment by Stage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Enrollment by Stage.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Code","Semester Filter","School Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(Code_Programme;"ACA-Programme".Code)
            {
            }
            column(Description_Programme;"ACA-Programme".Description)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                column(ReportForNavId_4; 4)
                {
                }
                column(Code_ProgrammeStages;"ACA-Programme Stages".Code)
                {
                }
                column(Description_ProgrammeStages;"ACA-Programme Stages".Description)
                {
                }
                column(StudentRegistered_ProgrammeStages;"ACA-Programme Stages"."Student Registered")
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

    labels
    {
    }
}


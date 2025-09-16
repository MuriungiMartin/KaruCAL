#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51262 "Registry Files"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Registry Files.rdlc';

    dataset
    {
        dataitem(UnknownTable61634;UnknownTable61634)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(folioNo;"REG-Registry Files"."File No.")
            {
            }
            column(File_Desc;"REG-Registry Files"."File Subject/Description")
            {
            }
            column(Issuing;"REG-Registry Files"."Issuing Officer")
            {
            }
            column(Return;"REG-Registry Files"."Expected Return Date")
            {
            }
            column(Reciving;"REG-Registry Files"."Receiving Officer")
            {
            }
            column(F_Status;Format("REG-Registry Files"."File Status"))
            {
            }
            column(CareOf;"REG-Registry Files"."Care of")
            {
            }
            column(Type;Format("REG-Registry Files"."File Type"))
            {
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


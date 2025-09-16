#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99920 "Process Supp"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Process Supp.rdlc';

    dataset
    {
        dataitem(SuppDetails;UnknownTable78002)
        {
            DataItemTableView = where("Exam Marks"=filter(<>0));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // IF SuppDetails.Category=SuppDetails.Category::Supplementary THEN BEGIN
                // SuppDetails.CALCFIELDS("Flow Marks");
                // SuppDetails."Exam Marks":=SuppDetails."Flow Marks";
                // IF ((SuppDetails."Total Marks"> 0) AND (SuppDetails."Exam Marks"=0)) THEN BEGIN
                //  IF SuppDetails."CAT Marks"<SuppDetails."Total Marks" THEN
                //  SuppDetails."Exam Marks":=SuppDetails."Total Marks"-SuppDetails."CAT Marks";
                //  SuppDetails.MODIFY;
                //  END;
                // SuppDetails.MODIFY;
                // CLEAR(AcaSpecialExamsResults);
                // AcaSpecialExamsResults.RESET;
                // AcaSpecialExamsResults.SETRANGE("Student No.",SuppDetails."Student No.");
                // AcaSpecialExamsResults.SETRANGE("Academic Year",SuppDetails."Academic Year");
                // AcaSpecialExamsResults.SETRANGE(Unit,SuppDetails."Unit Code");
                // AcaSpecialExamsResults.SETRANGE(Catogory,AcaSpecialExamsResults.Catogory::Supplementary);
                // IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
                //  AcaSpecialExamsResults.DELETEALL;
                //  END;
                //  END;
                SuppDetails."Charge Posted":=true;
                SuppDetails.Modify;
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
        AcaSpecialExamsResults: Record UnknownRecord78003;
}


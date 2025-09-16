#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78078 "69266"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(SuppStatus;UnknownTable69266)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // // SuppStatus."Status Msg1":=SuppStatus."Supp. Status Msg1";
                // // SuppStatus."Status Msg2":=SuppStatus."Supp. Status Msg2";
                // // SuppStatus."Status Msg3":=SuppStatus."Supp. Status Msg3";
                // // SuppStatus."Status Msg4":=SuppStatus."Supp. Status Msg4";
                // // SuppStatus."Status Msg5":=SuppStatus."Supp. Status Msg5";
                // // //SuppStatus."Status Msg6":=SuppStatus."Supp. Status Msg6";
                if SuppStatus."Status Msg1"<>'' then SuppStatus."IncludeVariable 1":=true;
                if SuppStatus."Status Msg2"<>'' then SuppStatus."IncludeVariable 2":=true;
                if SuppStatus."Status Msg3"<>'' then SuppStatus."IncludeVariable 3":=true;
                if SuppStatus."Status Msg4"<>'' then SuppStatus."IncludeVariable 4":=true;
                if SuppStatus."Status Msg5"<>'' then SuppStatus."IncludeVariable 5":=true;
                if SuppStatus."Status Msg6"<>'' then SuppStatus."IncludeVariable 6":=true;
                SuppStatus.Modify;
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


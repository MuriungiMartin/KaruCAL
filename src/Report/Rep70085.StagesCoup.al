#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70085 "Stages Coup"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "ACA-Programme Stages".Code='Y1S1' then begin
                "ACA-Programme Stages".Order:=1;
                  end;

                if "ACA-Programme Stages".Code='Y1S2' then begin
                "ACA-Programme Stages".Order:=2;
                  end;

                if "ACA-Programme Stages".Code='Y2S1' then begin
                "ACA-Programme Stages".Order:=3;
                  end;

                if "ACA-Programme Stages".Code='Y2S2' then begin
                "ACA-Programme Stages".Order:=4;
                  end;

                if "ACA-Programme Stages".Code='Y3S1' then begin
                "ACA-Programme Stages".Order:=5;
                  end;

                if "ACA-Programme Stages".Code='Y3S2' then begin
                "ACA-Programme Stages".Order:=6;
                  end;

                if "ACA-Programme Stages".Code='Y4S1' then begin
                "ACA-Programme Stages".Order:=7;
                  end;

                if "ACA-Programme Stages".Code='Y4S2' then begin
                "ACA-Programme Stages".Order:=8;
                  end;

                if "ACA-Programme Stages".Code='Y5S1' then begin
                "ACA-Programme Stages".Order:=9;
                  end;

                if "ACA-Programme Stages".Code='Y5S2' then begin
                "ACA-Programme Stages".Order:=10;
                  end;

                if "ACA-Programme Stages".Code='Y6S1' then begin
                "ACA-Programme Stages".Order:=11;
                  end;

                if "ACA-Programme Stages".Code='Y6S2' then begin
                "ACA-Programme Stages".Order:=12;
                  end;

                "ACA-Programme Stages".Modify;
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


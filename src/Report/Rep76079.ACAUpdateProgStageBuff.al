#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 76079 "ACA-Update Prog. Stage Buff."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ResBuffer;UnknownTable78069)
        {
            RequestFilterFields = "Prog. Code","Semester Code","Stage Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if PostDirection = Postdirection::Disable then begin
                   ResBuffer."To Buffer Results" := false;
                  end else if PostDirection = Postdirection::Enable then begin
                   ResBuffer."To Buffer Results" := true;
                  end;
                  ResBuffer.Modify;
            end;

            trigger OnPreDataItem()
            begin
                //IF ResBuffer.GETFILTER("Prog. Code") = '' THEN ERROR('Specify programs in the filter');
                if ResBuffer.GetFilter("Stage Code") = '' then Error('Specify Stages in the filter');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(PostDirection;PostDirection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Enable/Disable';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('Done!');
    end;

    trigger OnPreReport()
    begin
        if PostDirection = Postdirection::" " then Error('Specify whether you want to enable or disable buffering.');
    end;

    var
        PostDirection: Option " ",Enable,Disable;
}


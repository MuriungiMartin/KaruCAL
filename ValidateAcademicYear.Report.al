#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78073 "Validate Academic Year"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(dets;UnknownTable78002)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                seqz+=1;

                RecordRemaining:=RecordsTot-seqz;

                stat.Update(2,'Remaining:  '+Format(RecordRemaining));

                dets.CalcFields("Corect Semester Year");
                if dets.Rename(dets."Student No.",dets."Unit Code",dets."Corect Semester Year",dets.Semester,seqz) then begin

                  end else dets.Delete;
            end;

            trigger OnPreDataItem()
            begin
                RecordsTot:=dets.Count;
                stat.Update(1,'Total Records: '+Format(RecordsTot));
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

    trigger OnPostReport()
    begin
        stat.Close;
    end;

    trigger OnPreReport()
    begin
        stat.Open('#1####################################################\'+
        '#2#######################################');
        seqz:=50000;
    end;

    var
        seqz: Integer;
        RecordsTot: Integer;
        RecordRemaining: Integer;
        stat: Dialog;
        AcaSpecialExamsDetsBckUp: Record UnknownRecord78024;
        AcaSpecialExamsResultsbcku: Record UnknownRecord78026;
}


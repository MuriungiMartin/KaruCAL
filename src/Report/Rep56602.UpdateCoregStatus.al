#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56602 "Update Coreg. Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Coreg. Status.rdlc';

    dataset
    {
        dataitem(cust;Customer)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            dataitem(corec;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    corec."Semester Student Status":=cust.Status;
                    corec.Modify;
                    Processed:=Processed+1;
                    RemainingRecords-=1;
                    PercProcessed:=ROUND(((Processed/TotalRecord)*100),0.01,'=');
                    Progr.Update(3,'Processed Records: '+Format(Processed));
                    Progr.Update(4,'Remaining Records: '+Format(RemainingRecords));
                    Progr.Update(5,'Percentage Procecced: '+Format(PercProcessed));
                end;
            }

            trigger OnPreDataItem()
            begin
                ACACourseRegistration.Reset;
                if ACACourseRegistration.Find('-') then TotalRecord:=ACACourseRegistration.Count;
                RemainingRecords:=TotalRecord;
                Progr.Open('#1#################################################\'+
                '#2#################################################\'+
                '#3#################################################\'+
                '#4#################################################\'+
                '#5#################################################\');
                Progr.Update(1,'Processing Course Registrations');
                Progr.Update(2,'Total Records: '+Format(TotalRecord));
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
        TotalRecord: Integer;
        Processed: Integer;
        RemainingRecords: Integer;
        ACACourseRegistration: Record UnknownRecord61532;
        Progr: Dialog;
        PercProcessed: Decimal;
}


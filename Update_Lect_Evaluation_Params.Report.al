#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55515 Update_Lect_Evaluation_Params
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update_Lect_Evaluation_Params.rdlc';

    dataset
    {
        dataitem(StudUnits;UnknownTable61549)
        {
            RequestFilterFields = "Student No.",Semester,Programme,Stage,Unit,"Academic Year (Flow)";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ACAUnitsSubjects);
                Clear(ACACourseRegistration);
                Clear(ACALecturersUnits);
                Clear(Customer);


                RemainingRecord := RemainingRecord-1;
                ProcessedRecs +=1;


                Progresss.Update(2,'Processed Records: ...'+Format(ProcessedRecs));
                Progresss.Update(3,'Remaining Records: ...'+Format(RemainingRecord));

                Progresss.Update(4,'Student No.: ...'+StudUnits."Student No.");
                Progresss.Update(5,'Programme: ...'+StudUnits.Programme);
                Progresss.Update(6,'Unit Code / Stage: ...'+StudUnits.Unit+', Stage: '+StudUnits.Stage);

                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange("Programme Code",StudUnits.Programme);
                ACAUnitsSubjects.SetRange(Code,StudUnits.Unit);
                if ACAUnitsSubjects.Find('-') then;

                ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(Programme,StudUnits.Programme);
                ACACourseRegistration.SetRange(Semester,StudUnits.Semester);
                ACACourseRegistration.SetRange("Student No.",StudUnits."Student No.");
                ACACourseRegistration.SetRange(Reversed,false);
                if ACACourseRegistration.Find('-') then;

                Customer.Reset;
                Customer.SetRange("No.",StudUnits."Student No.");
                if Customer.Find('-') then;

                ACALecturersUnits.Reset;
                ACALecturersUnits.SetRange("Campus Code",Customer."Global Dimension 1 Code");
                ACALecturersUnits.SetRange(Programme,StudUnits.Programme);
                ACALecturersUnits.SetRange(Unit,StudUnits.Unit);
                ACALecturersUnits.SetRange(Semester,StudUnits.Semester);
                if not (ACALecturersUnits.Find('-')) then begin
                 Clear(ACALecturersUnits);
                ACALecturersUnits.Reset;
                ACALecturersUnits.SetRange(Programme,StudUnits.Programme);
                ACALecturersUnits.SetRange(Unit,StudUnits.Unit);
                ACALecturersUnits.SetRange(Semester,StudUnits.Semester);
                  end;


                Clear(HRMEmployeeC);
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.",ACALecturersUnits.Lecturer);
                if HRMEmployeeC.Find('-') then;

                StudUnits."Exempt in Evaluation" := ACAUnitsSubjects."Exempt From Evaluation";
                StudUnits.Posted := ACACourseRegistration.Posted;
                StudUnits."Unit Lecturer" := ACALecturersUnits.Lecturer;;
                StudUnits."Date Registered" := StudUnits."Date created";
                StudUnits."Lecturer Name" := HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name";
                StudUnits.Lecturer := ACALecturersUnits.Lecturer;
                StudUnits.Description := ACAUnitsSubjects.Desription;
                if StudUnits.Modify then;
            end;

            trigger OnPostDataItem()
            begin
                Progresss.Close;
            end;

            trigger OnPreDataItem()
            begin
                Progresss.Open('#1###############################################################\'+
                '#2###############################################################\'+
                '#3###############################################################\'+
                '#4###############################################################\'+
                '#5###############################################################\'+
                '#6###############################################################\');
                TotRecord := StudUnits.Count;
                RemainingRecord :=TotRecord;

                Progresss.Update(1,'Total Records: ...'+Format(TotRecord));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACACourseRegistration: Record UnknownRecord61532;
        ACALecturersUnits: Record UnknownRecord65202;
        Customer: Record Customer;
        HRMEmployeeC: Record UnknownRecord61188;
        Progresss: Dialog;
        TotRecord: Integer;
        ProcessedRecs: Integer;
        RemainingRecord: Integer;
}


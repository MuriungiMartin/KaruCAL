#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77721 "Aca-Transfer Stopped C. Reg."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = where(Code=filter(E101));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACACourseRegistration.Reset;
                ACACourseRegistration.SetFilter(Reversed,'%1',true);
                if ACACourseRegistration.Find('-') then begin
                  repeat
                    begin
                 //Copy Course Registrations That have been Reversed
                    ACACourseRegReservour.TransferFields(ACACourseRegistration);
                    ACACourseRegReservour.Insert;
                    ACACourseRegistration.Delete;
                    end;
                    until ACACourseRegistration.Next=0;
                  end;

                ACAStudentUnits.Reset;
                ACAStudentUnits.SetFilter("Reg. Reversed",'%1',true);
                if ACAStudentUnits.Find('-') then begin
                  repeat
                    begin
                 //Copy Student Units That have been Reversed
                    ACAStudentUnitsReservour.TransferFields(ACAStudentUnits);
                    ACAStudentUnitsReservour.Insert;
                    ACAStudentUnits.Delete;
                    end;
                    until ACAStudentUnits.Next=0;
                  end;

                ACAStdCharges.Reset;
                ACAStdCharges.SetFilter("Reg. Reversed",'%1',true);
                if ACAStdCharges.Find('-') then begin
                  repeat
                    begin
                 //Copy StudentCharges That have been Reversed
                    ACAStudentUnitsReservour.TransferFields(ACAStdCharges);
                    ACAStudentUnitsReservour.Insert;
                    ACAStdCharges.Delete;
                    end;
                    until ACAStdCharges.Next=0;
                  end;
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
        ACACourseRegistration: Record UnknownRecord61532;
        ACAStudentUnits: Record UnknownRecord61549;
        ACAStdCharges: Record UnknownRecord61535;
        ACACourseRegReservour: Record UnknownRecord77721;
        ACAStudentUnitsReservour: Record UnknownRecord77722;
        ACAStdChargesReservour: Record UnknownRecord77723;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77300 "Update Stoppages"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Coregcz;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(Yes),"Stoppage Reason"=filter(<>""));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ProcessedRecs +=1;
                RemainingRecs -=1;
                Diag.Update(1,'Processing ...................');
                Diag.Update(2,'Total: '+Format(TotalRecs));
                Diag.Update(3,'Processed: '+Format(ProcessedRecs));
                Diag.Update(4,'Remaining: '+Format(RemainingRecs));
                Diag.Update(5,'.......................'+Format(TotalRecs));
                if Coregcz.Reversed=true then begin
                  Clear(ACARegStoppageReasons);
                  ACARegStoppageReasons.Reset;
                  ACARegStoppageReasons.SetRange("Reason Code",Coregcz."Stoppage Reason");
                  if ACARegStoppageReasons.Find('-') then begin
                    if ACARegStoppageReasons."Move to Reservour" = true then begin
                  ACACourseRegReservour.Init;
                  ACACourseRegReservour."Reg. Transacton ID" := Coregcz."Reg. Transacton ID";
                  ACACourseRegReservour."Register for" := Coregcz."Register for";
                  ACACourseRegReservour."Student No." := Coregcz."Student No.";
                  ACACourseRegReservour."Academic Year" := Coregcz."Academic Year";
                  ACACourseRegReservour.Semester := Coregcz.Semester;
                  ACACourseRegReservour.Stage := Coregcz.Stage;
                  ACACourseRegReservour."Entry No." := Coregcz."Entry No.";
                  ACACourseRegReservour.Programme := Coregcz.Programme;
                  ACACourseRegReservour."Stopage Reason" := Coregcz."Stoppage Reason";
                  ACACourseRegReservour."Year Of Study" := Coregcz."Year Of Study";
                  ACACourseRegReservour."Student Type" := Coregcz."Student Type";
                  if ACACourseRegReservour.Insert then begin
                    Clear(ACACourseRegistrationsz);
                    ACACourseRegistrationsz.Reset;
                    ACACourseRegistrationsz.SetRange("Reg. Transacton ID",Coregcz."Reg. Transacton ID");
                    ACACourseRegistrationsz.SetRange(Semester,Coregcz.Semester);
                    ACACourseRegistrationsz.SetRange(Stage,Coregcz.Stage);
                    ACACourseRegistrationsz.SetRange("Student No.",Coregcz."Student No.");
                    ACACourseRegistrationsz.SetRange("Academic Year",Coregcz."Academic Year");
                    ACACourseRegistrationsz.SetRange("Register for",Coregcz."Register for");
                    ACACourseRegistrationsz.SetRange(Programme,Coregcz.Programme);
                    ACACourseRegistrationsz.SetRange("Entry No.",Coregcz."Entry No.");
                    ACACourseRegistrationsz.SetRange("Student Type",Coregcz."Student Type");
                    if ACACourseRegistrationsz.Find('-') then
                    ACACourseRegistrationsz.Delete(false)
                    end else begin

                    Clear(ACACourseRegReservour);
                    ACACourseRegReservour.Reset;
                    ACACourseRegReservour.SetRange("Reg. Transacton ID",Coregcz."Reg. Transacton ID");
                    ACACourseRegReservour.SetRange(Semester,Coregcz.Semester);
                    ACACourseRegReservour.SetRange(Stage,Coregcz.Stage);
                    ACACourseRegReservour.SetRange("Student No.",Coregcz."Student No.");
                    ACACourseRegReservour.SetRange("Academic Year",Coregcz."Academic Year");
                    ACACourseRegReservour.SetRange("Register for",Coregcz."Register for");
                    ACACourseRegReservour.SetRange(Programme,Coregcz.Programme);
                    ACACourseRegReservour.SetRange("Entry No.",Coregcz."Entry No.");
                    ACACourseRegReservour.SetRange("Student Type",Coregcz."Student Type");
                    if ACACourseRegReservour.Find('-') then begin
                      ACACourseRegReservour."Stopage Reason" := Coregcz."Stoppage Reason";
                      ACACourseRegReservour.Modify;

                    Clear(ACACourseRegistrationsz);
                    ACACourseRegistrationsz.Reset;
                    ACACourseRegistrationsz.SetRange("Reg. Transacton ID",Coregcz."Reg. Transacton ID");
                    ACACourseRegistrationsz.SetRange(Semester,Coregcz.Semester);
                    ACACourseRegistrationsz.SetRange(Stage,Coregcz.Stage);
                    ACACourseRegistrationsz.SetRange("Student No.",Coregcz."Student No.");
                    ACACourseRegistrationsz.SetRange("Academic Year",Coregcz."Academic Year");
                    ACACourseRegistrationsz.SetRange("Register for",Coregcz."Register for");
                    ACACourseRegistrationsz.SetRange(Programme,Coregcz.Programme);
                    ACACourseRegistrationsz.SetRange("Entry No.",Coregcz."Entry No.");
                    ACACourseRegistrationsz.SetRange("Student Type",Coregcz."Student Type");
                    if ACACourseRegistrationsz.Find('-') then
                    ACACourseRegistrationsz.Delete(false);
                      end// Modify ;
                    end;
                  end;
                  end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(TotalRecs);
                Clear(ProcessedRecs);
                Clear(RemainingRecs);
                TotalRecs := Coregcz.Count;
                RemainingRecs := TotalRecs;
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
        Diag.Close;
    end;

    trigger OnPreReport()
    begin
        Diag.Open('#1###############################################################\'+
        '#2#################################################################################\'+
        '#3#################################################################################\'+
        '#4#################################################################################\'+
        '#5#################################################################################');
    end;

    var
        ACACourseRegReservour: Record UnknownRecord77721;
        ACARegStoppageReasons: Record UnknownRecord66620;
        ACACourseRegistrationsz: Record UnknownRecord61532;
        Diag: Dialog;
        TotalRecs: Integer;
        ProcessedRecs: Integer;
        RemainingRecs: Integer;
}


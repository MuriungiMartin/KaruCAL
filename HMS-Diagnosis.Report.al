#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65589 "HMS-Diagnosis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS-Diagnosis.rdlc';

    dataset
    {
        dataitem(UnknownTable61412;UnknownTable61412)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(TreatmentNo_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Treatment No.")
            {
            }
            column(DiagnosisNo_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Diagnosis No.")
            {
            }
            column(DiagnosisName_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Diagnosis Name")
            {
            }
            column(Confirmed_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Confirmed)
            {
            }
            column(Remarks_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Remarks)
            {
            }
            column(TreatmentDate_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Treatment Date")
            {
            }
            column(PatientNoF_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".PatientNoF)
            {
            }
            column(PatientNo_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Patient No")
            {
            }
            column(Gender_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Gender)
            {
            }
            column(Age_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Age)
            {
            }
            column(PatientName_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Patient Name")
            {
            }
            column(DiagnosisDate_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Diagnosis Date")
            {
            }
            column(Treatment_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Treatment)
            {
            }
            column(PatientAppointments_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Patient Appointments")
            {
            }
            column(Doctor_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis".Doctor)
            {
            }
            column(DiagnosisCount_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Diagnosis Count")
            {
            }
            column(DateFilter_HMSTreatmentFormDiagnosis;"HMS-Treatment Form Diagnosis"."Date Filter")
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


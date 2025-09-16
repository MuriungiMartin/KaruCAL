#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51557 "Student Class Attendance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Class Attendance.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = where(Taken=const(Yes));
            RequestFilterFields = Programme,Unit,"Student No.","Reg. Transacton ID";
            column(ReportForNavId_2992; 2992)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(UDesc;UDesc)
            {
            }
            column(CreditH;CreditH)
            {
            }
            column(Student_Units_Remarks;Remarks)
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(RCount;RCount)
            {
            }
            column(Student_Units_Attendance;Attendance)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(KCA_UniversityCaption;KCA_UniversityCaptionLbl)
            {
            }
            column(Student_Class_AttendanceCaption;Student_Class_AttendanceCaptionLbl)
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Programme_FilterCaption;Programme_FilterCaptionLbl)
            {
            }
            column(Stage_FilterCaption;Stage_FilterCaptionLbl)
            {
            }
            column(Unit_FilterCaption;Unit_FilterCaptionLbl)
            {
            }
            column(Student_Units_AttendanceCaption;FieldCaption(Attendance))
            {
            }
            column(Credit_HoursCaption;Credit_HoursCaptionLbl)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Unitz.Reset;
                Unitz.SetRange(Unitz."Programme Code",Programme);
                Unitz.SetRange(Unitz.Code,Unit);
                if Unitz.Find('-') then begin
                UDesc:=Unitz.Desription;
                CreditH:=Unitz."Credit Hours";
                end;

                if "ACA-Student Units".Taken = true then begin
                if "ACA-Student Units".Attendance < (0.75*CreditH)  then begin
                Remarks:='Incomplete';
                end else begin
                Grade:='';
                Remarks:='Complete';
                end;


                end else begin
                Grade:='';
                Remarks:='**Exempted**';


                end;

                RCount:=RCount+1;

                if Cust.Get("ACA-Student Units"."Student No.") then
;

            trigger OnPreDataItem()
            begin
                CreditH:=0;
                UDesc:='';
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
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Unitz: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CReg: Record UnknownRecord61532;
        RCount: Integer;
        CreditH: Decimal;
        RemarkCaptionLbl: label 'Remark';
        KCA_UniversityCaptionLbl: label 'KCA University';
        Student_Class_AttendanceCaptionLbl: label 'Student Class Attendance';
        NameCaptionLbl: label 'Name';
        Programme_FilterCaptionLbl: label 'Programme Filter';
        Stage_FilterCaptionLbl: label 'Stage Filter';
        Unit_FilterCaptionLbl: label 'Unit Filter';
        Credit_HoursCaptionLbl: label 'Credit Hours';
}


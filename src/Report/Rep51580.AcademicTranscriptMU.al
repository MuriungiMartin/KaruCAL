#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51580 "Academic Transcript MU"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Academic Transcript MU.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Type"=const(Student));
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Customer_Customer_Name;Customer.Name)
            {
            }
            column(Customer_Customer__No__;Customer."No.")
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Customer_Customer__Date_Registered_;Customer."Date Registered")
            {
            }
            column(Sem;Sem)
            {
            }
            column(SDesc;SDesc)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("No.");
                RequestFilterFields = "Reg. Transacton ID",Programme,Stage,Semester;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(UDesc;UDesc)
                {
                }
                column(Student_Units_Grade;Grade)
                {
                }
                column(Student_Units__Total_Score_;"Total Score")
                {
                }
                column(Student_Units__Total_Score__Control1102760004;"Total Score")
                {
                }
                column(MeanGrade;MeanGrade)
                {
                }
                column(MeanScore;MeanScore)
                {
                }
                column(Average_Score_Grade_Caption;Average_Score_Grade_CaptionLbl)
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Student_Units_Student_No_;"Student No.")
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnAfterGetRecord()
                begin



                    UDesc:='';
                    Units.Reset;
                    Units.SetRange(Units."Programme Code","ACA-Student Units".Programme);
                    Units.SetRange(Units.Code,Unit);
                    if Units.Find('-') then
                    UDesc:=Units.Desription;

                    if "ACA-Student Units".Taken = true then begin



                    if "ACA-Student Units"."Total Score" > 0 then begin
                    Gradings.Reset;
                    Gradings.SetRange(Gradings.Category,'DEFAULT');
                    LastGrade:='';
                    LastRemark:='';
                    LastScore:=0;
                    if Gradings.Find('-') then begin
                    ExitDo:=false;
                    repeat
                    if "ACA-Student Units"."Total Score" < LastScore then begin
                    if ExitDo = false then begin
                    ExitDo:=true;
                    Grade:=LastGrade;
                    Remarks:=''//LastRemark;
                    end;
                    end;
                    LastGrade:=Gradings.Grade;
                    LastScore:=Gradings."Up to";
                    if Gradings.Failed = true then
                    LastRemark:=''//'Suplimentary'
                    else
                    LastRemark:=''//Gradings.Remarks;

                    until Gradings.Next = 0;

                    if ExitDo = false then begin
                    Gradings2.Reset;
                    Gradings2.SetRange(Gradings2.Category,'DEFAULT');
                    if Gradings2.Find('+') then begin
                    Grade:=Gradings2.Grade;
                    Remarks:=''//Gradings2.Remarks;
                    end;

                    end;
                    end;

                    end else begin
                    Grade:='';
                    //Remarks:='Not Done';
                    end;


                    OUnits:=OUnits + 1;
                    OScore:=OScore + "ACA-Student Units"."Total Score";

                    end else begin
                    Grade:='';
                    Remarks:='**Exempted**';


                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CReg.Reset;
                CReg.SetRange(CReg."Student No.",Customer."No.");
                CReg.SetFilter(CReg.Stage,GetFilter(Customer."Stage Filter"));
                if CReg.Find('+') then begin
                if Prog.Get(CReg.Programme) then
                RFound:=true;

                Sem:=CReg.Semester;

                if Prog.Get(CReg.Programme) then begin
                PName:=Prog.Description;
                if FacultyR.Get(Prog.Faculty) then
                FDesc:=FacultyR.Description;

                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."School Code");
                if DValue.Find('-') then
                Dept:=DValue.Name;

                end;

                if Stages.Get(CReg.Programme,CReg.Stage) then
                SDesc:=Stages.Description;

                if ProgOptions.Get(CReg.Programme,CReg.Stage,CReg.Options) then
                Comb:=ProgOptions.Desription;



                end;

                OUnits:=0;
                OScore:=0;

                Dept := '';
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
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61569;
        Gradings2: Record UnknownRecord61569;
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
        MRemark: Text[100];
        FacultyR: Record UnknownRecord61587;
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        ProgOptions: Record UnknownRecord61554;
        DMarks: Boolean;
        DSummary: Boolean;
        DValue: Record "Dimension Value";
        Sem: Code[20];
        Average_Score_Grade_CaptionLbl: label 'Average Score/Grade:';
}


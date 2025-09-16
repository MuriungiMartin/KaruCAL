#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78068 "Update Seq2"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DetRes;UnknownTable78003)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                seqz+=1;
                
                RecordRemaining:=RecordsTot-seqz;
                
                stat.Update(2,'Remaining:  '+Format(RecordRemaining));
                Clear(AcaSpecialExamsDets);
                AcaSpecialExamsDets.Reset;
                AcaSpecialExamsDets.SetRange(Semester,DetRes.Semester);
                AcaSpecialExamsDets.SetRange("Unit Code",DetRes.Unit);
                AcaSpecialExamsDets.SetRange("Student No.",DetRes."Student No.");
                if not (AcaSpecialExamsDets.Find('-')) then begin
                AcaSpecialExamsDets.Init;
                AcaSpecialExamsDets."Student No.":=DetRes."Student No.";
                AcaSpecialExamsDets."Unit Code":=DetRes.Unit;
                AcaSpecialExamsDets."Academic Year":=DetRes."Academic Year";
                AcaSpecialExamsDets.Semester:=DetRes.Semester;
                AcaSpecialExamsDets."Exam Session":=DetRes."Exam Session";
                AcaSpecialExamsDets.Stage:=DetRes.Stage;
                AcaSpecialExamsDets.Programme:=DetRes.Programme;
                AcaSpecialExamsDets."Exam Marks":=DetRes.Score;
                AcaSpecialExamsDets."Total Marks":=DetRes.Score;
                AcaSpecialExamsDets.Grade:=DetRes.Grade;
                AcaSpecialExamsDets.Category:=AcaSpecialExamsDets.Category::Supplementary;
                AcaSpecialExamsDets."Current Academic Year":=DetRes."Current Academic Year";
                AcaSpecialExamsDets."Current Semester":=DetRes.Semester;
                AcaSpecialExamsDets."Charge Posted":=true;
                
                if AcaSpecialExamsDets.Insert then;
                end else begin
                //  IF AcaSpecialExamsDets."Exam Marks" = 0 THEN  BEGIN
                // AcaSpecialExamsDets."Exam Marks":=DetRes.Score;
                //  IF AcaSpecialExamsDets.MODIFY THEN;
                //  END;
                  end;
                
                /*
                AcaSpecialExamsResultsbcku.INIT;
                AcaSpecialExamsResultsbcku.Programme:=DetRes.Programme;
                AcaSpecialExamsResultsbcku.Stage:=DetRes.Stage;
                AcaSpecialExamsResultsbcku.Unit:=DetRes.Unit;
                AcaSpecialExamsResultsbcku.Semester:=DetRes.Semester;
                AcaSpecialExamsResultsbcku."Student No.":=DetRes."Student No.";
                AcaSpecialExamsResultsbcku."Academic Year":=DetRes."Academic Year";
                AcaSpecialExamsResultsbcku.Score:=DetRes.Score;
                AcaSpecialExamsResultsbcku.Exam:=DetRes.Exam;
                AcaSpecialExamsResultsbcku."Reg. Transaction ID":=DetRes."Reg. Transaction ID";
                AcaSpecialExamsResultsbcku.Grade:=DetRes.Grade;
                AcaSpecialExamsResultsbcku.Percentage:=DetRes.Percentage;
                AcaSpecialExamsResultsbcku.Contribution:=DetRes.Contribution;
                AcaSpecialExamsResultsbcku."Exam Category":=DetRes."Exam Category";
                AcaSpecialExamsResultsbcku.ExamType:=DetRes.ExamType;
                AcaSpecialExamsResultsbcku."Admission No":=DetRes."Admission No";
                AcaSpecialExamsResultsbcku.Reported:=DetRes.Reported;
                AcaSpecialExamsResultsbcku."Lecturer Names":=DetRes."Lecturer Names";
                AcaSpecialExamsResultsbcku.UserID:=DetRes.UserID;
                AcaSpecialExamsResultsbcku."Exam Session":=DetRes."Exam Session";
                AcaSpecialExamsResultsbcku.Catogory:=DetRes.Catogory;
                AcaSpecialExamsResultsbcku."Current Academic Year":=DetRes."Current Academic Year";
                AcaSpecialExamsResultsbcku."Capture Date":=DetRes."Capture Date";
                AcaSpecialExamsResultsbcku."Modified Date":=DetRes."Modified Date";
                
                IF AcaSpecialExamsResultsbcku.INSERT THEN;
                */

            end;

            trigger OnPreDataItem()
            begin
                Clear(seqz);
                Clear(RecordRemaining);
                RecordsTot:=DetRes.Count;
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
    end;

    var
        seqz: Integer;
        RecordsTot: Integer;
        RecordRemaining: Integer;
        stat: Dialog;
        AcaSpecialExamsDets: Record UnknownRecord78002;
        AcaSpecialExamsResultsbcku: Record UnknownRecord78026;
}


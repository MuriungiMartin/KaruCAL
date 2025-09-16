#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78067 "Update Seq"
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
                /*
                dets.CALCFIELDS("Corect Semester Year");
                dets.RENAME(dets."Student No.",dets."Unit Code",dets."Corect Semester Year",dets.Semester,seqz);*/
                AcaSpecialExamsDetsBckUp.Init;
                AcaSpecialExamsDetsBckUp."Student No.":=dets."Student No.";
                AcaSpecialExamsDetsBckUp."Unit Code":=dets."Unit Code";
                AcaSpecialExamsDetsBckUp."Academic Year":=dets."Academic Year";
                AcaSpecialExamsDetsBckUp.Semester:=dets.Semester;
                AcaSpecialExamsDetsBckUp.Sequence:=dets.Sequence;
                AcaSpecialExamsDetsBckUp."Exam Session":=dets."Exam Session";
                AcaSpecialExamsDetsBckUp.Stage:=dets.Stage;
                AcaSpecialExamsDetsBckUp.Programme:=dets.Programme;
                AcaSpecialExamsDetsBckUp.Status:=dets.Status;
                AcaSpecialExamsDetsBckUp."CAT Marks":=dets."CAT Marks";
                AcaSpecialExamsDetsBckUp."Exam Marks":=dets."Exam Marks";
                AcaSpecialExamsDetsBckUp."Total Marks":=dets."Total Marks";
                AcaSpecialExamsDetsBckUp.Grade:=dets.Grade;
                AcaSpecialExamsDetsBckUp."Cost Per Exam":=dets."Cost Per Exam";
                AcaSpecialExamsDetsBckUp.Category:=dets.Category;
                AcaSpecialExamsDetsBckUp."Current Academic Year":=dets."Current Academic Year";
                AcaSpecialExamsDetsBckUp."Special Exam Reason":=dets."Special Exam Reason";
                AcaSpecialExamsDetsBckUp."Current Semester":=dets."Current Semester";
                AcaSpecialExamsDetsBckUp."Charge Posted":=dets."Charge Posted";
                AcaSpecialExamsDetsBckUp."Created By":=dets."Created By";
                AcaSpecialExamsDetsBckUp."Created Date/Time":=dets."Created Date/Time";
                AcaSpecialExamsDetsBckUp."Last Edited By":=dets."Last Edited By";
                AcaSpecialExamsDetsBckUp."Last Edited Date/Time":=dets."Last Edited Date/Time";
                AcaSpecialExamsDetsBckUp."Original Marks":=dets."Original Marks";
                AcaSpecialExamsDetsBckUp."New Mark":=dets."New Mark";
                AcaSpecialExamsDetsBckUp."Unit Description":=dets."Unit Description";
                
                if AcaSpecialExamsDetsBckUp.Insert then;

            end;

            trigger OnPreDataItem()
            begin
                RecordsTot:=dets.Count;
                stat.Update(1,'Total Records: '+Format(RecordsTot));
            end;
        }
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

                AcaSpecialExamsResultsbcku.Init;
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

                if AcaSpecialExamsResultsbcku.Insert then;
            end;

            trigger OnPreDataItem()
            begin
                Clear(seqz);
                Clear(RecordRemaining);
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
        AcaSpecialExamsDetsBckUp: Record UnknownRecord78024;
        AcaSpecialExamsResultsbcku: Record UnknownRecord78026;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78069 "Update Exam Details"
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
                dets."Charge Posted":=true;
                dets.Modify;
                seqz+=1;
                
                RecordRemaining:=RecordsTot-seqz;
                
                stat.Update(2,'Remaining:  '+Format(RecordRemaining));
                /*
                CLEAR(AcaSpecialExamsResults);
                AcaSpecialExamsResults.RESET;
                AcaSpecialExamsResults.SETRANGE("Student No.",dets."Student No.");
                AcaSpecialExamsResults.SETRANGE("Academic Year",dets."Academic Year");
                AcaSpecialExamsResults.SETRANGE(Unit,dets."Unit Code");
                AcaSpecialExamsResults.SETRANGE(Catogory,AcaSpecialExamsResults.Catogory::Supplementary);
                IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
                  // Update Score for Supplementary Here
                IF dets."Exam Marks" = 0 THEN BEGIN
                  dets."Exam Marks":=AcaSpecialExamsResults.Score;
                  dets.MODIFY;
                  END;
                  END ELSE BEGIN
                    IF dets."Exam Marks"<>0 THEN BEGIN
                      // Create a results entry here
                      AcaSpecialExamsResults.INIT;
                      AcaSpecialExamsResults.Programme:=dets.Programme;
                      AcaSpecialExamsResults.Stage:=dets.Stage;
                      AcaSpecialExamsResults.Unit:=dets."Unit Code";
                      AcaSpecialExamsResults.Semester:=dets.Semester;
                      AcaSpecialExamsResults."Student No.":=dets."Student No.";
                      AcaSpecialExamsResults."Academic Year":=dets."Academic Year";
                      AcaSpecialExamsResults.Score:=dets."Exam Marks";
                      AcaSpecialExamsResults.Grade:=dets.Grade;
                      AcaSpecialExamsResults."Admission No":=dets."Student No.";
                      AcaSpecialExamsResults.Reported:=TRUE;
                      AcaSpecialExamsResults.UserID:=dets."Last Edited By";
                      AcaSpecialExamsResults."Exam Session":=dets."Exam Session";
                      AcaSpecialExamsResults.Catogory:=dets.Category;
                      AcaSpecialExamsResults."Current Academic Year":=dets."Current Academic Year";
                      AcaSpecialExamsResults.INSERT;
                      END;
                    END;
                    dets."Combined Score":=dets."Exam Marks"+dets."CAT Marks";
                    dets.MODIFY;*/
                /*
                dets.CALCFIELDS("Corect Semester Year");
                dets.RENAME(dets."Student No.",dets."Unit Code",dets."Corect Semester Year",dets.Semester,seqz);
                AcaSpecialExamsDetsBckUp.INIT;
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
                
                IF AcaSpecialExamsDetsBckUp.INSERT THEN;
                */

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
    end;

    var
        seqz: Integer;
        RecordsTot: Integer;
        RecordRemaining: Integer;
        stat: Dialog;
        AcaSpecialExamsResults: Record UnknownRecord78003;
}


#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60278 "Update Values"
{

    trigger OnRun()
    begin
        UpdateSupps;
    end;

    local procedure UpdateSupps()
    var
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        AcaSpecialExamsDetails2: Record UnknownRecord78002;
        AcaSpecialExamsDetails3: Record UnknownRecord78002;
        AcaSpecialExamsResults: Record UnknownRecord78003;
    begin
        Clear(AcaSpecialExamsDetails);
        Clear(AcaSpecialExamsResults);
        AcaSpecialExamsDetails.Reset;
        if AcaSpecialExamsDetails.Find('-') then begin
          repeat
            begin
            AcaSpecialExamsDetails."Combined Score":=AcaSpecialExamsDetails."CAT Marks"+AcaSpecialExamsDetails."Exam Marks";
            AcaSpecialExamsDetails.Modify;
            end;
            until AcaSpecialExamsDetails.Next= 0;
          end;

        Clear(AcaSpecialExamsDetails);
        Clear(AcaSpecialExamsResults);
        AcaSpecialExamsDetails.Reset;
        if AcaSpecialExamsDetails.Find('-') then begin
          repeat
            begin
            AcaSpecialExamsDetails.CalcFields(Occurances);
            // If CAT mark is not empty, check if another entry exists with different Serial, delete the current one
            if AcaSpecialExamsDetails."CAT Marks"<>0 then begin
              AcaSpecialExamsDetails2.Reset;
              AcaSpecialExamsDetails2.SetRange("Student No.",AcaSpecialExamsDetails."Student No.");
              AcaSpecialExamsDetails2.SetRange("Unit Code",AcaSpecialExamsDetails."Unit Code");
              AcaSpecialExamsDetails2.SetFilter(Sequence,'<>%1',AcaSpecialExamsDetails.Sequence);
             if AcaSpecialExamsDetails2.Find('-') then begin
               repeat
                 begin
                 if ((AcaSpecialExamsDetails2."Exam Marks" = 0) or (AcaSpecialExamsDetails2."Exam Marks" = AcaSpecialExamsDetails."Combined Score")) then if AcaSpecialExamsDetails2.Delete then;
                 //IF AcaSpecialExamsDetails2."Exam Marks" = AcaSpecialExamsDetails."Combined Score" THEN AcaSpecialExamsDetails.DELETE;
                 end;
                 until AcaSpecialExamsDetails2.Next = 0;

             end;
              end;
           // AcaSpecialExamsDetails."Combined Score":=AcaSpecialExamsDetails."CAT Marks"+AcaSpecialExamsDetails."Exam Marks";
          //  AcaSpecialExamsDetails.MODIFY;
            end;
            until AcaSpecialExamsDetails.Next= 0;
          end;
        Clear(AcaSpecialExamsDetails);
        Clear(AcaSpecialExamsResults);
        AcaSpecialExamsDetails.Reset;
        if AcaSpecialExamsDetails.Find('-') then begin
          repeat
            begin
            AcaSpecialExamsDetails.CalcFields(Occurances);
            //Check Multiple Occurances
            if AcaSpecialExamsDetails.Occurances>1 then begin
              AcaSpecialExamsDetails2.Reset;
              AcaSpecialExamsDetails2.SetRange("Student No.",AcaSpecialExamsDetails."Student No.");
              AcaSpecialExamsDetails2.SetRange("Unit Code",AcaSpecialExamsDetails."Unit Code");
              AcaSpecialExamsDetails2.SetFilter(Sequence,'<>%1',AcaSpecialExamsDetails.Sequence);
             if AcaSpecialExamsDetails2.Find('-') then begin
               repeat
                 begin
                 if ((AcaSpecialExamsDetails2."Exam Marks" = 0) or (AcaSpecialExamsDetails2."Exam Marks" = AcaSpecialExamsDetails."Combined Score")) then begin

                    if AcaSpecialExamsDetails2.Delete then;
                   end;//
                 if AcaSpecialExamsDetails2."Exam Marks" = AcaSpecialExamsDetails."Combined Score" then if AcaSpecialExamsDetails.Delete then;
                 if AcaSpecialExamsDetails2."Combined Score" = AcaSpecialExamsDetails."Combined Score" then if AcaSpecialExamsDetails.Delete then;
                 end;
                 until AcaSpecialExamsDetails2.Next = 0;

             end;
              end;
            end;
            until AcaSpecialExamsDetails.Next= 0;
          end;
    end;
}


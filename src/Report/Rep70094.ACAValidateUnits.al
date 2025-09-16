#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70094 "ACA-Validate Units"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(OldUnitCode);
                Clear(NewUnitCode);
                Clear(VarcharPart);
                Clear(IntegerPart);
                
                if (StrLen("ACA-Units/Subjects".Code))>4 then begin
                  OldUnitCode:="ACA-Units/Subjects".Code;
                  VarcharPart:=CopyStr("ACA-Units/Subjects".Code,1,3);
                  IntegerPart:=CopyStr("ACA-Units/Subjects".Code,(StrLen("ACA-Units/Subjects".Code)-2),3);
                  NewUnitCode:=VarcharPart+' '+IntegerPart;
                
                 /*
                 ACAUnitsSubjects.RESET;
                 ACAUnitsSubjects.SETRANGE(Code,NewUnitCode);
                 ACAUnitsSubjects.SETRANGE("Programme Code","ACA-Units/Subjects"."Programme Code");
                 ACAUnitsSubjects.SETRANGE("Stage Code","ACA-Units/Subjects"."Stage Code");
                 ACAUnitsSubjects.SETRANGE("Entry No","ACA-Units/Subjects"."Entry No");
                 IF ACAUnitsSubjects.FIND('-') THEN BEGIN ACAUnitsSubjects.DELETE;
                   END;
                   */
                 "ACA-Units/Subjects"."Corected Unit Code":=NewUnitCode;
                "ACA-Units/Subjects".Modify;
                end

            end;

            trigger OnPostDataItem()
            var
                NewCodedUnits: Code[20];
            begin
                ACAUnitsSubjects.Reset;
                if ACAUnitsSubjects.Find('-') then begin
                  repeat

                    ACAUnitsSubjects2.Reset;
                    ACAUnitsSubjects2.SetRange("Programme Code",ACAUnitsSubjects."Programme Code");
                    ACAUnitsSubjects2.SetRange(ACAUnitsSubjects2."Corected Unit Code",ACAUnitsSubjects."Corected Unit Code");
                    if ACAUnitsSubjects2.Find('-') then begin
                      Clear(CountedValues);
                        repeat
                        CountedValues:=CountedValues+1;
                          ACAUnitsSubjects2."Repeatition Count":=CountedValues;
                          ACAUnitsSubjects2.Modify;
                          until ACAUnitsSubjects2.Next =0;
                        end;

                    until ACAUnitsSubjects.Next=0;
                  end;

                ACAUnitsSubjects3.Reset;
                ACAUnitsSubjects3.SetFilter("Repeatition Count",'>1');
                if ACAUnitsSubjects3.Find('-') then begin
                  ACAUnitsSubjects3.DeleteAll;
                  end;

                ACAUnitsSubjects4.Reset;
                ACAUnitsSubjects4.SetFilter("Repeatition Count",'=1');
                if ACAUnitsSubjects4.Find('-') then begin
                  repeat
                    Clear(NewCodedUnits);
                    NewCodedUnits:=ACAUnitsSubjects4."Corected Unit Code";
                    if NewCodedUnits<>'' then
                     if ACAUnitsSubjects4.Rename(NewCodedUnits,ACAUnitsSubjects4."Programme Code",
                       ACAUnitsSubjects4."Stage Code",ACAUnitsSubjects4."Entry No") then begin
                       end;
                    until ACAUnitsSubjects4.Next=0;
                  end;

            end;
        }
        dataitem(UnknownTable61746;UnknownTable61746)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(OldUnitCode);
                Clear(NewUnitCode);
                Clear(VarcharPart);
                Clear(IntegerPart);

                if (StrLen("ACA-Exam Results Buffer 2"."Unit Code"))>4 then begin
                if "ACA-Units/Subjects".Code<>'' then begin
                  OldUnitCode:="ACA-Exam Results Buffer 2"."Unit Code";
                  VarcharPart:=CopyStr("ACA-Exam Results Buffer 2"."Unit Code",1,3);
                  IntegerPart:=CopyStr("ACA-Exam Results Buffer 2"."Unit Code",(StrLen("ACA-Exam Results Buffer 2"."Unit Code")-2),3);
                  NewUnitCode:=VarcharPart+' '+IntegerPart;
                  end;

                "ACA-Exam Results Buffer 2".Rename("ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Academic Year"
                ,"ACA-Exam Results Buffer 2".Semester,"ACA-Exam Results Buffer 2".Programme,
                NewUnitCode,"ACA-Exam Results Buffer 2".Stage,"ACA-Exam Results Buffer 2".Intake,"ACA-Exam Results Buffer 2"."Exam Session");
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
        VarcharPart: Code[5];
        OldUnitCode: Code[10];
        NewUnitCode: Code[10];
        IntegerPart: Code[10];
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        ACAUnitsSubjects3: Record UnknownRecord61517;
        ACAUnitsSubjects4: Record UnknownRecord61517;
        CountedValues: Integer;
}

